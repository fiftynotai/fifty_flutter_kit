import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AchievementSummaryData', () {
    group('construction', () {
      test('creates with known values', () {
        const data = AchievementSummaryData(
          unlockedCount: 3,
          totalCount: 10,
          completionPercentage: 0.3,
          earnedPoints: 60,
          totalPoints: 200,
          rarityBreakdown: {},
          categoryBreakdown: {},
        );

        expect(data.unlockedCount, 3);
        expect(data.totalCount, 10);
        expect(data.completionPercentage, 0.3);
        expect(data.earnedPoints, 60);
        expect(data.totalPoints, 200);
        expect(data.rarityBreakdown, isEmpty);
        expect(data.categoryBreakdown, isEmpty);
      });

      test('stores rarity and category breakdowns', () {
        const data = AchievementSummaryData(
          unlockedCount: 2,
          totalCount: 5,
          completionPercentage: 0.4,
          earnedPoints: 30,
          totalPoints: 100,
          rarityBreakdown: {
            AchievementRarity.common: (unlocked: 1, total: 3),
            AchievementRarity.rare: (unlocked: 1, total: 2),
          },
          categoryBreakdown: {
            'Combat': (unlocked: 2, total: 4),
            'Social': (unlocked: 0, total: 1),
          },
        );

        expect(data.rarityBreakdown, hasLength(2));
        expect(data.rarityBreakdown[AchievementRarity.common]!.unlocked, 1);
        expect(data.rarityBreakdown[AchievementRarity.common]!.total, 3);
        expect(data.categoryBreakdown['Combat']!.unlocked, 2);
        expect(data.categoryBreakdown['Social']!.total, 1);
      });
    });

    group('fromController', () {
      late AchievementController<void> controller;

      setUp(() {
        controller = AchievementController(
          achievements: [
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
          ],
        );
      });

      test('computes correct values with no unlocks', () {
        final data = AchievementSummaryData.fromController(controller);

        expect(data.unlockedCount, 0);
        expect(data.totalCount, 3);
        expect(data.completionPercentage, 0.0);
        expect(data.earnedPoints, 0);
        expect(data.totalPoints, 80);
      });

      test('computes correct values after unlocking achievements', () {
        controller.forceUnlock('a1');
        controller.forceUnlock('a3');

        final data = AchievementSummaryData.fromController(controller);

        expect(data.unlockedCount, 2);
        expect(data.totalCount, 3);
        expect(data.completionPercentage, closeTo(0.666, 0.01));
        expect(data.earnedPoints, 60); // 10 + 50
        expect(data.totalPoints, 80);
      });

      test('computes correct rarity breakdown', () {
        controller.forceUnlock('a1');

        final data = AchievementSummaryData.fromController(controller);

        expect(data.rarityBreakdown[AchievementRarity.common]!.unlocked, 1);
        expect(data.rarityBreakdown[AchievementRarity.common]!.total, 2);
        expect(data.rarityBreakdown[AchievementRarity.rare]!.unlocked, 0);
        expect(data.rarityBreakdown[AchievementRarity.rare]!.total, 1);
      });

      test('computes correct category breakdown', () {
        controller.forceUnlock('a1');
        controller.forceUnlock('a3');

        final data = AchievementSummaryData.fromController(controller);

        expect(data.categoryBreakdown['Basics']!.unlocked, 1);
        expect(data.categoryBreakdown['Basics']!.total, 2);
        expect(data.categoryBreakdown['Advanced']!.unlocked, 1);
        expect(data.categoryBreakdown['Advanced']!.total, 1);
      });

      test('handles empty controller', () {
        final emptyController = AchievementController<void>();
        final data = AchievementSummaryData.fromController(emptyController);

        expect(data.unlockedCount, 0);
        expect(data.totalCount, 0);
        expect(data.completionPercentage, 0.0);
        expect(data.earnedPoints, 0);
        expect(data.totalPoints, 0);
        expect(data.rarityBreakdown, isEmpty);
        expect(data.categoryBreakdown, isEmpty);
      });
    });

    group('equality and hashCode', () {
      test('equal instances are equal', () {
        const a = AchievementSummaryData(
          unlockedCount: 2,
          totalCount: 5,
          completionPercentage: 0.4,
          earnedPoints: 30,
          totalPoints: 100,
          rarityBreakdown: {},
          categoryBreakdown: {},
        );
        const b = AchievementSummaryData(
          unlockedCount: 2,
          totalCount: 5,
          completionPercentage: 0.4,
          earnedPoints: 30,
          totalPoints: 100,
          rarityBreakdown: {},
          categoryBreakdown: {},
        );

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different instances are not equal', () {
        const a = AchievementSummaryData(
          unlockedCount: 2,
          totalCount: 5,
          completionPercentage: 0.4,
          earnedPoints: 30,
          totalPoints: 100,
          rarityBreakdown: {},
          categoryBreakdown: {},
        );
        const b = AchievementSummaryData(
          unlockedCount: 3,
          totalCount: 5,
          completionPercentage: 0.6,
          earnedPoints: 60,
          totalPoints: 100,
          rarityBreakdown: {},
          categoryBreakdown: {},
        );

        expect(a, isNot(equals(b)));
      });
    });

    group('toString', () {
      test('returns formatted string', () {
        const data = AchievementSummaryData(
          unlockedCount: 3,
          totalCount: 10,
          completionPercentage: 0.3,
          earnedPoints: 60,
          totalPoints: 200,
          rarityBreakdown: {},
          categoryBreakdown: {},
        );

        final str = data.toString();
        expect(str, contains('3/10'));
        expect(str, contains('30.0%'));
        expect(str, contains('60/200'));
      });
    });
  });
}
