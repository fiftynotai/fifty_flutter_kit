import 'package:flutter/foundation.dart';

/// Immutable data class representing a single frame in a scroll sequence.
///
/// Each frame has a zero-based [index] and a resolved file [path].
/// Optional [width] and [height] may be populated after decoding.
@immutable
class FrameInfo {
  /// Creates a [FrameInfo] with the given [index] and [path].
  const FrameInfo({
    required this.index,
    required this.path,
    this.width,
    this.height,
  });

  /// Zero-based frame index in the sequence.
  final int index;

  /// Resolved file path for this frame.
  final String path;

  /// Optional frame width in pixels (null if unknown before decode).
  final double? width;

  /// Optional frame height in pixels (null if unknown before decode).
  final double? height;

  /// Creates a copy of this [FrameInfo] with the given fields replaced.
  FrameInfo copyWith({
    int? index,
    String? path,
    double? width,
    double? height,
  }) {
    return FrameInfo(
      index: index ?? this.index,
      path: path ?? this.path,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FrameInfo &&
        other.index == index &&
        other.path == path &&
        other.width == width &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(index, path, width, height);

  @override
  String toString() =>
      'FrameInfo(index: $index, path: $path, width: $width, height: $height)';
}
