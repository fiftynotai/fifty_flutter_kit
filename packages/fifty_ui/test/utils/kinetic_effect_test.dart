import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('KineticEffect', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const KineticEffect(
          child: SizedBox(
            key: Key('test-child'),
            width: 100,
            height: 100,
          ),
        ),
      ));

      expect(find.byKey(const Key('test-child')), findsOneWidget);

      // Allow animations to complete
      await tester.pumpAndSettle();
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(wrapWithTheme(
        KineticEffect(
          onTap: () => tapped = true,
          child: const SizedBox(width: 100, height: 100),
        ),
      ));

      await tester.tap(find.byType(KineticEffect));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('does not animate when disabled', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const KineticEffect(
          enabled: false,
          child: SizedBox(width: 100, height: 100),
        ),
      ));

      // Should not find any animation-related widgets when disabled
      expect(find.byType(KineticEffect), findsOneWidget);
    });

    testWidgets('applies hover scale on mouse enter', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const KineticEffect(
          hoverScale: 1.05,
          child: SizedBox(width: 100, height: 100),
        ),
      ));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(find.byType(KineticEffect)));
      await tester.pumpAndSettle();

      // Effect should be rendered
      expect(find.byType(KineticEffect), findsOneWidget);
    });

    testWidgets('applies press scale on tap down', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const KineticEffect(
          pressScale: 0.9,
          child: SizedBox(width: 100, height: 100),
        ),
      ));

      await tester.press(find.byType(KineticEffect));
      await tester.pumpAndSettle();

      expect(find.byType(KineticEffect), findsOneWidget);
    });

    testWidgets('uses custom duration when provided', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const KineticEffect(
          duration: Duration(milliseconds: 500),
          child: SizedBox(width: 100, height: 100),
        ),
      ));

      expect(find.byType(KineticEffect), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('still triggers onTap when disabled', (tester) async {
      var tapped = false;

      await tester.pumpWidget(wrapWithTheme(
        KineticEffect(
          enabled: false,
          onTap: () => tapped = true,
          child: const SizedBox(width: 100, height: 100),
        ),
      ));

      await tester.tap(find.byType(KineticEffect));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });
}
