// lib/presentation/widgets/ui_kit/hz_responsive_layout.dart

import 'package:flutter/material.dart';

typedef ResponsiveBuilder = Widget Function(
    BuildContext context, BoxConstraints constraints);

class HzResponsiveLayout extends StatelessWidget {
  const HzResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final ResponsiveBuilder mobile;
  final ResponsiveBuilder? tablet;
  final ResponsiveBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        if (width >= 1024 && desktop != null) {
          return desktop!(context, constraints);
        }
        if (width >= 600 && tablet != null) {
          return tablet!(context, constraints);
        }
        return mobile(context, constraints);
      },
    );
  }
}
