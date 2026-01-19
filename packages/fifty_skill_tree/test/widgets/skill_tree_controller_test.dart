import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SkillTreeController', () {
    late SkillTree<void> tree;
    late SkillTreeController<void> controller;

    setUp(() {
      tree = SkillTree<void>(
        id: 'test',
        name: 'Test Tree',
      );

      tree.addNode(SkillNode(
        id: 'root',
        name: 'Root Skill',
        maxLevel: 1,
        costs: [1],
      ));

      tree.addNode(SkillNode(
        id: 'child1',
        name: 'Child 1',
        maxLevel: 3,
        costs: [1, 2, 3],
        prerequisites: ['root'],
      ));

      tree.addNode(SkillNode(
        id: 'child2',
        name: 'Child 2',
        maxLevel: 2,
        costs: [2, 3],
        prerequisites: ['root'],
      ));

      tree.addConnection(const SkillConnection(
        fromId: 'root',
        toId: 'child1',
      ));

      tree.addConnection(const SkillConnection(
        fromId: 'root',
        toId: 'child2',
      ));

      tree.addPoints(10);

      controller = SkillTreeController<void>(tree: tree);
    });

    group('Unlock Flow', () {
      test('unlocks root node successfully', () async {
        final result = await controller.unlock('root');

        expect(result.success, isTrue);
        expect(result.node?.currentLevel, 1);
        expect(controller.availablePoints, 9);
      });

      test('fails to unlock child without prerequisite', () async {
        final result = await controller.unlock('child1');

        expect(result.success, isFalse);
        expect(result.reason, UnlockFailureReason.prerequisitesNotMet);
      });

      test('unlocks child after prerequisite is met', () async {
        await controller.unlock('root');
        final result = await controller.unlock('child1');

        expect(result.success, isTrue);
        expect(result.node?.currentLevel, 1);
      });

      test('levels up multi-level skill', () async {
        await controller.unlock('root');
        await controller.unlock('child1');
        final result = await controller.unlock('child1');

        expect(result.success, isTrue);
        expect(result.node?.currentLevel, 2);
        expect(result.pointsSpent, 2);
      });

      test('fails to unlock when insufficient points', () async {
        controller.setPoints(0);
        final result = await controller.unlock('root');

        expect(result.success, isFalse);
        expect(result.reason, UnlockFailureReason.insufficientPoints);
      });

      test('fails to unlock already maxed skill', () async {
        await controller.unlock('root');

        final result = await controller.unlock('root');

        expect(result.success, isFalse);
        expect(result.reason, UnlockFailureReason.alreadyMaxed);
      });

      test('notifies listeners on unlock', () async {
        var notifyCount = 0;
        controller.addListener(() => notifyCount++);

        await controller.unlock('root');

        expect(notifyCount, 1);
      });
    });

    group('Zoom/Pan Control', () {
      test('zoomTo updates zoom level', () {
        controller.zoomTo(1.5);

        expect(controller.zoom, 1.5);
      });

      test('panTo updates pan offset', () {
        controller.panTo(const Offset(100, 200));

        expect(controller.panOffset, const Offset(100, 200));
      });

      test('resetView restores defaults', () {
        controller.zoomTo(2.0);
        controller.panTo(const Offset(50, 50));

        controller.resetView();

        expect(controller.zoom, 1.0);
        expect(controller.panOffset, Offset.zero);
      });

      test('zoomTo notifies listeners by default', () {
        var notified = false;
        controller.addListener(() => notified = true);

        controller.zoomTo(1.5);

        expect(notified, isTrue);
      });

      test('zoomTo can skip notification', () {
        var notified = false;
        controller.addListener(() => notified = true);

        controller.zoomTo(1.5, notify: false);

        expect(notified, isFalse);
      });
    });

    group('Selection & Hover', () {
      test('selectNode updates selection', () {
        controller.selectNode('root');

        expect(controller.selectedNodeId, 'root');
        expect(controller.selectedNode?.id, 'root');
      });

      test('selectNode with null clears selection', () {
        controller.selectNode('root');
        controller.selectNode(null);

        expect(controller.selectedNodeId, isNull);
        expect(controller.selectedNode, isNull);
      });

      test('hoverNode updates hover state', () {
        controller.hoverNode('root');

        expect(controller.hoveredNodeId, 'root');
        expect(controller.hoveredNode?.id, 'root');
      });

      test('toggleSelection selects unselected node', () {
        controller.toggleSelection('root');

        expect(controller.selectedNodeId, 'root');
      });

      test('toggleSelection deselects selected node', () {
        controller.selectNode('root');
        controller.toggleSelection('root');

        expect(controller.selectedNodeId, isNull);
      });
    });

    group('Export/Import Progress', () {
      test('exports progress correctly', () async {
        await controller.unlock('root');
        await controller.unlock('child1');

        final progress = controller.exportProgress();

        expect(progress['availablePoints'], 8);
        expect(progress['nodes']['root'], 1);
        expect(progress['nodes']['child1'], 1);
        expect(progress['nodes'].containsKey('child2'), isFalse);
      });

      test('imports progress correctly', () {
        final progress = {
          'availablePoints': 5,
          'nodes': {
            'root': 1,
            'child1': 2,
          },
        };

        controller.importProgress(progress);

        expect(controller.availablePoints, 5);
        expect(controller.getNode('root')?.currentLevel, 1);
        expect(controller.getNode('child1')?.currentLevel, 2);
        expect(controller.getNode('child2')?.currentLevel, 0);
      });

      test('import clears selection', () {
        controller.selectNode('root');

        controller.importProgress(<String, dynamic>{
          'availablePoints': 5,
          'nodes': <String, dynamic>{},
        });

        expect(controller.selectedNodeId, isNull);
      });

      test('import notifies listeners', () {
        var notified = false;
        controller.addListener(() => notified = true);

        controller.importProgress(<String, dynamic>{
          'availablePoints': 5,
          'nodes': <String, dynamic>{},
        });

        expect(notified, isTrue);
      });
    });

    group('Reset', () {
      test('reset refunds all points', () async {
        await controller.unlock('root');
        await controller.unlock('child1');

        controller.reset();

        expect(controller.availablePoints, 10);
        expect(controller.getNode('root')?.currentLevel, 0);
        expect(controller.getNode('child1')?.currentLevel, 0);
      });

      test('reset clears selection', () async {
        await controller.unlock('root');
        controller.selectNode('root');

        controller.reset();

        expect(controller.selectedNodeId, isNull);
      });

      test('resetNode refunds only that node', () async {
        await controller.unlock('root');
        await controller.unlock('child1');

        controller.resetNode('child1');

        expect(controller.getNode('root')?.currentLevel, 1);
        expect(controller.getNode('child1')?.currentLevel, 0);
        expect(controller.availablePoints, 9);
      });
    });

    group('Points Management', () {
      test('addPoints increases available points', () {
        controller.addPoints(5);

        expect(controller.availablePoints, 15);
      });

      test('removePoints decreases available points', () {
        controller.removePoints(3);

        expect(controller.availablePoints, 7);
      });

      test('setPoints sets exact value', () {
        controller.setPoints(25);

        expect(controller.availablePoints, 25);
      });
    });

    group('Theme', () {
      test('setTheme updates theme', () {
        final newTheme = SkillTreeTheme.light();

        controller.setTheme(newTheme);

        expect(controller.theme, newTheme);
      });

      test('setTheme notifies listeners', () {
        var notified = false;
        controller.addListener(() => notified = true);

        controller.setTheme(SkillTreeTheme.light());

        expect(notified, isTrue);
      });
    });
  });
}
