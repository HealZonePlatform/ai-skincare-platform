// lib/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const primary = Color(0xFF8A8E5A);
  static const primaryLight = Color(0xFFA5AA7E);
  static const primaryDark = Color(0xFF6B6F43);
  
  static const secondary = Color(0xFFF4A259);
  static const secondaryLight = Color(0xFFF6B77D);
  static const secondaryDark = Color(0xFFE08A3A);
  
  // Surface & Background
  static const surface = Color(0xFFFAF7F2);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const background = Color(0xFFF5F2ED);
  
  // Text Colors
  static const textPrimary = Color(0xFF222222);
  static const textSecondary = Color(0xFF666666);
  static const textTertiary = Color(0xFF999999);
  static const textDisabled = Color(0xFFCCCCCC);
  
  // Semantic Colors
  static const success = Color(0xFF4CAF50);
  static const successLight = Color(0xFF81C784);
  static const warning = Color(0xFFFFB300);
  static const warningLight = Color(0xFFFFCA28);
  static const danger = Color(0xFFE53935);
  static const dangerLight = Color(0xFFEF5350);
  static const info = Color(0xFF2196F3);
  static const infoLight = Color(0xFF64B5F6);
  
  // UI Elements
  static const chipBg = Color(0xFFEEF0E6);
  static const border = Color(0xFFE0E0E0);
  static const divider = Color(0xFFEEEEEE);
  static const overlay = Color(0x80000000);
  
  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF8A8E5A), Color(0xFFA5AA7E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const secondaryGradient = LinearGradient(
    colors: [Color(0xFFF4A259), Color(0xFFE08A3A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const heroGradient = LinearGradient(
    colors: [
      Color(0xFF8A8E5A),
      Color(0xFFA5AA7E),
      Color(0xFFF4A259),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
