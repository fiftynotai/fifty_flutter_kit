import 'package:flame/components.dart';

import '../../grid/tile_grid.dart';
import '../../config/world_config.dart';
import '../../components/base/priority.dart';
import 'tile_component.dart';

/// Renders a full tile grid by managing [TileComponent] children (internal).
///
/// This component creates one [TileComponent] child per non-null tile
/// in the [grid]. Call [rebuild] to recreate all children after modifying
/// the underlying [TileGrid].
///
/// This component is internal to the engine and should not be used
/// directly by consumers.
class TileGridComponent extends PositionComponent {
  /// The tile grid data to render.
  final TileGrid grid;

  /// The pixel size of each tile.
  final double tileSize;

  /// Creates a [TileGridComponent] that renders [grid].
  TileGridComponent({
    required this.grid,
    this.tileSize = FiftyWorldConfig.blockSize,
  }) : super(
          size: Vector2(
            grid.width * tileSize,
            grid.height * tileSize,
          ),
          position: Vector2.zero(),
          priority: FiftyRenderPriority.tileGrid,
        );

  @override
  Future<void> onLoad() async {
    await _buildGrid();
  }

  /// Rebuilds all tile components from the grid data.
  ///
  /// Call this after modifying the underlying [TileGrid] to reflect changes.
  Future<void> rebuild() async {
    removeAll(children);
    await _buildGrid();
  }

  Future<void> _buildGrid() async {
    for (final pos in grid.allPositions) {
      final tileType = grid.getTile(pos);
      if (tileType != null) {
        add(TileComponent(
          gridPos: pos,
          tileType: tileType,
          tileSize: tileSize,
        ));
      }
    }
  }
}
