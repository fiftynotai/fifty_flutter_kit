import 'package:flutter/widgets.dart';

import '../core/frame_cache_manager.dart';

/// Renders a single frame from the cache with gapless playback fallback.
///
/// Attempts to display the exact [frameIndex] from [cacheManager]. If that
/// frame is not yet cached, falls back to the nearest cached frame toward
/// frame 0 to avoid blank flashes during loading.
///
/// Uses [RawImage] for zero-copy GPU texture rendering.
class FrameDisplay extends StatelessWidget {
  /// Creates a [FrameDisplay] for the given [frameIndex].
  const FrameDisplay({
    required this.frameIndex,
    required this.cacheManager,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    super.key,
  });

  /// The target frame index to display.
  final int frameIndex;

  /// The cache manager holding decoded frame images.
  final FrameCacheManager cacheManager;

  /// How the frame image is fitted into the display area.
  final BoxFit fit;

  /// Display width (null = unconstrained).
  final double? width;

  /// Display height (null = unconstrained).
  final double? height;

  @override
  Widget build(BuildContext context) {
    // Try exact frame first, then fallback to nearest for gapless playback
    final image = cacheManager.getFrame(frameIndex) ??
        cacheManager.nearestCachedFrame(frameIndex);

    if (image == null) {
      // No frames loaded yet -- show empty SizedBox (only during initial load)
      return SizedBox(width: width, height: height);
    }

    return RawImage(
      image: image,
      fit: fit,
      width: width,
      height: height,
    );
  }
}
