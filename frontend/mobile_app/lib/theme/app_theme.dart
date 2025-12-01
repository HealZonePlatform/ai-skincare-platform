// lib/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_typography.dart';

export 'app_colors.dart';
export 'app_dimensions.dart';
export 'app_typography.dart';

class AppTheme {
  static ThemeData build({bool isDark = false}) {
    final surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final elevatedSurface =
        isDark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated;
    final background = isDark ? AppColors.darkBackground : AppColors.background;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final chipBg = isDark ? AppColors.darkChipBg : AppColors.chipBg;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final divider = isDark ? AppColors.darkDivider : AppColors.divider;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.secondary,
      onSecondary: textPrimary,
      surface: surface,
      onSurface: textPrimary,
      error: AppColors.danger,
      brightness: isDark ? Brightness.dark : Brightness.light,
    ).copyWith(surface: surface, onSurface: textPrimary);

    final base = ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      useMaterial3: true,
      fontFamily: 'Outfit', // Assuming Outfit or similar modern font
      textTheme: AppTypography.textTheme,
    );

    return base.copyWith(
      appBarTheme: base.appBarTheme.copyWith(
        elevation: 0,
        centerTitle: true,
        backgroundColor: background,
        foregroundColor: textPrimary,
        titleTextStyle: AppTypography.textTheme.headlineSmall?.copyWith(
          color: textPrimary,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        color: elevatedSurface,
        margin: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl, vertical: AppSpacing.s),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.l),
          side: BorderSide(color: border, width: 1),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: chipBg,
        selectedColor: AppColors.primary,
        labelStyle:
            AppTypography.textTheme.labelMedium?.copyWith(color: textPrimary),
        secondaryLabelStyle:
            AppTypography.textTheme.labelMedium?.copyWith(color: Colors.white),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l, vertical: AppSpacing.s),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.full)),
        side: BorderSide.none,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.l, horizontal: AppSpacing.xl),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xl)),
        elevation: 0,
        textStyle: AppTypography.textTheme.labelLarge
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.l, horizontal: AppSpacing.xl),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl)),
          textStyle: AppTypography.textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l, vertical: AppSpacing.s),
        ),
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l, vertical: AppSpacing.l),
        hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
            color:
                isDark ? AppColors.darkTextTertiary : AppColors.textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.m),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: divider,
        thickness: 1,
        space: AppSpacing.xl,
      ),
      bottomSheetTheme: base.bottomSheetTheme.copyWith(
        backgroundColor: elevatedSurface,
        surfaceTintColor: elevatedSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.l)),
        ),
      ),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor:
            isDark ? AppColors.darkTextTertiary : AppColors.textTertiary,
        selectedLabelStyle: AppTypography.textTheme.labelSmall
            ?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTypography.textTheme.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.textPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.l)),
      ),
    );
  }
}

extension ColorOpacityHelpers on Color {
  Color withOpacityFraction(double opacity) {
    final value = (opacity.clamp(0.0, 1.0) * 255).round();
    return withAlpha(value);
  }
}
