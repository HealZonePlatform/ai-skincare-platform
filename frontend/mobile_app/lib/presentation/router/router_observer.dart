// lib/presentation/router/router_observer.dart

import 'package:flutter/widgets.dart';

import 'package:ai_skincare_platform/core/analytics/analytics_service.dart';

class AnalyticsRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final screenName = route.settings.name ?? route.runtimeType.toString();
    AnalyticsService.logScreenView(screenName);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      final screenName = previousRoute.settings.name ?? previousRoute.runtimeType.toString();
      AnalyticsService.logScreenView(screenName);
    }
  }
}
