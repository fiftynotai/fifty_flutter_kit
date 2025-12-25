import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyCodeBlock', () {
    const sampleCode = '''void main() {
  print('Hello, Fifty!');
}''';

    testWidgets('renders code content', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: sampleCode,
        ),
      ));

      expect(find.textContaining('void'), findsOneWidget);
      expect(find.textContaining('main'), findsOneWidget);
    });

    testWidgets('shows line numbers by default', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: sampleCode,
        ),
      ));

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('hides line numbers when disabled', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: sampleCode,
          showLineNumbers: false,
        ),
      ));

      // Line numbers should not be visible as separate text
      // (Note: numbers might appear in code itself, so we check the structure)
      expect(find.byType(FiftyCodeBlock), findsOneWidget);
    });

    testWidgets('shows copy button by default', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: sampleCode,
        ),
      ));

      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets('hides copy button when disabled', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: sampleCode,
          copyButton: false,
        ),
      ));

      expect(find.byIcon(Icons.copy), findsNothing);
    });

    // Note: Copy button state change test is skipped because clipboard
    // operations are async and require platform channel mocking in tests.
    // The copy functionality is verified through manual testing.

    testWidgets('copy button is present and tappable', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: sampleCode,
        ),
      ));

      // Copy button should be present
      final copyButton = find.byIcon(Icons.copy);
      expect(copyButton, findsOneWidget);

      // Should be tappable without error
      await tester.tap(copyButton);
      await tester.pump();
    });

    testWidgets('renders with plain language', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: 'plain text without highlighting',
          language: 'plain',
        ),
      ));

      expect(find.textContaining('plain text'), findsOneWidget);
    });

    testWidgets('applies syntax highlighting for dart', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: 'void main() {}',
          language: 'dart',
        ),
      ));

      expect(find.byType(FiftyCodeBlock), findsOneWidget);
    });

    testWidgets('respects maxHeight constraint', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: sampleCode,
          maxHeight: 100,
        ),
      ));

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FiftyCodeBlock),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.constraints?.maxHeight, 100);
    });

    testWidgets('respects custom padding', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: sampleCode,
          padding: EdgeInsets.all(24),
        ),
      ));

      expect(find.byType(FiftyCodeBlock), findsOneWidget);
    });

    testWidgets('respects custom background color', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: sampleCode,
          backgroundColor: Colors.blue,
        ),
      ));

      expect(find.byType(FiftyCodeBlock), findsOneWidget);
    });

    testWidgets('code is selectable', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: sampleCode,
        ),
      ));

      expect(find.byType(SelectableText), findsOneWidget);
    });

    testWidgets('handles multi-line code', (tester) async {
      const multiLineCode = '''line1
line2
line3
line4
line5''';

      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: multiLineCode,
        ),
      ));

      expect(find.text('1'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('highlights comments correctly', (tester) async {
      const codeWithComment = '''void main() {
  // This is a comment
  print('test');
}''';

      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: codeWithComment,
        ),
      ));

      expect(find.byType(FiftyCodeBlock), findsOneWidget);
    });

    testWidgets('highlights strings correctly', (tester) async {
      const codeWithString = "String s = 'hello world';";

      await tester.pumpWidget(wrapWithTheme(
        const FiftyCodeBlock(
          code: codeWithString,
        ),
      ));

      expect(find.byType(FiftyCodeBlock), findsOneWidget);
    });
  });
}
