import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Renders an image safely on both Flutter Web and Native platforms.
/// Handles `blob:` URLs produced by `image_picker` on Web without crashing.
class QuickTechWebSafeImage extends StatelessWidget {
  final dynamic fileOrPath; // File, String (path or url), or null
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const QuickTechWebSafeImage({
    super.key,
    required this.fileOrPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (fileOrPath == null) {
      return _buildFallback();
    }

    final String path = fileOrPath is File ? (fileOrPath as File).path : fileOrPath.toString();
    if (path.isEmpty) {
      return _buildFallback();
    }

    Widget imageWidget;
    if (kIsWeb) {
      // In Flutter Web, picked files are blob: URLs or network paths
      imageWidget = Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    } else {
      // On native mobile/desktop platforms
      final File file = fileOrPath is File ? (fileOrPath as File) : File(path);
      imageWidget = Image.file(
        file,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildFallback() {
    if (errorWidget != null) return errorWidget!;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 24),
    );
  }
}

/// Provides an ImageProvider safely for CircleAvatar or DecorationImage on Web & Native.
ImageProvider? getWebSafeImageProvider(dynamic fileOrPath) {
  if (fileOrPath == null) return null;
  final String path = fileOrPath is File ? (fileOrPath).path : fileOrPath.toString();
  if (path.isEmpty) return null;

  if (kIsWeb) {
    return NetworkImage(path);
  } else {
    final File file = fileOrPath is File ? fileOrPath : File(path);
    return FileImage(file);
  }
}
