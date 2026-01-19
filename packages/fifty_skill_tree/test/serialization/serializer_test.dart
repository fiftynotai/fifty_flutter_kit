import 'dart:ui';

import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProgressData', () {
    test('creates empty progress data', () {
      final progress = ProgressData.empty();

      expect(progress.unlockedNodes, isEmpty);
      expect(progress.nodeLevels, isEmpty);
      expect(progress.availablePoints, equals(0));
      expect(progress.spentPoints, equals(0));
      expect(progress.totalPoints, equals(0));
      expect(progress.unlockedCount, equals(0));
    });

    test('creates progress data with values', () {
      final progress = ProgressData(
        unlockedNodes: {'node1', 'node2'},
        nodeLevels: {'node1': 3, 'node2': 1},
        availablePoints: 5,
        spentPoints: 4,
        timestamp: DateTime(2024, 1, 15),
      );

      expect(progress.unlockedNodes, contains('node1'));
      expect(progress.unlockedNodes, contains('node2'));
      expect(progress.nodeLevels['node1'], equals(3));
      expect(progress.nodeLevels['node2'], equals(1));
      expect(progress.availablePoints, equals(5));
      expect(progress.spentPoints, equals(4));
      expect(progress.totalPoints, equals(9));
      expect(progress.unlockedCount, equals(2));
      expect(progress.timestamp, equals(DateTime(2024, 1, 15)));
    });

    test('serializes to JSON correctly', () {
      final progress = ProgressData(
        unlockedNodes: {'node1', 'node2'},
        nodeLevels: {'node1': 3, 'node2': 1},
        availablePoints: 5,
        spentPoints: 4,
        timestamp: DateTime(2024, 1, 15),
        metadata: {'version': 1},
      );

      final json = progress.toJson();

      expect(json['unlockedNodes'], containsAll(['node1', 'node2']));
      expect(json['nodeLevels']['node1'], equals(3));
      expect(json['nodeLevels']['node2'], equals(1));
      expect(json['availablePoints'], equals(5));
      expect(json['spentPoints'], equals(4));
      expect(json['timestamp'], isNotNull);
      expect(json['metadata']['version'], equals(1));
    });

    test('deserializes from JSON correctly', () {
      final json = {
        'unlockedNodes': ['node1', 'node2'],
        'nodeLevels': {'node1': 3, 'node2': 1},
        'availablePoints': 5,
        'spentPoints': 4,
        'timestamp': '2024-01-15T00:00:00.000',
        'metadata': {'version': 1},
      };

      final progress = ProgressData.fromJson(json);

      expect(progress.unlockedNodes, contains('node1'));
      expect(progress.unlockedNodes, contains('node2'));
      expect(progress.nodeLevels['node1'], equals(3));
      expect(progress.nodeLevels['node2'], equals(1));
      expect(progress.availablePoints, equals(5));
      expect(progress.spentPoints, equals(4));
      expect(progress.timestamp, equals(DateTime(2024, 1, 15)));
      expect(progress.metadata?['version'], equals(1));
    });

    test('round-trips through JSON', () {
      final original = ProgressData(
        unlockedNodes: {'fireball', 'ice_bolt'},
        nodeLevels: {'fireball': 5, 'ice_bolt': 2},
        availablePoints: 10,
        spentPoints: 7,
        timestamp: DateTime.now(),
        metadata: {'saveSlot': 1},
      );

      final json = original.toJson();
      final restored = ProgressData.fromJson(json);

      expect(restored.unlockedNodes, equals(original.unlockedNodes));
      expect(restored.nodeLevels, equals(original.nodeLevels));
      expect(restored.availablePoints, equals(original.availablePoints));
      expect(restored.spentPoints, equals(original.spentPoints));
    });

    test('converts to tree import format', () {
      final progress = ProgressData(
        unlockedNodes: {'node1', 'node2'},
        nodeLevels: {'node1': 3, 'node2': 1},
        availablePoints: 5,
        spentPoints: 4,
      );

      final treeImport = progress.toTreeImport();

      expect(treeImport['availablePoints'], equals(5));
      expect(treeImport['nodes']['node1'], equals(3));
      expect(treeImport['nodes']['node2'], equals(1));
    });

    test('merges progress keeping higher values', () {
      final progress1 = ProgressData(
        unlockedNodes: {'node1'},
        nodeLevels: {'node1': 2},
        availablePoints: 5,
        spentPoints: 2,
      );

      final progress2 = ProgressData(
        unlockedNodes: {'node1', 'node2'},
        nodeLevels: {'node1': 3, 'node2': 1},
        availablePoints: 3,
        spentPoints: 4,
      );

      final merged = progress1.merge(progress2);

      // Should have both nodes
      expect(merged.unlockedNodes, contains('node1'));
      expect(merged.unlockedNodes, contains('node2'));

      // node1 should have higher level (3 from progress2)
      expect(merged.nodeLevels['node1'], equals(3));
      expect(merged.nodeLevels['node2'], equals(1));

      // Available points should be higher value
      expect(merged.availablePoints, equals(5));
    });

    test('copyWith creates modified copy', () {
      final original = ProgressData(
        unlockedNodes: {'node1'},
        nodeLevels: {'node1': 1},
        availablePoints: 5,
        spentPoints: 1,
      );

      final modified = original.copyWith(
        availablePoints: 10,
      );

      expect(modified.availablePoints, equals(10));
      expect(modified.unlockedNodes, equals(original.unlockedNodes));
      expect(modified.nodeLevels, equals(original.nodeLevels));
      expect(modified.spentPoints, equals(original.spentPoints));
    });
  });

  group('TreeSerializer', () {
    late SkillTree<void> tree;

    setUp(() {
      tree = SkillTree<void>(
        id: 'test_tree',
        name: 'Test Tree',
      );

      tree.addNode(SkillNode<void>(
        id: 'root',
        name: 'Root Skill',
        description: 'The root skill',
        maxLevel: 3,
        costs: [1, 2, 3],
        tier: 0,
      ));

      tree.addNode(SkillNode<void>(
        id: 'child',
        name: 'Child Skill',
        maxLevel: 1,
        tier: 1,
        prerequisites: ['root'],
      ));

      tree.addConnection(SkillConnection(
        fromId: 'root',
        toId: 'child',
      ));

      tree.addPoints(10);
    });

    test('serializes tree structure', () {
      final json = TreeSerializer.serialize<void>(tree);

      expect(json['id'], equals('test_tree'));
      expect(json['name'], equals('Test Tree'));
      expect(json['version'], equals('1.0.0'));
      expect(json['nodes'], isA<List>());
      expect(json['connections'], isA<List>());
      expect(json['availablePoints'], equals(10));
      expect(json['metadata'], isNotNull);
    });

    test('serializes nodes correctly', () {
      final json = TreeSerializer.serialize<void>(tree);
      final nodes = json['nodes'] as List<dynamic>;

      expect(nodes.length, equals(2));

      final rootNode = nodes.firstWhere((n) => n['id'] == 'root');
      expect(rootNode['name'], equals('Root Skill'));
      expect(rootNode['description'], equals('The root skill'));
      expect(rootNode['maxLevel'], equals(3));
      expect(rootNode['costs'], equals([1, 2, 3]));
      expect(rootNode['tier'], equals(0));
    });

    test('serializes connections correctly', () {
      final json = TreeSerializer.serialize<void>(tree);
      final connections = json['connections'] as List<dynamic>;

      expect(connections.length, equals(1));
      expect(connections.first['fromId'], equals('root'));
      expect(connections.first['toId'], equals('child'));
    });

    test('deserializes tree correctly', () {
      final json = TreeSerializer.serialize<void>(tree);
      final restored = TreeSerializer.deserialize<void>(json);

      expect(restored.id, equals('test_tree'));
      expect(restored.name, equals('Test Tree'));
      expect(restored.nodes.length, equals(2));
      expect(restored.connections.length, equals(1));
      expect(restored.availablePoints, equals(10));
    });

    test('round-trips tree through JSON', () {
      // Unlock a skill to test progress
      tree.unlock('root');

      final json = TreeSerializer.serialize<void>(tree);
      final restored = TreeSerializer.deserialize<void>(json);

      // Structure should match
      expect(restored.id, equals(tree.id));
      expect(restored.name, equals(tree.name));
      expect(restored.nodes.length, equals(tree.nodes.length));
      expect(restored.connections.length, equals(tree.connections.length));

      // Progress should match
      expect(restored.getNode('root')?.currentLevel, equals(1));
      expect(restored.availablePoints, equals(9)); // 10 - 1 cost
    });

    test('serializes without progress when includeProgress is false', () {
      tree.unlock('root');

      final json = TreeSerializer.serialize<void>(
        tree,
        includeProgress: false,
      );

      final rootNode =
          (json['nodes'] as List).firstWhere((n) => n['id'] == 'root');
      expect(rootNode.containsKey('currentLevel'), isFalse);
      expect(json.containsKey('availablePoints'), isFalse);
    });

    test('serializes without metadata when includeMetadata is false', () {
      final json = TreeSerializer.serialize<void>(
        tree,
        includeMetadata: false,
      );

      expect(json.containsKey('metadata'), isFalse);
    });

    test('handles node positions', () {
      tree.addNode(SkillNode<void>(
        id: 'positioned',
        name: 'Positioned',
        tier: 0,
        position: const Offset(100, 200),
      ));

      final json = TreeSerializer.serialize<void>(tree);
      final restored = TreeSerializer.deserialize<void>(json);

      final restoredNode = restored.getNode('positioned');
      expect(restoredNode?.position, equals(const Offset(100, 200)));
    });

    test('serializeProgress creates compact format', () {
      tree.unlock('root');

      final progress = TreeSerializer.serializeProgress<void>(tree);

      expect(progress['availablePoints'], equals(9));
      expect(progress['nodes']['root'], equals(1));
    });

    test('applyProgress restores tree state', () {
      // Create a fresh tree with same structure
      final freshTree = SkillTree<void>(
        id: 'test_tree',
        name: 'Test Tree',
      );
      freshTree.addNode(SkillNode<void>(
        id: 'root',
        name: 'Root Skill',
        maxLevel: 3,
        costs: [1, 2, 3],
        tier: 0,
      ));
      freshTree.addNode(SkillNode<void>(
        id: 'child',
        name: 'Child Skill',
        maxLevel: 1,
        tier: 1,
        prerequisites: ['root'],
      ));

      // Create progress to apply
      final progress = {
        'availablePoints': 8,
        'nodes': {'root': 2},
      };

      TreeSerializer.applyProgress<void>(freshTree, progress);

      expect(freshTree.availablePoints, equals(8));
      expect(freshTree.getNode('root')?.currentLevel, equals(2));
      expect(freshTree.getNode('child')?.currentLevel, equals(0));
    });
  });

  group('SkillTreeSerializationExtension', () {
    test('serialize extension method works', () {
      final tree = SkillTree<void>(
        id: 'test',
        name: 'Test',
      );
      tree.addNode(SkillNode<void>(id: 'n1', name: 'Node 1'));

      final json = tree.serialize();

      expect(json['id'], equals('test'));
      expect(json['nodes'], isNotEmpty);
    });
  });
}
