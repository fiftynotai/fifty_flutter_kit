import 'package:fifty_forms/fifty_forms.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyMultiStepForm navigationBuilder', () {
    late FiftyFormController controller;

    final steps = [
      const FormStep(title: 'Step One', fields: ['field_a']),
      const FormStep(title: 'Step Two', fields: ['field_b']),
      const FormStep(title: 'Step Three', fields: ['field_c']),
    ];

    setUp(() {
      controller = FiftyFormController(
        initialValues: {
          'field_a': 'a',
          'field_b': 'b',
          'field_c': 'c',
        },
      );
    });

    tearDown(() {
      controller.dispose();
    });

    Widget buildTestWidget({
      MultiStepNavigationBuilder? navigationBuilder,
      Future<void> Function(Map<String, dynamic> values)? onComplete,
      void Function(int)? onStepChanged,
    }) {
      return MaterialApp(
        theme: FiftyTheme.dark(),
        home: Scaffold(
          body: SizedBox(
            height: 600,
            width: 400,
            child: FiftyMultiStepForm(
              controller: controller,
              steps: steps,
              stepBuilder: (context, index, step) {
                return Text('Step content $index');
              },
              navigationBuilder: navigationBuilder,
              onComplete: onComplete,
              onStepChanged: onStepChanged,
            ),
          ),
        ),
      );
    }

    testWidgets('renders custom navigation when navigationBuilder provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        navigationBuilder: (isFirst, isLast, isSubmitting, onNext, onPrev) {
          return const Text('Custom Nav');
        },
      ));
      await tester.pumpAndSettle();

      expect(find.text('Custom Nav'), findsOneWidget);
      // Default buttons should not be present
      expect(find.text('NEXT'), findsNothing);
      expect(find.text('BACK'), findsNothing);
    });

    testWidgets(
        'renders default navigation buttons when navigationBuilder is null',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('NEXT'), findsOneWidget);
    });

    testWidgets(
        'builder receives isFirstStep=true and isLastStep=false on first step',
        (tester) async {
      bool? receivedIsFirst;
      bool? receivedIsLast;

      await tester.pumpWidget(buildTestWidget(
        navigationBuilder: (isFirst, isLast, isSubmitting, onNext, onPrev) {
          receivedIsFirst = isFirst;
          receivedIsLast = isLast;
          return const Text('Nav');
        },
      ));
      await tester.pumpAndSettle();

      expect(receivedIsFirst, isTrue);
      expect(receivedIsLast, isFalse);
    });

    testWidgets(
        'builder receives isFirstStep=false and isLastStep=true on last step',
        (tester) async {
      bool? receivedIsFirst;
      bool? receivedIsLast;

      await tester.pumpWidget(buildTestWidget(
        navigationBuilder: (isFirst, isLast, isSubmitting, onNext, onPrev) {
          receivedIsFirst = isFirst;
          receivedIsLast = isLast;
          return ElevatedButton(
            onPressed: onNext,
            child: const Text('Advance'),
          );
        },
      ));
      await tester.pumpAndSettle();

      // Advance to step 1
      await tester.tap(find.text('Advance'));
      await tester.pumpAndSettle();

      // Advance to step 2 (last step)
      await tester.tap(find.text('Advance'));
      await tester.pumpAndSettle();

      expect(receivedIsFirst, isFalse);
      expect(receivedIsLast, isTrue);
    });

    testWidgets('onNext callback advances the step', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        navigationBuilder: (isFirst, isLast, isSubmitting, onNext, onPrev) {
          return ElevatedButton(
            onPressed: onNext,
            child: const Text('Go Next'),
          );
        },
      ));
      await tester.pumpAndSettle();

      expect(find.text('Step content 0'), findsOneWidget);

      await tester.tap(find.text('Go Next'));
      await tester.pumpAndSettle();

      expect(find.text('Step content 1'), findsOneWidget);
    });

    testWidgets('onPrevious callback goes back a step', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        navigationBuilder: (isFirst, isLast, isSubmitting, onNext, onPrev) {
          return Row(
            children: [
              ElevatedButton(
                onPressed: onPrev,
                child: const Text('Go Back'),
              ),
              ElevatedButton(
                onPressed: onNext,
                child: const Text('Go Next'),
              ),
            ],
          );
        },
      ));
      await tester.pumpAndSettle();

      // Advance to step 1
      await tester.tap(find.text('Go Next'));
      await tester.pumpAndSettle();
      expect(find.text('Step content 1'), findsOneWidget);

      // Go back to step 0
      await tester.tap(find.text('Go Back'));
      await tester.pumpAndSettle();
      expect(find.text('Step content 0'), findsOneWidget);
    });

    testWidgets('builder receives isSubmitting=false when idle',
        (tester) async {
      bool? receivedIsSubmitting;

      await tester.pumpWidget(buildTestWidget(
        navigationBuilder: (isFirst, isLast, isSubmitting, onNext, onPrev) {
          receivedIsSubmitting = isSubmitting;
          return const Text('Nav');
        },
      ));
      await tester.pumpAndSettle();

      expect(receivedIsSubmitting, isFalse);
    });
  });
}
