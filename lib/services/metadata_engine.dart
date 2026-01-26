// lib/shared/services/metadata_engine.dart
import 'package:image/image.dart' as img;
import 'dart:io';

class MetadataEngine {
  static Future<File> removeMetadata(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) throw Exception('Invalid image');

    // Remove all metadata by re-encoding without EXIF
    final cleanedImage = img.encodeJpg(image, quality: 95);

    final outputFile = File('${imageFile.path}_cleaned.jpg');
    await outputFile.writeAsBytes(cleanedImage);

    return outputFile;
  }

  static Future<Map<String, dynamic>> scanMetadata(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    // Parse EXIF data (GPS, camera, timestamp)
    final hasGps = image.exif?.ifd0['GPS GPSLatitude'] != null;
    final hasCamera = image.exif?.ifd0['Make'] != null;

    return {
      'gps': hasGps,
      'camera': hasCamera,
      'timestamp': true, // Always present
      'riskLevel': hasGps ? 'HIGH' : 'LOW',
    };
  }
}
