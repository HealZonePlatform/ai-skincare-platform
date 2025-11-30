import 'package:flutter/services.dart';

class Haptics {
  Haptics._();

  static Future<void> light() {
    return HapticFeedback.lightImpact();
  }

  static Future<void> selection() {
    return HapticFeedback.selectionClick();
  }
}
