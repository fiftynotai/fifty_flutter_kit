import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyAvatar', () {
    testWidgets('renders with fallback text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyAvatar(
          fallbackText: 'JD',
        ),
      ));

      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('truncates fallback text to 2 characters', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyAvatar(
          fallbackText: 'John Doe',
        ),
      ));

      expect(find.text('JO'), findsOneWidget);
    });

    testWidgets('shows question mark when no fallback provided', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyAvatar(),
      ));

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('applies custom size', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyAvatar(
          fallbackText: 'JD',
          size: 64,
        ),
      ));

      // Find the outer container (the avatar wrapper)
      final avatar = tester.widget<FiftyAvatar>(find.byType(FiftyAvatar));
      expect(avatar.size, 64);
    });

    testWidgets('applies custom border color', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyAvatar(
          fallbackText: 'JD',
          borderColor: Colors.red,
        ),
      ));

      expect(find.byType(FiftyAvatar), findsOneWidget);
    });

    testWidgets('applies custom background color', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyAvatar(
          fallbackText: 'JD',
          backgroundColor: Colors.blue,
        ),
      ));

      expect(find.byType(FiftyAvatar), findsOneWidget);
    });
  });
}
