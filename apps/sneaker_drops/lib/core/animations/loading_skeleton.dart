import 'package:flutter/material.dart';

import '../theme/sneaker_colors.dart';
import 'animation_constants.dart';

/// **LoadingSkeleton**
///
/// Skeleton placeholder with shimmer animation for loading states.
/// Creates a polished loading experience while data is being fetched.
///
/// **Specs from design doc:**
/// - Duration: 1500ms loop
/// - LinearGradient shimmer from left to right
/// - Base color: surfaceDark
/// - Highlight color: surfaceDark.withValues(alpha: 0.7)
///
/// **Usage:**
/// ```dart
/// // Basic skeleton
/// LoadingSkeleton(
///   width: 200,
///   height: 150,
/// )
///
/// // Rounded skeleton
/// LoadingSkeleton(
///   width: 100,
///   height: 100,
///   borderRadius: BorderRadius.circular(50),
/// )
/// ```
class LoadingSkeleton extends StatefulWidget {
  /// Width of the skeleton.
  final double width;

  /// Height of the skeleton.
  final double height;

  /// Border radius. Defaults to 8px.
  final BorderRadius? borderRadius;

  /// Base color of the skeleton.
  final Color? baseColor;

  /// Highlight color for the shimmer effect.
  final Color? highlightColor;

  /// Animation duration. Defaults to 1500ms.
  final Duration duration;

  const LoadingSkeleton({
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.duration = SneakerAnimations.shimmer,
    super.key,
  });

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gradientAnimation;

  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _gradientAnimation = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _controller.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (_reduceMotion) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? SneakerColors.surfaceDark;
    final highlightColor = widget.highlightColor ??
        SneakerColors.surfaceDark.withValues(alpha: 0.7);

    if (_reduceMotion) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _gradientAnimation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _gradientAnimation.value - 0.3,
                _gradientAnimation.value,
                _gradientAnimation.value + 0.3,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// **SkeletonCard**
///
/// Product card placeholder with image, title, and price skeletons.
///
/// **Usage:**
/// ```dart
/// SkeletonCard()
/// ```
class SkeletonCard extends StatelessWidget {
  /// Width of the card. Defaults to 200.
  final double width;

  /// Height of the image area. Defaults to 150.
  final double imageHeight;

  const SkeletonCard({
    this.width = 200,
    this.imageHeight = 150,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SneakerColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SneakerColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          LoadingSkeleton(
            width: width - 24,
            height: imageHeight,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 12),

          // Brand placeholder
          LoadingSkeleton(
            width: 60,
            height: 12,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),

          // Title placeholder
          LoadingSkeleton(
            width: width - 48,
            height: 16,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 6),

          // Subtitle placeholder
          LoadingSkeleton(
            width: width - 80,
            height: 14,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),

          // Price placeholder
          LoadingSkeleton(
            width: 80,
            height: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

/// **SkeletonText**
///
/// Text line placeholder with configurable width.
///
/// **Usage:**
/// ```dart
/// SkeletonText(width: 120)  // Fixed width
/// SkeletonText()            // Full width
/// ```
class SkeletonText extends StatelessWidget {
  /// Width of the text line. Null for full width.
  final double? width;

  /// Height of the text line. Defaults to 14.
  final double height;

  const SkeletonText({
    this.width,
    this.height = 14,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingSkeleton(
      width: width ?? double.infinity,
      height: height,
      borderRadius: BorderRadius.circular(4),
    );
  }
}

/// **SkeletonCircle**
///
/// Circular placeholder for avatars and icons.
///
/// **Usage:**
/// ```dart
/// SkeletonCircle(size: 48)  // Avatar
/// SkeletonCircle(size: 24)  // Icon
/// ```
class SkeletonCircle extends StatelessWidget {
  /// Diameter of the circle.
  final double size;

  const SkeletonCircle({
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingSkeleton(
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
    );
  }
}

/// **SkeletonGrid**
///
/// Grid of skeleton cards for loading product grids.
///
/// **Usage:**
/// ```dart
/// SkeletonGrid(
///   crossAxisCount: 2,
///   itemCount: 6,
/// )
/// ```
class SkeletonGrid extends StatelessWidget {
  /// Number of columns.
  final int crossAxisCount;

  /// Number of skeleton items.
  final int itemCount;

  /// Spacing between items.
  final double spacing;

  const SkeletonGrid({
    this.crossAxisCount = 2,
    this.itemCount = 6,
    this.spacing = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: 0.7,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const SkeletonCard(),
    );
  }
}
