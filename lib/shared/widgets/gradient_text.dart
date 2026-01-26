// lib/shared/widgets/gradient_text.dart
import 'package:flutter/material.dart';
import '../../appcolors.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final TextAlign textAlign;

  const GradientText(
      this.text, {
        super.key,
        this.style,
        this.maxLines = 1,
        this.textAlign = TextAlign.center,
      });

  @override
  Widget build(BuildContext context) {
    final textStyle = style ?? Theme.of(context).textTheme.displayLarge!;
    return ShaderMask(
      shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(
        text,
        style: textStyle.copyWith(color: Colors.white),
        maxLines: maxLines,
        textAlign: textAlign,
      ),
    );
  }
}

// Usage: Replace Text('MetaClean') with GradientText('MetaClean')
