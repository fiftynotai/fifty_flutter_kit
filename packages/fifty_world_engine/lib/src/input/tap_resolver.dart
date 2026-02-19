import 'package:flame/components.dart';
import '../grid/grid_position.dart';
import '../grid/tile_grid.dart';
import '../config/world_config.dart';

/// Resolves screen coordinates to grid positions (internal).
///
/// Accounts for camera position and zoom to convert screen-space tap
/// coordinates to grid positions.
class TapResolver {
  TapResolver._();

  /// Resolves a world-space position to a [GridPosition].
  ///
  /// Returns null if the position is outside the grid bounds.
  static GridPosition? resolve(
    Vector2 worldPos,
    TileGrid grid, [
    double tileSize = FiftyWorldConfig.blockSize,
  ]) {
    final gridX = (worldPos.x / tileSize).floor();
    final gridY = (worldPos.y / tileSize).floor();
    final pos = GridPosition(gridX, gridY);
    return grid.isValid(pos) ? pos : null;
  }
}
