import 'dart:ui' as ui;

/// Abstract base class for loading image sequence frames.
///
/// Implementations decode frames from various sources (assets, network, etc.)
/// and return [ui.Image] objects ready for rendering with [RawImage].
///
/// Callers are responsible for disposing returned [ui.Image] objects
/// when they are no longer needed.
abstract class FrameLoader {
  /// Load and decode the frame at the given zero-based [index].
  ///
  /// Returns a [ui.Image] that is ready for rendering. The caller
  /// takes ownership and must dispose it when no longer needed.
  Future<ui.Image> loadFrame(int index);

  /// Resolve the file path for the given zero-based [index].
  String resolveFramePath(int index);

  /// Release any resources held by this loader.
  void dispose();
}
