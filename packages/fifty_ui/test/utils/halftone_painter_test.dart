import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('HalftonePainter', () {
    test('creates painter with default values', () {
      const painter = HalftonePainter();

      expect(painter.color, FiftyColors.cream);
      expect(painter.dotRadius, 1.0);
      expect(painter.spacing, 8.0);
      expect(painter.opacity, 0.05);
    });

    test('creates painter with custom values', () {
      const painter = HalftonePainter(
        color: Colors.red,
        dotRadius: 2.0,
        spacing: 16.0,
        opacity: 0.1,
      );

      expect(painter.color, Colors.red);
      expect(painter.dotRadius, 2.0);
      expect(painter.spacing, 16.0);
      expect(painter.opacity, 0.1);
    });

    test('shouldRepaint returns true when properties differ', () {
      const painter1 = HalftonePainter(color: Colors.white);
      const painter2 = HalftonePainter(color: Colors.red);

      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('shouldRepaint returns false when properties are same', () {
      const painter1 = HalftonePainter();
      const painter2 = HalftonePainter();

      expect(painter1.shouldRepaint(painter2), isFalse);
    });

    test('shouldRepaint returns true when dotRadius differs', () {
      const painter1 = HalftonePainter(dotRadius: 1.0);
      const painter2 = HalftonePainter(dotRadius: 2.0);

      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('shouldRepaint returns true when spacing differs', () {
      const painter1 = HalftonePainter(spacing: 8.0);
      const painter2 = HalftonePainter(spacing: 16.0);

      expect(painter1.shouldRepaint(painter2), isTrue);
    });

    test('shouldRepaint returns true when opacity differs', () {
      const painter1 = HalftonePainter(opacity: 0.05);
      const painter2 = HalftonePainter(opacity: 0.1);

      expect(painter1.shouldRepaint(painter2), isTrue);
    });
  });

  group('HalftoneOverlay', () {
    testWidgets('renders CustomPaint with HalftonePainter', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(
          width: 100,
          height: 100,
          child: HalftoneOverlay(),
        ),
      ));

      // HalftoneOverlay should render
      expect(find.byType(HalftoneOverlay), findsOneWidget);
      // CustomPaint is used internally
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('passes properties to HalftonePainter', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(
          width: 100,
          height: 100,
          child: HalftoneOverlay(
            color: Colors.blue,
            dotRadius: 2.0,
            spacing: 12.0,
            opacity: 0.08,
          ),
        ),
      ));

      // Find the CustomPaint inside HalftoneOverlay
      final halftoneOverlay = find.byType(HalftoneOverlay);
      expect(halftoneOverlay, findsOneWidget);

      final customPaints = find.descendant(
        of: halftoneOverlay,
        matching: find.byType(CustomPaint),
      );
      expect(customPaints, findsOneWidget);

      final customPaint = tester.widget<CustomPaint>(customPaints);
      final painter = customPaint.painter as HalftonePainter;

      expect(painter.color, Colors.blue);
      expect(painter.dotRadius, 2.0);
      expect(painter.spacing, 12.0);
      expect(painter.opacity, 0.08);
    });

    testWidgets('renders with default properties', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(
          width: 100,
          height: 100,
          child: HalftoneOverlay(),
        ),
      ));

      // Find the CustomPaint inside HalftoneOverlay
      final halftoneOverlay = find.byType(HalftoneOverlay);
      expect(halftoneOverlay, findsOneWidget);

      final customPaints = find.descendant(
        of: halftoneOverlay,
        matching: find.byType(CustomPaint),
      );
      expect(customPaints, findsOneWidget);

      final customPaint = tester.widget<CustomPaint>(customPaints);
      final painter = customPaint.painter as HalftonePainter;

      expect(painter.color, FiftyColors.cream);
      expect(painter.dotRadius, 1.0);
      expect(painter.spacing, 8.0);
      expect(painter.opacity, 0.05);
    });
  });
}
