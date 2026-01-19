import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SkillTree', () {
    late SkillTree<void> tree;

    setUp(() {
      tree = SkillTree<void>(
        id: 'test_tree',
        name: 'Test Tree',
      );
    });

    group('construction', () {
      test('creates empty tree with defaults', () {
        expect(tree.id, 'test_tree');
        expect(tree.name, 'Test Tree');
        expect(tree.nodes, isEmpty);
        expect(tree.connections, isEmpty);
        expect(tree.availablePoints, 0);
        expect(tree.spentPoints, 0);
      });

      test('creates tree with initial nodes', () {
        final treeWithNodes = SkillTree<void>(
          id: 'tree',
          name: 'Tree',
          nodes: [
            SkillNode(id: 'a', name: 'A'),
            SkillNode(id: 'b', name: 'B'),
          ],
        );

        expect(treeWithNodes.nodes.length, 2);
        expect(treeWithNodes.getNode('a'), isNotNull);
        expect(treeWithNodes.getNode('b'), isNotNull);
      });

      test('creates tree with initial connections', () {
        final treeWithConnections = SkillTree<void>(
          id: 'tree',
          name: 'Tree',
          connections: [
            const SkillConnection(fromId: 'a', toId: 'b'),
          ],
        );

        expect(treeWithConnections.connections.length, 1);
      });

      test('creates tree with initial points', () {
        final treeWithPoints = SkillTree<void>(
          id: 'tree',
          name: 'Tree',
          availablePoints: 10,
        );

        expect(treeWithPoints.availablePoints, 10);
      });
    });

    group('node management', () {
      test('addNode adds a node', () {
        tree.addNode(SkillNode(id: 'test', name: 'Test'));

        expect(tree.nodes.length, 1);
        expect(tree.getNode('test')?.name, 'Test');
      });

      test('addNode replaces existing node with same ID', () {
        tree.addNode(SkillNode(id: 'test', name: 'Original'));
        tree.addNode(SkillNode(id: 'test', name: 'Replaced'));

        expect(tree.nodes.length, 1);
        expect(tree.getNode('test')?.name, 'Replaced');
      });

      test('removeNode removes a node', () {
        tree.addNode(SkillNode(id: 'test', name: 'Test'));
        tree.removeNode('test');

        expect(tree.nodes, isEmpty);
        expect(tree.getNode('test'), isNull);
      });

      test('removeNode removes associated connections', () {
        tree.addNode(SkillNode(id: 'a', name: 'A'));
        tree.addNode(SkillNode(id: 'b', name: 'B'));
        tree.addConnection(const SkillConnection(fromId: 'a', toId: 'b'));

        tree.removeNode('a');

        expect(tree.connections, isEmpty);
      });

      test('getNode returns null for non-existent node', () {
        expect(tree.getNode('nonexistent'), isNull);
      });
    });

    group('connection management', () {
      test('addConnection adds a connection', () {
        tree.addConnection(const SkillConnection(fromId: 'a', toId: 'b'));

        expect(tree.connections.length, 1);
        expect(tree.connections.first.fromId, 'a');
      });

      test('removeConnection removes a connection', () {
        tree.addConnection(const SkillConnection(fromId: 'a', toId: 'b'));
        tree.removeConnection('a', 'b');

        expect(tree.connections, isEmpty);
      });
    });

    group('query methods', () {
      setUp(() {
        tree.addNode(SkillNode(
          id: 'fire_1',
          name: 'Fire 1',
          branch: 'fire',
          tier: 0,
        ));
        tree.addNode(SkillNode(
          id: 'fire_2',
          name: 'Fire 2',
          branch: 'fire',
          tier: 1,
          currentLevel: 1,
        ));
        tree.addNode(SkillNode(
          id: 'ice_1',
          name: 'Ice 1',
          branch: 'ice',
          tier: 0,
        ));
      });

      test('getNodesInBranch returns nodes in branch', () {
        final fireNodes = tree.getNodesInBranch('fire');

        expect(fireNodes.length, 2);
        expect(fireNodes.every((n) => n.branch == 'fire'), isTrue);
      });

      test('getNodesInTier returns nodes in tier', () {
        final tier0Nodes = tree.getNodesInTier(0);

        expect(tier0Nodes.length, 2);
        expect(tier0Nodes.every((n) => n.tier == 0), isTrue);
      });

      test('getUnlockedNodes returns only unlocked nodes', () {
        final unlocked = tree.getUnlockedNodes();

        expect(unlocked.length, 1);
        expect(unlocked.first.id, 'fire_2');
      });
    });

    group('points management', () {
      test('addPoints increases available points', () {
        tree.addPoints(10);

        expect(tree.availablePoints, 10);
      });

      test('addPoints ignores negative values', () {
        tree.addPoints(10);
        tree.addPoints(-5);

        expect(tree.availablePoints, 10);
      });

      test('removePoints decreases available points', () {
        tree.addPoints(10);
        tree.removePoints(3);

        expect(tree.availablePoints, 7);
      });

      test('removePoints cannot go below zero', () {
        tree.addPoints(5);
        tree.removePoints(10);

        expect(tree.availablePoints, 0);
      });

      test('setPoints sets exact value', () {
        tree.addPoints(10);
        tree.setPoints(5);

        expect(tree.availablePoints, 5);
      });

      test('setPoints ignores negative values', () {
        tree.addPoints(10);
        tree.setPoints(-5);

        expect(tree.availablePoints, 10);
      });

      test('spentPoints calculates total spent', () {
        tree.addNode(SkillNode(
          id: 'a',
          name: 'A',
          currentLevel: 2,
          maxLevel: 3,
          costs: [1, 2, 3],
        ));
        tree.addNode(SkillNode(
          id: 'b',
          name: 'B',
          currentLevel: 1,
          costs: [5],
        ));

        // a: 1 + 2 = 3, b: 5 = total 8
        expect(tree.spentPoints, 8);
      });
    });

    group('node state computation', () {
      test('getNodeState returns locked for non-existent node', () {
        expect(tree.getNodeState('nonexistent'), SkillState.locked);
      });

      test('getNodeState returns maxed for maxed node', () {
        tree.addNode(SkillNode(
          id: 'test',
          name: 'Test',
          currentLevel: 3,
          maxLevel: 3,
        ));

        expect(tree.getNodeState('test'), SkillState.maxed);
      });

      test('getNodeState returns unlocked for partial unlock', () {
        tree.addNode(SkillNode(
          id: 'test',
          name: 'Test',
          currentLevel: 1,
          maxLevel: 3,
        ));

        expect(tree.getNodeState('test'), SkillState.unlocked);
      });

      test('getNodeState returns locked when prereqs not met', () {
        tree.addNode(SkillNode(
          id: 'basic',
          name: 'Basic',
          currentLevel: 0,
        ));
        tree.addNode(SkillNode(
          id: 'advanced',
          name: 'Advanced',
          prerequisites: ['basic'],
        ));
        tree.addPoints(10);

        expect(tree.getNodeState('advanced'), SkillState.locked);
      });

      test('getNodeState returns available when prereqs met and has points', () {
        tree.addNode(SkillNode(
          id: 'basic',
          name: 'Basic',
          currentLevel: 1,
        ));
        tree.addNode(SkillNode(
          id: 'advanced',
          name: 'Advanced',
          prerequisites: ['basic'],
          costs: [2],
        ));
        tree.addPoints(5);

        expect(tree.getNodeState('advanced'), SkillState.available);
      });

      test('getNodeState returns locked when not enough points', () {
        tree.addNode(SkillNode(
          id: 'test',
          name: 'Test',
          costs: [10],
        ));
        tree.addPoints(5);

        expect(tree.getNodeState('test'), SkillState.locked);
      });

      test('getNodeState respects required connections', () {
        tree.addNode(SkillNode(id: 'a', name: 'A'));
        tree.addNode(SkillNode(id: 'b', name: 'B'));
        tree.addConnection(const SkillConnection(
          fromId: 'a',
          toId: 'b',
          type: ConnectionType.required,
        ));
        tree.addPoints(10);

        expect(tree.getNodeState('b'), SkillState.locked);
      });

      test('getNodeState allows optional connections', () {
        tree.addNode(SkillNode(id: 'a', name: 'A'));
        tree.addNode(SkillNode(id: 'b', name: 'B'));
        tree.addConnection(const SkillConnection(
          fromId: 'a',
          toId: 'b',
          type: ConnectionType.optional,
        ));
        tree.addPoints(10);

        expect(tree.getNodeState('b'), SkillState.available);
      });
    });

    group('exclusive connections', () {
      setUp(() {
        // Create a choice node that branches to two exclusive options
        tree.addNode(SkillNode(
          id: 'choice',
          name: 'Choice',
          currentLevel: 1,
        ));
        tree.addNode(SkillNode(id: 'option_a', name: 'Option A'));
        tree.addNode(SkillNode(id: 'option_b', name: 'Option B'));
        tree.addConnection(const SkillConnection(
          fromId: 'choice',
          toId: 'option_a',
          type: ConnectionType.exclusive,
        ));
        tree.addConnection(const SkillConnection(
          fromId: 'choice',
          toId: 'option_b',
          type: ConnectionType.exclusive,
        ));
        tree.addPoints(10);
      });

      test('both exclusive options available initially', () {
        expect(tree.getNodeState('option_a'), SkillState.available);
        expect(tree.getNodeState('option_b'), SkillState.available);
      });

      test('unlocking one exclusive locks the other', () {
        tree.unlock('option_a');

        // option_a is now maxed (default maxLevel: 1, after unlock: level 1)
        expect(tree.getNodeState('option_a'), SkillState.maxed);
        expect(tree.getNodeState('option_b'), SkillState.locked);
      });
    });

    group('unlock operation', () {
      test('unlock succeeds for available node', () {
        tree.addNode(SkillNode(id: 'test', name: 'Test', costs: [2]));
        tree.addPoints(5);

        final result = tree.unlock('test');

        expect(result.success, isTrue);
        expect(result.pointsSpent, 2);
        expect(result.newLevel, 1);
        expect(result.node?.currentLevel, 1);
        expect(tree.availablePoints, 3);
      });

      test('unlock fails for non-existent node', () {
        final result = tree.unlock('nonexistent');

        expect(result.success, isFalse);
        expect(result.reason, UnlockFailureReason.nodeNotFound);
      });

      test('unlock fails for maxed node', () {
        tree.addNode(SkillNode(
          id: 'test',
          name: 'Test',
          currentLevel: 1,
          maxLevel: 1,
        ));

        final result = tree.unlock('test');

        expect(result.success, isFalse);
        expect(result.reason, UnlockFailureReason.alreadyMaxed);
      });

      test('unlock fails when prerequisites not met', () {
        tree.addNode(SkillNode(id: 'prereq', name: 'Prereq'));
        tree.addNode(SkillNode(
          id: 'dependent',
          name: 'Dependent',
          prerequisites: ['prereq'],
        ));
        tree.addPoints(10);

        final result = tree.unlock('dependent');

        expect(result.success, isFalse);
        expect(result.reason, UnlockFailureReason.prerequisitesNotMet);
      });

      test('unlock fails when locked by exclusive', () {
        tree.addNode(SkillNode(
          id: 'root',
          name: 'Root',
          currentLevel: 1,
        ));
        tree.addNode(SkillNode(
          id: 'opt_a',
          name: 'Option A',
          currentLevel: 1,
        ));
        tree.addNode(SkillNode(id: 'opt_b', name: 'Option B'));
        tree.addConnection(const SkillConnection(
          fromId: 'root',
          toId: 'opt_a',
          type: ConnectionType.exclusive,
        ));
        tree.addConnection(const SkillConnection(
          fromId: 'root',
          toId: 'opt_b',
          type: ConnectionType.exclusive,
        ));
        tree.addPoints(10);

        final result = tree.unlock('opt_b');

        expect(result.success, isFalse);
        expect(result.reason, UnlockFailureReason.lockedByExclusive);
      });

      test('unlock fails when insufficient points', () {
        tree.addNode(SkillNode(id: 'test', name: 'Test', costs: [10]));
        tree.addPoints(5);

        final result = tree.unlock('test');

        expect(result.success, isFalse);
        expect(result.reason, UnlockFailureReason.insufficientPoints);
      });

      test('unlock can level up already unlocked node', () {
        tree.addNode(SkillNode(
          id: 'test',
          name: 'Test',
          currentLevel: 1,
          maxLevel: 3,
          costs: [1, 2, 3],
        ));
        tree.addPoints(10);

        final result = tree.unlock('test');

        expect(result.success, isTrue);
        expect(result.newLevel, 2);
        expect(result.pointsSpent, 2);
      });
    });

    group('reset operations', () {
      setUp(() {
        tree.addNode(SkillNode(
          id: 'a',
          name: 'A',
          currentLevel: 2,
          maxLevel: 3,
          costs: [1, 2, 3],
        ));
        tree.addNode(SkillNode(
          id: 'b',
          name: 'B',
          currentLevel: 1,
          costs: [5],
        ));
        tree.addPoints(3);
      });

      test('reset refunds all spent points', () {
        // Currently: 3 available, 8 spent (3 + 5)
        tree.reset();

        expect(tree.availablePoints, 11);
        expect(tree.spentPoints, 0);
      });

      test('reset sets all nodes to level 0', () {
        tree.reset();

        expect(tree.getNode('a')?.currentLevel, 0);
        expect(tree.getNode('b')?.currentLevel, 0);
      });

      test('resetNode refunds single node points', () {
        tree.resetNode('a');

        expect(tree.availablePoints, 6); // 3 + 3 (spent on 'a')
        expect(tree.getNode('a')?.currentLevel, 0);
        expect(tree.getNode('b')?.currentLevel, 1); // unchanged
      });

      test('resetNode does nothing for non-unlocked node', () {
        tree.addNode(SkillNode(id: 'new', name: 'New'));
        tree.resetNode('new');

        expect(tree.availablePoints, 3); // unchanged
      });
    });

    group('canUnlock', () {
      test('returns true for available node', () {
        tree.addNode(SkillNode(id: 'test', name: 'Test'));
        tree.addPoints(5);

        expect(tree.canUnlock('test'), isTrue);
      });

      test('returns false for locked node', () {
        tree.addNode(SkillNode(id: 'prereq', name: 'Prereq'));
        tree.addNode(SkillNode(
          id: 'test',
          name: 'Test',
          prerequisites: ['prereq'],
        ));
        tree.addPoints(5);

        expect(tree.canUnlock('test'), isFalse);
      });
    });

    group('arePrerequisitesMet', () {
      test('returns true when no prerequisites', () {
        tree.addNode(SkillNode(id: 'test', name: 'Test'));

        expect(tree.arePrerequisitesMet('test'), isTrue);
      });

      test('returns true when all prerequisites unlocked', () {
        tree.addNode(SkillNode(
          id: 'prereq',
          name: 'Prereq',
          currentLevel: 1,
        ));
        tree.addNode(SkillNode(
          id: 'test',
          name: 'Test',
          prerequisites: ['prereq'],
        ));

        expect(tree.arePrerequisitesMet('test'), isTrue);
      });

      test('returns false when prerequisite not unlocked', () {
        tree.addNode(SkillNode(id: 'prereq', name: 'Prereq'));
        tree.addNode(SkillNode(
          id: 'test',
          name: 'Test',
          prerequisites: ['prereq'],
        ));

        expect(tree.arePrerequisitesMet('test'), isFalse);
      });

      test('returns false for non-existent node', () {
        expect(tree.arePrerequisitesMet('nonexistent'), isFalse);
      });
    });

    group('getAvailableNodes', () {
      test('returns nodes that can be unlocked', () {
        tree.addNode(SkillNode(id: 'a', name: 'A'));
        tree.addNode(SkillNode(id: 'b', name: 'B'));
        tree.addNode(SkillNode(
          id: 'c',
          name: 'C',
          prerequisites: ['a'],
        ));
        tree.addPoints(10);

        final available = tree.getAvailableNodes();

        expect(available.length, 2);
        expect(available.map((n) => n.id), containsAll(['a', 'b']));
      });
    });

    group('JSON serialization', () {
      setUp(() {
        tree.addNode(SkillNode(
          id: 'a',
          name: 'A',
          currentLevel: 1,
        ));
        tree.addNode(SkillNode(
          id: 'b',
          name: 'B',
          prerequisites: ['a'],
        ));
        tree.addConnection(const SkillConnection(fromId: 'a', toId: 'b'));
        tree.addPoints(5);
      });

      test('toJson includes all data', () {
        final json = tree.toJson();

        expect(json['id'], 'test_tree');
        expect(json['name'], 'Test Tree');
        expect(json['availablePoints'], 5);
        expect((json['nodes'] as List).length, 2);
        expect((json['connections'] as List).length, 1);
      });

      test('fromJson restores tree correctly', () {
        final json = tree.toJson();
        final restored = SkillTree<void>.fromJson(json);

        expect(restored.id, tree.id);
        expect(restored.name, tree.name);
        expect(restored.availablePoints, tree.availablePoints);
        expect(restored.nodes.length, tree.nodes.length);
        expect(restored.connections.length, tree.connections.length);
        expect(restored.getNode('a')?.currentLevel, 1);
      });

      test('JSON round-trip preserves all data', () {
        final json = tree.toJson();
        final restored = SkillTree<void>.fromJson(json);

        expect(restored.getNode('a')?.name, 'A');
        expect(restored.getNode('b')?.prerequisites, ['a']);
        expect(restored.connections.first.fromId, 'a');
      });
    });

    group('progress export/import', () {
      setUp(() {
        tree.addNode(SkillNode(
          id: 'a',
          name: 'A',
          currentLevel: 2,
          maxLevel: 3,
        ));
        tree.addNode(SkillNode(id: 'b', name: 'B'));
        tree.addNode(SkillNode(
          id: 'c',
          name: 'C',
          currentLevel: 1,
        ));
        tree.addPoints(10);
      });

      test('exportProgress exports only unlocked state', () {
        final progress = tree.exportProgress();

        expect(progress['availablePoints'], 10);
        expect((progress['nodes'] as Map)['a'], 2);
        expect((progress['nodes'] as Map)['c'], 1);
        expect((progress['nodes'] as Map).containsKey('b'), isFalse);
      });

      test('importProgress restores unlocked state', () {
        final progress = tree.exportProgress();

        // Create fresh tree with same structure
        final newTree = SkillTree<void>(
          id: 'test_tree',
          name: 'Test Tree',
          nodes: [
            SkillNode(id: 'a', name: 'A', maxLevel: 3),
            SkillNode(id: 'b', name: 'B'),
            SkillNode(id: 'c', name: 'C'),
          ],
        );

        newTree.importProgress(progress);

        expect(newTree.availablePoints, 10);
        expect(newTree.getNode('a')?.currentLevel, 2);
        expect(newTree.getNode('b')?.currentLevel, 0);
        expect(newTree.getNode('c')?.currentLevel, 1);
      });

      test('importProgress clamps levels to maxLevel', () {
        final progress = {
          'availablePoints': 5,
          'nodes': {
            'a': 10, // exceeds maxLevel of 3
          },
        };

        tree.importProgress(progress);

        expect(tree.getNode('a')?.currentLevel, 3);
      });

      test('importProgress ignores unknown node IDs', () {
        final progress = {
          'availablePoints': 5,
          'nodes': {
            'unknown': 5,
          },
        };

        // Should not throw
        tree.importProgress(progress);
        expect(tree.getNode('unknown'), isNull);
      });
    });

    group('toString', () {
      test('produces readable output', () {
        tree.addNode(SkillNode(id: 'a', name: 'A'));
        tree.addNode(SkillNode(id: 'b', name: 'B'));
        tree.addPoints(5);

        expect(
          tree.toString(),
          'SkillTree(id: test_tree, name: Test Tree, nodes: 2, points: 5)',
        );
      });
    });
  });

  group('UnlockResult', () {
    test('success factory creates successful result', () {
      final result = UnlockResult<void>.success(
        node: SkillNode(id: 'test', name: 'Test', currentLevel: 1),
        pointsSpent: 2,
        newLevel: 1,
      );

      expect(result.success, isTrue);
      expect(result.failed, isFalse);
      expect(result.pointsSpent, 2);
      expect(result.newLevel, 1);
      expect(result.reason, isNull);
    });

    test('failure factory creates failed result', () {
      final result = UnlockResult<void>.failure(
        reason: UnlockFailureReason.insufficientPoints,
        node: SkillNode(id: 'test', name: 'Test'),
      );

      expect(result.success, isFalse);
      expect(result.failed, isTrue);
      expect(result.reason, UnlockFailureReason.insufficientPoints);
      expect(result.pointsSpent, 0);
    });

    test('toString for success', () {
      final result = UnlockResult<void>.success(
        node: SkillNode(id: 'test', name: 'Test', currentLevel: 1),
        pointsSpent: 2,
        newLevel: 1,
      );

      expect(
        result.toString(),
        contains('success'),
      );
    });

    test('toString for failure', () {
      final result = UnlockResult<void>.failure(
        reason: UnlockFailureReason.nodeNotFound,
      );

      expect(
        result.toString(),
        contains('failure'),
      );
    });
  });

  group('UnlockFailureReason', () {
    test('contains all expected values', () {
      expect(UnlockFailureReason.values, [
        UnlockFailureReason.insufficientPoints,
        UnlockFailureReason.prerequisitesNotMet,
        UnlockFailureReason.alreadyMaxed,
        UnlockFailureReason.nodeNotFound,
        UnlockFailureReason.lockedByExclusive,
      ]);
    });
  });
}
