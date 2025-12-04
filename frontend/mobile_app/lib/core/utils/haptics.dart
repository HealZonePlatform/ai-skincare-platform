import 'package:flutter/services.dart';

class Haptics {
  Haptics._();

  static Future<void> light() {
    return HapticFeedback.lightImpact();
  }

  static Future<void> medium() {
    return HapticFeedback.mediumImpact();
  }

  static Future<void> heavy() {
    return HapticFeedback.heavyImpact();
  }

  static Future<void> selection() {
    return HapticFeedback.selectionClick();
  }

  static Future<void> success() {
    return HapticFeedback.mediumImpact();
  }

  static Future<void> warning() {
    return HapticFeedback.selectionClick();
  }

  static Future<void> error() {
    return HapticFeedback.heavyImpact();
  }
}
