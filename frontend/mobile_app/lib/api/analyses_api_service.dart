// Package imports
import 'package:dio/dio.dart';

// Local imports
import 'package:ai_skincare_platform/utils/api_constants.dart';
import 'package:ai_skincare_platform/core/network/network_config.dart';
import 'package:ai_skincare_platform/utils/exceptions.dart';
import 'package:ai_skincare_platform/core/network/api_client.dart';

class AnalysesApiService {
  final Dio _dio;

  AnalysesApiService({Dio? dio}) : _dio = dio ?? apiClient;

  /// Upload skin analysis image with progress tracking
  Future<Response> uploadSkinAnalysis(
    dynamic imageFile, {
    Function(int, int)? onProgress,
  }) async {
    try {
      // Create multipart request
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await _dio.post(
        ApiConstants.analysesUpload,
        data: formData,
        onSendProgress: onProgress,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
          sendTimeout: NetworkConfig.uploadTimeout,
          receiveTimeout: NetworkConfig.uploadTimeout,
        ),
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  /// Get analysis history with pagination
  Future<Response> getAnalysisHistory({
    int page = 1,
    int limit = 10,
    String? status,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) queryParams['status'] = status;
      if (fromDate != null) queryParams['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();

      final response = await _dio.get(
        ApiConstants.analysesHistory,
        queryParameters: queryParams,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  /// Get analysis detail by ID
  Future<Response> getAnalysisDetail(String analysisId) async {
    try {
      final response = await _dio.get(
        ApiConstants.analysisDetail(analysisId),
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw UnknownException('Unexpected error: ${e.toString()}');
    }
  }

  /// Delete analysis by ID
  Future<Response> deleteAnalysis(String analysisId) async {
    try {
      final response = await _dio.delete(
        ApiConstants.analysisDetail(analysisId),
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
        final message = (error.response?.data?['message'] as String?) ?? 'API Error';

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
        return NetworkException(
          'Network error occurred. Please try again.',
        );
    }
  }
}


