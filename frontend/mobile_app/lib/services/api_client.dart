// Package imports
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

// Local imports
import 'package:ai_skincare_platform/utils/api_constants.dart';
import 'package:ai_skincare_platform/services/secure_storage_service.dart';
import 'package:ai_skincare_platform/config/environment.dart';

class ApiClient {
  static ApiClient? _instance;
  static ApiClient get instance => _instance ??= ApiClient._internal();
  ApiClient._internal();

  late Dio _dio;
  final SecureStorageService _storageService = SecureStorageService();

  Dio get dio => _dio;

  /// Initialize the API client with base options
  Future<void> init() async {
    final baseOptions = BaseOptions(
      baseUrl: Environment.apiBaseUrlWithVersion,
      connectTimeout: Environment.connectTimeout,
      receiveTimeout: Environment.receiveTimeout,
      sendTimeout: Environment.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(baseOptions);

    // Configure SSL validation based on environment
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        // In production, strict SSL validation
        if (Environment.strictSSL) {
          return false; // Don't allow bad certificates in production
        }
        // In development, allow self-signed certificates
        return true; // Allow bad certificates in development
      };
      return client;
    };

    // Add interceptors
    _dio.interceptors.add(
      _TokenInterceptor(
        dio: _dio,
        storageService: _storageService,
      ),
    );
  }
}

class _TokenInterceptor extends Interceptor {
  final Dio _dio;
  final SecureStorageService _storageService;
  Completer<void>? _refreshCompleter;
  final Object _lock = Object();

  _TokenInterceptor({
    required Dio dio,
    required SecureStorageService storageService,
  })  : _dio = dio,
        _storageService = storageService;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Check if this is a refresh token request
      if (err.requestOptions.path.contains('/api/v1/auth/refresh')) {
        // Refresh token failed, logout user
        await _logout();
        return handler.resolve(err.response!);
      }

      // Perform token refresh with concurrent safety
      final result = await _performRefresh();
      if (result) {
        // Retry original request with new token
        try {
          final options = err.requestOptions;
          final token = await _storageService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          final response = await _dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      } else {
        // Refresh failed, logout user
        await _logout();
        return handler.resolve(err.response!);
      }
    }
    return handler.next(err);
  }

  Future<bool> _performRefresh() async {
    // Use lock to prevent concurrent refresh requests
    if (_refreshCompleter != null) {
      // Another refresh is already in progress, wait for it to complete
      await _refreshCompleter!.future;
      return await _checkTokenRefreshed();
    }

    final completer = Completer<void>();
    _refreshCompleter = completer;

    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null) {
        await _logout();
        completer.complete();
        _refreshCompleter = null;
        return false;
      }

      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] as Map<String, dynamic>;
        final newAccessToken = data['accessToken'] as String;
        final newRefreshToken = data['refreshToken'] as String;
        
        // Save new tokens
        await _storageService.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        
        completer.complete();
        _refreshCompleter = null;
        return true;
      } else {
        await _logout();
        completer.complete();
        _refreshCompleter = null;
        return false;
      }
    } catch (e) {
      await _logout();
      completer.complete();
      _refreshCompleter = null;
      return false;
    }
  }

  Future<bool> _checkTokenRefreshed() async {
    // Check if token has been refreshed by another request
    final token = await _storageService.getAccessToken();
    return token != null;
  }

  Future<void> _logout() async {
    // Clear stored tokens
    await _storageService.deleteAllTokens();
  }
}

/// Singleton instance for easy access
Dio get apiClient => ApiClient.instance.dio;