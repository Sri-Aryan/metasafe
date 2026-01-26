// lib/core/animations/fade_slide_transition.dart
import 'package:flutter/cupertino.dart';

class FadeSlideTransition extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Widget child;

  const FadeSlideTransition({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([fadeAnimation, slideAnimation]),
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
