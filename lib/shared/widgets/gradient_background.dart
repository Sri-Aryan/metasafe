// lib/shared/widgets/gradient_background.dart
import 'package:flutter/material.dart';
import '../../appcolors.dart';

class GradientBackground extends StatelessWidget {
  final Widget? child;
  final Duration duration;

  const GradientBackground({
    super.key,
    this.child,
    this.duration = const Duration(milliseconds: 350),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLightBlue,
            AppColors.primaryDarkBlue,
            AppColors.blackBackground,
          ],
        ),
      ),
      child: SafeArea(
        child: child ?? const SizedBox(),
      ),
    );
  }
}
