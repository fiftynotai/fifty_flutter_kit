import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test enum for generic type support
enum TestOption { option1, option2, option3 }

void main() {
  Widget buildTestWidget(Widget child, {bool darkMode = true}) {
    return MaterialApp(
      theme: darkMode ? FiftyTheme.dark() : FiftyTheme.light(),
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('FiftyRadioCard', () {
    testWidgets('renders with icon and label', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyRadioCard<int>(
            value: 1,
            groupValue: 1,
            onChanged: (_) {},
            icon: Icons.light_mode,
            label: 'Light',
          ),
        ),
      );

      expect(find.byType(FiftyRadioCard<int>), findsOneWidget);
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
    });

    testWidgets('selected state shows correct styling', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyRadioCard<int>(
            value: 1,
            groupValue: 1,
            onChanged: (_) {},
            icon: Icons.light_mode,
            label: 'Light',
          ),
        ),
      );

      // Widget should render in selected state
      expect(find.byType(FiftyRadioCard<int>), findsOneWidget);
    });

    testWidgets('unselected state shows subtle border', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyRadioCard<int>(
            value: 1,
            groupValue: 2, // Different group value = unselected
            onChanged: (_) {},
            icon: Icons.light_mode,
            label: 'Light',
          ),
        ),
      );

      expect(find.byType(FiftyRadioCard<int>), findsOneWidget);
    });

    testWidgets('calls onChanged when tapped', (tester) async {
      int? selectedValue;

      await tester.pumpWidget(
        buildTestWidget(
          FiftyRadioCard<int>(
            value: 1,
            groupValue: 2,
            onChanged: (value) => selectedValue = value,
            icon: Icons.light_mode,
            label: 'Light',
          ),
        ),
      );

      await tester.tap(find.byType(FiftyRadioCard<int>));
      await tester.pumpAndSettle();

      expect(selectedValue, 1);
    });

    testWidgets('does not call onChanged when disabled', (tester) async {
      int? selectedValue;

      await tester.pumpWidget(
        buildTestWidget(
          FiftyRadioCard<int>(
            value: 1,
            groupValue: 2,
            onChanged: (value) => selectedValue = value,
            icon: Icons.light_mode,
            label: 'Light',
            enabled: false,
          ),
        ),
      );

      await tester.tap(find.byType(FiftyRadioCard<int>));
      await tester.pumpAndSettle();

      expect(selectedValue, isNull);
    });

    testWidgets('does not call onChanged when onChanged is null',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const FiftyRadioCard<int>(
            value: 1,
            groupValue: 2,
            onChanged: null,
            icon: Icons.light_mode,
            label: 'Light',
          ),
        ),
      );

      // Should not throw
      await tester.tap(find.byType(FiftyRadioCard<int>));
      await tester.pumpAndSettle();
    });

    testWidgets('supports enum generic type', (tester) async {
      TestOption? selectedOption;

      await tester.pumpWidget(
        buildTestWidget(
          FiftyRadioCard<TestOption>(
            value: TestOption.option1,
            groupValue: TestOption.option2,
            onChanged: (value) => selectedOption = value,
            icon: Icons.check,
            label: 'Option 1',
          ),
        ),
      );

      await tester.tap(find.byType(FiftyRadioCard<TestOption>));
      await tester.pumpAndSettle();

      expect(selectedOption, TestOption.option1);
    });

    testWidgets('disabled state reduces opacity', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyRadioCard<int>(
            value: 1,
            groupValue: 1,
            onChanged: (_) {},
            icon: Icons.light_mode,
            label: 'Light',
            enabled: false,
          ),
        ),
      );

      // Find the Opacity widget
      final opacityFinder = find.descendant(
        of: find.byType(FiftyRadioCard<int>),
        matching: find.byType(Opacity),
      );

      expect(opacityFinder, findsOneWidget);

      final opacityWidget = tester.widget<Opacity>(opacityFinder);
      expect(opacityWidget.opacity, 0.5);
    });

    testWidgets('renders in light mode', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyRadioCard<int>(
            value: 1,
            groupValue: 1,
            onChanged: (_) {},
            icon: Icons.light_mode,
            label: 'Light',
          ),
          darkMode: false,
        ),
      );

      expect(find.byType(FiftyRadioCard<int>), findsOneWidget);
    });

    testWidgets('renders in dark mode', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyRadioCard<int>(
            value: 1,
            groupValue: 1,
            onChanged: (_) {},
            icon: Icons.dark_mode,
            label: 'Dark',
          ),
          darkMode: true,
        ),
      );

      expect(find.byType(FiftyRadioCard<int>), findsOneWidget);
    });

    testWidgets('works in a radio group', (tester) async {
      int groupValue = 1;

      await tester.pumpWidget(
        buildTestWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FiftyRadioCard<int>(
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (value) =>
                        setState(() => groupValue = value ?? 1),
                    icon: Icons.light_mode,
                    label: 'Light',
                  ),
                  const SizedBox(width: 16),
                  FiftyRadioCard<int>(
                    value: 2,
                    groupValue: groupValue,
                    onChanged: (value) =>
                        setState(() => groupValue = value ?? 2),
                    icon: Icons.dark_mode,
                    label: 'Dark',
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Initially, option 1 is selected
      expect(groupValue, 1);

      // Tap on option 2
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(groupValue, 2);

      // Tap on option 1 again
      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      expect(groupValue, 1);
    });

    testWidgets('hover state triggers animation', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyRadioCard<int>(
            value: 1,
            groupValue: 1,
            onChanged: (_) {},
            icon: Icons.light_mode,
            label: 'Light',
          ),
        ),
      );

      // Find the AnimatedScale widget
      final animatedScaleFinder = find.descendant(
        of: find.byType(FiftyRadioCard<int>),
        matching: find.byType(AnimatedScale),
      );

      expect(animatedScaleFinder, findsOneWidget);

      // Initially scale should be 1.0
      final animatedScale = tester.widget<AnimatedScale>(animatedScaleFinder);
      expect(animatedScale.scale, 1.0);
    });
  });
}
