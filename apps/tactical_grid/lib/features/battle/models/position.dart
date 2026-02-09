/// Grid Position
///
/// Represents a coordinate on the 8x8 tactical board with
/// utility methods for adjacency, distance, and neighbor calculations.
library;

/// Grid position on the 8x8 tactical board.
///
/// **Example:**
/// ```dart
/// final pos = GridPosition(3, 4);
/// print(pos.isValid); // true
/// print(pos.distanceTo(GridPosition(5, 4))); // 2
/// ```
class GridPosition {
  /// The x-coordinate (column) on the board (0-7).
  final int x;

  /// The y-coordinate (row) on the board (0-7).
  final int y;

  /// Creates a grid position at the specified coordinates.
  const GridPosition(this.x, this.y);

  /// Board size constant (8x8 grid).
  static const int boardSize = 8;

  /// Check if this position is within board bounds (0-7).
  bool get isValid => x >= 0 && x < boardSize && y >= 0 && y < boardSize;

  /// Check if this position is adjacent to another (including diagonals).
  bool isAdjacent(GridPosition other) {
    final dx = (x - other.x).abs();
    final dy = (y - other.y).abs();
    return dx <= 1 && dy <= 1 && (dx != 0 || dy != 0);
  }

  /// Calculate Manhattan distance to another position.
  int distanceTo(GridPosition other) {
    return (x - other.x).abs() + (y - other.y).abs();
  }

  /// Get all adjacent positions (8 directions), filtered to valid board positions.
  List<GridPosition> getAdjacentPositions() {
    final positions = <GridPosition>[];
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue;
        final adjacent = GridPosition(x + dx, y + dy);
        if (adjacent.isValid) {
          positions.add(adjacent);
        }
      }
    }
    return positions;
  }

  /// Get all L-shape positions (chess knight moves).
  List<GridPosition> getKnightMovePositions() {
    const moves = [
      (2, 1),
      (2, -1),
      (-2, 1),
      (-2, -1),
      (1, 2),
      (1, -2),
      (-1, 2),
      (-1, -2),
    ];
    return moves
        .map((move) => GridPosition(x + move.$1, y + move.$2))
        .where((pos) => pos.isValid)
        .toList();
  }

  /// Returns the algebraic notation (e.g., "A1", "H8").
  String get notation {
    final col = String.fromCharCode('A'.codeUnitAt(0) + x);
    final row = (y + 1).toString();
    return '$col$row';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GridPosition && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'GridPosition($x, $y)';

  /// Get positions along the 4 cardinal directions (up/down/left/right).
  ///
  /// Extends from 1 to [range] in each direction, stopping before an
  /// occupied tile or out-of-bounds position. Used by Archer movement.
  List<GridPosition> getOrthogonalPositions(
    int range,
    Set<GridPosition> occupied,
  ) {
    const directions = [(0, -1), (0, 1), (-1, 0), (1, 0)];
    final positions = <GridPosition>[];
    for (final (dx, dy) in directions) {
      for (int step = 1; step <= range; step++) {
        final pos = GridPosition(x + dx * step, y + dy * step);
        if (!pos.isValid || occupied.contains(pos)) break;
        positions.add(pos);
      }
    }
    return positions;
  }

  /// Get positions along the 4 diagonal directions (NE/NW/SE/SW).
  ///
  /// Extends from 1 to [range] in each direction, stopping before an
  /// occupied tile or out-of-bounds position. Used by Mage movement.
  List<GridPosition> getDiagonalPositions(
    int range,
    Set<GridPosition> occupied,
  ) {
    const directions = [(-1, -1), (1, -1), (-1, 1), (1, 1)];
    final positions = <GridPosition>[];
    for (final (dx, dy) in directions) {
      for (int step = 1; step <= range; step++) {
        final pos = GridPosition(x + dx * step, y + dy * step);
        if (!pos.isValid || occupied.contains(pos)) break;
        positions.add(pos);
      }
    }
    return positions;
  }

  /// Get positions along all 8 directions (cardinal + diagonal).
  ///
  /// Extends from 1 to [range] in each direction, stopping before an
  /// occupied tile or out-of-bounds position. Used by Scout movement.
  List<GridPosition> getAnyDirectionPositions(
    int range,
    Set<GridPosition> occupied,
  ) {
    const directions = [
      (0, -1), (0, 1), (-1, 0), (1, 0),
      (-1, -1), (1, -1), (-1, 1), (1, 1),
    ];
    final positions = <GridPosition>[];
    for (final (dx, dy) in directions) {
      for (int step = 1; step <= range; step++) {
        final pos = GridPosition(x + dx * step, y + dy * step);
        if (!pos.isValid || occupied.contains(pos)) break;
        positions.add(pos);
      }
    }
    return positions;
  }

  /// Get all valid board positions within Chebyshev distance [radius].
  ///
  /// Returns positions where `max(abs(dx), abs(dy)) <= radius`.
  /// Does NOT check blocking -- abilities can target over units.
  /// Used for Rally adjacency and Fireball AoE targeting.
  List<GridPosition> getPositionsInRadius(int radius) {
    final positions = <GridPosition>[];
    for (int dx = -radius; dx <= radius; dx++) {
      for (int dy = -radius; dy <= radius; dy++) {
        if (dx == 0 && dy == 0) continue;
        final pos = GridPosition(x + dx, y + dy);
        if (pos.isValid) {
          positions.add(pos);
        }
      }
    }
    return positions;
  }

  /// Create a copy with optional field overrides.
  GridPosition copyWith({int? x, int? y}) {
    return GridPosition(x ?? this.x, y ?? this.y);
  }
}
