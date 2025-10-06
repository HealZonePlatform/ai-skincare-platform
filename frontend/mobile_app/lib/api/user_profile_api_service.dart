// lib/api/user_profile_api_service.dart

import 'package:dio/dio.dart';
import 'package:ai_skincare_platform/utils/api_constants.dart';
import 'package:ai_skincare_platform/models/user_profile.dart';

class UserProfileApiService {
  final Dio _dio = Dio();

  // Lấy thông tin người dùng
  Future<Response> getUserProfile(String token) async {
    final options = Options(headers: {
      'Authorization': 'Bearer $token',
    });
    
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/users/profile',
        options: options,
      );
      return response;
    } on DioException catch (e) {
      // Xử lý lỗi từ API
      throw e;
    }
 }

  // Cập nhật thông tin người dùng
  Future<Response> updateUserProfile(String token, Map<String, dynamic> userData) async {
    final options = Options(headers: {
      'Authorization': 'Bearer $token',
    });
    
    try {
      final response = await _dio.put(
        '${ApiConstants.baseUrl}/users/profile',
        data: userData,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      // Xử lý lỗi từ API
      throw e;
    }
  }

  // Lấy lịch sử phân tích da
  Future<Response> getSkinAnalysisHistory(String token) async {
    final options = Options(headers: {
      'Authorization': 'Bearer $token',
    });
    
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}/analysis/history',
        options: options,
      );
      return response;
    } on DioException catch (e) {
      // Xử lý lỗi từ API
      throw e;
    }
  }

  // Thêm phương thức upload ảnh đại diện nếu cần
  Future<Response> uploadAvatar(String token, String filePath) async {
    final options = Options(headers: {
      'Authorization': 'Bearer $token',
    });
    
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath, filename: 'avatar.jpg'),
      });
      
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/users/upload-avatar',
        data: formData,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      // Xử lý lỗi từ API
      throw e;
    }
  }
  
  // Thay đổi mật khẩu người dùng
 Future<Response> changePassword(String token, String oldPassword, String newPassword) async {
    final options = Options(headers: {
      'Authorization': 'Bearer $token',
    });
    
    try {
      final response = await _dio.put(
        '${ApiConstants.baseUrl}/users/change-password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
        options: options,
      );
      return response;
    } on DioException catch (e) {
      // Xử lý lỗi từ API
      throw e;
    }
  }
}
}