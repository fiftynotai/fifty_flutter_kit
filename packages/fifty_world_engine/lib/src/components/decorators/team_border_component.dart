import 'dart:ui';
import 'package:flame/components.dart';
import 'entity_decorator.dart';

/// Renders a team-colored border/glow around an entity.
///
/// Similar to [SelectionRingComponent] but with a thicker, semi-transparent
/// outer glow to distinguish team affiliation.
class TeamBorderComponent extends EntityDecorator {
  /// Team color.
  final Color color;

  /// Border width.
  final double borderWidth;

  TeamBorderComponent({
    required this.color,
    this.borderWidth = 4.0,
  });

  @override
  void onMount() {
    super.onMount();
    final parentSize = parent is PositionComponent
        ? (parent as PositionComponent).size
        : Vector2.zero();
    size = parentSize;
    position = Vector2.zero();
  }

  @override
  void render(Canvas canvas) {
    // Outer glow (semi-transparent, wider)
    canvas.drawRect(
      Rect.fromLTWH(
        -borderWidth / 2,
        -borderWidth / 2,
        size.x + borderWidth,
        size.y + borderWidth,
      ),
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
    // Inner border (solid, thinner)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth / 2,
    );
  }
}
