// lib/config/env/env_config.dart

class EnvConfig {
  const EnvConfig({
    required this.apiBaseUrl,
    required this.connectTimeoutMs,
    required this.receiveTimeoutMs,
    required this.sendTimeoutMs,
    required this.strictSSL,
    this.enableLogging = true,
    this.enableCrashReporting = false,
    this.enablePushNotifications = false,
    this.enableAnalytics = true,
  });

  final String apiBaseUrl;
  final int connectTimeoutMs;
  final int receiveTimeoutMs;
  final int sendTimeoutMs;
  final bool strictSSL;
  final bool enableLogging;
  final bool enableCrashReporting;
  final bool enablePushNotifications;
  final bool enableAnalytics;
}
