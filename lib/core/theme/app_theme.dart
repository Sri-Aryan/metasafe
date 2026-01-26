// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightBlueGlass => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryLightBlue,
      brightness: Brightness.dark,
      primary: AppColors.primaryLightBlue,
      background: AppColors.blackBackground,
      onBackground: AppColors.whiteText,
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.black.withOpacity(0.15),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.whiteText,
    ),
  );
}
