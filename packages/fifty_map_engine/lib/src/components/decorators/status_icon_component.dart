import 'dart:ui';
import 'package:flame/components.dart';
import 'entity_decorator.dart';

/// Renders a small status icon (buff/debuff) at the top-right of an entity.
///
/// Uses a colored circle with a text label as a simple representation.
/// For sprite-based icons, extend this class and override [render].
class StatusIconComponent extends EntityDecorator {
  /// Single character or short label.
  final String label;

  /// Icon background color.
  final Color color;

  /// Icon size (width and height).
  final double iconSize;

  StatusIconComponent({
    required this.label,
    this.color = const Color(0xFF9C27B0),
    this.iconSize = 16.0,
  }) : super(size: Vector2.all(iconSize));

  @override
  void onMount() {
    super.onMount();
    final parentSize = parent is PositionComponent
        ? (parent as PositionComponent).size
        : Vector2.zero();
    // Position at top-right corner of entity
    position = Vector2(parentSize.x - iconSize, -iconSize / 2);
  }

  @override
  void render(Canvas canvas) {
    // Circle background
    canvas.drawCircle(
      Offset(iconSize / 2, iconSize / 2),
      iconSize / 2,
      Paint()..color = color,
    );
    // Label text
    final paragraphBuilder = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: iconSize * 0.6,
    ))
      ..pushStyle(TextStyle(color: const Color(0xFFFFFFFF)))
      ..addText(label);
    final paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: iconSize));
    canvas.drawParagraph(
      paragraph,
      Offset(0, (iconSize - paragraph.height) / 2),
    );
  }
}
