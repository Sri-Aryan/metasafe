// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import '../../appcolors.dart';

class AppTheme {
  static ThemeData get lightBlueGlass => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryLightBlue,
      brightness: Brightness.dark,
      primary: AppColors.primaryLightBlue,
      onPrimary: AppColors.whiteText,
      background: AppColors.blackBackground,
      onBackground: AppColors.whiteText,
      surface: AppColors.glassSurface,
      onSurface: AppColors.whiteText,
      surfaceVariant: AppColors.glassCardBg,
      onSurfaceVariant: AppColors.textSecondary,
    ),

    // Fixed: Use CardThemeData instead of CardTheme
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: AppColors.glassCardBg,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.glassShadow,
      elevation: 4,
      margin: EdgeInsets.zero,
    ),

    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.whiteText,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      titleTextStyle: TextStyle(
        color: AppColors.whiteText,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.whiteText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 0,
      ),
    ),

    // Glassmorphism for all surfaces
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      surfaceTintColor: Colors.transparent,
    ),

    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      surfaceTintColor: Colors.transparent,
    ),
  );
}
