import 'dart:io';
import 'dart:typed_data';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:share_plus/share_plus.dart';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_text.dart';
import '../appcolors.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  final String imagePath;

  const DetailsScreen({super.key, required this.imagePath});

  @override
  ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
}

class SuccessDialog extends StatelessWidget {
  final String imagePath;
  final String originalFileName;

  const SuccessDialog({
    super.key,
    required this.imagePath,
    required this.originalFileName,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = imagePath.split(Platform.pathSeparator).last;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(32),
      child: GlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 72,
              ),
            ),

            const SizedBox(height: 32),

            // Title
            const GradientText(
              '✅ Metadata Cleaned!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 16),

            // Subtitle
            Text(
              'Your image is now privacy-safe',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 32),

            GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.folder_copy,
                            color: AppColors.primaryLightBlue,
                            size: 20
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Saved as:',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Path Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.blackBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.glassBorder,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // File Name (Bold)
                          Text(
                            fileName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryLightBlue,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Full Path (Selectable)
                          SelectableText(
                            imagePath,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            minLines: 1,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // File Size Info
                    Text(
                      'Original: $originalFileName',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Done'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Share cleaned file
                      Share.shareXFiles([XFile(imagePath)]);
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Share'),
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
    );
  }
}

class _DetailsScreenState extends ConsumerState<DetailsScreen>
    with TickerProviderStateMixin {
  Map<String, String>? _metadata;
  bool _isLoading = true;
  bool _isCleaning = false;
  Uint8List? _originalBytes;

  @override
  void initState() {
    super.initState();
    _loadMetadata();
  }

  Future<void> _loadMetadata() async {
    try {
      final file = File(widget.imagePath);
      _originalBytes = await file.readAsBytes();

      // 'readExifFromBytes' comes from the 'exif' package
      final data = await readExifFromBytes(_originalBytes!);

      if (mounted) {
        setState(() {
          _metadata = data.map((key, value) => MapEntry(key, value.toString()));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _metadata = {'Error': 'Failed to read metadata: $e'};
        });
      }
    }
  }

  Future<void> _cleanMetadata() async {
    setState(() => _isCleaning = true);

    try {
      final img.Image? originalImage = img.decodeImage(_originalBytes!);
      if (originalImage == null) {
        throw Exception("Failed to decode image");
      }

      final cleanedBytes = img.encodeJpg(originalImage, quality: 100);

      // ✅ FIXED: Get original filename properly
      final originalFile = File(widget.imagePath);
      final originalFileName = originalFile.path.split(Platform.pathSeparator).last;
      final dir = originalFile.parent.path;
      final newName = originalFileName.replaceAll(RegExp(r'\.(jpg|jpeg|png|heic)$', caseSensitive: false), '_cleaned.jpg');
      final outputPath = '$dir/$newName';

      await File(outputPath).writeAsBytes(cleanedBytes);

      if (mounted) {
        context.push(
          '/success',
          extra: {
            'cleanedImagePath': outputPath,
            'originalFileName': originalFileName,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cleaning failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCleaning = false);
      }
    }
  }

// Updated _showSuccessScreen method
  void _showSuccessScreen(String newPath, String originalFileName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        imagePath: newPath,
        originalFileName: originalFileName,
      ),
    );
  }

  // Future<void> _cleanMetadata() async {
  //   setState(() => _isCleaning = true);
  //
  //   try {
  //     // 1. Decode the image
  //     final img.Image? originalImage = img.decodeImage(_originalBytes!);
  //
  //     if (originalImage == null) {
  //       throw Exception("Failed to decode image");
  //     }
  //
  //     // 2. Remove Metadata (create a new image without it)
  //     // The image package strips EXIF by default when re-encoding
  //     // unless you explicitly copy it over.
  //     final cleanedBytes = img.encodeJpg(originalImage, quality: 100);
  //
  //     // 3. Save to new file
  //     final String dir = File(widget.imagePath).parent.path;
  //     final String filename = widget.imagePath.split(Platform.pathSeparator).last;
  //     final String newName = filename.replaceAll('.jpg', '_cleaned.jpg');
  //     final String outputPath = '$dir/$newName';
  //
  //     await File(outputPath).writeAsBytes(cleanedBytes);
  //
  //     if (mounted) {
  //       _showSuccessScreen(outputPath);
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Cleaning failed: $e')),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() => _isCleaning = false);
  //     }
  //   }
  // }

  // void _showSuccessScreen(String newPath) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => SuccessDialog(
  //       imagePath: newPath,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fixed Image Thumbnail (Half Screen)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.broken_image_outlined,
                    size: 100,
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
          ),

          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 60,
                    floating: true,
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: const GradientText(
                        'Metadata Details',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isLoading)
                            const Padding(
                              padding: EdgeInsets.all(40),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryLightBlue,
                                  ),
                                ),
                              ),
                            ),

                          if (!_isLoading && _metadata != null) ...[
                            _buildMetadataSection(),
                          ],

                          const SizedBox(height: 32),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isCleaning ? null : _cleanMetadata,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryLightBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: _isCleaning
                                  ? const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Cleaning...'),
                                ],
                              )
                                  : const Text(
                                '🛡️ Clean Metadata',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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
        ],
      ),
    );
  }

  Widget _buildMetadataSection() {
    final filteredMetadata = <String, String>{};

    _metadata!.forEach((key, value) {
      if (value.isNotEmpty &&
          value != 'null' &&
          !key.startsWith('MakerNote') &&
          !key.contains('Thumbnail')) {
        filteredMetadata[key] = value;
      }
    });

    if (filteredMetadata.isEmpty) {
      return const GlassCard(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.privacy_tip,
                  size: 48, color: AppColors.primaryLightBlue),
              SizedBox(height: 12),
              Text(
                '✅ No sensitive metadata found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRiskIndicators(filteredMetadata),
        const SizedBox(height: 24),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: filteredMetadata.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.whiteText,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRiskIndicators(Map<String, String> metadata) {
    final risks = <String, IconData>{};

    if (metadata.containsKey('GPS GPSLatitude') ||
        metadata.keys.any((k) => k.contains('GPS'))) {
      risks['GPS Location'] = Icons.location_on;
    }
    if (metadata.containsKey('Image Make') || metadata.containsKey('Image Model')) {
      risks['Camera Info'] = Icons.camera_alt;
    }
    if (metadata.containsKey('Image DateTime')) {
      risks['Timestamp'] = Icons.schedule;
    }

    return risks.isEmpty
        ? const SizedBox.shrink()
        : GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                SizedBox(width: 8),
                Text(
                  '⚠️ Privacy Risks Found',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: risks.entries.map((risk) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red ,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.red,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(risk.value, size: 14, color: Colors.red),
                      const SizedBox(width: 6),
                      Text(
                        risk.key,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}