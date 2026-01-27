import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyProgressCard', () {
    testWidgets('renders with title and progress bar', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'Weekly Goal',
          progress: 0.75,
        ),
      ));

      expect(find.text('Weekly Goal'), findsOneWidget);
      expect(find.byType(FiftyProgressCard), findsOneWidget);
    });

    testWidgets('shows correct percentage', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'Progress Test',
          progress: 0.75,
        ),
      ));

      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('shows 0% for zero progress', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'Zero Progress',
          progress: 0.0,
        ),
      ));

      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('shows 100% for full progress', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'Full Progress',
          progress: 1.0,
        ),
      ));

      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('icon renders in container', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'With Icon',
          progress: 0.5,
          icon: Icons.trending_up,
        ),
      ));

      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('subtitle renders when provided', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'With Subtitle',
          progress: 0.75,
          subtitle: '12 sales remaining to reach target',
        ),
      ));

      expect(find.text('12 sales remaining to reach target'), findsOneWidget);
    });

    testWidgets('subtitle hidden when not provided', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'No Subtitle',
          progress: 0.5,
        ),
      ));

      // Should only find the title, no subtitle text
      expect(find.text('No Subtitle'), findsOneWidget);
    });

    testWidgets('showPercentage=false hides percentage', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'Hidden Percentage',
          progress: 0.75,
          showPercentage: false,
        ),
      ));

      expect(find.text('75%'), findsNothing);
    });

    testWidgets('progress clamped to 0.0 for negative values', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'Negative Progress',
          progress: -0.5,
        ),
      ));

      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('progress clamped to 1.0 for values over 1.0', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'Over 100%',
          progress: 1.5,
        ),
      ));

      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('custom gradient works', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'Custom Gradient',
          progress: 0.5,
          progressGradient: LinearGradient(
            colors: [FiftyColors.hunterGreen, FiftyColors.slateGrey],
          ),
        ),
      ));

      expect(find.byType(FiftyProgressCard), findsOneWidget);
      // Widget should render without errors with custom gradient
    });

    testWidgets('renders all elements together', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          icon: Icons.trending_up,
          title: 'Weekly Goal',
          progress: 0.75,
          subtitle: '12 sales remaining to reach target',
        ),
      ));

      expect(find.byIcon(Icons.trending_up), findsOneWidget);
      expect(find.text('Weekly Goal'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
      expect(find.text('12 sales remaining to reach target'), findsOneWidget);
    });

    testWidgets('animates progress changes', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'Animation Test',
          progress: 0.25,
        ),
      ));

      expect(find.text('25%'), findsOneWidget);

      // Rebuild with new progress
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'Animation Test',
          progress: 0.75,
        ),
      ));

      // Start animation
      await tester.pump();

      // Complete animation
      await tester.pumpAndSettle();

      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('has AnimatedContainer for progress bar', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'Animated Container Test',
          progress: 0.5,
        ),
      ));

      expect(find.byType(AnimatedContainer), findsOneWidget);
    });

    testWidgets('uses slate grey background color', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyProgressCard(
          title: 'Background Test',
          progress: 0.5,
        ),
      ));

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, FiftyColors.slateGrey);
    });
  });
}
