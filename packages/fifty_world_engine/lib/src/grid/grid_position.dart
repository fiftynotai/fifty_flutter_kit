import 'dart:math' show sqrt;

/// Integer grid coordinate for tile-based positioning.
///
/// All public API methods use [GridPosition] instead of Flame's Vector2.
/// Coordinates use top-down convention: (0,0) = top-left of the grid.
class GridPosition implements Comparable<GridPosition> {
  /// Horizontal position (column index). Increases rightward.
  final int x;

  /// Vertical position (row index). Increases downward.
  final int y;

  /// Creates a [GridPosition] at column [x], row [y].
  const GridPosition(this.x, this.y);

  /// Zero position (origin).
  static const GridPosition zero = GridPosition(0, 0);

  /// Whether this position is within a grid of [width] x [height].
  bool isValidFor(int width, int height) =>
      x >= 0 && y >= 0 && x < width && y < height;

  /// Returns adjacent positions (4-directional by default).
  ///
  /// If [includeDiagonals] is true, also returns the 4 diagonal neighbors
  /// for a total of 8 positions.
  List<GridPosition> getAdjacent({bool includeDiagonals = false}) {
    final result = [
      GridPosition(x, y - 1), // up
      GridPosition(x + 1, y), // right
      GridPosition(x, y + 1), // down
      GridPosition(x - 1, y), // left
    ];
    if (includeDiagonals) {
      result.addAll([
        GridPosition(x - 1, y - 1), // top-left
        GridPosition(x + 1, y - 1), // top-right
        GridPosition(x - 1, y + 1), // bottom-left
        GridPosition(x + 1, y + 1), // bottom-right
      ]);
    }
    return result;
  }

  /// Manhattan distance to [other].
  int manhattanDistanceTo(GridPosition other) =>
      (x - other.x).abs() + (y - other.y).abs();

  /// Euclidean distance to [other].
  double euclideanDistanceTo(GridPosition other) {
    final dx = (x - other.x).toDouble();
    final dy = (y - other.y).toDouble();
    return sqrt(dx * dx + dy * dy);
  }

  /// Chess-style notation (e.g., "A1", "H8"). Column = letter, Row = number.
  String get notation => '${String.fromCharCode(65 + x)}${y + 1}';

  /// Adds two grid positions component-wise.
  GridPosition operator +(GridPosition other) =>
      GridPosition(x + other.x, y + other.y);

  /// Subtracts two grid positions component-wise.
  GridPosition operator -(GridPosition other) =>
      GridPosition(x - other.x, y - other.y);

  @override
  int compareTo(GridPosition other) {
    final yComp = y.compareTo(other.y);
    return yComp != 0 ? yComp : x.compareTo(other.x);
  }

  @override
  bool operator ==(Object other) =>
      other is GridPosition && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'GridPosition($x, $y)';
}
