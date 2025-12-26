import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      theme: FiftyTheme.dark(),
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('FiftySwitch', () {
    testWidgets('renders correctly when off', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftySwitch(
            value: false,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FiftySwitch), findsOneWidget);
    });

    testWidgets('renders correctly when on', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftySwitch(
            value: true,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FiftySwitch), findsOneWidget);
    });

    testWidgets('displays label when provided', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftySwitch(
            value: false,
            onChanged: (_) {},
            label: 'Test Label',
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
    });

    testWidgets('calls onChanged when tapped', (tester) async {
      bool? newValue;

      await tester.pumpWidget(
        buildTestWidget(
          FiftySwitch(
            value: false,
            onChanged: (value) => newValue = value,
          ),
        ),
      );

      await tester.tap(find.byType(FiftySwitch));
      await tester.pumpAndSettle();

      expect(newValue, true);
    });

    testWidgets('does not call onChanged when disabled', (tester) async {
      bool? newValue;

      await tester.pumpWidget(
        buildTestWidget(
          FiftySwitch(
            value: false,
            onChanged: (value) => newValue = value,
            enabled: false,
          ),
        ),
      );

      await tester.tap(find.byType(FiftySwitch));
      await tester.pumpAndSettle();

      expect(newValue, isNull);
    });

    testWidgets('does not call onChanged when onChanged is null',
        (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          const FiftySwitch(
            value: false,
            onChanged: null,
          ),
        ),
      );

      // Should not throw
      await tester.tap(find.byType(FiftySwitch));
      await tester.pumpAndSettle();
    });

    testWidgets('animates when toggled', (tester) async {
      bool value = false;

      await tester.pumpWidget(
        buildTestWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return FiftySwitch(
                value: value,
                onChanged: (newValue) => setState(() => value = newValue),
              );
            },
          ),
        ),
      );

      await tester.tap(find.byType(FiftySwitch));
      await tester.pump(const Duration(milliseconds: 50));

      // Animation should be in progress
      expect(value, true);

      await tester.pumpAndSettle();
    });

    testWidgets('renders all size variants', (tester) async {
      for (final size in FiftySwitchSize.values) {
        await tester.pumpWidget(
          buildTestWidget(
            FiftySwitch(
              value: false,
              onChanged: (_) {},
              size: size,
            ),
          ),
        );

        expect(find.byType(FiftySwitch), findsOneWidget);
      }
    });
  });
}
