import 'dart:ui';

import 'package:fifty_map_engine/src/components/base/priority.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

/// A floating text effect that rises upward and fades out, then self-removes.
///
/// Used for damage popups, healing numbers, status messages, etc.
/// Spawned at a world position, drifts upward, and auto-removes after [duration].
class FloatingTextComponent extends PositionComponent with HasPaint {
  /// The text to display.
  final String text;

  /// Text color.
  final Color color;

  /// Font size.
  final double fontSize;

  /// How far upward the text drifts (in pixels).
  final double driftDistance;

  /// Total animation duration.
  final double duration;

  /// Creates a floating text effect.
  ///
  /// - [text]: the string to render (e.g. "-12", "MISS").
  /// - [position]: world position where the text spawns.
  /// - [color]: text color (defaults to red).
  /// - [fontSize]: text size in logical pixels.
  /// - [driftDistance]: how far the text rises before disappearing.
  /// - [duration]: total lifetime in seconds.
  FloatingTextComponent({
    required this.text,
    required Vector2 position,
    this.color = const Color(0xFFFF0000),
    this.fontSize = 20.0,
    this.driftDistance = 40.0,
    this.duration = 1.0,
  }) : super(
          position: position,
          priority: FiftyRenderPriority.floatingEffect,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    // Drift upward
    add(MoveByEffect(
      Vector2(0, -driftDistance),
      EffectController(duration: duration, curve: Curves.easeOut),
    ));

    // Fade out (using opacity effect)
    add(OpacityEffect.to(
      0.0,
      EffectController(
        duration: duration * 0.6,
        startDelay: duration * 0.4,
        curve: Curves.easeIn,
      ),
    ));

    // Self-remove after duration
    add(RemoveEffect(delay: duration));
  }

  @override
  void render(Canvas canvas) {
    final paragraphBuilder = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    ))
      ..pushStyle(TextStyle(
        color: color.withValues(alpha: opacity),
      ))
      ..addText(text);

    final paragraph = paragraphBuilder.build()
      ..layout(const ParagraphConstraints(width: 200));

    canvas.drawParagraph(
      paragraph,
      Offset(-paragraph.width / 2, -paragraph.height / 2),
    );
  }
}
