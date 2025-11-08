// lib/config/env/staging.dart

import 'package:ai_skincare_platform/config/env/env_config.dart';

const stagingConfig = EnvConfig(
  apiBaseUrl: 'https://staging-api.healzone.app',
  connectTimeoutMs: 20000,
  receiveTimeoutMs: 20000,
  sendTimeoutMs: 20000,
  strictSSL: true,
  enableLogging: true,
  enableCrashReporting: true,
  enablePushNotifications: true,
  enableAnalytics: true,
);
