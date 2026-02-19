import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../grid/grid_position.dart';
import '../../grid/tile_type.dart';
import '../../view/world_builder.dart';
import '../../config/world_config.dart';

/// Flame component rendering a single tile (internal).
///
/// Renders either a sprite (from [tileType.asset]) or a solid color
/// (from [tileType.color]).
///
/// This component is internal to the engine and should not be used
/// directly by consumers. Use [TileGrid] and [TileGridComponent] instead.
class TileComponent extends PositionComponent
    with HasGameReference<FiftyWorldBuilder> {
  /// The grid position this tile occupies.
  final GridPosition gridPos;

  /// The tile type defining appearance and properties.
  final TileType tileType;

  /// The pixel size of this tile.
  final double tileSize;

  Sprite? _sprite;
  late final Paint _paint;

  /// Creates a [TileComponent] at [gridPos] with [tileType].
  TileComponent({
    required this.gridPos,
    required this.tileType,
    this.tileSize = FiftyWorldConfig.blockSize,
  }) : super(
          size: Vector2.all(tileSize),
          position: Vector2(gridPos.x * tileSize, gridPos.y * tileSize),
        );

  @override
  Future<void> onLoad() async {
    if (tileType.asset != null) {
      _sprite = Sprite(game.images.fromCache(tileType.asset!));
    }
    _paint = Paint()..color = tileType.color ?? Colors.grey;
  }

  @override
  void render(Canvas canvas) {
    if (_sprite != null) {
      _sprite!.render(canvas, size: size);
    } else {
      canvas.drawRect(size.toRect(), _paint);
    }
  }
}
