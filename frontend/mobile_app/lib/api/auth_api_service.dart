// lib/api/auth_api_service.dart

import 'package:dio/dio.dart';
import 'package:ai_skincare_platform/utils/api_constants.dart';

class AuthApiService {
  final Dio _dio = Dio();

  Future<Response> register(String email, String password) {
    return _dio.post(
      ApiConstants.registerUrl,
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> login(String email, String password) {
    return _dio.post(
      ApiConstants.loginUrl,
      data: {
        'email': email,
        'password': password,
      },
    );
  }
}