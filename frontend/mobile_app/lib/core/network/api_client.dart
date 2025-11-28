// lib/core/network/api_client.dart

import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

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

    if (!kIsWeb) {
      final adapter = _dio.httpClientAdapter;
      if (adapter is IOHttpClientAdapter) {
        adapter.createHttpClient = () {
          final client = HttpClient();
          if (!Environment.strictSSL) {
            client.badCertificateCallback = (cert, host, port) => true;
          }
          return client;
        };
      }
    }

    _dio.interceptors.add(SecurityInterceptor());

    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenRepository.fetchAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == HttpStatus.unauthorized) {
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
          }
          handler.next(error);
        },
      ),
    );

    _dio.interceptors.add(RetryInterceptor(dio: _dio));

    _initialized = true;
  }
}

Dio get apiClient => ApiClient.instance.dio;
