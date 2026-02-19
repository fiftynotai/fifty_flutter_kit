import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../grid/grid_position.dart';
import '../../grid/tile_overlay.dart';
import '../../config/world_config.dart';
import '../base/priority.dart';

/// Flame component rendering a colored tile overlay (internal).
///
/// Renders a semi-transparent rectangle at the tile's position.
/// Priority is set to [FiftyRenderPriority.tileOverlay] so overlays
/// render above tiles but below entities.
///
/// This component is internal to the engine and should not be used
/// directly by consumers. Use [OverlayManager] instead.
class TileOverlayComponent extends PositionComponent {
  /// The grid position this overlay covers.
  final GridPosition gridPos;

  /// The overlay style (color, opacity, group).
  final TileOverlay overlay;

  /// The tile size in pixels.
  final double tileSize;

  late final Paint _paint;

  /// Creates a [TileOverlayComponent] at [gridPos] with [overlay] style.
  TileOverlayComponent({
    required this.gridPos,
    required this.overlay,
    this.tileSize = FiftyWorldConfig.blockSize,
  }) : super(
          size: Vector2.all(tileSize),
          position: Vector2(gridPos.x * tileSize, gridPos.y * tileSize),
          priority: FiftyRenderPriority.tileOverlay,
        );

  @override
  Future<void> onLoad() async {
    _paint = Paint()
      ..color = overlay.color.withValues(alpha: overlay.opacity);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }
}
