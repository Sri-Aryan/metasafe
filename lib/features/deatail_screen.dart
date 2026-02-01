import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' hide Image;
import 'dart:io';
import '../../shared/widgets/glass_card.dart';
import '../../shared/widgets/gradient_text.dart';
import '../appcolors.dart';

class DetailsScreen extends ConsumerStatefulWidget {
  final String imagePath;

  const DetailsScreen({super.key, required this.imagePath});

  @override
  ConsumerState<DetailsScreen> createState() => _DetailsScreenState();
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
      final bytes = await File(widget.imagePath).readAsBytes();
     _originalBytes = (await File(widget.imagePath).readAsBytes()) as Uint8List?;
      final data = await readExifFromBytes(bytes);

      setState(() {
        _metadata = data.map((key, value) => MapEntry(key, value.toString()));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _metadata = {'Error': 'Failed to read metadata: $e'};
      });
    }
  }

  // Future<void> _cleanMetadata() async {
  //   setState(() => _isCleaning = true);
  //
  //   try {
  //     final bytes = await File(widget.imagePath).readAsBytes();
  //     _originalBytes = (await File(widget.imagePath).readAsBytes()) as Uint8List?;
  //     final exifData = Exif.fromBytes(bytes);
  //
  //     // Remove sensitive metadata
  //     exifData.make = '';
  //     exifData.model = '';
  //     exifData.dateTimeOriginal = null;
  //     exifData.gpsLatitude = null;
  //     exifData.gpsLongitude = null;
  //     exifData.gpsAltitude = null;
  //     exifData.imageLength = null;
  //     exifData.imageWidth = null;
  //
  //     final cleanedBytes = exifData.writeExifBytes(_originalBytes);
  //     final outputPath = '${widget.imagePath}_cleaned.jpg';
  //     await File(outputPath).writeAsBytes(cleanedBytes);
  //
  //     if (mounted) {
  //       _showSuccessScreen();
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

  Future<void> _cleanMetadata() async {
    setState(() => _isCleaning = true);

    try {
      final File originalFile = File(widget.imagePath);
      final bytes = await originalFile.readAsBytes();

      // 1. Decode the image using the 'image' package
      final img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception("Could not decode image");
      }

      // 2. Strip Metadata
      // By resetting the exif data to an empty object, we remove all tags.
      image.exif = img.ExifData();

      // 3. Re-encode the image to JPG (without metadata)
      final cleanedBytes = img.encodeJpg(image, quality: 100);

      // 4. Write to a new file
      // Creating a new path with '_cleaned' suffix
      final String dir = originalFile.parent.path;
      final String name = originalFile.uri.pathSegments.last;
      final String newName = name.replaceAll('.jpg', '_cleaned.jpg');
      final outputPath = '$dir/$newName';

      await File(outputPath).writeAsBytes(cleanedBytes);

      if (mounted) {
        _showSuccessScreen();
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

  // Future<void> _cleanMetadata() async {
  //   setState(() => _isCleaning = true);
  //
  //   try {
  //     final bytes = await File(widget.imagePath).readAsBytes();
  //     // Keep a copy of the original bytes
  //     _originalBytes = bytes as Uint8List?;
  //
  //     // Read existing EXIF data to work with
  //     final Map<String, IfdTag> exifData = await readExifFromBytes(bytes);
  //
  //     // Create a new Exif object to modify
  //     final newExif = Exif.fromMap(exifData);
  //
  //     // Remove sensitive metadata by setting them to null or empty
  //     newExif.imageIfd['Make'] = null;
  //     newExif.imageIfd['Model'] = null;
  //     newExif.exifIfd['DateTimeOriginal'] = null;
  //     newExif.gpsIfd['GPSLatitude'] = null;
  //     newExif.gpsIfd['GPSLongitude'] = null;
  //     newExif.gpsIfd['GPSAltitude'] = null;
  //     newExif.imageIfd['ImageLength'] = null;
  //     newExif.imageIfd['ImageWidth'] = null;
  //
  //     final cleanedBytes = await newExif.writeExifBytes(_originalBytes!);
  //     final outputPath = '${widget.imagePath}_cleaned.jpg';
  //     await File(outputPath).writeAsBytes(cleanedBytes);
  //
  //     if (mounted) {
  //       _showSuccessScreen();
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


  void _showSuccessScreen() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        imagePath: widget.imagePath,
      ),
    );
  }

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

          // Scrollable Metadata Content
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
                          // Loading State
                          if (_isLoading)
                            const Padding(
                              padding: EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.primaryLightBlue,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Scanning metadata...',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Metadata List
                          if (!_isLoading && _metadata != null) ...[
                            _buildMetadataSection(),
                          ],

                          const SizedBox(height: 32),

                          // Clean Button
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
                                      valueColor: AlwaysStoppedAnimation<Color>(
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

    // Filter out empty/null values and common noise
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
              Icon(Icons.privacy_tip, size: 48, color: AppColors.primaryLightBlue),
              SizedBox(height: 12),
              Text(
                '✅ No sensitive metadata found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Your image is already privacy-safe',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
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
        // Risk Indicators
        _buildRiskIndicators(filteredMetadata),
        const SizedBox(height: 24),

        // Metadata List
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

    if (metadata.containsKey('GPSLatitude') ||
        metadata.containsKey('GPSLatitudeRef')) {
      risks['GPS Location'] = Icons.location_on;
    }
    if (metadata.containsKey('Make') || metadata.containsKey('Model')) {
      risks['Camera Info'] = Icons.camera_alt;
    }
    if (metadata.containsKey('DateTimeOriginal')) {
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
            Row(
              children: [
                Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                const Text(
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
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.4),
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

// Success Screen Dialog
class SuccessDialog extends StatelessWidget {
  final String imagePath;

  const SuccessDialog({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(32),
      child: Stack(
        children: [
          GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Checkmark
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),

                const GradientText(
                  '✅ Privacy Saved!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                const Text(
                  'You have saved your privacy\nMetadata successfully removed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigate to share
                          // Share.shareXFiles([XFile(imagePath)]);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Share',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
