import 'package:fifty_forms/fifty_forms.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyFormProgress contentBuilder', () {
    Widget buildTestWidget({
      int currentStep = 1,
      int totalSteps = 3,
      List<String>? stepLabels,
      FormProgressContentBuilder? contentBuilder,
    }) {
      return MaterialApp(
        theme: FiftyTheme.dark(),
        home: Scaffold(
          body: FiftyFormProgress(
            currentStep: currentStep,
            totalSteps: totalSteps,
            stepLabels: stepLabels,
            contentBuilder: contentBuilder,
          ),
        ),
      );
    }

    testWidgets('renders builder widget when contentBuilder provided',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        contentBuilder: (currentStep, totalSteps, labels) {
          return Text('Custom: $currentStep of $totalSteps');
        },
      ));
      await tester.pumpAndSettle();

      expect(find.text('Custom: 1 of 3'), findsOneWidget);
    });

    testWidgets('renders default step circles when contentBuilder is null',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Default rendering shows step numbers
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('builder receives correct currentStep value', (tester) async {
      int? receivedCurrentStep;

      await tester.pumpWidget(buildTestWidget(
        currentStep: 2,
        contentBuilder: (currentStep, totalSteps, labels) {
          receivedCurrentStep = currentStep;
          return const Text('Progress');
        },
      ));
      await tester.pumpAndSettle();

      expect(receivedCurrentStep, 2);
    });

    testWidgets('builder receives correct totalSteps value', (tester) async {
      int? receivedTotalSteps;

      await tester.pumpWidget(buildTestWidget(
        totalSteps: 5,
        currentStep: 1,
        contentBuilder: (currentStep, totalSteps, labels) {
          receivedTotalSteps = totalSteps;
          return const Text('Progress');
        },
      ));
      await tester.pumpAndSettle();

      expect(receivedTotalSteps, 5);
    });

    testWidgets('builder receives stepLabels when provided', (tester) async {
      List<String>? receivedLabels;

      await tester.pumpWidget(buildTestWidget(
        stepLabels: ['Account', 'Profile', 'Review'],
        contentBuilder: (currentStep, totalSteps, labels) {
          receivedLabels = labels;
          return const Text('Progress');
        },
      ));
      await tester.pumpAndSettle();

      expect(receivedLabels, ['Account', 'Profile', 'Review']);
    });

    testWidgets('builder receives null stepLabels when not provided',
        (tester) async {
      List<String>? receivedLabels;
      var builderCalled = false;

      await tester.pumpWidget(buildTestWidget(
        contentBuilder: (currentStep, totalSteps, labels) {
          builderCalled = true;
          receivedLabels = labels;
          return const Text('Progress');
        },
      ));
      await tester.pumpAndSettle();

      expect(builderCalled, isTrue);
      expect(receivedLabels, isNull);
    });
  });
}
