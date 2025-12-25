import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyChip', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyChip(label: 'Tag'),
      ));

      expect(find.text('TAG'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(wrapWithTheme(
        FiftyChip(
          label: 'Tag',
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.byType(FiftyChip));
      expect(tapped, isTrue);
    });

    testWidgets('shows delete button when onDeleted is provided', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyChip(
          label: 'Tag',
          onDeleted: () {},
        ),
      ));

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('calls onDeleted when delete is tapped', (tester) async {
      var deleted = false;

      await tester.pumpWidget(wrapWithTheme(
        FiftyChip(
          label: 'Tag',
          onDeleted: () => deleted = true,
        ),
      ));

      await tester.tap(find.byIcon(Icons.close));
      expect(deleted, isTrue);
    });

    testWidgets('shows selected state', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyChip(
          label: 'Tag',
          selected: true,
        ),
      ));

      expect(find.byType(FiftyChip), findsOneWidget);
    });

    testWidgets('renders with avatar', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyChip(
          label: 'Tag',
          avatar: Icon(Icons.person),
        ),
      ));

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('renders all variants', (tester) async {
      for (final variant in FiftyChipVariant.values) {
        await tester.pumpWidget(wrapWithTheme(
          FiftyChip(
            label: 'Tag',
            variant: variant,
          ),
        ));

        expect(find.byType(FiftyChip), findsOneWidget);
      }
    });
  });
}
