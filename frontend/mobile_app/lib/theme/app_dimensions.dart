// lib/theme/app_dimensions.dart
import 'package:flutter/material.dart';

class AppSpacing {
  // Padding & Margins
  static const double xxs = 2;
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // Edge Insets presets
  static const screenPadding = EdgeInsets.all(xl);
  static const cardPadding = EdgeInsets.all(l);
  static const listItemPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: m,
  );
}

class AppRadius {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 20;
  static const double xxl = 28;
  static const double full = 9999;

  // Border Radius presets
  static BorderRadius get cardRadius => BorderRadius.circular(l);
  static BorderRadius get buttonRadius => BorderRadius.circular(xl);
  static BorderRadius get inputRadius => BorderRadius.circular(m);
  static BorderRadius get chipRadius => BorderRadius.circular(full);
}

class AppShadows {
  static const mild = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const medium = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: -2,
    ),
  ];

  static const strong = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  static const floating = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 20,
      offset: Offset(0, 10),
      spreadRadius: -5,
    ),
  ];

  static const softGlow = [
    BoxShadow(
      color: Color(0x22C5A9E0),
      blurRadius: 28,
      offset: Offset(0, 12),
      spreadRadius: -6,
    ),
  ];
}
