import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AchievementList', () {
    late AchievementController<void> controller;

    List<Achievement<void>> createAchievements() {
      return [
        const Achievement(
          id: 'a1',
          name: 'First Achievement',
          description: 'Description one',
          condition: EventCondition('e1'),
          rarity: AchievementRarity.common,
          points: 10,
        ),
        const Achievement(
          id: 'a2',
          name: 'Second Achievement',
          description: 'Description two',
          condition: EventCondition('e2'),
          rarity: AchievementRarity.rare,
          points: 50,
        ),
        const Achievement(
          id: 'a3',
          name: 'Third Achievement',
          description: 'Description three',
          condition: EventCondition('e3'),
          rarity: AchievementRarity.epic,
          points: 100,
        ),
      ];
    }

    setUp(() {
      controller = AchievementController(achievements: createAchievements());
    });

    Widget buildTestWidget({
      AchievementFilter filter = AchievementFilter.all,
      AchievementItemBuilder<void>? itemBuilder,
      Widget? emptyWidget,
    }) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFF0000),
            tertiary: Color(0xFF00FF00),
            onSurfaceVariant: Color(0xFFAAAAAA),
            surfaceContainerHighest: Color(0xFF333333),
          ),
        ),
        home: Scaffold(
          body: AchievementList<void>(
            controller: controller,
            filter: filter,
            itemBuilder: itemBuilder,
            emptyWidget: emptyWidget,
          ),
        ),
      );
    }

    group('default rendering', () {
      testWidgets('produces AchievementCard widgets', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(AchievementCard<void>), findsNWidgets(3));
        expect(find.text('First Achievement'), findsOneWidget);
        expect(find.text('Second Achievement'), findsOneWidget);
        expect(find.text('Third Achievement'), findsOneWidget);
      });
    });

    group('itemBuilder', () {
      testWidgets('renders custom widgets from itemBuilder', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          itemBuilder: (achievement, progress, state, index) {
            return ListTile(
              key: Key('custom-$index'),
              title: Text('Item: ${achievement.name}'),
            );
          },
        ));
        await tester.pumpAndSettle();

        expect(find.text('Item: First Achievement'), findsOneWidget);
        expect(find.text('Item: Second Achievement'), findsOneWidget);
        expect(find.text('Item: Third Achievement'), findsOneWidget);
        // Default cards should not be present
        expect(find.byType(AchievementCard<void>), findsNothing);
      });

      testWidgets('itemBuilder receives correct index', (tester) async {
        final receivedIndices = <int>[];

        await tester.pumpWidget(buildTestWidget(
          itemBuilder: (achievement, progress, state, index) {
            receivedIndices.add(index);
            return Text('Index: $index');
          },
        ));
        await tester.pumpAndSettle();

        expect(receivedIndices, containsAll([0, 1, 2]));
        expect(find.text('Index: 0'), findsOneWidget);
        expect(find.text('Index: 1'), findsOneWidget);
        expect(find.text('Index: 2'), findsOneWidget);
      });
    });

    group('filtering with itemBuilder', () {
      testWidgets('filter works correctly with itemBuilder', (tester) async {
        // Unlock one achievement to test filter
        controller.forceUnlock('a2');

        await tester.pumpWidget(buildTestWidget(
          filter: AchievementFilter.unlocked,
          itemBuilder: (achievement, progress, state, index) {
            return Text('Unlocked: ${achievement.name}');
          },
        ));
        await tester.pumpAndSettle();

        expect(find.text('Unlocked: Second Achievement'), findsOneWidget);
        // Other achievements should not be shown
        expect(find.text('Unlocked: First Achievement'), findsNothing);
        expect(find.text('Unlocked: Third Achievement'), findsNothing);
      });
    });

    group('emptyWidget', () {
      testWidgets('shows emptyWidget when list is empty', (tester) async {
        final emptyController = AchievementController<void>();

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFFF0000),
                tertiary: Color(0xFF00FF00),
                onSurfaceVariant: Color(0xFFAAAAAA),
                surfaceContainerHighest: Color(0xFF333333),
              ),
            ),
            home: Scaffold(
              body: AchievementList<void>(
                controller: emptyController,
                emptyWidget: const Text('Nothing here'),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Nothing here'), findsOneWidget);
      });

      testWidgets('shows default empty state when no emptyWidget provided',
          (tester) async {
        final emptyController = AchievementController<void>();

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFFF0000),
                tertiary: Color(0xFF00FF00),
                onSurfaceVariant: Color(0xFFAAAAAA),
                surfaceContainerHighest: Color(0xFF333333),
              ),
            ),
            home: Scaffold(
              body: AchievementList<void>(
                controller: emptyController,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('No achievements found'), findsOneWidget);
      });
    });
  });
}
