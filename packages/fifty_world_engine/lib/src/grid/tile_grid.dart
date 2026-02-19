import 'grid_position.dart';
import 'tile_type.dart';

/// 2D grid of tiles. Pure data structure with no rendering logic.
///
/// The grid uses top-down coordinates: (0,0) = top-left.
/// Y increases downward, X increases rightward.
class TileGrid {
  /// Grid width in tiles.
  final int width;

  /// Grid height in tiles.
  final int height;

  /// Internal 2D storage: _tiles[y][x]
  final List<List<TileType?>> _tiles;

  /// Creates an empty grid of [width] x [height].
  ///
  /// All tiles are initially null.
  TileGrid({required this.width, required this.height})
      : _tiles = List.generate(height, (_) => List.filled(width, null));

  /// Sets the tile at [position] to [type].
  ///
  /// Silently ignores out-of-bounds positions.
  void setTile(GridPosition position, TileType type) {
    if (!isValid(position)) return;
    _tiles[position.y][position.x] = type;
  }

  /// Gets the tile at [position]. Returns null if empty or out of bounds.
  TileType? getTile(GridPosition position) {
    if (!isValid(position)) return null;
    return _tiles[position.y][position.x];
  }

  /// Fills the entire grid with [type].
  void fill(TileType type) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        _tiles[y][x] = type;
      }
    }
  }

  /// Fills a rectangular area starting at [topLeft] with dimensions [w] x [h].
  ///
  /// Tiles outside the grid bounds are silently skipped.
  void fillRect(GridPosition topLeft, int w, int h, TileType type) {
    for (int y = topLeft.y; y < topLeft.y + h && y < height; y++) {
      for (int x = topLeft.x; x < topLeft.x + w && x < width; x++) {
        if (x >= 0 && y >= 0) {
          _tiles[y][x] = type;
        }
      }
    }
  }

  /// Fills the grid with alternating [a] and [b] in a checkerboard pattern.
  void fillCheckerboard(TileType a, TileType b) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        _tiles[y][x] = (x + y) % 2 == 0 ? a : b;
      }
    }
  }

  /// Whether [position] is within grid bounds.
  bool isValid(GridPosition position) => position.isValidFor(width, height);

  /// Whether the tile at [position] exists and is walkable.
  bool isWalkable(GridPosition position) {
    final tile = getTile(position);
    return tile != null && tile.walkable;
  }

  /// Returns walkable neighbor positions of [position].
  ///
  /// If [diagonals] is true, includes diagonal neighbors.
  List<GridPosition> getWalkableNeighbors(
    GridPosition position, {
    bool diagonals = false,
  }) {
    return position
        .getAdjacent(includeDiagonals: diagonals)
        .where((p) => isWalkable(p))
        .toList();
  }

  /// Iterates over all valid grid positions (row by row, left to right).
  Iterable<GridPosition> get allPositions sync* {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        yield GridPosition(x, y);
      }
    }
  }

  @override
  String toString() => 'TileGrid(${width}x$height)';
}
