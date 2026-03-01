import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyHero', () {
    testWidgets('renders text in uppercase', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHero(
          text: 'hello world',
        ),
      ));

      expect(find.text('HELLO WORLD'), findsOneWidget);
      expect(find.text('hello world'), findsNothing);
    });

    testWidgets('renders with display size by default', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHero(
          text: 'Test',
        ),
      ));

      final text = tester.widget<Text>(find.text('TEST'));
      expect(text.style?.fontSize, FiftyTypography.displayLarge);
    });

    testWidgets('renders with h1 size', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHero(
          text: 'Test',
          size: FiftyHeroSize.h1,
        ),
      ));

      final text = tester.widget<Text>(find.text('TEST'));
      expect(text.style?.fontSize, FiftyTypography.displayMedium);
    });

    testWidgets('renders with h2 size', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHero(
          text: 'Test',
          size: FiftyHeroSize.h2,
        ),
      ));

      final text = tester.widget<Text>(find.text('TEST'));
      expect(text.style?.fontSize, FiftyTypography.titleLarge);
    });

    testWidgets('applies glitch effect when glitchOnMount is true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHero(
          text: 'Test',
          glitchOnMount: true,
        ),
      ));

      expect(find.byType(GlitchEffect), findsOneWidget);
    });

    testWidgets('does not apply glitch effect by default', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHero(
          text: 'Test',
        ),
      ));

      expect(find.byType(GlitchEffect), findsNothing);
    });

    testWidgets('applies gradient when provided', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyHero(
          text: 'Test',
          gradient: LinearGradient(
            colors: [FiftyColors.burgundy, FiftyColors.cream],
          ),
        ),
      ));

      expect(find.byType(ShaderMask), findsOneWidget);
    });

    testWidgets('does not apply ShaderMask when no gradient', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHero(
          text: 'Test',
        ),
      ));

      expect(find.byType(ShaderMask), findsNothing);
    });

    testWidgets('respects textAlign property', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHero(
          text: 'Test',
          textAlign: TextAlign.left,
        ),
      ));

      final text = tester.widget<Text>(find.text('TEST'));
      expect(text.textAlign, TextAlign.left);
    });

    testWidgets('respects maxLines property', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHero(
          text: 'Test',
          maxLines: 2,
        ),
      ));

      final text = tester.widget<Text>(find.text('TEST'));
      expect(text.maxLines, 2);
    });

    testWidgets('respects overflow property', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHero(
          text: 'Test',
          overflow: TextOverflow.ellipsis,
        ),
      ));

      final text = tester.widget<Text>(find.text('TEST'));
      expect(text.overflow, TextOverflow.ellipsis);
    });

    testWidgets('uses Monument Extended font', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHero(
          text: 'Test',
        ),
      ));

      final text = tester.widget<Text>(find.text('TEST'));
      expect(text.style?.fontFamily, FiftyTypography.fontFamily);
    });
  });

  group('FiftyHeroSection', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHeroSection(
          title: 'Main Title',
        ),
      ));

      expect(find.text('MAIN TITLE'), findsOneWidget);
    });

    testWidgets('renders subtitle when provided', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHeroSection(
          title: 'Main Title',
          subtitle: 'This is a subtitle',
        ),
      ));

      expect(find.text('MAIN TITLE'), findsOneWidget);
      expect(find.text('This is a subtitle'), findsOneWidget);
    });

    testWidgets('does not render subtitle when not provided', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHeroSection(
          title: 'Main Title',
        ),
      ));

      // Only the FiftyHero should be rendered
      expect(find.byType(FiftyHero), findsOneWidget);
    });

    testWidgets('applies glitch effect to title', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHeroSection(
          title: 'Main Title',
          glitchOnMount: true,
        ),
      ));

      expect(find.byType(GlitchEffect), findsOneWidget);
    });

    testWidgets('respects crossAxisAlignment', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHeroSection(
          title: 'Main Title',
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ));

      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('respects custom spacing', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyHeroSection(
          title: 'Main Title',
          subtitle: 'Subtitle',
          spacing: 32.0,
        ),
      ));

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('applies gradient to title', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyHeroSection(
          title: 'Main Title',
          titleGradient: LinearGradient(
            colors: [FiftyColors.burgundy, FiftyColors.cream],
          ),
        ),
      ));

      expect(find.byType(ShaderMask), findsOneWidget);
    });
  });
}
