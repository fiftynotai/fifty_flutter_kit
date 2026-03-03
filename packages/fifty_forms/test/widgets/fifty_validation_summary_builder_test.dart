import 'package:fifty_forms/fifty_forms.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyValidationSummary contentBuilder', () {
    late FiftyFormController controller;

    setUp(() {
      controller = FiftyFormController(
        initialValues: {'email': '', 'name': ''},
        validators: {
          'email': [const Required(message: 'Email is required')],
          'name': [const Required(message: 'Name is required')],
        },
      );
    });

    tearDown(() {
      controller.dispose();
    });

    Widget buildTestWidget({
      ValidationSummaryContentBuilder? contentBuilder,
      void Function(String)? onFieldTap,
    }) {
      return MaterialApp(
        theme: FiftyTheme.dark(),
        home: Scaffold(
          body: FiftyValidationSummary(
            controller: controller,
            contentBuilder: contentBuilder,
            onFieldTap: onFieldTap,
          ),
        ),
      );
    }

    testWidgets(
        'renders builder widget when contentBuilder provided and errors exist',
        (tester) async {
      // Trigger validation to produce errors
      controller.markAllTouched();
      await controller.validate();

      await tester.pumpWidget(buildTestWidget(
        contentBuilder: (errors, onFieldTap) {
          return Text('Custom errors: ${errors.length}');
        },
      ));
      await tester.pumpAndSettle();

      expect(find.text('Custom errors: 2'), findsOneWidget);
    });

    testWidgets('renders default FiftyCard when contentBuilder is null',
        (tester) async {
      // Trigger validation to produce errors
      controller.markAllTouched();
      await controller.validate();

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Default title should appear
      expect(
        find.text('Please fix the following errors:'),
        findsOneWidget,
      );
    });

    testWidgets(
        'does not render builder when no errors exist (even if builder provided)',
        (tester) async {
      // No validation triggered, so no errors
      var builderCalled = false;

      await tester.pumpWidget(buildTestWidget(
        contentBuilder: (errors, onFieldTap) {
          builderCalled = true;
          return const Text('Should not appear');
        },
      ));
      await tester.pumpAndSettle();

      expect(builderCalled, isFalse);
      expect(find.text('Should not appear'), findsNothing);
    });

    testWidgets('builder receives correct error map', (tester) async {
      // Trigger validation
      controller.markAllTouched();
      await controller.validate();

      Map<String, String>? receivedErrors;

      await tester.pumpWidget(buildTestWidget(
        contentBuilder: (errors, onFieldTap) {
          receivedErrors = errors;
          return const Text('Errors shown');
        },
      ));
      await tester.pumpAndSettle();

      expect(receivedErrors, isNotNull);
      expect(receivedErrors!.containsKey('email'), isTrue);
      expect(receivedErrors!['email'], 'Email is required');
      expect(receivedErrors!.containsKey('name'), isTrue);
      expect(receivedErrors!['name'], 'Name is required');
    });

    testWidgets('builder receives onFieldTap callback', (tester) async {
      // Trigger validation
      controller.markAllTouched();
      await controller.validate();

      void Function(String)? receivedOnFieldTap;
      String? tappedField;

      await tester.pumpWidget(buildTestWidget(
        onFieldTap: (fieldName) => tappedField = fieldName,
        contentBuilder: (errors, onFieldTap) {
          receivedOnFieldTap = onFieldTap;
          return const Text('Builder rendered');
        },
      ));
      await tester.pumpAndSettle();

      expect(receivedOnFieldTap, isNotNull);

      // Invoke the callback
      receivedOnFieldTap!('email');
      expect(tappedField, 'email');
    });

    testWidgets('animation wrapper preserved with contentBuilder',
        (tester) async {
      // Trigger validation
      controller.markAllTouched();
      await controller.validate();

      await tester.pumpWidget(buildTestWidget(
        contentBuilder: (errors, onFieldTap) {
          return const Text('Custom content');
        },
      ));
      await tester.pumpAndSettle();

      // AnimatedSize and AnimatedOpacity should still be in the tree
      expect(find.byType(AnimatedSize), findsOneWidget);
      expect(find.byType(AnimatedOpacity), findsOneWidget);
      expect(find.text('Custom content'), findsOneWidget);
    });
  });
}
