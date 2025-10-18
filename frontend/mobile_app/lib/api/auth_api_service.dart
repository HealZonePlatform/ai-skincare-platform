// Package imports
import 'package:dio/dio.dart';

// Local imports
import 'package:ai_skincare_platform/utils/api_constants.dart';
import 'package:ai_skincare_platform/utils/exceptions.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: ApiConstants.baseUrl,
                connectTimeout: ApiConstants.connectTimeout,
                receiveTimeout: ApiConstants.receiveTimeout,
                sendTimeout: ApiConstants.sendTimeout,
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            );

  /// User login
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  /// User registration
  Future<Response> register(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: userData,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  /// Refresh access token
  Future<Response> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  /// Handle Dio errors
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'API Error';

        if (statusCode != null) {
          return ApiException(
            message: message,
            statusCode: statusCode,
          );
        }
        return ApiException(message: message);

      case DioExceptionType.connectionError:
        return NetworkException(
          'Network connection failed. Please check your internet.',
        );

      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled');

      case DioExceptionType.badCertificate:
        return NetworkException('SSL certificate verification failed');

      case DioExceptionType.unknown:
      default:
        return NetworkException(
          'Network error occurred. Please try again.',
        );
    }
  }
}
