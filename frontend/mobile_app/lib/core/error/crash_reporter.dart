import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:ai_skincare_platform/config/environment.dart';
import 'package:ai_skincare_platform/core/logging/app_logger.dart';

/// Thin wrapper around Sentry to centralize crash reporting toggles and hooks.
class CrashReporter {
  CrashReporter._();

  static bool _enabled = false;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    if (!Environment.enableCrashReporting) {
      _initialized = true;
      AppLogger.info('Crash reporting disabled by environment',
          tag: 'CrashReporter');
      return;
    }

    final dsn = Environment.crashDsn;
    if (dsn.isEmpty) {
      _initialized = true;
      AppLogger.info('Crash reporting skipped: missing DSN',
          tag: 'CrashReporter');
      return;
    }

    await SentryFlutter.init((options) {
      options.dsn = dsn;
      options.environment = Environment.flavor.name;
      options.tracesSampleRate = 0.1;
      options.enableAutoPerformanceTracing = false;
    });

    _initialized = true;
    _enabled = true;
  }

  static Future<void> guard(Future<void> Function() body) async {
    return runZonedGuarded(() async {
      await body();
    }, recordZoneError);
  }

  static void recordFlutterError(FlutterErrorDetails details) {
    FlutterError.presentError(details);
    _capture(details.exception, details.stack ?? StackTrace.empty);
  }

  static void recordZoneError(Object error, StackTrace stackTrace) {
    _capture(error, stackTrace);
  }

  static Future<void> recordNonFatal(
    Object error,
    StackTrace stackTrace,
  ) async {
    await _capture(error, stackTrace);
  }

  static Future<void> _capture(Object error, StackTrace stackTrace) async {
    AppLogger.error(
      'Captured unhandled error',
      error: error,
      stackTrace: stackTrace,
      tag: 'CrashReporter',
    );
    if (!_enabled) return;
    await Sentry.captureException(error, stackTrace: stackTrace);
  }
}
