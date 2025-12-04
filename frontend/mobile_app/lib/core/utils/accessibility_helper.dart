import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Accessibility helper utilities for the app
class AccessibilityHelper {
  AccessibilityHelper._();

  /// Check if the device has bold text enabled
  static bool isBoldTextEnabled(BuildContext context) {
    return MediaQuery.of(context).boldText;
  }

  /// Check if the device has reduced motion enabled
  static bool isReducedMotionEnabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  /// Get the text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }

  /// Check if the device is using a larger text size
  static bool isLargeTextEnabled(BuildContext context) {
    return getTextScaleFactor(context) > 1.2;
  }

  /// Check if high contrast mode is enabled
  static bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }
}

/// A widget that provides semantic labels for interactive elements
class SemanticAction extends StatelessWidget {
  const SemanticAction({
    super.key,
    required this.label,
    required this.child,
    this.hint,
    this.isButton = true,
    this.enabled = true,
    this.onTap,
  });

  final String label;
  final String? hint;
  final Widget child;
  final bool isButton;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      enabled: enabled,
      onTap: onTap,
      child: ExcludeSemantics(child: child),
    );
  }
}

/// A widget that announces changes to screen readers
class SemanticAnnouncer extends StatefulWidget {
  const SemanticAnnouncer({
    super.key,
    required this.message,
    required this.child,
    this.assertiveness = Assertiveness.polite,
  });

  final String message;
  final Widget child;
  final Assertiveness assertiveness;

  @override
  State<SemanticAnnouncer> createState() => _SemanticAnnouncerState();
}

class _SemanticAnnouncerState extends State<SemanticAnnouncer> {
  String? _lastMessage;

  @override
  void didUpdateWidget(SemanticAnnouncer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message != _lastMessage) {
      _lastMessage = widget.message;
      SemanticsService.announce(
        widget.message,
        TextDirection.ltr,
        assertiveness: widget.assertiveness,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Extension for adding semantic labels easily
extension SemanticExtension on Widget {
  /// Wrap this widget with a semantic label
  Widget withSemanticLabel(String label, {String? hint}) {
    return Semantics(
      label: label,
      hint: hint,
      child: this,
    );
  }

  /// Mark this widget as a button for accessibility
  Widget asSemanticButton(String label, {VoidCallback? onTap}) {
    return SemanticAction(
      label: label,
      onTap: onTap,
      child: this,
    );
  }

  /// Exclude this widget from semantics tree
  Widget excludeFromSemantics() {
    return ExcludeSemantics(child: this);
  }
}

/// Accessible color contrast utilities
class ContrastHelper {
  ContrastHelper._();

  /// Calculate the luminance ratio between two colors
  static double getContrastRatio(Color foreground, Color background) {
    final l1 = foreground.computeLuminance();
    final l2 = background.computeLuminance();
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if the contrast ratio meets WCAG AA standard (4.5:1 for normal text)
  static bool meetsWcagAA(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 4.5;
  }

  /// Check if the contrast ratio meets WCAG AAA standard (7:1 for normal text)
  static bool meetsWcagAAA(Color foreground, Color background) {
    return getContrastRatio(foreground, background) >= 7.0;
  }

  /// Get an accessible text color for a given background
  static Color getAccessibleTextColor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
