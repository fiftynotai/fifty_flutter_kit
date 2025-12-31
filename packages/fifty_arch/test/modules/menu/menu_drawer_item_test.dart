import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_arch/src/modules/menu/views/menu_drawer_item.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MenuDrawerItem Widget Tests', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: FiftyTheme.dark(),
        darkTheme: FiftyTheme.dark(),
        themeMode: ThemeMode.dark,
        home: Scaffold(body: child),
      );
    }

    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MenuDrawerItem(
            label: 'Home',
            icon: Icons.home,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.byType(MenuDrawerItem), findsOneWidget);
    });

    testWidgets('displays label text in uppercase (FDL style)', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MenuDrawerItem(
            label: 'Home',
            icon: Icons.home,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      // FDL redesign converts labels to uppercase
      expect(find.text('HOME'), findsOneWidget);
    });

    testWidgets('displays icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MenuDrawerItem(
            label: 'Home',
            icon: Icons.home,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('shows selected state with gunmetal background', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MenuDrawerItem(
            label: 'Home',
            icon: Icons.home,
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      // FDL redesign: selected items have gunmetal background
      final animatedContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(MenuDrawerItem),
          matching: find.byType(AnimatedContainer),
        ).first,
      );

      final decoration = animatedContainer.decoration as BoxDecoration;
      expect(decoration.color, equals(FiftyColors.gunmetal));
    });

    testWidgets('shows transparent background when not selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MenuDrawerItem(
            label: 'Home',
            icon: Icons.home,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(MenuDrawerItem),
          matching: find.byType(AnimatedContainer),
        ).first,
      );

      final decoration = animatedContainer.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.transparent));
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        createTestWidget(
          MenuDrawerItem(
            label: 'Home',
            icon: Icons.home,
            isSelected: false,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byType(MenuDrawerItem));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('has left border accent when selected (FDL style)', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MenuDrawerItem(
            label: 'Home',
            icon: Icons.home,
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      // FDL redesign: selected items have crimsonPulse left border
      final animatedContainer = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(MenuDrawerItem),
          matching: find.byType(AnimatedContainer),
        ).first,
      );

      final decoration = animatedContainer.decoration as BoxDecoration;
      // FDL uses Border with left side, not borderRadius
      expect(decoration.border, isNotNull);
      final border = decoration.border as Border;
      expect(border.left.color, equals(FiftyColors.crimsonPulse));
    });

    testWidgets('icon and label are horizontally arranged', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MenuDrawerItem(
            label: 'Home',
            icon: Icons.home,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      final row = find.descendant(
        of: find.byType(MenuDrawerItem),
        matching: find.byType(Row),
      );

      expect(row, findsOneWidget);
    });

    testWidgets('multiple drawer items can be displayed with FDL styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          ListView(
            children: [
              MenuDrawerItem(
                label: 'Home',
                icon: Icons.home,
                isSelected: true,
                onTap: () {},
              ),
              MenuDrawerItem(
                label: 'Profile',
                icon: Icons.person,
                isSelected: false,
                onTap: () {},
              ),
              MenuDrawerItem(
                label: 'Settings',
                icon: Icons.settings,
                isSelected: false,
                onTap: () {},
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MenuDrawerItem), findsNWidgets(3));
      // FDL uses uppercase labels
      expect(find.text('HOME'), findsOneWidget);
      expect(find.text('PROFILE'), findsOneWidget);
      expect(find.text('SETTINGS'), findsOneWidget);
    });

    testWidgets('has InkWell for tap feedback', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MenuDrawerItem(
            label: 'Home',
            icon: Icons.home,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      expect(find.descendant(
        of: find.byType(MenuDrawerItem),
        matching: find.byType(InkWell),
      ), findsOneWidget);
    });

    testWidgets('uses FDL spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MenuDrawerItem(
            label: 'Test',
            icon: Icons.star,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      // Should render without errors with FDL spacing values
      expect(find.byType(MenuDrawerItem), findsOneWidget);
    });

    testWidgets('selected icon uses crimsonPulse color', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MenuDrawerItem(
            label: 'Home',
            icon: Icons.home,
            isSelected: true,
            onTap: () {},
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.home));
      expect(icon.color, equals(FiftyColors.crimsonPulse));
    });

    testWidgets('unselected icon uses hyperChrome color', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          MenuDrawerItem(
            label: 'Home',
            icon: Icons.home,
            isSelected: false,
            onTap: () {},
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.home));
      expect(icon.color, equals(FiftyColors.hyperChrome));
    });
  });
}
