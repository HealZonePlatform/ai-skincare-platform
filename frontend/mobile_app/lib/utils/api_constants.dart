class ApiConstants {
  // Private constructor to prevent instantiation
  ApiConstants._();

  // Base Configuration
  static const String _localIp = '192.168.56.1';
  static const String _port = '3001';
  static const String _apiVersion = 'v1';

  // Base URL with API version
  static const String baseUrl = 'http://$_localIp:$_port/api/$_apiVersion';

  // ✅ ADDED: Full URL getters for backward compatibility
  static String get registerUrl => '$baseUrl/auth/register';
  static String get loginUrl => '$baseUrl/auth/login';

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

  // Request Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
