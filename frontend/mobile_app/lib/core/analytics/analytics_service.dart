// lib/core/analytics/analytics_service.dart

import 'package:ai_skincare_platform/config/environment.dart';
import 'package:ai_skincare_platform/core/analytics/analytics_events.dart';
import 'package:ai_skincare_platform/core/logging/app_logger.dart';

class AnalyticsService {
  AnalyticsService._();

  static void logEvent(
    AnalyticsEvent event, {
    Map<String, Object?> parameters = const {},
  }) {
    if (!Environment.enableAnalytics) return;
    final payload = <String, Object?>{
      ...parameters,
      for (final required in event.requiredParams)
        if (!parameters.containsKey(required)) required: 'n/a',
    };
    AppLogger.info(
      '[${event.category}] ${event.name} $payload',
      tag: 'Analytics',
    );
  }

  static void logScreenView(String screenName) {
    logEvent(
      AnalyticsEvent.screenView,
      parameters: {'screen': screenName},
    );
  }

  static void logButtonTap(
    String buttonId, {
    Map<String, Object?> parameters = const {},
  }) {
    logEvent(
      AnalyticsEvent.buttonTap,
      parameters: {'id': buttonId, ...parameters},
    );
  }

  static void logScanStarted({String source = 'home'}) {
    logEvent(
      AnalyticsEvent.scanStarted,
      parameters: {'source': source},
    );
  }

  static void logScanCompleted({
    String source = 'camera',
    Map<String, Object?> parameters = const {},
  }) {
    logEvent(
      AnalyticsEvent.scanCompleted,
      parameters: {'source': source, ...parameters},
    );
  }

  static void logProductView(
    String productId, {
    Map<String, Object?> parameters = const {},
  }) {
    logEvent(
      AnalyticsEvent.productViewed,
      parameters: {'id': productId, ...parameters},
    );
  }

  static void logArticleView(
    String articleId, {
    Map<String, Object?> parameters = const {},
  }) {
    logEvent(
      AnalyticsEvent.contentArticleViewed,
      parameters: {'id': articleId, ...parameters},
    );
  }

  static void logRoutineOpen(
    String routineId, {
    Map<String, Object?> parameters = const {},
  }) {
    logEvent(
      AnalyticsEvent.routineOpened,
      parameters: {'id': routineId, ...parameters},
    );
  }

  static void logError(String message, {String? surface}) {
    logEvent(
      AnalyticsEvent.error,
      parameters: {
        'message': message,
        if (surface != null) 'surface': surface,
      },
    );
  }
}
