import 'dart:collection';

import 'package:fifty_map_engine/src/grid/grid_position.dart';

import 'grid_graph.dart';

/// Calculates the set of tiles reachable from a starting position within
/// a movement budget using BFS (Breadth-First Search).
///
/// Respects tile walkability, movement costs, and blocked positions.
class MovementRange {
  MovementRange._();

  /// Returns all positions reachable from [start] within [budget] movement
  /// points on the given [graph].
  ///
  /// The result includes [start] itself (cost 0). Each step costs the
  /// tile's movement cost (from [GridGraph.cost]).
  ///
  /// Returns a map of reachable positions to their minimum movement cost.
  static Map<GridPosition, double> calculate({
    required GridPosition start,
    required double budget,
    required GridGraph graph,
  }) {
    final costs = <GridPosition, double>{start: 0.0};
    final queue = Queue<GridPosition>();
    queue.add(start);

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      final currentCost = costs[current]!;

      for (final neighbor in graph.neighbors(current)) {
        final moveCost = currentCost + graph.cost(current, neighbor);
        if (moveCost <= budget &&
            (!costs.containsKey(neighbor) || moveCost < costs[neighbor]!)) {
          costs[neighbor] = moveCost;
          queue.add(neighbor);
        }
      }
    }

    return costs;
  }

  /// Returns just the set of reachable positions (without costs).
  ///
  /// Convenience wrapper around [calculate].
  static Set<GridPosition> reachable({
    required GridPosition start,
    required double budget,
    required GridGraph graph,
  }) {
    return calculate(start: start, budget: budget, graph: graph).keys.toSet();
  }
}
