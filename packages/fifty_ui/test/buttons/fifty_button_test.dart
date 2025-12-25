import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyButton', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyButton(
          label: 'Test Button',
          onPressed: () {},
        ),
      ));

      expect(find.text('TEST BUTTON'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(wrapWithTheme(
        FiftyButton(
          label: 'Test',
          onPressed: () => pressed = true,
        ),
      ));

      await tester.tap(find.byType(FiftyButton));
      expect(pressed, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var pressed = false;

      await tester.pumpWidget(wrapWithTheme(
        FiftyButton(
          label: 'Test',
          onPressed: () => pressed = true,
          disabled: true,
        ),
      ));

      await tester.tap(find.byType(FiftyButton));
      expect(pressed, isFalse);
    });

    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyButton(
          label: 'Test',
          onPressed: () {},
          loading: true,
        ),
      ));

      // FDL Rule: "Loading: Never use a spinner. Use text sequences."
      // Loading state shows animated dots instead of CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('TEST'), findsNothing);
      // Should contain dots (animated loading indicator)
      expect(find.byType(RichText), findsOneWidget);
    });

    testWidgets('loading state uses FDL-compliant dots (no spinner)',
        (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyButton(
          label: 'Test',
          onPressed: () {},
          loading: true,
        ),
      ));

      // FDL compliance check - no spinners allowed
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders with icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyButton(
          label: 'Test',
          onPressed: () {},
          icon: Icons.add,
        ),
      ));

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('TEST'), findsOneWidget);
    });

    testWidgets('renders all variants', (tester) async {
      for (final variant in FiftyButtonVariant.values) {
        await tester.pumpWidget(wrapWithTheme(
          FiftyButton(
            label: 'Test',
            onPressed: () {},
            variant: variant,
          ),
        ));

        expect(find.byType(FiftyButton), findsOneWidget);
      }
    });

    testWidgets('renders all sizes', (tester) async {
      for (final size in FiftyButtonSize.values) {
        await tester.pumpWidget(wrapWithTheme(
          FiftyButton(
            label: 'Test',
            onPressed: () {},
            size: size,
          ),
        ));

        expect(find.byType(FiftyButton), findsOneWidget);
      }
    });

    testWidgets('expands to full width when expanded is true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 300,
          child: FiftyButton(
            label: 'Test',
            onPressed: () {},
            expanded: true,
          ),
        ),
      ));

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FiftyButton),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.constraints?.maxWidth, double.infinity);
    });
  });
}
