/// Environment configuration class for managing different environments
class Environment {
  /// API base URL from environment variables
  static String get apiBaseUrl => const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://192.168.56.1:3001',
      );

  /// Check if running in production mode
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');

  /// Check if running in development mode
  static bool get isDevelopment => !isProduction;

  /// Enable logging in development mode
  static bool get enableLogging => isDevelopment;

  /// Strict SSL validation in production mode
  static bool get strictSSL => isProduction;

  /// Connect timeout duration
 static Duration get connectTimeout => const Duration(seconds: 30);

  /// Receive timeout duration
  static Duration get receiveTimeout => const Duration(seconds: 30);

  /// Send timeout duration
  static Duration get sendTimeout => const Duration(seconds: 30);

  /// API version
  static String get apiVersion => 'v1';

  /// Full API base URL with version
  static String get apiBaseUrlWithVersion => '$apiBaseUrl/api/$apiVersion';
}