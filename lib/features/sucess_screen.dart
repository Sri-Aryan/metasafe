import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_background.dart';
import '../../shared/widgets/gradient_text.dart';
import '../appcolors.dart';

class SuccessScreen extends StatefulWidget {
  final String cleanedImagePath;
  final String originalFileName;

  const SuccessScreen({
    super.key,
    required this.cleanedImagePath,
    required this.originalFileName,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _redirectTimer;
  int _countdown = 5;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    _startCountdown();
  }

  void _startCountdown() {
    _redirectTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        _redirectToHome();
      }
    });
  }

  void _redirectToHome() {
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _redirectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = widget.cleanedImagePath.split(Platform.pathSeparator).last;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Success Icon
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(48),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.3),
                          Colors.green.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.green,
                        width: 4,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 100,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const GradientText(
                    '✅ Metadata Cleaned!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      height: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Your image is now privacy-safe',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // File Path Card
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.folder_copy,
                                color: AppColors.primaryLightBlue,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Saved as:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.whiteText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Path Container
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.blackBackground,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.glassBorder,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // File Name
                                Text(
                                  fileName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primaryLightBlue,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Full Path
                                SelectableText(
                                  widget.cleanedImagePath,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontFamily: 'Courier',
                                    fontSize: 11,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Original filename
                          Text(
                            'Original: ${widget.originalFileName}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: AppColors.textMuted,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Countdown Timer
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.glassCardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.glassBorder,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Returning home in $_countdown seconds...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _redirectToHome,
                        icon: const Icon(Icons.home, size: 20),
                        label: const Text('Home Now'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.whiteText,
                          side: BorderSide(
                            color: AppColors.glassBorder,
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Share.shareXFiles([XFile(widget.cleanedImagePath)]);
                        },
                        icon: const Icon(Icons.share, size: 20),
                        label: const Text('Share Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLightBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
