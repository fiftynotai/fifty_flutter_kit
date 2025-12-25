import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyDivider', () {
    testWidgets('renders horizontal divider', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyDivider(),
      ));

      expect(find.byType(FiftyDivider), findsOneWidget);
    });

    testWidgets('renders vertical divider', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(
          height: 100,
          child: FiftyDivider(vertical: true),
        ),
      ));

      expect(find.byType(FiftyDivider), findsOneWidget);
    });

    testWidgets('applies custom thickness', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyDivider(thickness: 2),
      ));

      expect(find.byType(FiftyDivider), findsOneWidget);
    });

    testWidgets('applies indent', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyDivider(indent: 16),
      ));

      expect(find.byType(FiftyDivider), findsOneWidget);
    });

    testWidgets('applies end indent', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyDivider(endIndent: 16),
      ));

      expect(find.byType(FiftyDivider), findsOneWidget);
    });

    testWidgets('applies custom color', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyDivider(color: Colors.red),
      ));

      expect(find.byType(FiftyDivider), findsOneWidget);
    });
  });
}
