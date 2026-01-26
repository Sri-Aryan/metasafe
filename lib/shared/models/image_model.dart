// lib/shared/models/image_file.dart
class ImageFile {
  final String path;
  final String name;
  final bool hasGps;
  final bool hasCamera;
  final bool hasTimestamp;
  final String riskLevel;
  final int originalSize;
  final DateTime? scanDate;

  const ImageFile({
    required this.path,
    required this.name,
    this.hasGps = false,
    this.hasCamera = false,
    this.hasTimestamp = false,
    required this.riskLevel,
    this.originalSize = 0,
    this.scanDate,
  });
}
