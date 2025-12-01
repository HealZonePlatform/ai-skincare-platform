// lib/data/auth/datasources/auth_remote_data_source.dart

import 'package:dio/dio.dart';

import 'package:ai_skincare_platform/core/network/api_client.dart';
import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';
import 'package:ai_skincare_platform/domain/auth/entities/user_credentials.dart';
import 'package:ai_skincare_platform/utils/api_constants.dart';
import 'package:ai_skincare_platform/utils/exceptions.dart';

/// Remote data source that communicates with the authentication endpoints.
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource({
    Dio? dio,
  }) : _dio = dio ?? apiClient;

  Future<AuthTokens> login(UserCredentials credentials) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': credentials.email,
          'password': credentials.password,
        },
      );
      return _mapTokens(response.data);
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  Future<AuthTokens> register(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: payload,
      );
      return _mapTokens(response.data);
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  Future<AuthTokens> refresh(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      return _mapTokens(response.data);
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  AuthTokens _mapTokens(dynamic payload) {
    final data = (payload is Map<String, dynamic> ? payload['data'] : null)
        as Map<String, dynamic>?;
    if (data == null ||
        data['accessToken'] == null ||
        data['refreshToken'] == null) {
      throw ApiException(message: 'Invalid auth response');
    }
    return AuthTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  AppException _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout. Please try again.');
      case DioExceptionType.connectionError:
        return NetworkException('Network error. Please check connection.');
      case DioExceptionType.badCertificate:
        return NetworkException('SSL certificate verification failed');
      case DioExceptionType.cancel:
        return ApiException(message: 'Request cancelled');
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        final message = (error.response?.data is Map<String, dynamic> &&
                error.response?.data['message'] is String)
            ? error.response!.data['message'] as String
            : 'Authentication failed';
        return ApiException(message: message, statusCode: status);
      case DioExceptionType.unknown:
        return NetworkException('Network error occurred. Please retry.');
    }
  }
}
