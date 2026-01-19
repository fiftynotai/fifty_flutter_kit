import 'dart:math' as math;
import 'dart:ui';

import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RadialTreeLayout', () {
    late RadialTreeLayout layout;
    late List<SkillNode<void>> nodes;
    late List<SkillConnection> connections;

    setUp(() {
      layout = const RadialTreeLayout();
      nodes = [];
      connections = [];
    });

    test('returns empty map for empty nodes list', () {
      final positions = layout.calculatePositions(
        nodes: [],
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 100,
        availableSize: const Size(400, 400),
      );

      expect(positions, isEmpty);
    });

    test('positions single node at center', () {
      nodes = [
        SkillNode<void>(id: 'root', name: 'Root', tier: 0),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: [],
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 100,
        availableSize: const Size(400, 400),
      );

      expect(positions.length, equals(1));

      final rootPos = positions['root']!;
      expect(rootPos.dx, equals(200)); // Center of 400
      expect(rootPos.dy, equals(200)); // Center of 400
    });

    test('positions children in ring around center', () {
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
        SkillNode<void>(
          id: 'child4',
          name: 'Child 4',
          tier: 1,
          prerequisites: ['root'],
        ),
      ];

      connections = [
        SkillConnection(fromId: 'root', toId: 'child1'),
        SkillConnection(fromId: 'root', toId: 'child2'),
        SkillConnection(fromId: 'root', toId: 'child3'),
        SkillConnection(fromId: 'root', toId: 'child4'),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: connections,
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 100,
        availableSize: const Size(400, 400),
      );

      expect(positions.length, equals(5));

      final centerX = 200.0;
      final centerY = 200.0;

      // Root should be at center
      final rootPos = positions['root']!;
      expect(rootPos.dx, closeTo(centerX, 1));
      expect(rootPos.dy, closeTo(centerY, 1));

      // Children should be equidistant from center
      final children = ['child1', 'child2', 'child3', 'child4'];
      final distances = <double>[];

      for (final childId in children) {
        final childPos = positions[childId]!;
        final dx = childPos.dx - centerX;
        final dy = childPos.dy - centerY;
        final distance = math.sqrt(dx * dx + dy * dy);
        distances.add(distance);
      }

      // All children should be at same distance (first ring)
      for (final distance in distances) {
        expect(distance, closeTo(distances.first, 1));
      }

      // Distance should be approximately ringSpacing + nodeSize/2
      expect(distances.first, greaterThan(50));
    });

    test('respects startAngle parameter', () {
      layout = const RadialTreeLayout(
        startAngle: 0, // Start from right instead of top
      );

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
        SkillConnection(fromId: 'root', toId: 'child'),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: connections,
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 100,
        availableSize: const Size(400, 400),
      );

      final centerX = 200.0;
      final centerY = 200.0;

      final childPos = positions['child']!;

      // With startAngle = 0, first child should be to the right of center
      expect(childPos.dx, greaterThan(centerX));
      expect(childPos.dy, closeTo(centerY, 1));
    });

    test('respects angleSpan parameter for half circle', () {
      layout = const RadialTreeLayout(
        startAngle: -math.pi / 2, // Start from top
        angleSpan: math.pi, // Half circle (top semicircle)
      );

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
        SkillConnection(fromId: 'root', toId: 'child1'),
        SkillConnection(fromId: 'root', toId: 'child2'),
        SkillConnection(fromId: 'root', toId: 'child3'),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: connections,
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 100,
        availableSize: const Size(400, 400),
      );

      final centerY = 200.0;

      // At least one child should be at or above center (partial arc)
      // The middle child should be near the top
      final child2Pos = positions['child2']!;
      expect(child2Pos.dy, lessThanOrEqualTo(centerY + 50));
    });

    test('respects ringSpacing parameter', () {
      layout = const RadialTreeLayout(
        ringSpacing: 150,
      );

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
        SkillConnection(fromId: 'root', toId: 'child'),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: connections,
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 150, // levelSeparation used as ringSpacing
        availableSize: const Size(500, 500),
      );

      final centerX = 250.0;
      final centerY = 250.0;

      final childPos = positions['child']!;
      final dx = childPos.dx - centerX;
      final dy = childPos.dy - centerY;
      final distance = math.sqrt(dx * dx + dy * dy);

      // Distance should be approximately centerRadius + nodeSize/2 + ringSpacing
      // With default centerRadius = 0, nodeSize = 56, ringSpacing = 150
      // Expected: 0 + 28 + 150 = 178
      expect(distance, closeTo(178, 10));
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
        levelSeparation: 100,
        availableSize: const Size(400, 400),
      );

      expect(positions['custom'], equals(const Offset(50, 75)));
    });

    test('handles multiple rings correctly', () {
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
        SkillConnection(fromId: 'root', toId: 'child'),
        SkillConnection(fromId: 'child', toId: 'grandchild'),
      ];

      final positions = layout.calculatePositions(
        nodes: nodes,
        connections: connections,
        nodeSize: const Size(56, 56),
        nodeSeparation: 24,
        levelSeparation: 100,
        availableSize: const Size(500, 500),
      );

      final centerX = 250.0;
      final centerY = 250.0;

      // Calculate distances from center
      double distanceTo(String nodeId) {
        final pos = positions[nodeId]!;
        final dx = pos.dx - centerX;
        final dy = pos.dy - centerY;
        return math.sqrt(dx * dx + dy * dy);
      }

      final rootDist = distanceTo('root');
      final childDist = distanceTo('child');
      final grandchildDist = distanceTo('grandchild');

      // Root at center
      expect(rootDist, closeTo(0, 1));

      // Child in ring 1
      expect(childDist, greaterThan(rootDist));

      // Grandchild in ring 2 (further out)
      expect(grandchildDist, greaterThan(childDist));
    });

    test('supportsAnimation returns true', () {
      expect(layout.supportsAnimation, isTrue);
    });
  });
}
