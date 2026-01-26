// lib/features/onboarding/onboarding_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/glass_card.dart';

class OnboardingScreen extends ConsumerWidget {
  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Your photos contain GPS data',
      subtitle: 'Location tracking follows you everywhere',
      icon: Icons.location_on,
    ),
    OnboardingPage(
      title: 'One tap removes all tracking',
      subtitle: 'Clean metadata instantly',
      icon: Icons.cleaning_services,
    ),
    OnboardingPage(
      title: 'Share securely anywhere',
      subtitle: 'Privacy first, always',
      icon: Icons.share,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: GradientBackground(
        child: PageView.builder(
          itemCount: pages.length,
          itemBuilder: (context, index) => OnboardingPageView(
            page: pages[index],
            isLast: index == pages.length - 1,
          ),
          onPageChanged: (index) {},
        ),
      ),
    );
  }
}
