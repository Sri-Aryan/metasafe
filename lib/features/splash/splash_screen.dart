// lib/features/splash/splash_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/global_provider.dart';
import '../../shared/widgets/glass_card.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    Future.delayed(Duration(seconds: 2), _navigate);
  }

  void _navigate() {
    final isOnboarded = ref.read(onboardingCompletedProvider);
    context.go(isOnboarded ? '/home' : '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        children: [
          Center(
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Text(
                'MetaClean',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  foregroundPainter: Paint()
                    ..shader = LinearGradient(
                      colors: [AppColors.primaryLightBlue, Colors.white],
                    ).createShader(Rect.fromLTWH(0, 0, 200, 100)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
