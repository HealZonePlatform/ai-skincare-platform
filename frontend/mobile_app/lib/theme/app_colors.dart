// lib/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors - Premium & Soft
  static const primary = Color(0xFFC5A9E0); // Gentle Purple
  static const primaryLight = Color(0xFFE2D4F0);
  static const primaryDark = Color(0xFF9A7FB5);

  static const secondary = Color(0xFFFFB5C5); // Soft Pink
  static const secondaryLight = Color(0xFFFFD6E0);
  static const secondaryDark = Color(0xFFE08A9D);

  static const accent = Color(0xFFA8E6CF); // Mint Green
  static const accentLight = Color(0xFFD4F3E7);
  static const accentDark = Color(0xFF7AC4AB);

  // Surface & Background - Warm & Clean
  static const surface = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFFBFBF9);
  static const surfaceElevated = Color(0xFFFFFFFF);
  static const background = Color(0xFFFFF8F0); // Warm Cream

  // Text Colors - High Contrast but Soft
  static const textPrimary = Color(0xFF2C2C2C); // Rich Charcoal
  static const textSecondary = Color(0xFF6C6C6C); // Medium Grey
  static const textTertiary = Color(0xFFA0A0A0); // Light Grey
  static const textDisabled = Color(0xFFD6D6D6);

  // Semantic Colors
  static const success = Color(0xFFA8E6CF); // Mint Green
  static const successLight = Color(0xFFD4F3E7);
  static const warning = Color(0xFFFFD166); // Soft Yellow/Orange
  static const warningLight = Color(0xFFFFE8B3);
  static const danger = Color(0xFFFF8A8A); // Soft Red
  static const dangerLight = Color(0xFFFFC4C4);
  static const info = Color(0xFF90DBF4); // Soft Blue
  static const infoLight = Color(0xFFC7EDFA);

  // UI Elements
  static const chipBg = Color(0xFFF5F0F6); // Very light purple tint
  static const border = Color(0xFFEFEFEF);
  static const divider = Color(0xFFF5F5F5);
  static const overlay = Color(0x662C2C2C);
  static const overlayDark = Color(0xAA000000);

  // Dark palette (Adjusted for premium feel in dark mode)
  static const darkSurface = Color(0xFF1E1E24);
  static const darkSurfaceMuted = Color(0xFF25252D);
  static const darkBackground = Color(0xFF121216);
  static const darkTextPrimary = Color(0xFFE8E8E8);
  static const darkTextSecondary = Color(0xFFB0B0B0);
  static const darkTextTertiary = Color(0xFF808080);
  static const darkBorder = Color(0xFF2E2E36);
  static const darkDivider = Color(0xFF2A2A30);
  static const darkChipBg = Color(0xFF2C2C35);
  static const darkSurfaceElevated = Color(0xFF25252D);
  static const darkOverlay = Color(0xAA000000);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFFC5A9E0), Color(0xFFA084CA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [Color(0xFFFFB5C5), Color(0xFFFF8FA3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const sunriseGradient = LinearGradient(
    colors: [Color(0xFFFFB5C5), Color(0xFFFFD6E0), Color(0xFFFFF8F0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const dewdropGradient = LinearGradient(
    colors: [Color(0xFFE0F7FA), Color(0xFFA8E6CF), Color(0xFFFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const glassGradient = LinearGradient(
    colors: [Color(0x99FFFFFF), Color(0x66FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const glassGradientDark = LinearGradient(
    colors: [Color(0x991E1E24), Color(0x661E1E24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
