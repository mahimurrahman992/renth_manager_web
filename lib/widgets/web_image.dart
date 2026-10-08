import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:renth_manager/consts/api.dart';

/// A robust, cross-platform image widget for Flutter Web, Mobile, and Desktop.
///
/// Features:
/// 1. Solves CORS issues on Flutter Web by using [WebHtmlElementStrategy.prefer].
/// 2. Automatically normalizes relative image paths (e.g. `uploads/...`, `/uploads/...`).
/// 3. Fixes malformed URL concatenations (e.g. `https://renth.appuploads/...`, `https://renth.app//...`).
/// 4. Handles `blob:`, `data:`, and local file paths safely.
/// 5. Gracefully handles null, empty, or whitespace strings with a clean fallback.
/// 6. Provides built-in loading indicator and error placeholder.
class WebSafeNetworkImage extends StatelessWidget {
  final dynamic imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isCircle;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Alignment alignment;

  const WebSafeNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isCircle = false,
    this.placeholder,
    this.errorWidget,
    this.alignment = Alignment.center,
  });

  /// Normalizes any raw image URL, relative path, or file object to a valid loadable URL.
  static String resolveUrl(dynamic input) {
    if (input == null) return '';
    String path;
    if (input is File) {
      path = input.path;
    } else {
      path = input.toString().trim();
    }
    if (path.isEmpty) return '';

    // If it's a blob URL, data URI, or local file path
    if (path.startsWith('blob:') || path.startsWith('data:') || path.startsWith('file:')) {
      return path;
    }

    // Fix broken concatenations like 'https://renth.appuploads/'
    if (path.contains('renth.appuploads/')) {
      path = path.replaceFirst('renth.appuploads/', 'renth.app/uploads/');
    }

    // Fix double slashes like 'https://renth.app//uploads'
    if (path.contains('renth.app//')) {
      path = path.replaceAll('renth.app//', 'renth.app/');
    }

    // If the input was just baseUrl or root URL without an actual image path
    if (path == Api.baseUrl || path == '${Api.baseUrl}/' || path == Api.imageUrl) {
      return '';
    }

    // Absolute URLs
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // Protocol-relative URLs
    if (path.startsWith('//')) {
      return 'https:$path';
    }

    // Relative path with leading slash
    if (path.startsWith('/')) {
      return '${Api.baseUrl}$path';
    }

    // Relative path without leading slash
    return '${Api.baseUrl}/$path';
  }

  Widget _buildFallback() {
    if (errorWidget != null) return errorWidget!;

    Widget iconWidget;
    if (isCircle || (width != null && height != null && width! <= 48 && height! <= 48)) {
      iconWidget = Icon(
        Icons.person,
        size: width != null ? (width! * 0.6).clamp(16.0, 36.0) : 24,
        color: Colors.grey.shade400,
      );
    } else {
      iconWidget = Icon(
        Icons.image_not_supported_outlined,
        size: width != null ? (width! * 0.4).clamp(18.0, 42.0) : 26,
        color: Colors.grey.shade400,
      );
    }

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : (borderRadius ?? BorderRadius.circular(8)),
      ),
      child: iconWidget,
    );
  }

  Widget _buildLoading() {
    if (placeholder != null) return placeholder!;
    final double indicatorSize = width != null ? (width! * 0.35).clamp(14.0, 24.0) : 18.0;

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : (borderRadius ?? BorderRadius.circular(8)),
      ),
      child: SizedBox(
        width: indicatorSize,
        height: indicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String cleanUrl = resolveUrl(imageUrl);

    if (cleanUrl.isEmpty) {
      return _buildFallback();
    }

    Widget imageWidget;

    // Check if it's a native local file (only on non-web platforms)
    if (!kIsWeb && imageUrl is File) {
      imageWidget = Image.file(
        imageUrl as File,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    } else {
      // Network, blob:, or data: URL
      imageWidget = Image.network(
        cleanUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoading();
        },
        errorBuilder: (context, error, stackTrace) => _buildFallback(),
      );
    }

    if (isCircle) {
      return ClipOval(child: imageWidget);
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
