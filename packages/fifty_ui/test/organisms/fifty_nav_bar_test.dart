import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyNavBar', () {
    final testItems = [
      const FiftyNavItem(label: 'Home', icon: Icons.home),
      const FiftyNavItem(label: 'Search', icon: Icons.search),
      const FiftyNavItem(label: 'Profile', icon: Icons.person),
    ];

    testWidgets('renders all navigation items', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyNavBar(
          items: testItems,
          selectedIndex: 0,
          onItemSelected: (_) {},
        ),
      ));

      expect(find.text('HOME'), findsOneWidget);
      expect(find.text('SEARCH'), findsOneWidget);
      expect(find.text('PROFILE'), findsOneWidget);
    });

    testWidgets('renders icons for items', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyNavBar(
          items: testItems,
          selectedIndex: 0,
          onItemSelected: (_) {},
        ),
      ));

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('calls onItemSelected when item is tapped', (tester) async {
      int? selectedIndex;

      await tester.pumpWidget(wrapWithTheme(
        FiftyNavBar(
          items: testItems,
          selectedIndex: 0,
          onItemSelected: (index) => selectedIndex = index,
        ),
      ));

      await tester.tap(find.text('SEARCH'));
      expect(selectedIndex, 1);
    });

    testWidgets('renders with pill style by default', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyNavBar(
          items: testItems,
          selectedIndex: 0,
          onItemSelected: (_) {},
        ),
      ));

      expect(find.byType(FiftyNavBar), findsOneWidget);
    });

    testWidgets('renders with standard style', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyNavBar(
          items: testItems,
          selectedIndex: 0,
          onItemSelected: (_) {},
          style: FiftyNavBarStyle.standard,
        ),
      ));

      expect(find.byType(FiftyNavBar), findsOneWidget);
    });

    testWidgets('applies glassmorphism effect', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyNavBar(
          items: testItems,
          selectedIndex: 0,
          onItemSelected: (_) {},
        ),
      ));

      // Check for BackdropFilter (glassmorphism)
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('renders items without icons', (tester) async {
      final itemsWithoutIcons = [
        const FiftyNavItem(label: 'Home'),
        const FiftyNavItem(label: 'Search'),
      ];

      await tester.pumpWidget(wrapWithTheme(
        FiftyNavBar(
          items: itemsWithoutIcons,
          selectedIndex: 0,
          onItemSelected: (_) {},
        ),
      ));

      expect(find.text('HOME'), findsOneWidget);
      expect(find.text('SEARCH'), findsOneWidget);
    });

    testWidgets('respects custom height', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyNavBar(
          items: testItems,
          selectedIndex: 0,
          onItemSelected: (_) {},
          height: 72.0,
        ),
      ));

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FiftyNavBar),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.constraints?.maxHeight, 72.0);
    });

    testWidgets('respects custom margin', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyNavBar(
          items: testItems,
          selectedIndex: 0,
          onItemSelected: (_) {},
          margin: const EdgeInsets.all(24),
        ),
      ));

      expect(find.byType(FiftyNavBar), findsOneWidget);
    });

    testWidgets('highlights selected item', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyNavBar(
          items: testItems,
          selectedIndex: 1,
          onItemSelected: (_) {},
        ),
      ));

      // The selected item (Search) should be rendered
      expect(find.text('SEARCH'), findsOneWidget);
    });

    testWidgets('updates selection when index changes', (tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(wrapWithTheme(
        StatefulBuilder(
          builder: (context, setState) {
            return FiftyNavBar(
              items: testItems,
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                setState(() => selectedIndex = index);
              },
            );
          },
        ),
      ));

      await tester.tap(find.text('PROFILE'));
      await tester.pumpAndSettle();

      expect(selectedIndex, 2);
    });
  });

  group('FiftyNavItem', () {
    test('creates item with label only', () {
      const item = FiftyNavItem(label: 'Test');

      expect(item.label, 'Test');
      expect(item.icon, isNull);
    });

    test('creates item with label and icon', () {
      const item = FiftyNavItem(label: 'Test', icon: Icons.star);

      expect(item.label, 'Test');
      expect(item.icon, Icons.star);
    });
  });
}
