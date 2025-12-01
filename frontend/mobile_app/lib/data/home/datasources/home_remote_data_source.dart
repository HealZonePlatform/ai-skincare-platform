import 'package:dio/dio.dart';

import 'package:ai_skincare_platform/core/logging/app_logger.dart';
import 'package:ai_skincare_platform/core/network/api_client.dart';
import 'package:ai_skincare_platform/data/home/models/home_dashboard_dto.dart';
import 'package:ai_skincare_platform/domain/home/entities/home_dashboard.dart';
import 'package:ai_skincare_platform/utils/api_constants.dart';
import 'package:ai_skincare_platform/utils/exceptions.dart';

class HomeRemoteDataSource {
  HomeRemoteDataSource({
    Dio? client,
  }) : _client = client ?? apiClient;

  final Dio _client;

  Future<HomeDashboard> fetchDashboard() async {
    final dto = await fetchDashboardDto();
    return dto.toEntity();
  }

  Future<HomeDashboardDto> fetchDashboardDto() async {
    try {
      final response = await _client.get(ApiConstants.dashboard);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw UnknownException('Invalid dashboard response format');
      }
      final dto = HomeDashboardDto.fromJson(data);
      return dto;
    } on DioException catch (error, stackTrace) {
      AppLogger.error(
        'Dashboard fetch failed',
        error: error,
        stackTrace: stackTrace,
      );
      throw _mapDioError(error);
    } catch (error, stackTrace) {
      AppLogger.error(
        'Unexpected dashboard fetch error',
        error: error,
        stackTrace: stackTrace,
      );
      throw UnknownException('Unexpected error while loading dashboard.');
    }
  }

  AppException _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = (error.response?.data is Map<String, dynamic> &&
                error.response?.data['message'] is String)
            ? error.response!.data['message'] as String
            : 'Failed to load dashboard';
        return ApiException(
          message: message,
          statusCode: statusCode,
        );
      case DioExceptionType.connectionError:
        return NetworkException(
          'Network error. Please check your connection.',
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled');
      case DioExceptionType.badCertificate:
        return NetworkException('SSL certificate verification failed');
      case DioExceptionType.unknown:
        return NetworkException('Network error occurred. Please try again.');
    }
  }
}
