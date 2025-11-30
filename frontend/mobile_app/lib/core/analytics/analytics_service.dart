// lib/core/analytics/analytics_service.dart

import 'package:ai_skincare_platform/config/environment.dart';
import 'package:ai_skincare_platform/core/logging/app_logger.dart';

class AnalyticsService {
  AnalyticsService._();

  static void logEvent(String name,
      {Map<String, Object?> parameters = const {}}) {
    if (!Environment.enableLogging) return;
    AppLogger.info('Analytics event: $name, params: $parameters',
        tag: 'Analytics');
  }

  static void logScreenView(String screenName) {
    if (!Environment.enableLogging) return;
    AppLogger.info('Screen view: $screenName', tag: 'Analytics');
  }
}
