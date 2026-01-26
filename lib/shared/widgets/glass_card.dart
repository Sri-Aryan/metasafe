// lib/shared/widgets/glass_card.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.15),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: child,
      ),
    );
  }
}

// lib/shared/widgets/gradient_background.dart
class GradientBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryLightBlue,
            AppColors.blackBackground,
          ],
        ),
      ),
      child: SafeArea(child: EdgeInsets.all(0).child),
    );
  }
}
