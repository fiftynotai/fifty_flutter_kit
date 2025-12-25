import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyLoadingIndicator', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(),
      ));

      expect(find.byType(FiftyLoadingIndicator), findsOneWidget);
    });

    testWidgets('renders with custom size', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(size: 48),
      ));

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(FiftyLoadingIndicator),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, 48);
      expect(sizedBox.height, 48);
    });

    testWidgets('renders with custom stroke width', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(strokeWidth: 4),
      ));

      expect(find.byType(FiftyLoadingIndicator), findsOneWidget);
    });

    testWidgets('renders with custom color', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(color: Colors.blue),
      ));

      expect(find.byType(FiftyLoadingIndicator), findsOneWidget);
    });

    testWidgets('animates', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyLoadingIndicator(),
      ));

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
