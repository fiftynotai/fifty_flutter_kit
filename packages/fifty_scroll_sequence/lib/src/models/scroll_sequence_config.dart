import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Configuration data class for a scroll-driven image sequence.
///
/// Holds all parameters needed to set up a [ScrollSequence] widget,
/// including frame count, path pattern, scroll extent, and display options.
@immutable
class ScrollSequenceConfig {
  /// Creates a [ScrollSequenceConfig] with the given parameters.
  const ScrollSequenceConfig({
    required this.frameCount,
    required this.framePath,
    this.scrollExtent = 3000.0,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.indexPadWidth,
    this.indexOffset = 0,
  });

  /// Total number of frames in the sequence.
  final int frameCount;

  /// Path pattern with `{index}` placeholder.
  ///
  /// Example: `'assets/frames/hero_{index}.webp'`
  final String framePath;

  /// Total scroll distance in logical pixels for the full sequence.
  final double scrollExtent;

  /// How frames are fitted into the display area.
  final BoxFit fit;

  /// Display width constraint (null = unconstrained).
  final double? width;

  /// Display height constraint (null = unconstrained).
  final double? height;

  /// Override for zero-pad width. Null = auto-compute from [frameCount].
  final int? indexPadWidth;

  /// Starting index offset (0 = first frame is index 0, 1 = first frame is index 1).
  final int indexOffset;

  /// Creates a copy of this [ScrollSequenceConfig] with the given fields replaced.
  ScrollSequenceConfig copyWith({
    int? frameCount,
    String? framePath,
    double? scrollExtent,
    BoxFit? fit,
    double? width,
    double? height,
    int? indexPadWidth,
    int? indexOffset,
  }) {
    return ScrollSequenceConfig(
      frameCount: frameCount ?? this.frameCount,
      framePath: framePath ?? this.framePath,
      scrollExtent: scrollExtent ?? this.scrollExtent,
      fit: fit ?? this.fit,
      width: width ?? this.width,
      height: height ?? this.height,
      indexPadWidth: indexPadWidth ?? this.indexPadWidth,
      indexOffset: indexOffset ?? this.indexOffset,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScrollSequenceConfig &&
        other.frameCount == frameCount &&
        other.framePath == framePath &&
        other.scrollExtent == scrollExtent &&
        other.fit == fit &&
        other.width == width &&
        other.height == height &&
        other.indexPadWidth == indexPadWidth &&
        other.indexOffset == indexOffset;
  }

  @override
  int get hashCode => Object.hash(
        frameCount,
        framePath,
        scrollExtent,
        fit,
        width,
        height,
        indexPadWidth,
        indexOffset,
      );

  @override
  String toString() =>
      'ScrollSequenceConfig(frameCount: $frameCount, framePath: $framePath, '
      'scrollExtent: $scrollExtent, fit: $fit, width: $width, '
      'height: $height, indexPadWidth: $indexPadWidth, '
      'indexOffset: $indexOffset)';
}
