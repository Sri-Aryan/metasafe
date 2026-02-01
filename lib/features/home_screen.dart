import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_text.dart';
import '../appcolors.dart';
import '../core/providers/home_provider.dart';
import '../shared/widgets/quick_actions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // Fixed demo images for carousel
  static const List<String> _demoImages = [
    'assets/images/demo1.jpg',
    'assets/images/demo2.jpg',
    'assets/images/demo3.jpg',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeStateProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeStateProvider.notifier).refresh(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 80,
              floating: false,
              pinned: true,
              backgroundColor: Colors.black,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: const GradientText(
                  'MetaSafe',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    // Fixed Demo Carousel
                    _buildDemoCarousel(context),

                    const SizedBox(height: 32),

                    // Main Select Photos Card
                    _buildSelectPhotosCard(context, ref, screenHeight),

                    const SizedBox(height: 24),

                    // Quick Actions
                    const QuickActionsRow(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fixed Demo Images Carousel
  Widget _buildDemoCarousel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Recent Cleans',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.whiteText,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CarouselSlider.builder(
          itemCount: _demoImages.length,
          options: CarouselOptions(
            height: 180,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 7),
            autoPlayCurve: Curves.easeInOutCubic,
            enableInfiniteScroll: true,
          ),
          itemBuilder: (context, index, realIndex) {
            return _buildCarouselItem(
              context,
              _demoImages[index],
              index,
            );
          },
        ),
      ],
    );
  }

  // Carousel Item (Fixed Images)
  Widget _buildCarouselItem(
      BuildContext context,
      String imagePath,
      int index,
      ) {
    return GestureDetector(
      onTap: () {
        // Optional: Navigate or show demo message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Select your own photos to clean metadata'),
            backgroundColor: AppColors.primaryLightBlue,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: GlassCard(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Fixed Asset Image
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback colored container if image not found
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryLightBlue.withOpacity(0.3),
                          AppColors.primaryLightBlue.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.photo_library_outlined,
                      size: 60,
                      color: AppColors.whiteText.withOpacity(0.3),
                    ),
                  );
                },
              ),

              // Gradient Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.primaryLightBlue,
                        size: 20,
                      ),
                      Text(
                        'Demo ${index + 1}',
                        style: TextStyle(
                          color: AppColors.whiteText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Main Select Photos Card
  Widget _buildSelectPhotosCard(
      BuildContext context,
      WidgetRef ref,
      double screenHeight,
      ) {
    return GestureDetector(
      onTap: () => _selectImage(context, ref),
      child: GlassCard(
        height: screenHeight * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryLightBlue.withOpacity(0.2),
                    AppColors.primaryLightBlue.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.photo_library_outlined,
                size: 100,
                color: AppColors.whiteText.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Select Photos',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.whiteText,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap to scan privacy risks',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryLightBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryLightBlue.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.security,
                    size: 16,
                    color: AppColors.primaryLightBlue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Privacy Protected',
                    style: TextStyle(
                      color: AppColors.primaryLightBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Image Selection Method
  Future<void> _selectImage(BuildContext context, WidgetRef ref) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );

      if (image != null && context.mounted) {
        context.push('/details', extra: image.path);
      }
    } catch (e) {
      debugPrint('Image selection error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select image: ${e.toString()}'),
            backgroundColor: Colors.red.shade900,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
