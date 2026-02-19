import 'dart:ui';
import 'package:flame/components.dart';
import 'entity_decorator.dart';

/// Renders a horizontal health bar above an entity.
///
/// The bar has a background (dark) and a foreground whose width
/// scales with [ratio] (0.0 = empty, 1.0 = full).
///
/// Colors can be customized. The bar is positioned centered above the entity.
class HealthBarComponent extends EntityDecorator {
  /// Current HP ratio (0.0 to 1.0).
  double _ratio;

  /// Width of the full bar in pixels.
  final double barWidth;

  /// Height of the bar in pixels.
  final double barHeight;

  /// Offset above the entity's top edge.
  final double offsetY;

  /// Foreground (filled) color.
  final Color foregroundColor;

  /// Background (empty) color.
  final Color backgroundColor;

  HealthBarComponent({
    required double ratio,
    this.barWidth = 48.0,
    this.barHeight = 6.0,
    this.offsetY = 4.0,
    this.foregroundColor = const Color(0xFF4CAF50),
    this.backgroundColor = const Color(0xFF424242),
  })  : _ratio = ratio.clamp(0.0, 1.0),
        super(
          size: Vector2(barWidth, barHeight),
        );

  double get ratio => _ratio;

  /// Updates the HP ratio and triggers a visual refresh.
  set ratio(double value) {
    _ratio = value.clamp(0.0, 1.0);
  }

  @override
  void onMount() {
    super.onMount();
    // Center horizontally above the parent entity
    final parentSize = parent is PositionComponent
        ? (parent as PositionComponent).size
        : Vector2.zero();
    position = Vector2(
      (parentSize.x - barWidth) / 2,
      -barHeight - offsetY,
    );
  }

  @override
  void render(Canvas canvas) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, barWidth, barHeight),
      Paint()..color = backgroundColor,
    );
    // Foreground (HP fill)
    if (_ratio > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, barWidth * _ratio, barHeight),
        Paint()..color = foregroundColor,
      );
    }
  }
}
