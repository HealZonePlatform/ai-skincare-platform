// lib/config/environment.dart

enum AppEnvironment {
  development,
  staging,
  production,
}

class _EnvConfig {
  const _EnvConfig({
    required this.apiBaseUrl,
    required this.connectTimeoutMs,
    required this.receiveTimeoutMs,
    required this.sendTimeoutMs,
    required this.strictSSL,
  });

  final String apiBaseUrl;
  final int connectTimeoutMs;
  final int receiveTimeoutMs;
  final int sendTimeoutMs;
  final bool strictSSL;
}

class Environment {
  static const String _envName =
      String.fromEnvironment('APP_ENV', defaultValue: 'development');

  static final Map<AppEnvironment, _EnvConfig> _configs = {
    AppEnvironment.development: const _EnvConfig(
      apiBaseUrl: 'http://192.168.56.1:3001',
      connectTimeoutMs: 15000,
      receiveTimeoutMs: 15000,
      sendTimeoutMs: 15000,
      strictSSL: false,
    ),
    AppEnvironment.staging: const _EnvConfig(
      apiBaseUrl: 'https://staging-api.healzone.app',
      connectTimeoutMs: 20000,
      receiveTimeoutMs: 20000,
      sendTimeoutMs: 20000,
      strictSSL: true,
    ),
    AppEnvironment.production: const _EnvConfig(
      apiBaseUrl: 'https://api.healzone.app',
      connectTimeoutMs: 20000,
      receiveTimeoutMs: 20000,
      sendTimeoutMs: 20000,
      strictSSL: true,
    ),
  };

  static AppEnvironment get flavor {
    switch (_envName.toLowerCase()) {
      case 'production':
      case 'prod':
        return AppEnvironment.production;
      case 'staging':
        return AppEnvironment.staging;
      default:
        return AppEnvironment.development;
    }
  }

  static _EnvConfig get _config => _configs[flavor]!;

  static String get apiBaseUrl {
    const override = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    return override.isNotEmpty ? override : _config.apiBaseUrl;
  }

  static bool get isProduction => flavor == AppEnvironment.production;
  static bool get isDevelopment => flavor == AppEnvironment.development;

  static bool get enableLogging {
    const override = bool.fromEnvironment('API_ENABLE_LOGGING', defaultValue: true);
    return isDevelopment && override;
  }

  static bool get strictSSL {
    const override = bool.fromEnvironment('API_STRICT_SSL', defaultValue: true);
    return override && _config.strictSSL;
  }

  static Duration get connectTimeout {
    const override = int.fromEnvironment('API_CONNECT_TIMEOUT_MS', defaultValue: 0);
    final value = override > 0 ? override : _config.connectTimeoutMs;
    return Duration(milliseconds: value);
  }

  static Duration get receiveTimeout {
    const override = int.fromEnvironment('API_RECEIVE_TIMEOUT_MS', defaultValue: 0);
    final value = override > 0 ? override : _config.receiveTimeoutMs;
    return Duration(milliseconds: value);
  }

  static Duration get sendTimeout {
    const override = int.fromEnvironment('API_SEND_TIMEOUT_MS', defaultValue: 0);
    final value = override > 0 ? override : _config.sendTimeoutMs;
    return Duration(milliseconds: value);
  }

  static String get apiVersion {
    const override = String.fromEnvironment('API_VERSION', defaultValue: '');
    return override.isNotEmpty ? override : 'v1';
  }

  static String get apiBaseUrlWithVersion => '$apiBaseUrl/api/$apiVersion';
}
