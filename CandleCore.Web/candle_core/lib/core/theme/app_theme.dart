import 'package:flutter/material.dart';

import 'tokens.dart';

/// AppTheme defines the light and dark [ThemeData] used across the app.
///
/// It builds on top of [AppColors], [AppTypography], and other design tokens
/// to ensure consistent styling everywhere.
class AppTheme {
  /// 🌞 Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.surfaceLight,
    cardColor: AppColors.cardLight,
    dividerColor: AppColors.borderLight,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.primaryForeground,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.textPrimary,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.errorForeground,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: AppTypography.textBase,
        fontWeight: AppTypography.fontWeightNormal,
        color: AppColors.textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: AppTypography.textLg,
        fontWeight: AppTypography.fontWeightNormal,
        color: AppColors.textSecondary,
      ),
      titleLarge: TextStyle(
        fontSize: AppTypography.text2xl,
        fontWeight: AppTypography.fontWeightMedium,
        color: AppColors.textPrimary,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackgroundLight,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primaryForeground,
        textStyle: const TextStyle(
          fontWeight: AppTypography.fontWeightMedium,
          fontSize: AppTypography.textLg,
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.borderLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      ),
    ),
  );

  /// 🌚 Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.surfaceDark,
    cardColor: AppColors.cardDark,
    dividerColor: AppColors.borderDark,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.primaryForeground,
      secondary: AppColors.secondaryDark,
      onSecondary: AppColors.textLight,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textLight,
      error: AppColors.error,
      onError: AppColors.errorForeground,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: AppTypography.textBase,
        fontWeight: AppTypography.fontWeightNormal,
        color: AppColors.textLight,
      ),
      bodySmall: TextStyle(
        fontSize: AppTypography.textLg,
        fontWeight: AppTypography.fontWeightNormal,
        color: AppColors.mutedForegroundDark,
      ),
      titleLarge: TextStyle(
        fontSize: AppTypography.text2xl,
        fontWeight: AppTypography.fontWeightMedium,
        color: AppColors.textLight,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackgroundDark,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        borderSide: const BorderSide(color: AppColors.primaryLight),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.primaryForeground,
        textStyle: const TextStyle(
          fontWeight: AppTypography.fontWeightMedium,
          fontSize: AppTypography.textLg,
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textLight,
        side: const BorderSide(color: AppColors.borderDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      ),
    ),
  );
}
