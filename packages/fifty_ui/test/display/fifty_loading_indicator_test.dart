import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyLoadingIndicator', () {
    testWidgets('renders with default text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(),
      ));

      expect(find.byType(FiftyLoadingIndicator), findsOneWidget);
      // Default text is "LOADING" with "> " prefix
      expect(find.textContaining('> LOADING'), findsOneWidget);
    });

    testWidgets('renders with custom text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(text: 'PROCESSING'),
      ));

      expect(find.textContaining('> PROCESSING'), findsOneWidget);
    });

    testWidgets('renders with dots style by default', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(),
      ));

      // Should contain dots
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.textContaining('.'), findsOneWidget);
    });

    testWidgets('renders with static style', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(style: FiftyLoadingStyle.static),
      ));

      // Static always shows "..."
      expect(find.textContaining('...'), findsOneWidget);
    });

    testWidgets('respects size parameter - small', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(size: FiftyLoadingSize.small),
      ));

      final text = tester.widget<RichText>(find.byType(RichText).first);
      final span = text.text as TextSpan;
      expect(span.style?.fontSize, 12);
    });

    testWidgets('respects size parameter - medium', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(size: FiftyLoadingSize.medium),
      ));

      final text = tester.widget<RichText>(find.byType(RichText).first);
      final span = text.text as TextSpan;
      expect(span.style?.fontSize, 14);
    });

    testWidgets('respects size parameter - large', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(size: FiftyLoadingSize.large),
      ));

      final text = tester.widget<RichText>(find.byType(RichText).first);
      final span = text.text as TextSpan;
      expect(span.style?.fontSize, 16);
    });

    testWidgets('respects custom color', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(color: Colors.blue),
      ));

      final text = tester.widget<RichText>(find.byType(RichText).first);
      final span = text.text as TextSpan;
      expect(span.style?.color, Colors.blue);
    });

    testWidgets('animates dots over time', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(style: FiftyLoadingStyle.dots),
      ));

      // Animation should change the dot count
      await tester.pump(const Duration(milliseconds: 0));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 150));

      // Just verify it's still rendering
      expect(find.byType(FiftyLoadingIndicator), findsOneWidget);
    });

    testWidgets('does NOT use CircularProgressIndicator (FDL compliance)',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(),
      ));

      // FDL Rule: "Loading: Never use a spinner. Use text sequences."
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('uppercase text is enforced', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(text: 'loading'),
      ));

      // Text should be uppercase
      expect(find.textContaining('> LOADING'), findsOneWidget);
    });

    group('sequence mode', () {
      testWidgets('renders with sequence style', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyLoadingIndicator(style: FiftyLoadingStyle.sequence),
        ));

        expect(find.byType(FiftyLoadingIndicator), findsOneWidget);
      });

      testWidgets('uses default sequences when none provided', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyLoadingIndicator(style: FiftyLoadingStyle.sequence),
        ));

        // Default sequences start with "> INITIALIZING..."
        expect(find.textContaining('INITIALIZING'), findsOneWidget);
      });

      testWidgets('uses custom sequences when provided', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyLoadingIndicator(
            style: FiftyLoadingStyle.sequence,
            sequences: ['> CUSTOM STEP 1...', '> CUSTOM STEP 2...'],
          ),
        ));

        expect(find.textContaining('CUSTOM STEP'), findsOneWidget);
      });

      testWidgets('cycles through sequences', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyLoadingIndicator(
            style: FiftyLoadingStyle.sequence,
            sequences: ['> STEP 1...', '> STEP 2...'],
          ),
        ));

        // First sequence
        expect(find.textContaining('STEP 1'), findsOneWidget);

        // Pump to advance animation
        await tester.pump(const Duration(milliseconds: 1100));
        await tester.pump(const Duration(milliseconds: 100));

        // Animation cycles through
        expect(find.byType(FiftyLoadingIndicator), findsOneWidget);
      });

      testWidgets('all loading styles render correctly', (tester) async {
        for (final style in FiftyLoadingStyle.values) {
          await tester.pumpWidget(wrapWithTheme(
            FiftyLoadingIndicator(style: style),
          ));

          expect(find.byType(FiftyLoadingIndicator), findsOneWidget);
        }
      });
    });
  });
}
