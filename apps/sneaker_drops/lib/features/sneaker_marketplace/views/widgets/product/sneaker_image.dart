import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/animations/loading_skeleton.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';

/// **SneakerImage**
///
/// Cached network image with loading skeleton and error fallback.
/// Provides a polished image loading experience with smooth transitions.
///
/// **Features:**
/// - Placeholder skeleton while loading
/// - Error fallback with sneaker icon
/// - Fade in animation on load
/// - Memory and disk caching via cached_network_image
///
/// **Usage:**
/// ```dart
/// SneakerImage(
///   imageUrl: sneaker.imageUrl,
///   width: 200,
///   height: 150,
///   fit: BoxFit.cover,
/// )
/// ```
class SneakerImage extends StatelessWidget {
  /// URL of the image to load.
  final String imageUrl;

  /// Width of the image container.
  final double? width;

  /// Height of the image container.
  final double? height;

  /// How the image should be inscribed into the space.
  final BoxFit fit;

  /// Border radius for the image. Defaults to 8px.
  final BorderRadius? borderRadius;

  /// Fade in duration. Defaults to 300ms.
  final Duration fadeInDuration;

  /// Whether to show border around the image.
  final bool showBorder;

  /// Custom placeholder widget.
  final Widget? placeholder;

  /// Custom error widget.
  final Widget? errorWidget;

  /// Creates a [SneakerImage] with the specified parameters.
  const SneakerImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fadeInDuration = SneakerAnimations.medium,
    this.showBorder = false,
    this.placeholder,
    this.errorWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? SneakerRadii.radiusMd;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        border: showBorder
            ? Border.all(
                color: SneakerColors.border,
                width: 1,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: fit,
          fadeInDuration: fadeInDuration,
          fadeInCurve: SneakerAnimations.standard,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) => _buildErrorWidget(),
          memCacheWidth: _calculateCacheSize(width),
          memCacheHeight: _calculateCacheSize(height),
        ),
      ),
    );
  }

  /// Build the loading placeholder.
  Widget _buildPlaceholder() {
    if (placeholder != null) return placeholder!;

    return LoadingSkeleton(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      borderRadius: borderRadius ?? SneakerRadii.radiusMd,
    );
  }

  /// Build the error fallback widget.
  Widget _buildErrorWidget() {
    if (errorWidget != null) return errorWidget!;

    return Container(
      width: width,
      height: height,
      color: SneakerColors.surfaceDark,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: _calculateIconSize(),
            color: SneakerColors.slateGrey,
          ),
          const SizedBox(height: 8),
          Text(
            'Image unavailable',
            style: TextStyle(
              fontSize: 12,
              color: SneakerColors.slateGrey,
            ),
          ),
        ],
      ),
    );
  }

  /// Calculate appropriate icon size based on container dimensions.
  double _calculateIconSize() {
    final minDimension = (width ?? 100).clamp(50.0, double.infinity);
    final heightDim = (height ?? 100).clamp(50.0, double.infinity);
    final smaller = minDimension < heightDim ? minDimension : heightDim;
    return (smaller * 0.3).clamp(24.0, 48.0);
  }

  /// Calculate cache size for memory optimization.
  /// Returns null if dimension is not specified.
  int? _calculateCacheSize(double? dimension) {
    if (dimension == null) return null;
    // Use 2x for high DPI displays
    return (dimension * 2).toInt();
  }
}

/// **SneakerImageGallery**
///
/// Horizontal scrollable gallery of sneaker images.
/// Useful for product detail pages showing multiple angles.
///
/// **Usage:**
/// ```dart
/// SneakerImageGallery(
///   images: sneaker.images,
///   height: 300,
///   onImageTap: (index) => showFullscreen(index),
/// )
/// ```
class SneakerImageGallery extends StatelessWidget {
  /// List of image URLs to display.
  final List<String> images;

  /// Height of the gallery.
  final double height;

  /// Callback when an image is tapped.
  final void Function(int index)? onImageTap;

  /// Spacing between images.
  final double spacing;

  /// Creates a [SneakerImageGallery] with the specified parameters.
  const SneakerImageGallery({
    required this.images,
    this.height = 200,
    this.onImageTap,
    this.spacing = 12,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'No images available',
            style: TextStyle(
              color: SneakerColors.slateGrey,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: spacing),
        itemCount: images.length,
        separatorBuilder: (context, index) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onImageTap?.call(index),
            child: SneakerImage(
              imageUrl: images[index],
              height: height,
              width: height * 1.2,
              fit: BoxFit.cover,
              borderRadius: SneakerRadii.radiusLg,
            ),
          );
        },
      ),
    );
  }
}
