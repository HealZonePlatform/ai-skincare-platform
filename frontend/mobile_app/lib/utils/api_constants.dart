// lib/utils/api_constants.dart

import 'package:ai_skincare_platform/config/environment.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl => Environment.apiBaseUrlWithVersion;

  // Authentication Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String refreshToken = '/auth/refresh';

  // User Profile Endpoints
  static const String userProfile = '/users/profile';
  static const String changePassword = '/users/change-password';
  static const String uploadAvatar = '/users/upload-avatar';

  // Skin Analysis Endpoints
  static const String analysesHistory = '/analyses/history';
  static const String analysesUpload = '/analyses/upload';
  static String analysisDetail(String id) => '/analyses/$id';
}
