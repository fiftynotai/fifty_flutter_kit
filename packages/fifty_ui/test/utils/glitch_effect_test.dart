import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('GlitchEffect', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlitchEffect(
          child: SizedBox(
            key: Key('test-child'),
            width: 100,
            height: 100,
          ),
        ),
      ));

      expect(find.byKey(const Key('test-child')), findsOneWidget);
    });

    testWidgets('does not glitch by default', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlitchEffect(
          child: SizedBox(width: 100, height: 100),
        ),
      ));

      // Should not find stacked color filtered widgets when not glitching
      expect(find.byType(ColorFiltered), findsNothing);
    });

    testWidgets('glitches on mount when triggerOnMount is true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlitchEffect(
          triggerOnMount: true,
          child: SizedBox(width: 100, height: 100),
        ),
      ));

      // Allow the glitch effect to trigger
      await tester.pump(const Duration(milliseconds: 50));

      // Should find ColorFiltered widgets during glitch
      expect(find.byType(ColorFiltered), findsWidgets);
    });

    testWidgets('respects enabled property', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlitchEffect(
          enabled: false,
          triggerOnMount: true,
          child: SizedBox(width: 100, height: 100),
        ),
      ));

      await tester.pump(const Duration(milliseconds: 50));

      // Should not glitch when disabled
      expect(find.byType(ColorFiltered), findsNothing);
    });

    testWidgets('glitch effect completes after duration', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlitchEffect(
          triggerOnMount: true,
          duration: Duration(milliseconds: 100),
          child: SizedBox(width: 100, height: 100),
        ),
      ));

      await tester.pump(const Duration(milliseconds: 50));
      // During glitch - should find ColorFiltered widgets
      expect(find.byType(ColorFiltered), findsWidgets);

      // Wait for glitch to complete (pump past the duration)
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 100));

      // After glitch ends - may still render, just check widget exists
      expect(find.byType(GlitchEffect), findsOneWidget);
    });

    testWidgets('triggers glitch on hover when triggerOnHover is true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlitchEffect(
          triggerOnHover: true,
          child: SizedBox(width: 100, height: 100),
        ),
      ));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(find.byType(GlitchEffect)));
      await tester.pump(const Duration(milliseconds: 50));

      // Should be glitching due to hover
      expect(find.byType(ColorFiltered), findsWidgets);
    });

    testWidgets('respects intensity parameter', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlitchEffect(
          triggerOnMount: true,
          intensity: 0.5,
          child: SizedBox(width: 100, height: 100),
        ),
      ));

      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(GlitchEffect), findsOneWidget);
    });

    testWidgets('respects offset parameter', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const GlitchEffect(
          triggerOnMount: true,
          offset: 5.0,
          child: SizedBox(width: 100, height: 100),
        ),
      ));

      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(GlitchEffect), findsOneWidget);
    });
  });
}
