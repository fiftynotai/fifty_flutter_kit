import 'dart:ui' show Color;

import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_map_engine/src/grid/grid_position.dart';
import 'package:fifty_map_engine/src/grid/tile_type.dart';
import 'package:fifty_map_engine/src/grid/tile_grid.dart';
import 'package:fifty_map_engine/src/pathfinding/grid_graph.dart';
import 'package:fifty_map_engine/src/pathfinding/pathfinder.dart';
import 'package:fifty_map_engine/src/pathfinding/movement_range.dart';

void main() {
  late TileGrid grid;
  late TileType grass;
  late TileType wall;

  setUp(() {
    grass = const TileType(
      id: 'grass',
      color: Color(0xFF00FF00),
      walkable: true,
    );
    wall = const TileType(
      id: 'wall',
      color: Color(0xFF888888),
      walkable: false,
    );
    grid = TileGrid(width: 5, height: 5);
    grid.fill(grass);
  });

  group('GridGraph', () {
    test('returns walkable neighbors', () {
      final graph = GridGraph(grid: grid);
      final neighbors = graph.neighbors(const GridPosition(2, 2));
      expect(neighbors.length, 4); // up, right, down, left
    });

    test('excludes non-walkable tiles', () {
      grid.setTile(const GridPosition(2, 1), wall); // block above center
      final graph = GridGraph(grid: grid);
      final neighbors = graph.neighbors(const GridPosition(2, 2));
      expect(neighbors.length, 3);
      expect(neighbors.contains(const GridPosition(2, 1)), isFalse);
    });

    test('excludes blocked positions', () {
      final graph = GridGraph(
        grid: grid,
        blocked: {const GridPosition(2, 1)},
      );
      final neighbors = graph.neighbors(const GridPosition(2, 2));
      expect(neighbors.length, 3);
    });

    test('includes diagonal neighbors when enabled', () {
      final graph = GridGraph(grid: grid, diagonal: true);
      final neighbors = graph.neighbors(const GridPosition(2, 2));
      expect(neighbors.length, 8);
    });

    test('base cost is 1.0 for cardinal movement', () {
      final graph = GridGraph(grid: grid);
      expect(
        graph.cost(const GridPosition(2, 2), const GridPosition(2, 3)),
        1.0,
      );
    });

    test('diagonal cost is sqrt(2) times base cost', () {
      final graph = GridGraph(grid: grid, diagonal: true);
      final cost = graph.cost(
        const GridPosition(2, 2),
        const GridPosition(3, 3),
      );
      expect(cost, closeTo(1.4142, 0.001));
    });

    test('respects tile movement cost', () {
      final swamp = const TileType(
        id: 'swamp',
        color: Color(0xFF006600),
        walkable: true,
        movementCost: 2.0,
      );
      grid.setTile(const GridPosition(2, 3), swamp);
      final graph = GridGraph(grid: grid);
      expect(
        graph.cost(const GridPosition(2, 2), const GridPosition(2, 3)),
        2.0,
      );
    });

    test('returns fewer neighbors at grid edge', () {
      final graph = GridGraph(grid: grid);
      final neighbors = graph.neighbors(const GridPosition(0, 0));
      expect(neighbors.length, 2); // right and down only
    });

    test('diagonal cost respects tile movement cost', () {
      final swamp = const TileType(
        id: 'swamp',
        color: Color(0xFF006600),
        walkable: true,
        movementCost: 2.0,
      );
      grid.setTile(const GridPosition(3, 3), swamp);
      final graph = GridGraph(grid: grid, diagonal: true);
      final cost = graph.cost(
        const GridPosition(2, 2),
        const GridPosition(3, 3),
      );
      expect(cost, closeTo(2.8284, 0.001)); // 2.0 * sqrt(2)
    });
  });

  group('Pathfinder', () {
    test('finds straight path in open field', () {
      final graph = GridGraph(grid: grid);
      final path = Pathfinder.findPath(
        start: const GridPosition(0, 0),
        goal: const GridPosition(4, 0),
        graph: graph,
      );
      expect(path, isNotNull);
      expect(path!.first, const GridPosition(0, 0));
      expect(path.last, const GridPosition(4, 0));
      expect(path.length, 5); // 0,0 -> 1,0 -> 2,0 -> 3,0 -> 4,0
    });

    test('finds path around obstacle', () {
      // Wall blocking middle row except last column
      for (int x = 0; x < 4; x++) {
        grid.setTile(GridPosition(x, 2), wall);
      }
      final graph = GridGraph(grid: grid);
      final path = Pathfinder.findPath(
        start: const GridPosition(0, 0),
        goal: const GridPosition(0, 4),
        graph: graph,
      );
      expect(path, isNotNull);
      expect(path!.first, const GridPosition(0, 0));
      expect(path.last, const GridPosition(0, 4));
      // Must go around the wall
      expect(path.length, greaterThan(5));
    });

    test('returns null when no path exists', () {
      // Wall completely blocking
      for (int x = 0; x < 5; x++) {
        grid.setTile(GridPosition(x, 2), wall);
      }
      final graph = GridGraph(grid: grid);
      final path = Pathfinder.findPath(
        start: const GridPosition(0, 0),
        goal: const GridPosition(0, 4),
        graph: graph,
      );
      expect(path, isNull);
    });

    test('returns single position when start equals goal', () {
      final graph = GridGraph(grid: grid);
      final path = Pathfinder.findPath(
        start: const GridPosition(2, 2),
        goal: const GridPosition(2, 2),
        graph: graph,
      );
      expect(path, [const GridPosition(2, 2)]);
    });

    test('returns null for invalid start', () {
      final graph = GridGraph(grid: grid);
      final path = Pathfinder.findPath(
        start: const GridPosition(-1, 0),
        goal: const GridPosition(4, 4),
        graph: graph,
      );
      expect(path, isNull);
    });

    test('returns null for invalid goal', () {
      final graph = GridGraph(grid: grid);
      final path = Pathfinder.findPath(
        start: const GridPosition(0, 0),
        goal: const GridPosition(10, 10),
        graph: graph,
      );
      expect(path, isNull);
    });

    test('returns null when goal is blocked', () {
      final graph = GridGraph(
        grid: grid,
        blocked: {const GridPosition(4, 4)},
      );
      final path = Pathfinder.findPath(
        start: const GridPosition(0, 0),
        goal: const GridPosition(4, 4),
        graph: graph,
      );
      expect(path, isNull);
    });

    test('finds diagonal path when enabled', () {
      final graph = GridGraph(grid: grid, diagonal: true);
      final path = Pathfinder.findPath(
        start: const GridPosition(0, 0),
        goal: const GridPosition(4, 4),
        graph: graph,
      );
      expect(path, isNotNull);
      // Diagonal path should be shorter than cardinal
      expect(path!.length, 5); // diagonal steps
    });

    test('path avoids blocked positions', () {
      final graph = GridGraph(
        grid: grid,
        blocked: {const GridPosition(2, 0)},
      );
      final path = Pathfinder.findPath(
        start: const GridPosition(0, 0),
        goal: const GridPosition(4, 0),
        graph: graph,
      );
      expect(path, isNotNull);
      expect(path!.contains(const GridPosition(2, 0)), isFalse);
    });

    test('prefers lower cost path', () {
      final swamp = const TileType(
        id: 'swamp',
        color: Color(0xFF006600),
        walkable: true,
        movementCost: 5.0,
      );
      // Make direct horizontal path expensive
      grid.setTile(const GridPosition(1, 0), swamp);
      grid.setTile(const GridPosition(2, 0), swamp);
      final graph = GridGraph(grid: grid);
      final path = Pathfinder.findPath(
        start: const GridPosition(0, 0),
        goal: const GridPosition(3, 0),
        graph: graph,
      );
      expect(path, isNotNull);
      // Should prefer going around through row 1 (cost 1.0 each)
      // rather than through swamp tiles (cost 5.0 each)
      expect(path!.length, greaterThan(4));
    });
  });

  group('MovementRange', () {
    test('returns start position with zero cost', () {
      final graph = GridGraph(grid: grid);
      final range = MovementRange.calculate(
        start: const GridPosition(2, 2),
        budget: 0,
        graph: graph,
      );
      expect(range.length, 1);
      expect(range[const GridPosition(2, 2)], 0.0);
    });

    test('returns adjacent tiles with budget 1', () {
      final graph = GridGraph(grid: grid);
      final range = MovementRange.reachable(
        start: const GridPosition(2, 2),
        budget: 1,
        graph: graph,
      );
      expect(range.length, 5); // center + 4 adjacent
      expect(range.contains(const GridPosition(2, 2)), isTrue);
      expect(range.contains(const GridPosition(2, 1)), isTrue);
      expect(range.contains(const GridPosition(3, 2)), isTrue);
      expect(range.contains(const GridPosition(2, 3)), isTrue);
      expect(range.contains(const GridPosition(1, 2)), isTrue);
    });

    test('respects obstacles', () {
      grid.setTile(const GridPosition(2, 1), wall);
      grid.setTile(const GridPosition(3, 2), wall);
      final graph = GridGraph(grid: grid);
      final range = MovementRange.reachable(
        start: const GridPosition(2, 2),
        budget: 1,
        graph: graph,
      );
      expect(range.contains(const GridPosition(2, 1)), isFalse);
      expect(range.contains(const GridPosition(3, 2)), isFalse);
    });

    test('respects movement costs', () {
      final swamp = const TileType(
        id: 'swamp',
        color: Color(0xFF006600),
        walkable: true,
        movementCost: 3.0,
      );
      grid.setTile(const GridPosition(2, 1), swamp);
      final graph = GridGraph(grid: grid);
      final costs = MovementRange.calculate(
        start: const GridPosition(2, 2),
        budget: 2,
        graph: graph,
      );
      // Swamp costs 3 to enter, so with budget 2 it should be unreachable
      expect(costs.containsKey(const GridPosition(2, 1)), isFalse);
    });

    test('full range in open 5x5 grid', () {
      final graph = GridGraph(grid: grid);
      final range = MovementRange.reachable(
        start: const GridPosition(2, 2),
        budget: 10,
        graph: graph,
      );
      // All 25 tiles should be reachable with budget 10
      expect(range.length, 25);
    });

    test('corner start with limited budget', () {
      final graph = GridGraph(grid: grid);
      final range = MovementRange.reachable(
        start: const GridPosition(0, 0),
        budget: 2,
        graph: graph,
      );
      // From corner with budget 2: (0,0), (1,0), (0,1), (2,0), (0,2), (1,1)
      expect(range.length, 6);
      expect(range.contains(const GridPosition(0, 0)), isTrue);
      expect(range.contains(const GridPosition(2, 0)), isTrue);
      expect(range.contains(const GridPosition(1, 1)), isTrue);
    });

    test('costs are correct for adjacent tiles', () {
      final graph = GridGraph(grid: grid);
      final costs = MovementRange.calculate(
        start: const GridPosition(2, 2),
        budget: 2,
        graph: graph,
      );
      expect(costs[const GridPosition(2, 2)], 0.0);
      expect(costs[const GridPosition(2, 1)], 1.0);
      expect(costs[const GridPosition(3, 2)], 1.0);
      expect(costs[const GridPosition(2, 0)], 2.0);
    });

    test('blocked positions are excluded', () {
      final graph = GridGraph(
        grid: grid,
        blocked: {const GridPosition(2, 1)},
      );
      final range = MovementRange.reachable(
        start: const GridPosition(2, 2),
        budget: 1,
        graph: graph,
      );
      expect(range.contains(const GridPosition(2, 1)), isFalse);
    });

    test('diagonal movement range with budget', () {
      final graph = GridGraph(grid: grid, diagonal: true);
      final range = MovementRange.reachable(
        start: const GridPosition(2, 2),
        budget: 1.5,
        graph: graph,
      );
      // Cardinal neighbors cost 1.0, diagonal neighbors cost ~1.414
      // Both should be reachable with budget 1.5
      expect(range.contains(const GridPosition(2, 1)), isTrue); // up
      expect(range.contains(const GridPosition(3, 3)), isTrue); // diagonal
    });
  });
}
