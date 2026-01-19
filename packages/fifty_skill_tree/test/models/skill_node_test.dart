import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SkillNode', () {
    group('construction', () {
      test('creates with required fields only', () {
        final node = SkillNode<void>(id: 'test', name: 'Test Skill');

        expect(node.id, 'test');
        expect(node.name, 'Test Skill');
        expect(node.description, isNull);
        expect(node.icon, isNull);
        expect(node.iconUrl, isNull);
        // Cannot test void data value directly - just verify we can create the node
        expect(node.currentLevel, 0);
        expect(node.maxLevel, 1);
        expect(node.costs, [1]);
        expect(node.prerequisites, isEmpty);
        expect(node.type, SkillType.passive);
        expect(node.branch, isNull);
        expect(node.tier, 0);
        expect(node.position, isNull);
      });

      test('creates with all optional fields', () {
        final node = SkillNode<String>(
          id: 'fireball',
          name: 'Fireball',
          description: 'Launches a ball of fire',
          icon: Icons.whatshot,
          iconUrl: 'https://example.com/icon.png',
          data: 'custom_data',
          currentLevel: 2,
          maxLevel: 5,
          costs: [1, 1, 2, 2, 3],
          prerequisites: ['basic_magic'],
          type: SkillType.active,
          branch: 'fire',
          tier: 2,
          position: const Offset(100, 200),
        );

        expect(node.id, 'fireball');
        expect(node.name, 'Fireball');
        expect(node.description, 'Launches a ball of fire');
        expect(node.icon, Icons.whatshot);
        expect(node.iconUrl, 'https://example.com/icon.png');
        expect(node.data, 'custom_data');
        expect(node.currentLevel, 2);
        expect(node.maxLevel, 5);
        expect(node.costs, [1, 1, 2, 2, 3]);
        expect(node.prerequisites, ['basic_magic']);
        expect(node.type, SkillType.active);
        expect(node.branch, 'fire');
        expect(node.tier, 2);
        expect(node.position, const Offset(100, 200));
      });
    });

    group('computed properties', () {
      test('nextCost returns correct cost for first level', () {
        final node = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 0,
          costs: [2, 3, 4],
        );

        expect(node.nextCost, 2);
      });

      test('nextCost returns correct cost for intermediate level', () {
        final node = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 1,
          maxLevel: 3,
          costs: [2, 3, 4],
        );

        expect(node.nextCost, 3);
      });

      test('nextCost returns last cost when costs list is shorter', () {
        final node = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 2,
          maxLevel: 5,
          costs: [1, 2],
        );

        expect(node.nextCost, 2);
      });

      test('nextCost returns 0 when maxed', () {
        final node = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 3,
          maxLevel: 3,
          costs: [1, 2, 3],
        );

        expect(node.nextCost, 0);
      });

      test('isMaxed returns true when at max level', () {
        final node = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 5,
          maxLevel: 5,
        );

        expect(node.isMaxed, isTrue);
      });

      test('isMaxed returns false when below max level', () {
        final node = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 4,
          maxLevel: 5,
        );

        expect(node.isMaxed, isFalse);
      });

      test('isUnlocked returns true when level > 0', () {
        final node = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 1,
        );

        expect(node.isUnlocked, isTrue);
      });

      test('isUnlocked returns false when level is 0', () {
        final node = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 0,
        );

        expect(node.isUnlocked, isFalse);
      });

      test('totalSpent calculates correctly', () {
        final node = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 3,
          maxLevel: 5,
          costs: [1, 2, 3, 4, 5],
        );

        // Spent: 1 + 2 + 3 = 6
        expect(node.totalSpent, 6);
      });

      test('totalSpent returns 0 when not unlocked', () {
        final node = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 0,
          costs: [1, 2, 3],
        );

        expect(node.totalSpent, 0);
      });

      test('totalSpent uses last cost when list is shorter', () {
        final node = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 4,
          maxLevel: 5,
          costs: [1, 2],
        );

        // Spent: 1 + 2 + 2 + 2 = 7
        expect(node.totalSpent, 7);
      });
    });

    group('copyWith', () {
      test('creates a copy with updated fields', () {
        final original = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 0,
        );

        final copy = original.copyWith(
          currentLevel: 1,
          name: 'Updated Test',
        );

        expect(copy.id, 'test');
        expect(copy.name, 'Updated Test');
        expect(copy.currentLevel, 1);
      });

      test('preserves unchanged fields', () {
        final original = SkillNode<String>(
          id: 'test',
          name: 'Test',
          description: 'A test skill',
          data: 'custom',
          tier: 3,
        );

        final copy = original.copyWith(currentLevel: 1);

        expect(copy.id, 'test');
        expect(copy.name, 'Test');
        expect(copy.description, 'A test skill');
        expect(copy.data, 'custom');
        expect(copy.tier, 3);
        expect(copy.currentLevel, 1);
      });
    });

    group('JSON serialization', () {
      test('toJson includes all serializable fields', () {
        final node = SkillNode<void>(
          id: 'fireball',
          name: 'Fireball',
          description: 'Fire attack',
          currentLevel: 2,
          maxLevel: 5,
          costs: [1, 2, 3, 4, 5],
          prerequisites: ['magic_basics'],
          type: SkillType.active,
          branch: 'fire',
          tier: 2,
          position: const Offset(100, 200),
        );

        final json = node.toJson();

        expect(json['id'], 'fireball');
        expect(json['name'], 'Fireball');
        expect(json['description'], 'Fire attack');
        expect(json['currentLevel'], 2);
        expect(json['maxLevel'], 5);
        expect(json['costs'], [1, 2, 3, 4, 5]);
        expect(json['prerequisites'], ['magic_basics']);
        expect(json['type'], 'active');
        expect(json['branch'], 'fire');
        expect(json['tier'], 2);
        expect(json['position'], {'dx': 100.0, 'dy': 200.0});
      });

      test('toJson omits null optional fields', () {
        final node = SkillNode<void>(id: 'test', name: 'Test');

        final json = node.toJson();

        expect(json.containsKey('description'), isFalse);
        expect(json.containsKey('branch'), isFalse);
        expect(json.containsKey('position'), isFalse);
      });

      test('fromJson creates equivalent node', () {
        final original = SkillNode<void>(
          id: 'fireball',
          name: 'Fireball',
          description: 'Fire attack',
          currentLevel: 2,
          maxLevel: 5,
          costs: [1, 2, 3],
          prerequisites: ['magic'],
          type: SkillType.active,
          branch: 'fire',
          tier: 2,
        );

        final json = original.toJson();
        final restored = SkillNode<void>.fromJson(json);

        expect(restored.id, original.id);
        expect(restored.name, original.name);
        expect(restored.description, original.description);
        expect(restored.currentLevel, original.currentLevel);
        expect(restored.maxLevel, original.maxLevel);
        expect(restored.costs, original.costs);
        expect(restored.prerequisites, original.prerequisites);
        expect(restored.type, original.type);
        expect(restored.branch, original.branch);
        expect(restored.tier, original.tier);
      });

      test('fromJson handles position', () {
        final json = {
          'id': 'test',
          'name': 'Test',
          'position': {'dx': 50.5, 'dy': 100.5},
        };

        final node = SkillNode<void>.fromJson(json);

        expect(node.position, const Offset(50.5, 100.5));
      });

      test('fromJson uses defaults for missing fields', () {
        final json = {
          'id': 'test',
          'name': 'Test',
        };

        final node = SkillNode<void>.fromJson(json);

        expect(node.currentLevel, 0);
        expect(node.maxLevel, 1);
        expect(node.costs, [1]);
        expect(node.prerequisites, isEmpty);
        expect(node.type, SkillType.passive);
        expect(node.tier, 0);
      });
    });

    group('equality', () {
      test('equal nodes are equal', () {
        final node1 = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 1,
        );
        final node2 = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 1,
        );

        expect(node1, equals(node2));
        expect(node1.hashCode, equals(node2.hashCode));
      });

      test('different nodes are not equal', () {
        final node1 = SkillNode<void>(id: 'test1', name: 'Test 1');
        final node2 = SkillNode<void>(id: 'test2', name: 'Test 2');

        expect(node1, isNot(equals(node2)));
      });

      test('nodes with different levels are not equal', () {
        final node1 = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 1,
        );
        final node2 = SkillNode<void>(
          id: 'test',
          name: 'Test',
          currentLevel: 2,
          maxLevel: 2,
        );

        expect(node1, isNot(equals(node2)));
      });
    });

    group('toString', () {
      test('produces readable output', () {
        final node = SkillNode<void>(
          id: 'fireball',
          name: 'Fireball',
          currentLevel: 2,
          maxLevel: 5,
        );

        expect(
          node.toString(),
          'SkillNode(id: fireball, name: Fireball, level: 2/5)',
        );
      });
    });
  });

  group('SkillType', () {
    test('contains all expected values', () {
      expect(SkillType.values, [
        SkillType.passive,
        SkillType.active,
        SkillType.ultimate,
        SkillType.keystone,
        SkillType.minor,
      ]);
    });
  });

  group('SkillState', () {
    test('contains all expected values', () {
      expect(SkillState.values, [
        SkillState.locked,
        SkillState.available,
        SkillState.unlocked,
        SkillState.maxed,
      ]);
    });
  });
}
