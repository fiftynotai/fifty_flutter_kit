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
  });
}
