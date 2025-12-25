import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyDialog', () {
    testWidgets('renders with title and content', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const FiftyDialog(
                title: 'Test Title',
                content: Text('Test content'),
              ),
            ),
            child: const Text('Show'),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('TEST TITLE'), findsOneWidget);
      expect(find.text('Test content'), findsOneWidget);
    });

    testWidgets('shows close button by default', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const FiftyDialog(
                title: 'Test',
                content: Text('Content'),
              ),
            ),
            child: const Text('Show'),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('closes when close button is tapped', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const FiftyDialog(
                title: 'Test',
                content: Text('Content'),
              ),
            ),
            child: const Text('Show'),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('TEST'), findsNothing);
    });

    testWidgets('hides close button when showCloseButton is false', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => const FiftyDialog(
                title: 'Test',
                content: Text('Content'),
                showCloseButton: false,
              ),
            ),
            child: const Text('Show'),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('renders action buttons', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => FiftyDialog(
                title: 'Test',
                content: const Text('Content'),
                actions: [
                  FiftyButton(
                    label: 'Cancel',
                    variant: FiftyButtonVariant.ghost,
                    onPressed: () {},
                  ),
                  FiftyButton(
                    label: 'Confirm',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            child: const Text('Show'),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('CANCEL'), findsOneWidget);
      expect(find.text('CONFIRM'), findsOneWidget);
    });

    testWidgets('showFiftyDialog works with animations', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showFiftyDialog(
              context: context,
              builder: (context) => const FiftyDialog(
                title: 'Animated',
                content: Text('With animation'),
              ),
            ),
            child: const Text('Show'),
          ),
        ),
      ));

      await tester.tap(find.text('Show'));
      await tester.pumpAndSettle();

      expect(find.text('ANIMATED'), findsOneWidget);
    });
  });
}
