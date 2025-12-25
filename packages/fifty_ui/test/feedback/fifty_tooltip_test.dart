import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyTooltip', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyTooltip(
          message: 'Tooltip text',
          child: Text('Hover me'),
        ),
      ));

      expect(find.text('Hover me'), findsOneWidget);
    });

    testWidgets('shows tooltip on long press', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyTooltip(
          message: 'Tooltip text',
          child: Text('Hover me'),
        ),
      ));

      await tester.longPress(find.text('Hover me'));
      await tester.pumpAndSettle();

      expect(find.text('Tooltip text'), findsOneWidget);
    });

    testWidgets('shows tooltip on hover', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyTooltip(
          message: 'Tooltip text',
          waitDuration: Duration(milliseconds: 100),
          child: Text('Hover me'),
        ),
      ));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Hover me')));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      expect(find.text('Tooltip text'), findsOneWidget);
    });

    testWidgets('respects preferBelow setting', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyTooltip(
          message: 'Tooltip text',
          preferBelow: false,
          child: Text('Hover me'),
        ),
      ));

      expect(find.byType(FiftyTooltip), findsOneWidget);
    });

    testWidgets('respects custom wait duration', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyTooltip(
          message: 'Tooltip text',
          waitDuration: Duration(seconds: 2),
          child: Text('Hover me'),
        ),
      ));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('Hover me')));
      await tester.pump(const Duration(milliseconds: 500));

      // Tooltip should not be visible yet (wait duration is 2 seconds)
      expect(find.text('Tooltip text'), findsNothing);
    });
  });
}
