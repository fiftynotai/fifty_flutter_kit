import 'dart:ui';

import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VerticalTreeLayout', () {
    late VerticalTreeLayout layout;
    late List<SkillNode<void>> nodes;
    late List<SkillConnection> connections;

    setUp(() {
      layout = const VerticalTreeLayout();
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
        availableSize: const Size(400, 600),
      );

      expect(positions, isEmpty);
    });

    test('positions single node at center top', () {
      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(400, 600),
      );

      expect(positions.length, equals(1));
      expect(positions['root'], isNotNull);

      // Should be centered horizontally and at top
      final rootPos = positions['root']!;
      expect(rootPos.dx, equals(200)); // Center of 400
      expect(rootPos.dy, equals(28)); // nodeSize.height / 2
    });

    test('positions child nodes in next tier', () {
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
        availableSize: const Size(400, 600),
      );

      expect(positions.length, equals(3));

      // Root should be at tier 0
      final rootY = positions['root']!.dy;
      expect(rootY, equals(28));

      // Children should be at tier 1 (below root)
      final child1Y = positions['child1']!.dy;
      final child2Y = positions['child2']!.dy;

      // Tier 1 Y = startY + 1 * (nodeSize.height + levelSeparation)
      // = 28 + 1 * (56 + 80) = 28 + 136 = 164
      expect(child1Y, equals(164));
      expect(child2Y, equals(164));

      // Children should be on either side of center
      final child1X = positions['child1']!.dx;
      final child2X = positions['child2']!.dx;
      expect(child1X, lessThan(child2X));
    });

    test('respects rootAtTop = false', () {
      layout = const VerticalTreeLayout(rootAtTop: false);

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
        availableSize: const Size(400, 600),
      );

      final rootY = positions['root']!.dy;
      final childY = positions['child']!.dy;

      // Root should be at bottom, child above
      expect(rootY, greaterThan(childY));
    });

    test('respects TreeAlignment.start', () {
      layout = const VerticalTreeLayout(alignment: TreeAlignment.start);

      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(400, 600),
      );

      final rootX = positions['root']!.dx;

      // Should be aligned to start (left)
      expect(rootX, equals(28)); // nodeSize.width / 2
    });

    test('respects TreeAlignment.end', () {
      layout = const VerticalTreeLayout(alignment: TreeAlignment.end);

      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
        availableSize: const Size(400, 600),
      );

      final rootX = positions['root']!.dx;

      // Should be aligned to end (right)
      // endX = availableSize.width - tierWidth + nodeSize.width / 2
      // = 400 - 56 + 28 = 372
      expect(rootX, equals(372));
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
        availableSize: const Size(400, 600),
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
        availableSize: const Size(400, 600),
      );

      expect(positions.length, equals(2));
      expect(positions['root'], isNotNull);
      expect(positions['disconnected'], isNotNull);

      // Both nodes exist in positions - the exact position depends on
      // whether they're processed as roots or by tier
      final rootY = positions['root']!.dy;
      final disconnectedY = positions['disconnected']!.dy;
      // Disconnected nodes are placed at their defined tier if not connected
      expect(disconnectedY, greaterThanOrEqualTo(rootY));
    });

    test('supportsAnimation returns true', () {
      expect(layout.supportsAnimation, isTrue);
    });

    test('getMinimumSize calculates correct bounds', () {
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

      final minSize = layout.getMinimumSize(
        nodes: nodes,
        connections: connections,
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 80,
      );

      // Should accommodate 2 tiers and 2 nodes wide
      expect(minSize.width, greaterThan(0));
      expect(minSize.height, greaterThan(0));
    });
  });
}
