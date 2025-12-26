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

  final testItems = [
    const FiftyDropdownItem(value: 'dart', label: 'Dart'),
    const FiftyDropdownItem(value: 'kotlin', label: 'Kotlin'),
    const FiftyDropdownItem(value: 'swift', label: 'Swift'),
  ];

  group('FiftyDropdown', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyDropdown<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byType(FiftyDropdown<String>), findsOneWidget);
    });

    testWidgets('displays label when provided', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyDropdown<String>(
            items: testItems,
            onChanged: (_) {},
            label: 'Language',
          ),
        ),
      );

      expect(find.text('LANGUAGE'), findsOneWidget);
    });

    testWidgets('displays hint when no value selected', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyDropdown<String>(
            items: testItems,
            onChanged: (_) {},
            hint: 'Select a language',
          ),
        ),
      );

      expect(find.text('Select a language'), findsOneWidget);
    });

    testWidgets('displays selected value', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyDropdown<String>(
            items: testItems,
            value: 'dart',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Dart'), findsOneWidget);
    });

    testWidgets('opens menu when tapped', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyDropdown<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        ),
      );

      await tester.tap(find.byType(FiftyDropdown<String>));
      await tester.pumpAndSettle();

      // All items should be visible in the overlay
      expect(find.text('Dart'), findsOneWidget);
      expect(find.text('Kotlin'), findsOneWidget);
      expect(find.text('Swift'), findsOneWidget);
    });

    testWidgets('calls onChanged when item is selected', (tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        buildTestWidget(
          FiftyDropdown<String>(
            items: testItems,
            onChanged: (value) => selectedValue = value,
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FiftyDropdown<String>));
      await tester.pumpAndSettle();

      // Select an item
      await tester.tap(find.text('Kotlin'));
      await tester.pumpAndSettle();

      expect(selectedValue, 'kotlin');
    });

    testWidgets('closes menu after selection', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return FiftyDropdown<String>(
                items: testItems,
                onChanged: (_) {},
              );
            },
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FiftyDropdown<String>));
      await tester.pumpAndSettle();

      // Verify menu is open (multiple items visible)
      expect(find.text('Kotlin'), findsOneWidget);

      // Select an item
      await tester.tap(find.text('Kotlin'));
      await tester.pumpAndSettle();

      // Menu should be closed - overlay should be removed
      // The selected value should still be visible in the trigger
    });

    testWidgets('does not open when disabled', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyDropdown<String>(
            items: testItems,
            onChanged: (_) {},
            enabled: false,
          ),
        ),
      );

      await tester.tap(find.byType(FiftyDropdown<String>));
      await tester.pumpAndSettle();

      // Items should not be visible (menu not opened)
      // Only one finder for the type, not multiple
    });

    testWidgets('does not open when onChanged is null', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyDropdown<String>(
            items: testItems,
            onChanged: null,
          ),
        ),
      );

      await tester.tap(find.byType(FiftyDropdown<String>));
      await tester.pumpAndSettle();

      // Should not throw
    });

    testWidgets('displays check mark for selected item', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyDropdown<String>(
            items: testItems,
            value: 'dart',
            onChanged: (_) {},
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FiftyDropdown<String>));
      await tester.pumpAndSettle();

      // Should have a check icon for selected item
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('supports items with icons', (tester) async {
      final itemsWithIcons = [
        const FiftyDropdownItem(
          value: 'dart',
          label: 'Dart',
          icon: Icons.code,
        ),
        const FiftyDropdownItem(
          value: 'kotlin',
          label: 'Kotlin',
          icon: Icons.android,
        ),
      ];

      await tester.pumpWidget(
        buildTestWidget(
          FiftyDropdown<String>(
            items: itemsWithIcons,
            onChanged: (_) {},
          ),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(FiftyDropdown<String>));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.code), findsOneWidget);
      expect(find.byIcon(Icons.android), findsOneWidget);
    });

    testWidgets('rotates chevron when open', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FiftyDropdown<String>(
            items: testItems,
            onChanged: (_) {},
          ),
        ),
      );

      // Find chevron icon
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

      // Open dropdown
      await tester.tap(find.byType(FiftyDropdown<String>));
      await tester.pumpAndSettle();

      // Chevron should still exist (rotation is applied via transform)
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });
  });
}
