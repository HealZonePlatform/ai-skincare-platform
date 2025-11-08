// lib/config/env/development.dart

import 'package:ai_skincare_platform/config/env/env_config.dart';

const developmentConfig = EnvConfig(
  apiBaseUrl: 'http://192.168.56.1:3001',
  connectTimeoutMs: 15000,
  receiveTimeoutMs: 15000,
  sendTimeoutMs: 15000,
  strictSSL: false,
  enableLogging: true,
  enableCrashReporting: false,
  enablePushNotifications: false,
  enableAnalytics: true,
);
