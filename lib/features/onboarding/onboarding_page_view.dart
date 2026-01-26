// lib/features/onboarding/widgets/onboarding_page_view.dart
import 'package:flutter/material.dart';
import '../../appcolors.dart';
import 'onboarding_page.dart';

class OnboardingPageView extends StatelessWidget {
  final OnboardingPage page;
  final bool isLast;

  const OnboardingPageView({
    super.key,
    required this.page,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            page.icon,
            size: 120,
            color: page.accentColor.withOpacity(0.9),
          ),
          const SizedBox(height: 48),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: AppColors.whiteText,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              page.subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
