import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AchievementPopup', () {
    late Achievement<void> testAchievement;

    /// The default duration used for the popup auto-dismiss timer.
    /// Tests must pump past this duration to avoid pending-timer errors.
    const testDuration = Duration(seconds: 4);

    setUp(() {
      testAchievement = const Achievement(
        id: 'test_popup',
        name: 'Test Popup Achievement',
        description: 'A test achievement for popup',
        condition: EventCondition('test_event'),
        rarity: AchievementRarity.rare,
        points: 50,
        icon: Icons.star,
      );
    });

    Widget buildTestWidget({
      Achievement<void>? achievement,
      VoidCallback? onDismiss,
      Duration duration = testDuration,
      AchievementPopupContentBuilder<void>? contentBuilder,
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
          body: AchievementPopup<void>(
            achievement: achievement ?? testAchievement,
            onDismiss: onDismiss,
            duration: duration,
            showAnimation: false,
            contentBuilder: contentBuilder,
          ),
        ),
      );
    }

    /// Drains the auto-dismiss timer so the test framework
    /// does not complain about pending timers.
    Future<void> drainTimer(WidgetTester tester) async {
      await tester.pump(testDuration + const Duration(seconds: 1));
    }

    group('default rendering', () {
      testWidgets('shows ACHIEVEMENT UNLOCKED text', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        expect(find.text('ACHIEVEMENT UNLOCKED'), findsOneWidget);
        expect(find.text('Test Popup Achievement'), findsOneWidget);

        await drainTimer(tester);
      });

      testWidgets('shows achievement description', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        expect(
          find.text('A test achievement for popup'),
          findsOneWidget,
        );

        await drainTimer(tester);
      });

      testWidgets('shows rarity badge and points', (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump();

        expect(find.text('RARE'), findsOneWidget);
        expect(find.text('+50 pts'), findsOneWidget);

        await drainTimer(tester);
      });
    });

    group('contentBuilder', () {
      testWidgets('renders custom widget from contentBuilder', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          contentBuilder: (achievement, rarityColor, animController) {
            return Text('Custom popup: ${achievement.name}');
          },
        ));
        await tester.pump();

        expect(
          find.text('Custom popup: Test Popup Achievement'),
          findsOneWidget,
        );
        // Default content should not be present
        expect(find.text('ACHIEVEMENT UNLOCKED'), findsNothing);

        await drainTimer(tester);
      });

      testWidgets('builder receives correct rarityColor', (tester) async {
        Color? receivedColor;

        await tester.pumpWidget(buildTestWidget(
          contentBuilder: (achievement, rarityColor, animController) {
            receivedColor = rarityColor;
            return const Text('builder');
          },
        ));
        await tester.pump();

        // Rare rarity uses hardcoded color 0xFF5B8BD4
        expect(receivedColor, const Color(0xFF5B8BD4));

        await drainTimer(tester);
      });

      testWidgets('builder receives AnimationController', (tester) async {
        AnimationController? receivedController;

        await tester.pumpWidget(buildTestWidget(
          contentBuilder: (achievement, rarityColor, animController) {
            receivedController = animController;
            return const Text('builder');
          },
        ));
        await tester.pump();

        expect(receivedController, isNotNull);
        // showAnimation is false, so value should be at 1.0
        expect(receivedController!.value, 1.0);

        await drainTimer(tester);
      });
    });

    group('auto-dismiss', () {
      testWidgets('calls onDismiss after duration', (tester) async {
        var dismissed = false;
        const dismissDuration = Duration(seconds: 1);

        await tester.pumpWidget(buildTestWidget(
          duration: dismissDuration,
          onDismiss: () => dismissed = true,
        ));
        await tester.pump();

        // Not dismissed yet
        expect(dismissed, isFalse);

        // Advance past the duration to fire the Future.delayed callback
        await tester.pump(dismissDuration + const Duration(seconds: 1));

        expect(dismissed, isTrue);
      });
    });
  });
}
