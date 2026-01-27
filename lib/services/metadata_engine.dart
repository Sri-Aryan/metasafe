// lib/shared/services/metadata_engine.dart
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:exif/exif.dart';

import '../shared/models/image_model.dart';

class MetadataEngine {
  static Future<ImageFile> scanMetadata(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final exifData = await readExifFromBytes(bytes);

      final hasGps = exifData.containsKey('GPS GPSLatitude') ||
          exifData.containsKey('GPS GPSLongitude');
      final hasCamera = exifData.containsKey('Image Make') ||
          exifData.containsKey('Image Model');
      final hasTimestamp = exifData.containsKey('Image DateTime');

      final riskScore = _calculateRisk(hasGps, hasCamera, hasTimestamp);

      return ImageFile(
        path: imageFile.path,
        name: imageFile.path.split('/').last,
        hasGps: hasGps,
        hasCamera: hasCamera,
        hasTimestamp: hasTimestamp,
        riskLevel: riskScore,
        originalSize: bytes.length,
      );
    } catch (e) {
      return ImageFile(
        path: imageFile.path,
        name: imageFile.path.split('/').last,
        riskLevel: 'LOW',
      );
    }
  }

  static Future<File> removeMetadata(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Invalid image file');
    }

    // Re-encode without metadata
    final cleanedBytes = img.encodeJpg(image, quality: 95);
    final outputPath = '${imageFile.path}_cleaned.jpg';
    final outputFile = File(outputPath);

    await outputFile.writeAsBytes(cleanedBytes);
    return outputFile;
  }

  static String _calculateRisk(bool gps, bool camera, bool timestamp) {
    if (gps) return 'HIGH';
    if (camera) return 'MEDIUM';
    return 'LOW';
  }
}
