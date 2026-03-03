import 'package:fifty_forms/fifty_forms.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftySubmitButton buttonBuilder', () {
    late FiftyFormController controller;

    setUp(() {
      controller = FiftyFormController(
        initialValues: {'field': 'value'},
      );
    });

    tearDown(() {
      controller.dispose();
    });

    Widget buildTestWidget({
      SubmitButtonBuilder? buttonBuilder,
      String label = 'SUBMIT',
      String? loadingText,
      bool disableWhenInvalid = true,
      VoidCallback? onPressed,
    }) {
      return MaterialApp(
        theme: FiftyTheme.dark(),
        home: Scaffold(
          body: FiftySubmitButton(
            controller: controller,
            onPressed: onPressed ?? () {},
            label: label,
            loadingText: loadingText,
            disableWhenInvalid: disableWhenInvalid,
            buttonBuilder: buttonBuilder,
          ),
        ),
      );
    }

    testWidgets('renders builder widget when buttonBuilder provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        buttonBuilder: (isLoading, isDisabled, onPressed, label) {
          return ElevatedButton(
            onPressed: onPressed,
            child: Text('Custom: $label'),
          );
        },
      ));
      await tester.pumpAndSettle();

      expect(find.text('Custom: SUBMIT'), findsOneWidget);
    });

    testWidgets('renders default FiftyButton when buttonBuilder is null',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('SUBMIT'), findsOneWidget);
    });

    testWidgets('builder receives isLoading=false when idle', (tester) async {
      bool? receivedIsLoading;

      await tester.pumpWidget(buildTestWidget(
        buttonBuilder: (isLoading, isDisabled, onPressed, label) {
          receivedIsLoading = isLoading;
          return const Text('Button');
        },
      ));
      await tester.pumpAndSettle();

      expect(receivedIsLoading, isFalse);
    });

    testWidgets(
        'builder receives isDisabled=true when form invalid and disableWhenInvalid',
        (tester) async {
      // Use controller with required validator and empty field
      controller.dispose();
      controller = FiftyFormController(
        initialValues: {'email': ''},
        validators: {
          'email': [const Required(message: 'Required')],
        },
      );

      // Trigger validation so the form knows it's invalid
      controller.markAllTouched();
      await controller.validate();

      bool? receivedIsDisabled;

      await tester.pumpWidget(buildTestWidget(
        disableWhenInvalid: true,
        buttonBuilder: (isLoading, isDisabled, onPressed, label) {
          receivedIsDisabled = isDisabled;
          return const Text('Button');
        },
      ));
      await tester.pumpAndSettle();

      expect(receivedIsDisabled, isTrue);
    });

    testWidgets('builder receives non-null onPressed when form valid',
        (tester) async {
      VoidCallback? receivedOnPressed;

      await tester.pumpWidget(buildTestWidget(
        buttonBuilder: (isLoading, isDisabled, onPressed, label) {
          receivedOnPressed = onPressed;
          return const Text('Button');
        },
      ));
      await tester.pumpAndSettle();

      expect(receivedOnPressed, isNotNull);
    });

    testWidgets('builder receives null onPressed when disabled',
        (tester) async {
      // Use controller with required validator and empty field
      controller.dispose();
      controller = FiftyFormController(
        initialValues: {'email': ''},
        validators: {
          'email': [const Required(message: 'Required')],
        },
      );

      controller.markAllTouched();
      await controller.validate();

      VoidCallback? receivedOnPressed;

      await tester.pumpWidget(buildTestWidget(
        disableWhenInvalid: true,
        buttonBuilder: (isLoading, isDisabled, onPressed, label) {
          receivedOnPressed = onPressed;
          return const Text('Button');
        },
      ));
      await tester.pumpAndSettle();

      expect(receivedOnPressed, isNull);
    });

    testWidgets('builder receives resolved label with loadingText',
        (tester) async {
      // For this test we need to verify the label resolution logic.
      // In idle state, builder should receive the normal label.
      String? receivedLabel;

      await tester.pumpWidget(buildTestWidget(
        label: 'SAVE',
        loadingText: 'SAVING...',
        buttonBuilder: (isLoading, isDisabled, onPressed, label) {
          receivedLabel = label;
          return Text('Btn: $label');
        },
      ));
      await tester.pumpAndSettle();

      // When not loading, resolvedLabel should be the normal label
      expect(receivedLabel, 'SAVE');
    });
  });
}
