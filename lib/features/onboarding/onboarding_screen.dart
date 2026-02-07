// lib/features/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../appcolors.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_background.dart';
import 'onboarding_page.dart';
import 'onboarding_page_view.dart';
class OnboardingScreen extends ConsumerWidget {
  final List<OnboardingPage> pages = OnboardingPages.pages;

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: pages.length,
                  itemBuilder: (context, index) => OnboardingPageView(
                    page: pages[index],
                    isLast: index == pages.length - 1,
                  ),
                  onPageChanged: (index) {},
                ),
              ),
              _buildBottomControls(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _ProgressDots(pages: pages),
          const SizedBox(height: 32),
          GlassCard(
            child: Row(
              children: [
                Expanded(child: _SkipButton()),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _GetStartedButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Progress Dots
class _ProgressDots extends StatelessWidget {
  final List<OnboardingPage> pages;
  const _ProgressDots({required this.pages});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pages.length,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// Skip Button
class _SkipButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go('/home'),
      child: Text(
        'Skip',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColors.whiteText,
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.go('/home'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Text(
        'Get Started',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.whiteText,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
