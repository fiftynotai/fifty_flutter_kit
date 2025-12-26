import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: FiftyTheme.dark(),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            child: child,
          ),
        ),
      ),
    );
  }

  group('FiftySlider', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftySlider(
            value: 0.5,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FiftySlider), findsOneWidget);
    });

    testWidgets('displays label when provided', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftySlider(
            value: 0.5,
            onChanged: (_) {},
            label: 'Volume',
          ),
        ),
      );

      expect(find.text('VOLUME'), findsOneWidget);
    });

    testWidgets('calls onChanged when tapped', (tester) async {
      double? newValue;

      await tester.pumpWidget(
        buildTestWidget(
          FiftySlider(
            value: 0.0,
            onChanged: (value) => newValue = value,
          ),
        ),
      );

      // Tap in the middle of the slider
      await tester.tapAt(tester.getCenter(find.byType(FiftySlider)));
      await tester.pumpAndSettle();

      expect(newValue, isNotNull);
      expect(newValue, greaterThan(0.0));
    });

    testWidgets('does not call onChanged when disabled', (tester) async {
      double? newValue;

      await tester.pumpWidget(
        buildTestWidget(
          FiftySlider(
            value: 0.5,
            onChanged: (value) => newValue = value,
            enabled: false,
          ),
        ),
      );

      await tester.tapAt(tester.getCenter(find.byType(FiftySlider)));
      await tester.pumpAndSettle();

      expect(newValue, isNull);
    });

    testWidgets('respects min and max values', (tester) async {
      double? newValue;

      await tester.pumpWidget(
        buildTestWidget(
          FiftySlider(
            value: 50,
            min: 0,
            max: 100,
            onChanged: (value) => newValue = value,
          ),
        ),
      );

      // Tap at the end of the slider
      final sliderRect = tester.getRect(find.byType(FiftySlider));
      await tester.tapAt(Offset(sliderRect.right - 10, sliderRect.center.dy));
      await tester.pumpAndSettle();

      expect(newValue, isNotNull);
      expect(newValue, lessThanOrEqualTo(100));
      expect(newValue, greaterThanOrEqualTo(0));
    });

    testWidgets('applies divisions when specified', (tester) async {
      double? newValue;

      await tester.pumpWidget(
        buildTestWidget(
          FiftySlider(
            value: 0,
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: (value) => newValue = value,
          ),
        ),
      );

      // Tap in the middle
      await tester.tapAt(tester.getCenter(find.byType(FiftySlider)));
      await tester.pumpAndSettle();

      expect(newValue, isNotNull);
      // Value should be an integer due to divisions
      expect(newValue! % 1, equals(0));
    });

    testWidgets('shows value label when showLabel is true', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftySlider(
            value: 50,
            min: 0,
            max: 100,
            onChanged: (_) {},
            showLabel: true,
          ),
        ),
      );

      expect(find.byType(FiftySlider), findsOneWidget);
      // The label is shown on hover/drag, so we just verify it renders
    });

    testWidgets('uses custom labelBuilder when provided', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftySlider(
            value: 0.5,
            onChanged: (_) {},
            showLabel: true,
            labelBuilder: (value) => '${(value * 100).toInt()}%',
          ),
        ),
      );

      expect(find.byType(FiftySlider), findsOneWidget);
    });

    testWidgets('handles drag gesture', (tester) async {
      double currentValue = 0.0;

      await tester.pumpWidget(
        buildTestWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return FiftySlider(
                value: currentValue,
                onChanged: (value) => setState(() => currentValue = value),
              );
            },
          ),
        ),
      );

      final slider = find.byType(FiftySlider);
      final startPosition = tester.getTopLeft(slider);
      final endPosition = tester.getTopRight(slider);

      await tester.dragFrom(
        Offset(startPosition.dx + 10, startPosition.dy + 10),
        Offset(endPosition.dx - startPosition.dx - 20, 0),
      );
      await tester.pumpAndSettle();

      expect(currentValue, greaterThan(0.0));
    });
  });
}
