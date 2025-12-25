import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftySnackbar', () {
    testWidgets('shows snackbar with message', (tester) async {
      await tester.pumpWidget(wrapWithScaffold(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => FiftySnackbar.show(
              context,
              message: 'Test message',
            ),
            child: const Text('Show'),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('shows info variant with info icon', (tester) async {
      await tester.pumpWidget(wrapWithScaffold(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => FiftySnackbar.show(
              context,
              message: 'Info message',
              variant: FiftySnackbarVariant.info,
            ),
            child: const Text('Show'),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });

    testWidgets('shows success variant with check icon', (tester) async {
      await tester.pumpWidget(wrapWithScaffold(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => FiftySnackbar.show(
              context,
              message: 'Success message',
              variant: FiftySnackbarVariant.success,
            ),
            child: const Text('Show'),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('shows warning variant with warning icon', (tester) async {
      await tester.pumpWidget(wrapWithScaffold(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => FiftySnackbar.show(
              context,
              message: 'Warning message',
              variant: FiftySnackbarVariant.warning,
            ),
            child: const Text('Show'),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
    });

    testWidgets('shows error variant with error icon', (tester) async {
      await tester.pumpWidget(wrapWithScaffold(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => FiftySnackbar.show(
              context,
              message: 'Error message',
              variant: FiftySnackbarVariant.error,
            ),
            child: const Text('Show'),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('shows action button when provided', (tester) async {
      var actionPressed = false;

      await tester.pumpWidget(wrapWithScaffold(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => FiftySnackbar.show(
              context,
              message: 'Message',
              actionLabel: 'Undo',
              onAction: () => actionPressed = true,
            ),
            child: const Text('Show'),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('UNDO'), findsOneWidget);

      await tester.tap(find.text('UNDO'));
      expect(actionPressed, isTrue);
    });
  });
}
