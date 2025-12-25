import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyTextField', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyTextField(
          label: 'Email',
        ),
      ));

      expect(find.text('EMAIL'), findsOneWidget);
    });

    testWidgets('renders with hint', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyTextField(
          hint: 'Enter your email',
        ),
      ));

      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('displays error text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyTextField(
          errorText: 'Invalid email',
        ),
      ));

      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('accepts text input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(wrapWithTheme(
        FiftyTextField(
          controller: controller,
        ),
      ));

      await tester.enterText(find.byType(TextField), 'test@email.com');
      expect(controller.text, 'test@email.com');
    });

    testWidgets('calls onChanged when text changes', (tester) async {
      String? changedValue;

      await tester.pumpWidget(wrapWithTheme(
        FiftyTextField(
          onChanged: (value) => changedValue = value,
        ),
      ));

      await tester.enterText(find.byType(TextField), 'hello');
      expect(changedValue, 'hello');
    });

    testWidgets('obscures text when obscureText is true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyTextField(
          obscureText: true,
        ),
      ));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });

    testWidgets('renders with prefix icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyTextField(
          prefix: Icon(Icons.email),
        ),
      ));

      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets('renders with suffix icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyTextField(
          suffix: Icon(Icons.visibility),
        ),
      ));

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('is disabled when enabled is false', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyTextField(
          enabled: false,
        ),
      ));

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });

    group('borderStyle parameter', () {
      testWidgets('renders with full border by default', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyTextField(),
        ));

        expect(find.byType(FiftyTextField), findsOneWidget);
      });

      testWidgets('renders with full border style', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyTextField(
            borderStyle: FiftyBorderStyle.full,
          ),
        ));

        expect(find.byType(FiftyTextField), findsOneWidget);
      });

      testWidgets('renders with bottom border style', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyTextField(
            borderStyle: FiftyBorderStyle.bottom,
          ),
        ));

        expect(find.byType(FiftyTextField), findsOneWidget);
      });

      testWidgets('renders with no border style', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyTextField(
            borderStyle: FiftyBorderStyle.none,
          ),
        ));

        expect(find.byType(FiftyTextField), findsOneWidget);
      });

      testWidgets('renders all border styles', (tester) async {
        for (final style in FiftyBorderStyle.values) {
          await tester.pumpWidget(wrapWithTheme(
            FiftyTextField(
              borderStyle: style,
            ),
          ));

          expect(find.byType(FiftyTextField), findsOneWidget);
        }
      });
    });

    group('prefixStyle parameter', () {
      testWidgets('renders with chevron prefix', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyTextField(
            prefixStyle: FiftyPrefixStyle.chevron,
          ),
        ));

        expect(find.text('>'), findsOneWidget);
      });

      testWidgets('renders with comment prefix', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyTextField(
            prefixStyle: FiftyPrefixStyle.comment,
          ),
        ));

        expect(find.text('//'), findsOneWidget);
      });

      testWidgets('renders with no prefix', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyTextField(
            prefixStyle: FiftyPrefixStyle.none,
          ),
        ));

        expect(find.text('>'), findsNothing);
        expect(find.text('//'), findsNothing);
      });

      testWidgets('renders with custom prefix', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyTextField(
            prefixStyle: FiftyPrefixStyle.custom,
            customPrefix: '\$',
          ),
        ));

        expect(find.text('\$'), findsOneWidget);
      });

      testWidgets('terminalStyle shows chevron prefix', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyTextField(
            terminalStyle: true,
          ),
        ));

        expect(find.text('>'), findsOneWidget);
      });
    });

    group('cursorStyle parameter', () {
      testWidgets('renders with line cursor by default', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          const FiftyTextField(),
        ));

        expect(find.byType(FiftyTextField), findsOneWidget);
      });

      testWidgets('renders all cursor styles', (tester) async {
        for (final style in FiftyCursorStyle.values) {
          await tester.pumpWidget(wrapWithTheme(
            FiftyTextField(
              cursorStyle: style,
            ),
          ));

          expect(find.byType(FiftyTextField), findsOneWidget);
        }
      });
    });
  });
}
