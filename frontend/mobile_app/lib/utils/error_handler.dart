// Flutter imports
import 'package:flutter/foundation.dart';

// Local imports
import 'package:ai_skincare_platform/utils/exceptions.dart';

class ErrorHandler {
  ErrorHandler._();

  /// Log errors to console (in debug mode) or external service (in production)
  static void logError(dynamic error, StackTrace? stackTrace) {
    if (kDebugMode) {
      debugPrint('❌ Error: $error');
      if (stackTrace != null) {
        debugPrint('Stack trace: $stackTrace');
      }
    } else {
      // TODO: Send to error reporting service (Firebase Crashlytics, Sentry, etc.)
    }
  }

  /// Get user-friendly error message
  static String getUserMessage(dynamic error) {
    if (error is ApiException) {
      if (error.isUnauthorized) {
        return 'Session expired. Please login again.';
      } else if (error.isServerError) {
        return 'Server error. Please try again later.';
      }
      return error.message;
    } else if (error is NetworkException) {
      return error.message;
    } else if (error is ValidationException) {
      return error.message;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
