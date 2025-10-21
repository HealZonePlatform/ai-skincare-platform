// lib/data/profile/datasources/profile_remote_data_source.dart

import 'package:dio/dio.dart';

import 'package:ai_skincare_platform/core/network/api_client.dart';
import 'package:ai_skincare_platform/domain/profile/entities/user_profile.dart';
import 'package:ai_skincare_platform/utils/api_constants.dart';

class ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSource({Dio? dio}) : _dio = dio ?? apiClient;

  Future<UserProfile> fetchProfile() async {
    final response = await _dio.get(ApiConstants.userProfile);
    return UserProfile.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<UserProfile> updateProfile(Map<String, dynamic> payload) async {
    final response = await _dio.put(
      ApiConstants.userProfile,
      data: payload,
    );
    return UserProfile.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<SkinAnalysisHistory>> fetchAnalysisHistory({
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await _dio.get(
      ApiConstants.analysesHistory,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
      },
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((json) => SkinAnalysisHistory.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<UserProfile> uploadAvatar(String filePath) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(filePath, filename: 'avatar.jpg'),
    });
    final response = await _dio.post(
      ApiConstants.uploadAvatar,
      data: formData,
    );
    return UserProfile.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.put(
      ApiConstants.changePassword,
      data: {
        'oldPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }
}
