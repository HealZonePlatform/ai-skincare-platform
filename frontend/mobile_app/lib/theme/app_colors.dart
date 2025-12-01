// lib/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors - Earthy & Natural
  static const primary = Color(0xFF6B705C); // Olive Green - More grounded
  static const primaryLight = Color(0xFFA5A58D); // Sage
  static const primaryDark = Color(0xFF484A3E); // Deep Olive

  static const secondary = Color(0xFFDDBEA9); // Beige/Peach - Softer
  static const secondaryLight = Color(0xFFFFE8D6); // Champagne
  static const secondaryDark = Color(0xFFCB997E); // Terracotta

  // Surface & Background - Clean & Warm
  static const surface = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFFBFBF9); // Off-white
  static const surfaceElevated = Color(0xFFF2F2EC);
  static const background = Color(0xFFF7F7F5); // Very light grey/beige

  // Text Colors - High Contrast but Soft
  static const textPrimary =
      Color(0xFF2F3128); // Almost black, slightly green-tinted
  static const textSecondary = Color(0xFF6C7064); // Dark Grey/Green
  static const textTertiary = Color(0xFFA0A498);
  static const textDisabled = Color(0xFFD6D8D1);

  // Semantic Colors
  static const success = Color(0xFF606C38); // Forest Green
  static const successLight = Color(0xFF8F9E58);
  static const warning = Color(0xFFD4A373); // Muted Orange
  static const warningLight = Color(0xFFE9C496);
  static const danger = Color(0xFFBC6C25); // Burnt Orange/Red
  static const dangerLight = Color(0xFFDDA15E);
  static const info = Color(0xFF7F9CA2); // Muted Blue/Green
  static const infoLight = Color(0xFFA8C0C4);

  // UI Elements
  static const chipBg = Color(0xFFF0F2EB);
  static const border = Color(0xFFE6E8E0);
  static const divider = Color(0xFFF0F2EB);
  static const overlay = Color(0x662F3128);
  static const overlayDark = Color(0xAA0B0C0A);

  // Dark palette
  static const darkSurface = Color(0xFF1E1F1B);
  static const darkSurfaceMuted = Color(0xFF262822);
  static const darkBackground = Color(0xFF121310);
  static const darkTextPrimary = Color(0xFFE8EAE2);
  static const darkTextSecondary = Color(0xFFB5B8AE);
  static const darkTextTertiary = Color(0xFF8A8D83);
  static const darkBorder = Color(0xFF30332B);
  static const darkDivider = Color(0xFF2A2D26);
  static const darkChipBg = Color(0xFF2A2D26);
  static const darkSurfaceElevated = Color(0xFF24261F);
  static const darkOverlay = Color(0xAA0B0C0A);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF6B705C), Color(0xFF888C75)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const primaryGradientDark = LinearGradient(
    colors: [Color(0xFF2E3126), Color(0xFF484B3D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [Color(0xFFDDBEA9), Color(0xFFCB997E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const heroGradient = LinearGradient(
    colors: [
      Color(0xFF6B705C),
      Color(0xFF888C75),
      Color(0xFFDDBEA9),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const heroGradientDark = LinearGradient(
    colors: [
      Color(0xFF1E2218),
      Color(0xFF32362A),
      Color(0xFF6B705C),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
