// lib/core/constants/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors (Light Blue Gradient)
  static const Color primaryLightBlue = Color(0xFF4FC3F7);
  static const Color primaryDarkBlue = Color(0xFF0288D1);
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLightBlue, primaryDarkBlue],
  );

  // Background & Surface
  static const Color blackBackground = Color(0xFF0A0A0A);
  static const Color glassSurface = Color(0x26FFFFFF); // 0.15 opacity white
  static const Color glassBorder = Color(0x33FFFFFF);  // 0.2 opacity white

  // Text & Icons
  static const Color whiteText = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textMuted = Color(0xFF808080);

  // Success/Error States
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);

  // Glassmorphism Components
  static const Color glassCardBg = Color(0x26FFFFFF); // 15% opacity
  static const Color glassCardBorder = Color(0x1AFFFFFF); // Subtle border
  static const Color glassShadow = Color(0x80000000);

  // Risk Indicators (Privacy Scanner)
  static const Color riskHigh = Color(0xFFE53935);    // Red
  static const Color riskMedium = Color(0xFFFFB74D);  // Yellow
  static const Color riskLow = Color(0xFF81C784);     // Green

  // Button States
  static const Color buttonPrimary = Color(0xFF4FC3F7);
  static const Color buttonPrimaryPressed = Color(0xFF0288D1);
  static const Color buttonDisabled = Color(0xFF424242);

  // Progress & Loading
  static const Color progressTrack = Color(0xFF424242);
  static const Color progressFill = Color(0xFF4FC3F7);

  // Divider & Borders
  static const Color divider = Color(0xFF333333);
  static const Color subtleBorder = Color(0xFF424242);

  // Onboarding Illustrations
  static const Color illustrationAccent = Color(0xFF81D4FA);

  // SafeArea Overlay
  static const Color safeAreaOverlay = Color(0xE60A0A0A);

  // FAB & Quick Actions
  static const Color fabGradientStart = Color(0xFF4FC3F7);
  static const Color fabGradientEnd = Color(0xFF0293EE);

  static List<Color> get gradientSpectrum => [
    primaryLightBlue,
    const Color(0xFF29B6F6),
    primaryDarkBlue,
    const Color(0xFF0277BD),
    blackBackground,
  ];

  static List<Color> get riskGradient => [
    riskHigh,
    riskMedium,
    riskLow,
  ];
}
