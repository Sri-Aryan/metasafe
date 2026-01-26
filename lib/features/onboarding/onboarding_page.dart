import 'package:flutter/material.dart';
import '../../appcolors.dart';

class OnboardingPage {
  final String title;
  final String subtitle;
  final IconData icon;
  final String imageAsset;
  final Color accentColor;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.imageAsset,
    this.accentColor = AppColors.primaryLightBlue,
  });
}

// Predefined pages for minimalist UX
abstract class OnboardingPages {
  static const List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Photos Track You',
      subtitle: 'GPS location and camera data embedded in every photo',
      icon: Icons.location_on_outlined,
      imageAsset: 'assets/images/gps_tracking.png',
      accentColor: AppColors.riskHigh,
    ),
    OnboardingPage(
      title: 'One Tap Privacy',
      subtitle: 'Remove all tracking metadata instantly',
      icon: Icons.cleaning_services_outlined,
      imageAsset: 'assets/images/clean_sweep.png',
      accentColor: AppColors.successGreen,
    ),
    OnboardingPage(
      title: 'Share Safely',
      subtitle: 'Clean images ready for secure sharing anywhere',
      icon: Icons.share_outlined,
      imageAsset: 'assets/images/secure_share.png',
      accentColor: AppColors.primaryLightBlue,
    ),
  ];
}
