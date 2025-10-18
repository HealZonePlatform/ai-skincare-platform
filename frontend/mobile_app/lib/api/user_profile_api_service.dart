// lib/api/user_profile_api_service.dart

import 'package:dio/dio.dart';
import 'package:ai_skincare_platform/utils/api_constants.dart';
import 'package:ai_skincare_platform/utils/exceptions.dart';


class UserProfileApiService {
  final Dio _dio;

  UserProfileApiService({Dio? dio})
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

  /// Get user profile
  Future<Response> getUserProfile(String token) async {
    try {
      final response = await _dio.get(
        ApiConstants.userProfile,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<Response> updateUserProfile(
    String token,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await _dio.put(
        ApiConstants.userProfile,
        data: userData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  /// Get skin analysis history
  Future<Response> getSkinAnalysisHistory(String token) async {
    try {
      final response = await _dio.get(
        ApiConstants.analysesHistory,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  /// Upload user avatar
  Future<Response> uploadAvatar(String token, String filePath) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          filePath,
          filename: 'avatar.jpg',
        ),
      });

      final response = await _dio.post(
        ApiConstants.uploadAvatar,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  /// Change user password
  Future<Response> changePassword(
    String token,
    String oldPassword,
    String newPassword,
  ) async {
    try {
      final response = await _dio.put(
        ApiConstants.changePassword,
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
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
