import 'dart:ui';

import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GridLayout', () {
    late GridLayout layout;
    late List<SkillNode<void>> nodes;
    late List<SkillConnection> connections;

    setUp(() {
      layout = const GridLayout();
      nodes = [];
      connections = [];
    });

    test('returns empty map for empty nodes list', () {
      final positions = layout.calculatePositions(
        nodes: [],
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 600),
      );

      expect(positions, isEmpty);
    });

    test('positions single node centered horizontally', () {
      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 600),
      );

      expect(positions.length, equals(1));
      expect(positions['root'], isNotNull);

      final rootPos = positions['root']!;
      // Y should be nodeSize.height / 2 = 28 (first tier row)
      expect(rootPos.dy, equals(28));
      // X should be centered: (600 - 80) / 2 + 28 = 288
      // cellWidth = 80 + 24 = 104, tierWidth = 1 * 104 - 24 = 80
      // startX = (600 - 80) / 2 + 28 = 288
      expect(rootPos.dx, equals(288));
    });

    test('positions nodes in same tier side by side', () {
      nodes = [
        SkillNode<void>(id: 'a', name: 'A', tier: 0),
        SkillNode<void>(id: 'b', name: 'B', tier: 0),
        SkillNode<void>(id: 'c', name: 'C', tier: 0),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 600),
      );

      expect(positions.length, equals(3));

      // All should be at the same Y (same tier)
      expect(positions['a']!.dy, equals(positions['b']!.dy));
      expect(positions['b']!.dy, equals(positions['c']!.dy));

      // Should be sorted left to right
      expect(positions['a']!.dx, lessThan(positions['b']!.dx));
      expect(positions['b']!.dx, lessThan(positions['c']!.dx));

      // Spacing between nodes should be consistent (effectiveCellWidth = 104)
      final spacing = positions['b']!.dx - positions['a']!.dx;
      expect(spacing, equals(104)); // cellSize.width + nodeSeparation
    });

    test('positions nodes in different tiers in different rows', () {
      nodes = [
        SkillNode<void>(id: 'tier0', name: 'Tier 0', tier: 0),
        SkillNode<void>(
          id: 'tier1',
          name: 'Tier 1',
          tier: 1,
          prerequisites: ['tier0'],
        ),
        SkillNode<void>(
          id: 'tier2',
          name: 'Tier 2',
          tier: 2,
          prerequisites: ['tier1'],
        ),
      ];

      connections = [
        const SkillConnection(fromId: 'tier0', toId: 'tier1'),
        const SkillConnection(fromId: 'tier1', toId: 'tier2'),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: connections,
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 600),
      );

      // Each tier should have a different Y
      final y0 = positions['tier0']!.dy;
      final y1 = positions['tier1']!.dy;
      final y2 = positions['tier2']!.dy;

      expect(y1, greaterThan(y0));
      expect(y2, greaterThan(y1));

      // effectiveCellHeight = cellSize.height + levelSeparation = 80 + 80 = 160
      expect(y1 - y0, equals(160));
      expect(y2 - y1, equals(160));
    });

    test('respects custom columns parameter', () {
      layout = const GridLayout(columns: 3);

      nodes = [
        SkillNode<void>(id: 'a', name: 'A', tier: 0),
        SkillNode<void>(id: 'b', name: 'B', tier: 0),
        SkillNode<void>(id: 'c', name: 'C', tier: 0),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 600),
      );

      // All 3 nodes should fit in one row
      expect(positions.length, equals(3));
      expect(positions['a']!.dy, equals(positions['c']!.dy));
    });

    test('respects custom cellSize parameter', () {
      layout = const GridLayout(cellSize: Size(100, 100));

      nodes = [
        SkillNode<void>(id: 'a', name: 'A', tier: 0),
        SkillNode<void>(id: 'b', name: 'B', tier: 0),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 600),
      );

      // effectiveCellWidth = 100 + 24 = 124
      final spacing = positions['b']!.dx - positions['a']!.dx;
      expect(spacing, equals(124));
    });

    test('centerTiers = false aligns nodes to grid start', () {
      layout = const GridLayout(centerTiers: false);

      nodes = [
        SkillNode<void>(id: 'a', name: 'A', tier: 0),
      ];

      final positionsCentered = const GridLayout(centerTiers: true)
          .calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 600),
      );

      final positionsLeft = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 600),
      );

      // With centerTiers=false and 1 node in a 5-column grid,
      // the node should be at a different X than centered
      // (unless perfectly centered by coincidence)
      expect(positionsLeft['a']!.dx, isNot(equals(positionsCentered['a']!.dx)));
    });

    test('uses explicit node positions when provided', () {
      nodes = [
        SkillNode<void>(
          id: 'custom',
          name: 'Custom',
          tier: 0,
          position: const Offset(50, 75),
        ),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 600),
      );

      expect(positions['custom'], equals(const Offset(50, 75)));
    });

    test('supportsAnimation returns true', () {
      expect(layout.supportsAnimation, isTrue);
    });

    test('getMinimumSize returns nodeSize for empty nodes', () {
      final minSize = layout.getMinimumSize(
        nodes: [],
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
      );

      expect(minSize, equals(const Size(56, 56)));
    });

    test('getMinimumSize calculates correct bounds', () {
      nodes = [
        SkillNode<void>(id: 'a', name: 'A', tier: 0),
        SkillNode<void>(id: 'b', name: 'B', tier: 0),
        SkillNode<void>(
          id: 'c',
          name: 'C',
          tier: 1,
          prerequisites: ['a'],
        ),
      ];

      connections = [
        const SkillConnection(fromId: 'a', toId: 'c'),
      ];

      final minSize = layout.getMinimumSize(
        nodes: nodes,
        connections: connections,
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
      );

      // Width should accommodate the widest tier (2 nodes)
      // maxNodesInTier = 2, effectiveCellWidth = 104
      // width = 2 * 104 + 56 = 264
      expect(minSize.width, equals(264));

      // Height should accommodate 2 tiers
      // numTiers = 2, effectiveCellHeight = 160
      // height = 2 * 160 + 56 = 376
      expect(minSize.height, equals(376));
    });

    test('handles multiple nodes in multiple tiers', () {
      nodes = [
        SkillNode<void>(id: 'a', name: 'A', tier: 0),
        SkillNode<void>(id: 'b', name: 'B', tier: 0),
        SkillNode<void>(id: 'c', name: 'C', tier: 0),
        SkillNode<void>(id: 'd', name: 'D', tier: 1),
        SkillNode<void>(id: 'e', name: 'E', tier: 1),
        SkillNode<void>(id: 'f', name: 'F', tier: 2),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(800, 800),
      );

      expect(positions.length, equals(6));

      // All tier 0 nodes at same Y
      expect(positions['a']!.dy, equals(positions['b']!.dy));
      expect(positions['b']!.dy, equals(positions['c']!.dy));

      // All tier 1 nodes at same Y
      expect(positions['d']!.dy, equals(positions['e']!.dy));

      // Tier 1 Y > Tier 0 Y
      expect(positions['d']!.dy, greaterThan(positions['a']!.dy));

      // Tier 2 Y > Tier 1 Y
      expect(positions['f']!.dy, greaterThan(positions['d']!.dy));
    });
  });
}
