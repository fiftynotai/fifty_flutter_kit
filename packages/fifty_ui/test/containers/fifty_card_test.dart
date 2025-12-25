import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyCard', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCard(
          child: Text('Card Content'),
        ),
      ));

      expect(find.text('Card Content'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(wrapWithTheme(
        FiftyCard(
          onTap: () => tapped = true,
          child: const Text('Tappable Card'),
        ),
      ));

      await tester.tap(find.byType(FiftyCard));
      expect(tapped, isTrue);
    });

    testWidgets('applies custom padding', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCard(
          padding: EdgeInsets.all(32),
          child: Text('Content'),
        ),
      ));

      expect(find.byType(FiftyCard), findsOneWidget);
    });

    testWidgets('applies custom margin', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCard(
          margin: EdgeInsets.all(16),
          child: Text('Content'),
        ),
      ));

      expect(find.byType(FiftyCard), findsOneWidget);
    });

    testWidgets('shows selected state', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCard(
          selected: true,
          child: Text('Selected Card'),
        ),
      ));

      expect(find.byType(FiftyCard), findsOneWidget);
    });

    testWidgets('applies custom background color', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCard(
          backgroundColor: Colors.blue,
          child: Text('Content'),
        ),
      ));

      expect(find.byType(FiftyCard), findsOneWidget);
    });
  });
}
