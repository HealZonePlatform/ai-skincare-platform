// lib/data/auth/datasources/auth_remote_data_source.dart

import 'package:dio/dio.dart';

import 'package:ai_skincare_platform/core/network/api_client.dart';
import 'package:ai_skincare_platform/domain/auth/entities/auth_tokens.dart';
import 'package:ai_skincare_platform/domain/auth/entities/user_credentials.dart';
import 'package:ai_skincare_platform/utils/api_constants.dart';

/// Remote data source that communicates with the authentication endpoints.
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource({
    Dio? dio,
  }) : _dio = dio ?? apiClient;

  Future<AuthTokens> login(UserCredentials credentials) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {
        'email': credentials.email,
        'password': credentials.password,
      },
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return AuthTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  Future<AuthTokens> register(Map<String, dynamic> payload) async {
    final response = await _dio.post(
      ApiConstants.register,
      data: payload,
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return AuthTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  Future<AuthTokens> refresh(String refreshToken) async {
    final response = await _dio.post(
      ApiConstants.refreshToken,
      data: {'refreshToken': refreshToken},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return AuthTokens(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }
}
