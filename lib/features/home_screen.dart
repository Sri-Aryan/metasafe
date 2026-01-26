// lib/features/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_text.dart';
import '../appcolors.dart';
import '../core/providers/home_provider.dart';
import '../shared/widgets/quick_actions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeStateProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: GradientText('MetaClean'),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectImage(context, ref),
                        child: GlassCard(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_library_outlined,
                                size: 120,
                                color: AppColors.whiteText.withOpacity(0.8),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Select Photos',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppColors.whiteText,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tap to scan privacy risks',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    QuickActionsRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // FIXED: Only context.mounted, no ref.mounted
  // Future<void> _selectImage(BuildContext context, WidgetRef ref) async {
  //   final notifier = ref.read(homeStateProvider.notifier);
  //   await notifier.selectImage();
  //
  //   try {
  //     final ImagePicker picker = ImagePicker();
  //     final XFile? image = await picker.pickImage(
  //       source: ImageSource.gallery,
  //       maxWidth: 1024,
  //       imageQuality: 85,
  //     );
  //
  //     if (image != null && context.mounted) {
  //       if (mounted) {
  //         context.push('/details', extra: image.path);
  //       }
  //     }
  //   } catch (e) {
  //     // Error handled by notifier
  //     debugPrint('Image selection error: $e');
  //   }
  // }
// lib/features/home/home_screen.dart - FIXED _selectImage
  Future<void> _selectImage(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(homeStateProvider.notifier);
    await notifier.selectImage();

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );

      // FIXED: Only use context.mounted, no standalone 'mounted'
      if (image != null && context.mounted) {
        context.push('/details', extra: image.path);
      }
    } catch (e) {
      debugPrint('Image selection error: $e');
      // Notifier handles error state
    }
  }

}
