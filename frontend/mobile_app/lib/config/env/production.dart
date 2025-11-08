// lib/config/env/production.dart

import 'package:ai_skincare_platform/config/env/env_config.dart';

const productionConfig = EnvConfig(
  apiBaseUrl: 'https://api.healzone.app',
  connectTimeoutMs: 20000,
  receiveTimeoutMs: 25000,
  sendTimeoutMs: 25000,
  strictSSL: true,
  enableLogging: false,
  enableCrashReporting: true,
  enablePushNotifications: true,
  enableAnalytics: true,
);
