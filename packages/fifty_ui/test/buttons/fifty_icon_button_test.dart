import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyIconButton', () {
    testWidgets('renders with icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyIconButton(
          icon: Icons.settings,
          tooltip: 'Settings',
          onPressed: () {},
        ),
      ));

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var pressed = false;

      await tester.pumpWidget(wrapWithTheme(
        FiftyIconButton(
          icon: Icons.settings,
          tooltip: 'Settings',
          onPressed: () => pressed = true,
        ),
      ));

      await tester.tap(find.byType(FiftyIconButton));
      expect(pressed, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      var pressed = false;

      await tester.pumpWidget(wrapWithTheme(
        FiftyIconButton(
          icon: Icons.settings,
          tooltip: 'Settings',
          onPressed: () => pressed = true,
          disabled: true,
        ),
      ));

      await tester.tap(find.byType(FiftyIconButton));
      expect(pressed, isFalse);
    });

    testWidgets('shows tooltip on long press', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyIconButton(
          icon: Icons.settings,
          tooltip: 'Settings',
          onPressed: () {},
        ),
      ));

      await tester.longPress(find.byType(FiftyIconButton));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders all variants', (tester) async {
      for (final variant in FiftyIconButtonVariant.values) {
        await tester.pumpWidget(wrapWithTheme(
          FiftyIconButton(
            icon: Icons.settings,
            tooltip: 'Settings',
            onPressed: () {},
            variant: variant,
          ),
        ));

        expect(find.byType(FiftyIconButton), findsOneWidget);
      }
    });

    testWidgets('renders all sizes', (tester) async {
      for (final size in FiftyIconButtonSize.values) {
        await tester.pumpWidget(wrapWithTheme(
          FiftyIconButton(
            icon: Icons.settings,
            tooltip: 'Settings',
            onPressed: () {},
            size: size,
          ),
        ));

        expect(find.byType(FiftyIconButton), findsOneWidget);
      }
    });
  });
}
