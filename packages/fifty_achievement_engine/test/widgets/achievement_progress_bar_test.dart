import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AchievementProgressBar', () {
    Widget buildTestWidget({
      double progress = 0.5,
      double height = 6,
      Color? backgroundColor,
      Color? foregroundColor,
      BorderRadius? borderRadius,
      bool showLabel = false,
      AchievementProgressBarBuilder? barBuilder,
    }) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFFF0000),
            surfaceContainerHighest: Color(0xFF333333),
          ),
        ),
        home: Scaffold(
          body: AchievementProgressBar(
            progress: progress,
            height: height,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            borderRadius: borderRadius,
            showLabel: showLabel,
            barBuilder: barBuilder,
          ),
        ),
      );
    }

    group('default rendering', () {
      testWidgets('renders animated container without barBuilder',
          (tester) async {
        await tester.pumpWidget(buildTestWidget());
        await tester.pumpAndSettle();

        // Should find the AnimatedContainer used for progress fill
        expect(find.byType(AnimatedContainer), findsOneWidget);
      });

      testWidgets('showLabel displays percentage text', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          progress: 0.75,
          showLabel: true,
        ));
        await tester.pumpAndSettle();

        expect(find.text('75%'), findsOneWidget);
      });

      testWidgets('clamps progress between 0 and 1', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          progress: 1.5,
          showLabel: true,
        ));
        await tester.pumpAndSettle();

        // Progress is clamped to 1.0 => 100%
        expect(find.text('100%'), findsOneWidget);
      });
    });

    group('barBuilder', () {
      testWidgets('renders custom widget from barBuilder', (tester) async {
        await tester.pumpWidget(buildTestWidget(
          barBuilder: (progress, height, bgColor, fgColor, radius) {
            return Container(
              key: const Key('custom-bar'),
              height: height,
              color: fgColor,
            );
          },
        ));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('custom-bar')), findsOneWidget);
        // Default AnimatedContainer should not be present
        expect(find.byType(AnimatedContainer), findsNothing);
      });

      testWidgets('builder receives correct progress value', (tester) async {
        double? receivedProgress;

        await tester.pumpWidget(buildTestWidget(
          progress: 0.42,
          barBuilder: (progress, height, bgColor, fgColor, radius) {
            receivedProgress = progress;
            return const SizedBox();
          },
        ));
        await tester.pumpAndSettle();

        expect(receivedProgress, 0.42);
      });

      testWidgets('builder receives correct height', (tester) async {
        double? receivedHeight;

        await tester.pumpWidget(buildTestWidget(
          height: 12,
          barBuilder: (progress, height, bgColor, fgColor, radius) {
            receivedHeight = height;
            return const SizedBox();
          },
        ));
        await tester.pumpAndSettle();

        expect(receivedHeight, 12);
      });

      testWidgets('builder receives resolved colors', (tester) async {
        Color? receivedBg;
        Color? receivedFg;

        await tester.pumpWidget(buildTestWidget(
          backgroundColor: const Color(0xFF111111),
          foregroundColor: const Color(0xFF222222),
          barBuilder: (progress, height, bgColor, fgColor, radius) {
            receivedBg = bgColor;
            receivedFg = fgColor;
            return const SizedBox();
          },
        ));
        await tester.pumpAndSettle();

        expect(receivedBg, const Color(0xFF111111));
        expect(receivedFg, const Color(0xFF222222));
      });

      testWidgets('builder receives resolved borderRadius', (tester) async {
        BorderRadius? receivedRadius;
        final customRadius = BorderRadius.circular(20);

        await tester.pumpWidget(buildTestWidget(
          borderRadius: customRadius,
          barBuilder: (progress, height, bgColor, fgColor, radius) {
            receivedRadius = radius;
            return const SizedBox();
          },
        ));
        await tester.pumpAndSettle();

        expect(receivedRadius, customRadius);
      });
    });
  });
}
