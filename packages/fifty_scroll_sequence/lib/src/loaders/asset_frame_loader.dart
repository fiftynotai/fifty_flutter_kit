import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import '../utils/frame_path_resolver.dart';
import 'frame_loader.dart';

/// Loads image sequence frames from the Flutter asset bundle.
///
/// Uses [rootBundle] to load frame files and [ui.instantiateImageCodec]
/// to decode them into [ui.Image] objects for GPU-backed rendering.
///
/// ## Example
///
/// ```dart
/// final loader = AssetFrameLoader(
///   framePath: 'assets/hero/frame_{index}.webp',
///   frameCount: 120,
/// );
///
/// final image = await loader.loadFrame(0);
/// // Use image with RawImage widget...
/// image.dispose(); // When done
/// ```
class AssetFrameLoader implements FrameLoader {
  /// Creates an [AssetFrameLoader] for the given frame path pattern.
  AssetFrameLoader({
    required String framePath,
    required int frameCount,
    int? indexPadWidth,
    int indexOffset = 0,
  }) : _resolver = FramePathResolver(
          framePath: framePath,
          frameCount: frameCount,
          indexPadWidth: indexPadWidth,
          indexOffset: indexOffset,
        );

  final FramePathResolver _resolver;

  @override
  String resolveFramePath(int index) => _resolver.resolve(index);

  @override
  Future<ui.Image> loadFrame(int index) async {
    final path = resolveFramePath(index);
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
    );
    final frame = await codec.getNextFrame();
    codec.dispose();
    return frame.image;
  }

  @override
  void dispose() {
    // No persistent resources to release in asset loader.
  }
}
