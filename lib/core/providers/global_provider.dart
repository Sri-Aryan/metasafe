import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

final themeProvider = Provider<ThemeData>((ref) => AppTheme.lightBlueGlass);

final onboardingCompletedProvider =
StateNotifierProvider.autoDispose<OnboardingNotifier, bool>(
      (ref) => OnboardingNotifier(),
);

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false);

  Future<void> completeOnboarding() async {
    state = true;
    // Persist with SharedPreferences
  }
}

