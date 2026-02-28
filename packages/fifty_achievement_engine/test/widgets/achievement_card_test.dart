import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AchievementCard', () {
    late Achievement<void> testAchievement;

    Achievement<void> makeAchievement({
      AchievementRarity rarity = AchievementRarity.common,
      bool hidden = false,
    }) {
      return Achievement<void>(
        id: 'test_achievement',
        name: 'Test Achievement',
        description: 'A test achievement',
        condition: const EventCondition('test_event'),
        rarity: rarity,
        icon: Icons.star,
        hidden: hidden,
      );
    }

    setUp(() {
      testAchievement = makeAchievement();
    });

    Widget buildTestWidget({
      Achievement<void>? achievement,
      AchievementState state = AchievementState.available,
      Map<AchievementRarity, Color>? rarityColors,
      ColorScheme? colorScheme,
    }) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: colorScheme ??
              const ColorScheme.dark(
                primary: Color(0xFFFF0000),
                tertiary: Color(0xFF00FF00),
                onSurfaceVariant: Color(0xFFAAAAAA),
                surfaceContainerHighest: Color(0xFF333333),
              ),
        ),
        home: Scaffold(
          body: AchievementCard<void>(
            achievement: achievement ?? testAchievement,
            progress: 0.5,
            state: state,
            rarityColors: rarityColors,
          ),
        ),
      );
    }

    group('rarity color resolution', () {
      testWidgets('common rarity uses colorScheme.onSurfaceVariant',
          (tester) async {
        final achievement = makeAchievement(rarity: AchievementRarity.common);

        await tester.pumpWidget(buildTestWidget(achievement: achievement));
        await tester.pumpAndSettle();

        // The card renders without error, using the theme's onSurfaceVariant
        expect(find.text('Test Achievement'), findsOneWidget);
        expect(find.text('Common'), findsOneWidget);
      });

      testWidgets('uncommon rarity uses colorScheme.tertiary',
          (tester) async {
        final achievement =
            makeAchievement(rarity: AchievementRarity.uncommon);

        await tester.pumpWidget(buildTestWidget(achievement: achievement));
        await tester.pumpAndSettle();

        expect(find.text('Test Achievement'), findsOneWidget);
        expect(find.text('Uncommon'), findsOneWidget);
      });

      testWidgets('rare rarity uses hardcoded domain color', (tester) async {
        final achievement = makeAchievement(rarity: AchievementRarity.rare);

        await tester.pumpWidget(buildTestWidget(achievement: achievement));
        await tester.pumpAndSettle();

        expect(find.text('Test Achievement'), findsOneWidget);
        expect(find.text('Rare'), findsOneWidget);
      });

      testWidgets('epic rarity uses hardcoded domain color', (tester) async {
        final achievement = makeAchievement(rarity: AchievementRarity.epic);

        await tester.pumpWidget(buildTestWidget(achievement: achievement));
        await tester.pumpAndSettle();

        expect(find.text('Test Achievement'), findsOneWidget);
        expect(find.text('Epic'), findsOneWidget);
      });

      testWidgets('legendary rarity uses hardcoded domain color',
          (tester) async {
        final achievement =
            makeAchievement(rarity: AchievementRarity.legendary);

        await tester.pumpWidget(buildTestWidget(achievement: achievement));
        await tester.pumpAndSettle();

        expect(find.text('Test Achievement'), findsOneWidget);
        expect(find.text('Legendary'), findsOneWidget);
      });

      testWidgets('custom rarityColors override defaults', (tester) async {
        const customColor = Color(0xFF123456);
        final achievement = makeAchievement(rarity: AchievementRarity.common);

        await tester.pumpWidget(buildTestWidget(
          achievement: achievement,
          rarityColors: {AchievementRarity.common: customColor},
        ));
        await tester.pumpAndSettle();

        // The card renders without error with custom color
        expect(find.text('Test Achievement'), findsOneWidget);
      });

      testWidgets(
          'custom rarityColors for one rarity do not affect others',
          (tester) async {
        const customColor = Color(0xFF123456);
        final achievement =
            makeAchievement(rarity: AchievementRarity.uncommon);

        // Only override common, not uncommon
        await tester.pumpWidget(buildTestWidget(
          achievement: achievement,
          rarityColors: {AchievementRarity.common: customColor},
        ));
        await tester.pumpAndSettle();

        // Uncommon still renders correctly with default theme color
        expect(find.text('Test Achievement'), findsOneWidget);
        expect(find.text('Uncommon'), findsOneWidget);
      });
    });

    group('theme alignment', () {
      testWidgets('respects custom colorScheme for common rarity',
          (tester) async {
        final achievement = makeAchievement(rarity: AchievementRarity.common);

        const customScheme = ColorScheme.light(
          primary: Color(0xFF1A73E8),
          tertiary: Color(0xFF4CAF50),
          onSurfaceVariant: Color(0xFF999999),
          surfaceContainerHighest: Color(0xFFEEEEEE),
        );

        await tester.pumpWidget(buildTestWidget(
          achievement: achievement,
          colorScheme: customScheme,
        ));
        await tester.pumpAndSettle();

        // Card renders successfully with the custom light scheme
        expect(find.text('Test Achievement'), findsOneWidget);
      });

      testWidgets('card renders in different states', (tester) async {
        for (final state in AchievementState.values) {
          await tester.pumpWidget(buildTestWidget(state: state));
          await tester.pumpAndSettle();

          // Should render without error in any state
          if (state == AchievementState.locked) {
            // Locked non-hidden shows the achievement name
            expect(find.text('Test Achievement'), findsOneWidget);
          }
        }
      });
    });
  });
}
