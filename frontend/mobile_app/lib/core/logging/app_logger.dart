// lib/core/logging/app_logger.dart

import 'dart:developer' as developer;

import 'package:ai_skincare_platform/config/environment.dart';

class AppLogger {
  AppLogger._();

  static void info(String message, {String tag = 'HealZone'}) {
    if (Environment.enableLogging) {
      developer.log(message, name: tag);
    }
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String tag = 'HealZone',
  }) {
    developer.log(
      message,
      name: tag,
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }
}
