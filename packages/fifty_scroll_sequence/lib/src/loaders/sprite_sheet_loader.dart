import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import 'frame_loader.dart';

/// Configuration for a single sprite sheet image containing a grid of frames.
///
/// Each sprite sheet is a single image file arranged as a [columns] x [rows]
/// grid, where each cell is a frame of [frameWidth] x [frameHeight] pixels.
///
/// ## Example
///
/// ```dart
/// const config = SpriteSheetConfig(
///   assetPath: 'assets/sprites/sheet_01.webp',
///   columns: 10,
///   rows: 10,
///   frameWidth: 320,
///   frameHeight: 180,
/// );
/// print(config.maxFrames); // 100
/// ```
class SpriteSheetConfig {
  /// Creates a sprite sheet configuration.
  const SpriteSheetConfig({
    required this.assetPath,
    required this.columns,
    required this.rows,
    required this.frameWidth,
    required this.frameHeight,
  });

  /// Asset path to the sprite sheet image.
  final String assetPath;

  /// Number of columns in the sprite grid.
  final int columns;

  /// Number of rows in the sprite grid.
  final int rows;

  /// Width of each frame in pixels.
  final int frameWidth;

  /// Height of each frame in pixels.
  final int frameHeight;

  /// Total frames in this sheet ([columns] * [rows]).
  int get maxFrames => columns * rows;
}

/// Loads individual frames by cropping them from sprite sheet grid images.
///
/// Supports multiple sprite sheets for large sequences. Each sheet contains
/// a grid of frames at [columns] x [rows]. The global frame index is mapped
/// to the correct sheet, row, and column automatically.
///
/// ## Frame Extraction
///
/// Uses [Canvas] + [PictureRecorder] to draw the crop region from the
/// source sheet into a new [ui.Image], ensuring GPU-backed output.
///
/// Sheet images are lazily loaded on first access and cached for reuse
/// across all frames within the same sheet.
///
/// ## Example
///
/// ```dart
/// final loader = SpriteSheetLoader(
///   sheets: [
///     SpriteSheetConfig(
///       assetPath: 'assets/sprites/sheet_01.webp',
///       columns: 10,
///       rows: 10,
///       frameWidth: 320,
///       frameHeight: 180,
///     ),
///   ],
///   totalFrames: 100,
/// );
///
/// final image = await loader.loadFrame(0);
/// // Use image with RawImage widget...
/// image.dispose(); // When done
/// ```
class SpriteSheetLoader implements FrameLoader {
  /// Creates a [SpriteSheetLoader] for the given sprite sheet configurations.
  ///
  /// At least one sheet must be provided. The [totalFrames] should not exceed
  /// the sum of [SpriteSheetConfig.maxFrames] across all sheets.
  SpriteSheetLoader({
    required this.sheets,
    required this.totalFrames,
  }) : assert(sheets.isNotEmpty, 'At least one sheet required');

  /// Ordered list of sprite sheet configurations.
  final List<SpriteSheetConfig> sheets;

  /// Total frame count across all sheets.
  final int totalFrames;

  /// Cached decoded sheet images, keyed by sheet index. Loaded lazily.
  final Map<int, ui.Image> _sheetImages = {};

  @override
  Future<ui.Image> loadFrame(int index) async {
    final (sheetIndex, localIndex) = _resolveSheetPosition(index);
    final sheet = sheets[sheetIndex];

    // Load sheet image if not cached
    _sheetImages[sheetIndex] ??= await _loadSheetImage(sheet.assetPath);
    final sheetImage = _sheetImages[sheetIndex]!;

    // Calculate crop rect from grid position
    final col = localIndex % sheet.columns;
    final row = localIndex ~/ sheet.columns;
    final srcRect = ui.Rect.fromLTWH(
      col * sheet.frameWidth.toDouble(),
      row * sheet.frameHeight.toDouble(),
      sheet.frameWidth.toDouble(),
      sheet.frameHeight.toDouble(),
    );

    // Extract frame via Canvas + PictureRecorder
    return _cropFrame(sheetImage, srcRect, sheet.frameWidth, sheet.frameHeight);
  }

  @override
  String resolveFramePath(int index) {
    final (sheetIndex, localIndex) = _resolveSheetPosition(index);
    return '${sheets[sheetIndex].assetPath}#$localIndex';
  }

  @override
  void dispose() {
    for (final image in _sheetImages.values) {
      image.dispose();
    }
    _sheetImages.clear();
  }

  /// Resolve a global frame [globalIndex] to `(sheetIndex, localIndex)`.
  ///
  /// Iterates sheets in order, subtracting each sheet's [maxFrames] until
  /// the index falls within the current sheet's range.
  ///
  /// Throws [RangeError] if [globalIndex] exceeds the total capacity
  /// of all sheets combined.
  (int, int) _resolveSheetPosition(int globalIndex) {
    int remaining = globalIndex;
    for (int i = 0; i < sheets.length; i++) {
      final capacity = sheets[i].maxFrames;
      if (remaining < capacity) {
        return (i, remaining);
      }
      remaining -= capacity;
    }
    throw RangeError(
      'Frame index $globalIndex exceeds total frames across all sheets',
    );
  }

  /// Load and decode a sprite sheet image from the asset bundle.
  Future<ui.Image> _loadSheetImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    codec.dispose();
    return frame.image;
  }

  /// Crop a rectangle from [source] into a new [ui.Image].
  Future<ui.Image> _cropFrame(
    ui.Image source,
    ui.Rect srcRect,
    int width,
    int height,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.drawImageRect(
      source,
      srcRect,
      ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      ui.Paint(),
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    picture.dispose();
    return image;
  }
}
