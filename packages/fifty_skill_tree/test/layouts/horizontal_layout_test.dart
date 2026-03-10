import 'dart:ui';

import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HorizontalTreeLayout', () {
    late HorizontalTreeLayout layout;
    late List<SkillNode<void>> nodes;
    late List<SkillConnection> connections;

    setUp(() {
      layout = const HorizontalTreeLayout();
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
        availableSize: const Size(600, 400),
      );

      expect(positions, isEmpty);
    });

    test('positions single node at left center', () {
      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 400),
      );

      expect(positions.length, equals(1));
      expect(positions['root'], isNotNull);

      final rootPos = positions['root']!;
      // Left-to-right: root at left edge (nodeSize.width / 2)
      expect(rootPos.dx, equals(28));
      // Vertically centered: (400 - 56) / 2 + 28 = 200
      expect(rootPos.dy, equals(200));
    });

    test('positions child nodes to the right of root', () {
      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
        SkillNode<void>(
          id: 'child1',
          name: 'Child 1',
          tier: 1,
          prerequisites: ['root'],
        ),
        SkillNode<void>(
          id: 'child2',
          name: 'Child 2',
          tier: 1,
          prerequisites: ['root'],
        ),
      ];

      connections = [
        const SkillConnection(fromId: 'root', toId: 'child1'),
        const SkillConnection(fromId: 'root', toId: 'child2'),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: connections,
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 400),
      );

      expect(positions.length, equals(3));

      // Root should be at tier 0 (left)
      final rootX = positions['root']!.dx;
      expect(rootX, equals(28));

      // Children should be at tier 1 (to the right of root)
      final child1X = positions['child1']!.dx;
      final child2X = positions['child2']!.dx;

      // Tier 1 X = startX + 1 * (nodeSize.width + levelSeparation)
      // = 28 + 1 * (56 + 80) = 28 + 136 = 164
      expect(child1X, equals(164));
      expect(child2X, equals(164));

      // Children should be vertically separated
      final child1Y = positions['child1']!.dy;
      final child2Y = positions['child2']!.dy;
      expect(child1Y, lessThan(child2Y));
    });

    test('respects leftToRight = false', () {
      layout = const HorizontalTreeLayout(leftToRight: false);

      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
        SkillNode<void>(
          id: 'child',
          name: 'Child',
          tier: 1,
          prerequisites: ['root'],
        ),
      ];

      connections = [
        const SkillConnection(fromId: 'root', toId: 'child'),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: connections,
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 400),
      );

      final rootX = positions['root']!.dx;
      final childX = positions['child']!.dx;

      // Root should be on the right, child to the left
      expect(rootX, greaterThan(childX));
    });

    test('respects TreeAlignment.start', () {
      layout = const HorizontalTreeLayout(alignment: TreeAlignment.start);

      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 400),
      );

      final rootY = positions['root']!.dy;

      // Should be aligned to start (top)
      expect(rootY, equals(28)); // nodeSize.height / 2
    });

    test('respects TreeAlignment.end', () {
      layout = const HorizontalTreeLayout(alignment: TreeAlignment.end);

      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 400),
      );

      final rootY = positions['root']!.dy;

      // Should be aligned to end (bottom)
      // endY = availableSize.height - tierHeight + nodeSize.height / 2
      // = 400 - 56 + 28 = 372
      expect(rootY, equals(372));
    });

    test('uses explicit node positions when provided', () {
      nodes = [
        SkillNode<void>(
          id: 'custom',
          name: 'Custom',
          tier: 0,
          position: const Offset(100, 200),
        ),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 400),
      );

      expect(positions['custom'], equals(const Offset(100, 200)));
    });

    test('handles disconnected nodes', () {
      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
        SkillNode<void>(id: 'disconnected', name: 'Disconnected', tier: 2),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(600, 400),
      );

      expect(positions.length, equals(2));
      expect(positions['root'], isNotNull);
      expect(positions['disconnected'], isNotNull);

      // Disconnected node should be further right (higher tier)
      final rootX = positions['root']!.dx;
      final disconnectedX = positions['disconnected']!.dx;
      expect(disconnectedX, greaterThanOrEqualTo(rootX));
    });

    test('positions multiple tiers incrementally to the right', () {
      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
        SkillNode<void>(
          id: 'child',
          name: 'Child',
          tier: 1,
          prerequisites: ['root'],
        ),
        SkillNode<void>(
          id: 'grandchild',
          name: 'Grandchild',
          tier: 2,
          prerequisites: ['child'],
        ),
      ];

      connections = [
        const SkillConnection(fromId: 'root', toId: 'child'),
        const SkillConnection(fromId: 'child', toId: 'grandchild'),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: connections,
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(800, 400),
      );

      final rootX = positions['root']!.dx;
      final childX = positions['child']!.dx;
      final grandchildX = positions['grandchild']!.dx;

      // Each tier should be further right
      expect(childX, greaterThan(rootX));
      expect(grandchildX, greaterThan(childX));

      // Spacing should be consistent: nodeSize.width + levelSeparation = 136
      expect(childX - rootX, equals(136));
      expect(grandchildX - childX, equals(136));
    });

    test('supportsAnimation returns true', () {
      expect(layout.supportsAnimation, isTrue);
    });

    test('centers children vertically within their tier', () {
      layout = const HorizontalTreeLayout(alignment: TreeAlignment.center);

      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
        SkillNode<void>(
          id: 'child1',
          name: 'Child 1',
          tier: 1,
          prerequisites: ['root'],
        ),
        SkillNode<void>(
          id: 'child2',
          name: 'Child 2',
          tier: 1,
          prerequisites: ['root'],
        ),
        SkillNode<void>(
          id: 'child3',
          name: 'Child 3',
          tier: 1,
          prerequisites: ['root'],
        ),
      ];

      connections = [
        const SkillConnection(fromId: 'root', toId: 'child1'),
        const SkillConnection(fromId: 'root', toId: 'child2'),
        const SkillConnection(fromId: 'root', toId: 'child3'),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: connections,
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        availableSize: const Size(600, 400),
        levelSeparation: 80,
      );

      // The middle child of 3 should be near the vertical center
      final child2Y = positions['child2']!.dy;
      expect(child2Y, closeTo(200, 1)); // center of 400
    });
  });
}
