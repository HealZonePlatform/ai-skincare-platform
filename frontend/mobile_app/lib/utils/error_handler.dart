// lib/utils/error_handler.dart

import 'package:ai_skincare_platform/core/logging/app_logger.dart';
import 'package:ai_skincare_platform/utils/exceptions.dart';

class ErrorHandler {
  ErrorHandler._();

  /// Log errors to console (in debug mode) or external service (in production)
  static void logError(dynamic error, StackTrace? stackTrace) {
    AppLogger.error(
      'Captured error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static AppException normalize(dynamic error) {
    if (error is AppException) {
      return error;
    }
    return UnknownException(
      'An unexpected error occurred. Please try again.',
    );
  }

  /// Get user-friendly error message
  static String getUserMessage(dynamic error) {
    final normalized = normalize(error);
    if (normalized is ApiException) {
      if (normalized.isUnauthorized) {
        return 'Session expired. Please login again.';
      } else if (normalized.isServerError) {
        return 'Server error. Please try again later.';
      }
      return normalized.message;
    }
    if (normalized is NetworkException) {
      return normalized.message;
    }
    if (normalized is ValidationException) {
      return normalized.message;
    }
    return normalized.message;
  }
}
