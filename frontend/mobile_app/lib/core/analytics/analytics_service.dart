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

  static void logButtonTap(String buttonId,
      {Map<String, Object?> parameters = const {}}) {
    logEvent('buttonTap', parameters: {'id': buttonId, ...parameters});
  }

  static void logScanStarted() {
    logEvent('scanStarted');
  }

  static void logScanCompleted({Map<String, Object?> parameters = const {}}) {
    logEvent('scanCompleted', parameters: parameters);
  }

  static void logProductView(String productId,
      {Map<String, Object?> parameters = const {}}) {
    logEvent('productView', parameters: {'id': productId, ...parameters});
  }

  static void logArticleView(String articleId,
      {Map<String, Object?> parameters = const {}}) {
    logEvent('articleView', parameters: {'id': articleId, ...parameters});
  }
}
