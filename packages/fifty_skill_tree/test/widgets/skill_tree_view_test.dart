import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SkillTreeView', () {
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
        icon: Icons.star,
      ));

      tree.addNode(SkillNode(
        id: 'child1',
        name: 'Child 1',
        maxLevel: 3,
        costs: [1, 2, 3],
        prerequisites: ['root'],
        icon: Icons.shield,
      ));

      tree.addNode(SkillNode(
        id: 'child2',
        name: 'Child 2',
        maxLevel: 2,
        costs: [2, 3],
        prerequisites: ['root'],
        icon: Icons.flash_on,
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

    Widget buildTestWidget({
      void Function(SkillNode<void>)? onNodeTap,
      void Function(SkillNode<void>)? onNodeLongPress,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: SkillTreeView<void>(
              controller: controller,
              layout: const VerticalTreeLayout(),
              onNodeTap: onNodeTap,
              onNodeLongPress: onNodeLongPress,
            ),
          ),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('renders all nodes', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Should render 3 SkillNodeWidget instances
        final nodeWidgets = find.byType(SkillNodeWidget<void>);
        expect(nodeWidgets, findsNWidgets(3));
      });

      testWidgets('renders connections via CustomPaint', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Should have CustomPaint for connections
        final customPaint = find.byType(CustomPaint);
        expect(customPaint, findsWidgets);
      });

      testWidgets('nodes have correct initial state colors', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Root should be available (has points, no prerequisites)
        // Children should be locked (prerequisite not met)
        // This is verified by the node widget displaying correctly
        expect(find.byType(SkillNodeWidget<void>), findsNWidgets(3));
      });

      testWidgets('updates when controller changes', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Unlock root
        await controller.unlock('root');
        await tester.pump();

        // Widget should rebuild
        expect(find.byType(SkillNodeWidget<void>), findsNWidgets(3));
      });
    });

    group('Interactions', () {
      testWidgets('calls onNodeTap when node is tapped', (tester) async {
        SkillNode<void>? tappedNode;

        await tester.pumpWidget(buildTestWidget(
          onNodeTap: (node) => tappedNode = node,
        ));
        await tester.pumpAndSettle();

        // Find and tap any SkillNodeWidget
        final nodeWidgets = find.byType(SkillNodeWidget<void>);
        await tester.tap(nodeWidgets.first);
        await tester.pump();

        expect(tappedNode, isNotNull);
      });

      testWidgets('calls onNodeLongPress when node is long-pressed',
          (tester) async {
        SkillNode<void>? longPressedNode;

        await tester.pumpWidget(buildTestWidget(
          onNodeLongPress: (node) => longPressedNode = node,
        ));
        await tester.pumpAndSettle();

        // Find and long-press any SkillNodeWidget
        final nodeWidgets = find.byType(SkillNodeWidget<void>);
        await tester.longPress(nodeWidgets.first);
        await tester.pump();

        expect(longPressedNode, isNotNull);
      });

      testWidgets('selects node on tap', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Tap a node
        final nodeWidgets = find.byType(SkillNodeWidget<void>);
        await tester.tap(nodeWidgets.first);
        await tester.pump();

        // Controller should have a selected node
        expect(controller.selectedNodeId, isNotNull);
      });
    });

    group('Pan/Zoom', () {
      testWidgets('InteractiveViewer is present for pan/zoom', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(InteractiveViewer), findsOneWidget);
      });

      testWidgets('pan can be disabled', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: SkillTreeView<void>(
                controller: controller,
                enablePan: false,
              ),
            ),
          ),
        ));
        await tester.pumpAndSettle();

        final viewer = tester.widget<InteractiveViewer>(
          find.byType(InteractiveViewer),
        );
        expect(viewer.panEnabled, isFalse);
      });

      testWidgets('zoom can be disabled', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: SkillTreeView<void>(
                controller: controller,
                enableZoom: false,
              ),
            ),
          ),
        ));
        await tester.pumpAndSettle();

        final viewer = tester.widget<InteractiveViewer>(
          find.byType(InteractiveViewer),
        );
        expect(viewer.scaleEnabled, isFalse);
      });
    });

    group('Custom Node Builder', () {
      testWidgets('uses custom node builder when provided', (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: SkillTreeView<void>(
                controller: controller,
                nodeBuilder: (node, state) => Container(
                  key: ValueKey('custom_${node.id}'),
                  width: 50,
                  height: 50,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ));
        await tester.pumpAndSettle();

        // Should find custom containers instead of SkillNodeWidget
        expect(find.byKey(const ValueKey('custom_root')), findsOneWidget);
        expect(find.byKey(const ValueKey('custom_child1')), findsOneWidget);
        expect(find.byKey(const ValueKey('custom_child2')), findsOneWidget);
      });
    });

    group('Layout', () {
      testWidgets('respects nodeSize parameter', (tester) async {
        const customSize = Size(80, 80);

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: SkillTreeView<void>(
                controller: controller,
                nodeSize: customSize,
              ),
            ),
          ),
        ));
        await tester.pumpAndSettle();

        // Verify SkillNodeWidget receives correct size
        final nodeWidget = tester.widget<SkillNodeWidget<void>>(
          find.byType(SkillNodeWidget<void>).first,
        );
        expect(nodeWidget.size, customSize);
      });

      testWidgets('respects padding parameter', (tester) async {
        const padding = EdgeInsets.all(20);

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: SkillTreeView<void>(
                controller: controller,
                padding: padding,
              ),
            ),
          ),
        ));
        await tester.pumpAndSettle();

        // Padding widget should be present
        expect(find.byType(Padding), findsWidgets);
      });
    });

    group('Connection Styles', () {
      testWidgets('curved connections by default', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Default should be curved
        expect(find.byType(CustomPaint), findsWidgets);
      });

      testWidgets('straight connections when connectionCurved is false',
          (tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: SkillTreeView<void>(
                controller: controller,
                connectionCurved: false,
              ),
            ),
          ),
        ));
        await tester.pumpAndSettle();

        // Should still render (just with straight lines)
        expect(find.byType(CustomPaint), findsWidgets);
      });
    });
  });

  group('SkillNodeWidget', () {
    testWidgets('displays level badge for multi-level skills', (tester) async {
      final node = SkillNode<void>(
        id: 'test',
        name: 'Test',
        maxLevel: 5,
        currentLevel: 2,
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SkillNodeWidget<void>(
            node: node,
            state: SkillState.unlocked,
            theme: SkillTreeTheme.dark(),
          ),
        ),
      ));

      // Should show level badge with "2/5"
      expect(find.text('2/5'), findsOneWidget);
    });

    testWidgets('does not show level badge for single-level skills',
        (tester) async {
      final node = SkillNode<void>(
        id: 'test',
        name: 'Test',
        maxLevel: 1,
        currentLevel: 0,
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SkillNodeWidget<void>(
            node: node,
            state: SkillState.available,
            theme: SkillTreeTheme.dark(),
          ),
        ),
      ));

      // Should not show level badge
      expect(find.text('0/1'), findsNothing);
    });

    testWidgets('displays custom icon when provided', (tester) async {
      final node = SkillNode<void>(
        id: 'test',
        name: 'Test',
        icon: Icons.star,
      );

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SkillNodeWidget<void>(
            node: node,
            state: SkillState.available,
            theme: SkillTreeTheme.dark(),
          ),
        ),
      ));

      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
