import 'dart:ui';
import 'package:flame/components.dart';
import 'entity_decorator.dart';

/// Renders a colored border/ring around the parent entity to indicate selection.
///
/// The ring draws a stroked rectangle matching the parent entity's size.
class SelectionRingComponent extends EntityDecorator {
  /// Ring stroke color.
  final Color color;

  /// Ring stroke width.
  final double strokeWidth;

  SelectionRingComponent({
    this.color = const Color(0xFFFFC107),
    this.strokeWidth = 3.0,
  });

  @override
  void onMount() {
    super.onMount();
    // Match parent entity size
    final parentSize = parent is PositionComponent
        ? (parent as PositionComponent).size
        : Vector2.zero();
    size = parentSize;
    position = Vector2.zero();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
  }
}
