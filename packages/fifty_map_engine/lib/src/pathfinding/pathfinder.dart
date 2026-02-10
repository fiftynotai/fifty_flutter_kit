import 'dart:collection';

import 'package:fifty_map_engine/src/grid/grid_position.dart';

import 'grid_graph.dart';

/// A* pathfinder that finds the shortest path between two grid positions.
///
/// Uses Manhattan distance as the heuristic for 4-directional movement,
/// and Chebyshev distance for 8-directional (diagonal) movement.
class Pathfinder {
  Pathfinder._();

  /// Finds the shortest path from [start] to [goal] on the given [graph].
  ///
  /// Returns the path as a list of [GridPosition] from start to goal
  /// (inclusive), or `null` if no path exists.
  ///
  /// The path includes both [start] and [goal] positions.
  static List<GridPosition>? findPath({
    required GridPosition start,
    required GridPosition goal,
    required GridGraph graph,
  }) {
    if (!graph.grid.isValid(start) || !graph.grid.isValid(goal)) return null;
    if (start == goal) return [start];
    // If the goal is in the blocked set, no path
    if (graph.blocked.contains(goal)) return null;

    final openSet = SplayTreeSet<_Node>((a, b) {
      final fCompare = a.f.compareTo(b.f);
      if (fCompare != 0) return fCompare;
      // Tie-break by position for deterministic ordering
      final yCompare = a.position.y.compareTo(b.position.y);
      if (yCompare != 0) return yCompare;
      return a.position.x.compareTo(b.position.x);
    });

    final gScore = <GridPosition, double>{};
    final cameFrom = <GridPosition, GridPosition>{};
    final inOpenSet = <GridPosition>{};

    gScore[start] = 0.0;
    final startNode = _Node(
      position: start,
      g: 0.0,
      h: _heuristic(start, goal, graph.diagonal),
    );
    openSet.add(startNode);
    inOpenSet.add(start);

    while (openSet.isNotEmpty) {
      final current = openSet.first;
      openSet.remove(current);
      inOpenSet.remove(current.position);

      if (current.position == goal) {
        return _reconstructPath(cameFrom, goal);
      }

      for (final neighbor in graph.neighbors(current.position)) {
        final tentativeG = (gScore[current.position] ?? double.infinity) +
            graph.cost(current.position, neighbor);

        if (tentativeG < (gScore[neighbor] ?? double.infinity)) {
          cameFrom[neighbor] = current.position;
          gScore[neighbor] = tentativeG;

          if (!inOpenSet.contains(neighbor)) {
            openSet.add(_Node(
              position: neighbor,
              g: tentativeG,
              h: _heuristic(neighbor, goal, graph.diagonal),
            ));
            inOpenSet.add(neighbor);
          }
        }
      }
    }

    return null; // No path found
  }

  static double _heuristic(GridPosition a, GridPosition b, bool diagonal) {
    if (diagonal) {
      // Chebyshev distance for 8-directional movement
      // D * (dx + dy) + (D2 - 2*D) * min(dx, dy)
      // where D = 1, D2 = sqrt(2)
      final dx = (a.x - b.x).abs();
      final dy = (a.y - b.y).abs();
      return (dx + dy - 0.5857864376269049 * (dx < dy ? dx : dy)).toDouble();
    }
    return a.manhattanDistanceTo(b).toDouble();
  }

  static List<GridPosition> _reconstructPath(
    Map<GridPosition, GridPosition> cameFrom,
    GridPosition current,
  ) {
    final path = [current];
    var node = current;
    while (cameFrom.containsKey(node)) {
      node = cameFrom[node]!;
      path.add(node);
    }
    return path.reversed.toList();
  }
}

class _Node {
  final GridPosition position;
  final double g;
  final double h;
  double get f => g + h;

  const _Node({
    required this.position,
    required this.g,
    required this.h,
  });
}
