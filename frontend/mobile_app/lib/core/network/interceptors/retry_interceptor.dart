// lib/core/network/interceptors/retry_interceptor.dart

import 'dart:async';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 2,
    this.retryableStatuses = const {500, 502, 503, 504},
    this.retryableTypes = const {
      DioExceptionType.connectionError,
      DioExceptionType.connectionTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.sendTimeout,
    },
  }) : _dio = dio;

  final Dio _dio;
  final int maxRetries;
  final Set<int> retryableStatuses;
  final Set<DioExceptionType> retryableTypes;

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    final shouldRetry = _shouldRetry(err);
    final retries = (requestOptions.extra['retry_count'] as int?) ?? 0;

    if (shouldRetry && retries < maxRetries) {
      final delay = Duration(milliseconds: 300 * (retries + 1));
      await Future<void>.delayed(delay);
      requestOptions.extra['retry_count'] = retries + 1;

      try {
        final response = await _dio.fetch(requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException exception) {
    if (retryableTypes.contains(exception.type)) {
      return true;
    }
    final statusCode = exception.response?.statusCode;
    if (statusCode != null && retryableStatuses.contains(statusCode)) {
      return true;
    }
    return false;
  }
}
