/// Scroll Sequence Example - Procedural Frame Generator
///
/// Generates gradient frames at runtime using PictureRecorder + Canvas,
/// avoiding the need for bundled image assets.
library;

import 'dart:ui' as ui;

import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter/painting.dart';

/// A [FrameLoader] that generates gradient frames procedurally.
///
/// Uses HSL hue rotation across frames (0 degrees to 360 degrees) to create
/// a smooth colour-shifting gradient sequence. Each frame also renders a
/// centred text overlay showing the frame number.
///
/// This avoids bundling real image assets in the example app while
/// demonstrating how to implement a custom [FrameLoader].
///
/// ## Example
///
/// ```dart
/// final loader = GeneratedFrameLoader(frameCount: 60);
/// final image = await loader.loadFrame(0);
/// ```
class GeneratedFrameLoader extends FrameLoader {
  /// Creates a procedural frame generator.
  ///
  /// [frameCount] is the total number of frames in the sequence.
  /// [width] and [height] control the output image dimensions.
  GeneratedFrameLoader({
    required this.frameCount,
    this.width = 360,
    this.height = 640,
  });

  /// Total number of frames this loader can generate.
  final int frameCount;

  /// Width of each generated frame in logical pixels.
  final int width;

  /// Height of each generated frame in logical pixels.
  final int height;

  @override
  Future<ui.Image> loadFrame(int index) async {
    final w = width.toDouble();
    final h = height.toDouble();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, w, h));

    // HSL hue rotation: 0 -> 360 across the frame range.
    final hue = frameCount > 1 ? (index / (frameCount - 1)) * 360.0 : 0.0;
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(w, h),
        [
          HSLColor.fromAHSL(1, hue, 0.8, 0.5).toColor(),
          HSLColor.fromAHSL(1, (hue + 60) % 360, 0.8, 0.3).toColor(),
        ],
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);

    // Frame number overlay.
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${index + 1} / $frameCount',
        style: const TextStyle(
          color: Color(0xDDFFFFFF),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        w / 2 - textPainter.width / 2,
        h / 2 - textPainter.height / 2,
      ),
    );

    textPainter.dispose();

    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    picture.dispose();
    return image;
  }

  @override
  String resolveFramePath(int index) => 'generated_$index';

  @override
  void dispose() {
    // No resources to release for procedural generation.
  }
}
