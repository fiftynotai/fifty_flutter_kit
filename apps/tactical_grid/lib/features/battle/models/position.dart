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

  /// Create a copy with optional field overrides.
  GridPosition copyWith({int? x, int? y}) {
    return GridPosition(x ?? this.x, y ?? this.y);
  }
}
