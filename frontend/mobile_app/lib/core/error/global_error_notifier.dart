// lib/core/error/global_error_notifier.dart

import 'package:flutter/foundation.dart';

class GlobalErrorNotifier {
  GlobalErrorNotifier._();

  static final ValueNotifier<String?> notifier = ValueNotifier<String?>(null);

  static void report(String message) {
    notifier.value = message;
  }

  static void clear() {
    notifier.value = null;
  }
}
