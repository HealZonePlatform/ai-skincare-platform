// lib/core/network/api_client.dart

import 'package:dio/dio.dart';

import 'package:ai_skincare_platform/config/environment.dart';
import 'package:ai_skincare_platform/core/logging/app_logger.dart';
import 'package:ai_skincare_platform/core/network/interceptors/retry_interceptor.dart';
import 'package:ai_skincare_platform/core/network/interceptors/security_interceptor.dart';
import 'package:ai_skincare_platform/core/session/auth_session_observer.dart';
import 'package:ai_skincare_platform/data/auth/repositories/auth_repository_impl.dart';
import 'package:ai_skincare_platform/data/auth/repositories/token_repository_impl.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/auth_repository.dart';
import 'package:ai_skincare_platform/domain/auth/repositories/token_repository.dart';
import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';
import 'package:ai_skincare_platform/domain/auth/usecases/refresh_session_usecase.dart';
import 'package:ai_skincare_platform/utils/api_constants.dart';
import 'package:ai_skincare_platform/utils/exceptions.dart';

class ApiClient {
  ApiClient._internal();
  static final ApiClient instance = ApiClient._internal();

  final Dio _dio = Dio();

  bool _initialized = false;
  late TokenRepository _tokenRepository;
  late AuthRepository _authRepository;
  late RefreshSessionUseCase _refreshSessionUseCase;
  Future<AuthTokens?>? _refreshingTokenFuture;

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
              AppLogger.error('[ApiClient] Token fetch error', error: e);
            }
            handler.next(options);
          },
          onError: (error, handler) async {
            if (error.response?.statusCode == 401) {
              return _handleUnauthorized(error, handler);
            }
            return handler.next(error);
          },
        ),
      );

      _dio.interceptors.add(RetryInterceptor(dio: _dio));

      _initialized = true;
    } catch (e) {
      AppLogger.error('[ApiClient] Initialization error', error: e);
      // Mark as initialized anyway to prevent blocking the app
      _initialized = true;
    }
  }

  bool _isAuthPath(String path) {
    return path.startsWith(ApiConstants.login) ||
        path.startsWith(ApiConstants.register) ||
        path.startsWith(ApiConstants.refreshToken);
  }

  Future<void> _handleUnauthorized(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isAuthPath(error.requestOptions.path) ||
        error.requestOptions.extra['__retry'] == true) {
      return handler.next(error);
    }

    try {
      _refreshingTokenFuture ??= _refreshSessionUseCase.execute();
      final refreshedTokens = await _refreshingTokenFuture;

      if (refreshedTokens == null) {
        await _signOut();
        return handler.next(error);
      }

      final requestOptions = error.requestOptions
        ..headers['Authorization'] = 'Bearer ${refreshedTokens.accessToken}'
        ..extra['__retry'] = true;

      try {
        final response = await _dio.fetch(requestOptions);
        return handler.resolve(response);
      } on DioException catch (retryError) {
        return handler.next(retryError);
      } catch (retryError, stackTrace) {
        AppLogger.error(
          '[ApiClient] Retry after refresh failed',
          error: retryError,
          stackTrace: stackTrace,
        );
        return handler.next(
          DioException(
            requestOptions: requestOptions,
            error: retryError,
            type: DioExceptionType.unknown,
          ),
        );
      }
    } on AppException catch (refreshError, stackTrace) {
      AppLogger.error(
        '[ApiClient] Token refresh failed',
        error: refreshError,
        stackTrace: stackTrace,
      );
      await _signOut();
      return handler.next(error);
    } catch (refreshError, stackTrace) {
      AppLogger.error(
        '[ApiClient] Token refresh unexpected failure',
        error: refreshError,
        stackTrace: stackTrace,
      );
      await _signOut();
      return handler.next(error);
    } finally {
      _refreshingTokenFuture = null;
    }
  }

  Future<void> _signOut() async {
    await _tokenRepository.clearTokens();
    AuthSessionObserver.instance.notify(AuthSessionEvent.signedOut);
  }
}

Dio get apiClient => ApiClient.instance.dio;
