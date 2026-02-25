import '../models/frame_info.dart';

/// Resolves frame file paths from a pattern string with `{index}` placeholder.
///
/// Given a [framePath] like `'assets/frames/hero_{index}.webp'` and a
/// [frameCount], this class resolves individual frame paths by replacing
/// `{index}` with a zero-padded frame number.
///
/// ## Example
///
/// ```dart
/// final resolver = FramePathResolver(
///   framePath: 'assets/hero_{index}.webp',
///   frameCount: 120,
/// );
///
/// resolver.resolve(0);   // 'assets/hero_000.webp'
/// resolver.resolve(42);  // 'assets/hero_042.webp'
/// resolver.resolve(119); // 'assets/hero_119.webp'
/// ```
class FramePathResolver {
  /// Creates a [FramePathResolver] for the given [framePath] pattern.
  ///
  /// Throws [ArgumentError] if [framePath] does not contain `{index}`.
  FramePathResolver({
    required this.framePath,
    required this.frameCount,
    this.indexPadWidth,
    this.indexOffset = 0,
  }) {
    if (!framePath.contains('{index}')) {
      throw ArgumentError.value(
        framePath,
        'framePath',
        'Must contain {index} placeholder',
      );
    }
  }

  /// Path pattern with `{index}` placeholder.
  final String framePath;

  /// Total number of frames in the sequence.
  final int frameCount;

  /// Override for zero-pad width. Null = auto-compute from [frameCount].
  final int? indexPadWidth;

  /// Starting index offset (0 = first frame is index 0, 1 = first frame is index 1).
  final int indexOffset;

  /// Effective pad width: custom override or auto-computed from [frameCount].
  int get effectivePadWidth =>
      indexPadWidth ?? (frameCount + indexOffset).toString().length;

  /// Resolve the path for the given zero-based frame [index].
  ///
  /// Applies [indexOffset] to shift from zero-based to the export numbering,
  /// then zero-pads the result to [effectivePadWidth] digits.
  String resolve(int index) {
    final adjusted = index + indexOffset;
    final padded = adjusted.toString().padLeft(effectivePadWidth, '0');
    return framePath.replaceAll('{index}', padded);
  }

  /// Resolve all frame paths, returning a list of [FrameInfo] in order.
  List<FrameInfo> resolveAll() {
    return List<FrameInfo>.generate(
      frameCount,
      (i) => FrameInfo(index: i, path: resolve(i)),
    );
  }
}
