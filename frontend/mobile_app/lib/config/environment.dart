// lib/config/environment.dart

import 'package:flutter/foundation.dart';

import 'package:ai_skincare_platform/config/env/development.dart';
import 'package:ai_skincare_platform/config/env/env_config.dart';
import 'package:ai_skincare_platform/config/env/production.dart';
import 'package:ai_skincare_platform/config/env/staging.dart';

enum AppEnvironment {
  development,
  staging,
  production,
}

class Environment {
  static const String _envName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static final Map<AppEnvironment, EnvConfig> _configs = {
    AppEnvironment.development: developmentConfig,
    AppEnvironment.staging: stagingConfig,
    AppEnvironment.production: productionConfig,
  };

  static AppEnvironment? _override;

  /// Allows tests/debug builds to override the current environment.
  static void debugOverride(AppEnvironment? env) {
    if (kDebugMode) {
      _override = env;
    }
  }

  static AppEnvironment get flavor => _override ?? _parseEnvName(_envName);

  static EnvConfig get _config => _configs[flavor]!;

  static String get apiBaseUrl {
    const override = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    return override.isNotEmpty ? override : _config.apiBaseUrl;
  }

  static bool get isProduction => flavor == AppEnvironment.production;
  static bool get isDevelopment => flavor == AppEnvironment.development;

  static bool get enableLogging {
    const override =
        bool.fromEnvironment('API_ENABLE_LOGGING', defaultValue: true);
    return override && _config.enableLogging;
  }

  static bool get enableCrashReporting {
    const override = bool.fromEnvironment(
      'ENABLE_CRASH_REPORTING',
      defaultValue: true,
    );
    return override && _config.enableCrashReporting;
  }

  static bool get enablePushNotifications {
    const override = bool.fromEnvironment(
      'ENABLE_PUSH_NOTIFICATIONS',
      defaultValue: true,
    );
    return override && _config.enablePushNotifications;
  }

  static bool get enableAnalytics => _config.enableAnalytics;

  static bool get strictSSL {
    const override = bool.fromEnvironment('API_STRICT_SSL', defaultValue: true);
    return override && _config.strictSSL;
  }

  static Duration get connectTimeout {
    const override =
        int.fromEnvironment('API_CONNECT_TIMEOUT_MS', defaultValue: 0);
    final value = override > 0 ? override : _config.connectTimeoutMs;
    return Duration(milliseconds: value);
  }

  static Duration get receiveTimeout {
    const override =
        int.fromEnvironment('API_RECEIVE_TIMEOUT_MS', defaultValue: 0);
    final value = override > 0 ? override : _config.receiveTimeoutMs;
    return Duration(milliseconds: value);
  }

  static Duration get sendTimeout {
    const override =
        int.fromEnvironment('API_SEND_TIMEOUT_MS', defaultValue: 0);
    final value = override > 0 ? override : _config.sendTimeoutMs;
    return Duration(milliseconds: value);
  }

  static String get apiVersion {
    const override = String.fromEnvironment('API_VERSION', defaultValue: '');
    return override.isNotEmpty ? override : 'v1';
  }

  static String get apiBaseUrlWithVersion => '$apiBaseUrl/api/$apiVersion';

  static AppEnvironment _parseEnvName(String value) {
    switch (value.toLowerCase()) {
      case 'production':
      case 'prod':
        return AppEnvironment.production;
      case 'staging':
        return AppEnvironment.staging;
      default:
        return AppEnvironment.development;
    }
  }
}
