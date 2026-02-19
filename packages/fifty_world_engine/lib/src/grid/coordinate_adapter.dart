import 'package:flame/components.dart';

import 'grid_position.dart';
import '../config/world_config.dart';

/// Converts between [GridPosition] (integer) and [Vector2] (pixel).
///
/// Uses top-down coordinate system: (0,0) = top-left.
/// No Y-axis flipping. Direct mapping.
///
/// This class is not instantiable. All methods are static.
class CoordinateAdapter {
  CoordinateAdapter._();

  /// Converts a [GridPosition] to pixel [Vector2].
  ///
  /// The returned position is the top-left corner of the tile.
  static Vector2 gridToPixel(
    GridPosition pos, [
    double tileSize = FiftyWorldConfig.blockSize,
  ]) {
    return Vector2(pos.x * tileSize, pos.y * tileSize);
  }

  /// Converts a pixel [Vector2] to [GridPosition].
  ///
  /// Floors the result to get the tile containing the pixel.
  static GridPosition pixelToGrid(
    Vector2 pixel, [
    double tileSize = FiftyWorldConfig.blockSize,
  ]) {
    return GridPosition(
      (pixel.x / tileSize).floor(),
      (pixel.y / tileSize).floor(),
    );
  }

  /// Converts a [GridPosition] to center pixel [Vector2] (center of tile).
  static Vector2 gridToCenterPixel(
    GridPosition pos, [
    double tileSize = FiftyWorldConfig.blockSize,
  ]) {
    return Vector2(
      pos.x * tileSize + tileSize / 2,
      pos.y * tileSize + tileSize / 2,
    );
  }
}
