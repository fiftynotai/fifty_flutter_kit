import 'package:fifty_world_engine/src/grid/grid_position.dart';
import 'package:fifty_world_engine/src/grid/tile_grid.dart';

/// Graph adapter that wraps a [TileGrid] for pathfinding algorithms.
///
/// Provides neighbor enumeration and movement cost lookup, respecting
/// tile walkability and optional blocked positions.
class GridGraph {
  /// The underlying tile grid.
  final TileGrid grid;

  /// Positions blocked by entities or other obstacles (in addition to
  /// non-walkable tiles).
  final Set<GridPosition> blocked;

  /// Whether diagonal movement is allowed.
  final bool diagonal;

  /// Creates a graph adapter for [grid].
  ///
  /// - [blocked]: additional positions to treat as impassable.
  /// - [diagonal]: whether to include diagonal neighbors.
  const GridGraph({
    required this.grid,
    this.blocked = const {},
    this.diagonal = false,
  });

  /// Returns traversable neighbors of [position].
  ///
  /// A neighbor is traversable if it is within bounds, walkable, and not
  /// in the [blocked] set.
  List<GridPosition> neighbors(GridPosition position) {
    return position
        .getAdjacent(includeDiagonals: diagonal)
        .where(
          (p) => grid.isValid(p) && grid.isWalkable(p) && !blocked.contains(p),
        )
        .toList();
  }

  /// Returns the movement cost to enter [to] from [from].
  ///
  /// Defaults to 1.0 if the tile is null or has no custom cost.
  /// For diagonal movement, cost is multiplied by sqrt(2) (~1.414).
  double cost(GridPosition from, GridPosition to) {
    final tile = grid.getTile(to);
    final baseCost = tile?.movementCost ?? 1.0;
    // Diagonal movement costs more
    if (from.x != to.x && from.y != to.y) {
      return baseCost * 1.4142135623730951; // sqrt(2)
    }
    return baseCost;
  }
}
