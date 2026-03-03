import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AchievementSummary', () {
    late AchievementController<void> controller;

    List<Achievement<void>> createAchievements() {
      return [
        const Achievement(
          id: 'a1',
          name: 'First',
          condition: EventCondition('e1'),
          rarity: AchievementRarity.common,
          points: 10,
          category: 'Basics',
        ),
        const Achievement(
          id: 'a2',
          name: 'Second',
          condition: EventCondition('e2'),
          rarity: AchievementRarity.common,
          points: 20,
          category: 'Basics',
        ),
        const Achievement(
          id: 'a3',
          name: 'Third',
          condition: EventCondition('e3'),
          rarity: AchievementRarity.rare,
          points: 50,
          category: 'Advanced',
        ),
      ];
    }

    setUp(() {
      controller = AchievementController(achievements: createAchievements());
    });

    Widget buildTestWidget({
      AchievementSummaryContentBuilder? contentBuilder,
      bool showRarityBreakdown = false,
    }) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFF0000),
            tertiary: Color(0xFF00FF00),
            onSurfaceVariant: Color(0xFFAAAAAA),
            surfaceContainerHighest: Color(0xFF333333),
            outline: Color(0xFF555555),
          ),
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            child: AchievementSummary<void>(
              controller: controller,
              contentBuilder: contentBuilder,
              showRarityBreakdown: showRarityBreakdown,
            ),
          ),
        ),
      );
    }

    group('default rendering', () {
      testWidgets('shows achievement stats', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('ACHIEVEMENTS'), findsOneWidget);
        expect(find.text('0 / 3 Unlocked'), findsOneWidget);
        expect(find.text('Overall Progress'), findsOneWidget);
      });

      testWidgets('updates when achievements unlocked', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('0 / 3 Unlocked'), findsOneWidget);

        controller.forceUnlock('a1');
        await tester.pumpAndSettle();

        expect(find.text('1 / 3 Unlocked'), findsOneWidget);
      });

      testWidgets('shows earned points', (tester) async {
        controller.forceUnlock('a1');

        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        expect(find.text('POINTS'), findsOneWidget);
        expect(find.text('10'), findsOneWidget);
        expect(find.text('of 80'), findsOneWidget);
      });
    });

    group('contentBuilder', () {
      testWidgets('renders custom widget from contentBuilder', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          contentBuilder: (data) {
            return Text('Custom: ${data.unlockedCount}/${data.totalCount}');
          },
        ));
        await tester.pumpAndSettle();

        expect(find.text('Custom: 0/3'), findsOneWidget);
        // Default content should not be present
        expect(find.text('ACHIEVEMENTS'), findsNothing);
      });

      testWidgets('contentBuilder receives correct AchievementSummaryData',
          (tester) async {
        controller.forceUnlock('a1');
        controller.forceUnlock('a3');

        AchievementSummaryData? receivedData;

        await tester.pumpWidget(buildTestWidget(
          contentBuilder: (data) {
            receivedData = data;
            return const Text('builder');
          },
        ));
        await tester.pumpAndSettle();

        expect(receivedData, isNotNull);
        expect(receivedData!.unlockedCount, 2);
        expect(receivedData!.totalCount, 3);
        expect(receivedData!.earnedPoints, 60); // 10 + 50
        expect(receivedData!.totalPoints, 80);
        expect(
          receivedData!.completionPercentage,
          closeTo(0.666, 0.01),
        );
      });

      testWidgets('contentBuilder updates when controller changes',
          (tester) async {
        await tester.pumpWidget(buildTestWidget(
          contentBuilder: (data) {
            return Text('Score: ${data.earnedPoints}/${data.totalPoints}');
          },
        ));
        await tester.pumpAndSettle();

        expect(find.text('Score: 0/80'), findsOneWidget);

        controller.forceUnlock('a2');
        await tester.pumpAndSettle();

        expect(find.text('Score: 20/80'), findsOneWidget);
      });
    });
  });
}
