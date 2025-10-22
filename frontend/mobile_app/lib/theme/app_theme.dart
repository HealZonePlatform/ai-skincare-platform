import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF8A8E5A);
  static const secondary = Color(0xFFF4A259);
  static const surface = Color(0xFFFAF7F2);
  static const textPrimary = Color(0xFF222222);
  static const textSecondary = Color(0xFF666666);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFB300);
  static const danger = Color(0xFFE53935);
  static const chipBg = Color(0xFFEEF0E6);
}

class AppSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppRadius {
  static const double s = 8;
  static const double m = 12;
  static const double l = 20;
  static const double xl = 28;
}

class AppShadows {
  static const mild = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];
}

class AppTheme {
  static ThemeData build() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
    ).copyWith(
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
    );

    final base = ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.manropeTextTheme(
        Typography.blackMountainView.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipBg,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(color: AppColors.textPrimary),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s / 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.l)),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m, horizontal: AppSpacing.xl),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.l)),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.m, horizontal: AppSpacing.xl),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.m)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
    );

    return base;
  }
}

extension ColorOpacityHelpers on Color {
  Color withOpacityFraction(double opacity) {
    final value = (opacity.clamp(0.0, 1.0) * 255).round();
    return withAlpha(value);
  }
}
