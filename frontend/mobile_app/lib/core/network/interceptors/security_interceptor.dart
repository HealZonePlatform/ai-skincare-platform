// lib/core/network/interceptors/security_interceptor.dart

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';

import 'package:ai_skincare_platform/config/environment.dart';

class SecurityInterceptor extends Interceptor {
  SecurityInterceptor({
    bool? enforceHttps,
  }) : _enforceHttps = enforceHttps ?? Environment.isProduction;

  final bool _enforceHttps;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_enforceHttps && options.uri.scheme != 'https') {
      return handler.reject(
        DioException(
          requestOptions: options,
          message: 'Insecure request blocked: ${options.uri}',
          type: DioExceptionType.unknown,
        ),
      );
    }
    if (!kIsWeb) {
      options.headers.putIfAbsent('X-Client-Platform', () => 'mobile');
    } else {
      options.headers.putIfAbsent('X-Client-Platform', () => 'web');
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      err = err.copyWith(
        message: 'Unauthorized request intercepted',
      );
    }
    handler.next(err);
  }
}
