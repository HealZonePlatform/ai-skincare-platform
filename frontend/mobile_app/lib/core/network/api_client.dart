// lib/core/network/api_client.dart

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';

import 'package:ai_skincare_platform/config/environment.dart';
import 'package:ai_skincare_platform/core/network/interceptors/retry_interceptor.dart';
import 'package:ai_skincare_platform/core/network/interceptors/security_interceptor.dart';
import 'package:ai_skincare_platform/core/session/auth_session_observer.dart';
import 'package:ai_skincare_platform/data/auth/repositories/auth_repository_impl.dart';
import 'package:ai_skincare_platform/data/auth/repositories/token_repository_impl.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/auth_repository.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/token_repository.dart';
import 'package:ai_skincare_platform/domain/auth/usecases/refresh_session_usecase.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient instance = ApiClient._internal();

  final Dio _dio = Dio();

  bool _initialized = false;
  late TokenRepository _tokenRepository;
  late AuthRepository _authRepository;
  late RefreshSessionUseCase _refreshSessionUseCase;

  Dio get dio => _dio;

  Future<void> init({
    TokenRepository? tokenRepository,
    AuthRepository? authRepository,
  }) async {
    if (_initialized) {
      return;
    }

    try {
      _tokenRepository = tokenRepository ?? TokenRepositoryImpl();
      _authRepository = authRepository ?? AuthRepositoryImpl();
      _refreshSessionUseCase = RefreshSessionUseCase(
        authRepository: _authRepository,
        tokenRepository: _tokenRepository,
      );

      _dio.options = BaseOptions(
        baseUrl: Environment.apiBaseUrlWithVersion,
        connectTimeout: Environment.connectTimeout,
        receiveTimeout: Environment.receiveTimeout,
        sendTimeout: Environment.sendTimeout,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      // SSL pinning/certificate bypass is not needed/supported on web in this way.
      // if (!kIsWeb) { ... } logic removed to avoid dart:io dependency.

      _dio.interceptors.add(SecurityInterceptor());

      _dio.interceptors.add(
        QueuedInterceptorsWrapper(
          onRequest: (options, handler) async {
            try {
              final token = await _tokenRepository.fetchAccessToken();
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
              }
            } catch (e) {
              if (kDebugMode) {
                print('[ApiClient] Token fetch error: $e');
              }
            }
            handler.next(options);
          },
          onError: (error, handler) async {
            if (error.response?.statusCode == 401) {
              try {
                final refreshedTokens = await _refreshSessionUseCase.execute();
                if (refreshedTokens != null) {
                  final requestOptions = error.requestOptions;
                  requestOptions.headers['Authorization'] =
                      'Bearer ${refreshedTokens.accessToken}';
                  try {
                    final response = await _dio.fetch(requestOptions);
                    return handler.resolve(response);
                  } on DioException catch (retryError) {
                    return handler.next(retryError);
                  }
                }
                await _tokenRepository.clearTokens();
                AuthSessionObserver.instance.notify(AuthSessionEvent.signedOut);
              } catch (e) {
                if (kDebugMode) {
                  print('[ApiClient] Token refresh error: $e');
                }
              }
            }
            handler.next(error);
          },
        ),
      );

      _dio.interceptors.add(RetryInterceptor(dio: _dio));

      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('[ApiClient] Initialization error: $e');
      }
      // Mark as initialized anyway to prevent blocking the app
      _initialized = true;
    }
  }
}

Dio get apiClient => ApiClient.instance.dio;
