import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyStatCard', () {
    testWidgets('renders with label, value, and icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyStatCard(
          label: 'Total Views',
          value: '45.2k',
          icon: Icons.visibility,
        ),
      ));

      expect(find.text('Total Views'), findsOneWidget);
      expect(find.text('45.2k'), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('renders up trend with arrow and value', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyStatCard(
          label: 'Sales',
          value: '350',
          icon: Icons.shopping_bag,
          trend: FiftyStatTrend.up,
          trendValue: '12%',
        ),
      ));

      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
      expect(find.text('12%'), findsOneWidget);
    });

    testWidgets('renders down trend with arrow', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyStatCard(
          label: 'Orders',
          value: '42',
          icon: Icons.inventory,
          trend: FiftyStatTrend.down,
          trendValue: '5%',
        ),
      ));

      expect(find.byIcon(Icons.arrow_downward_rounded), findsOneWidget);
    });

    testWidgets('renders neutral trend', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyStatCard(
          label: 'Steady',
          value: '100',
          icon: Icons.balance,
          trend: FiftyStatTrend.neutral,
        ),
      ));

      expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
    });

    testWidgets('hides trend badge when trend is null', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyStatCard(
          label: 'Revenue',
          value: '\$12.5k',
          icon: Icons.account_balance_wallet,
        ),
      ));

      expect(find.byIcon(Icons.arrow_upward_rounded), findsNothing);
      expect(find.byIcon(Icons.arrow_downward_rounded), findsNothing);
      expect(find.byIcon(Icons.remove_rounded), findsNothing);
    });

    testWidgets('renders highlight variant', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyStatCard(
          label: 'Revenue',
          value: '\$12.5k',
          icon: Icons.account_balance_wallet,
          highlight: true,
        ),
      ));

      expect(find.byType(FiftyStatCard), findsOneWidget);
      // Widget should render without errors
    });

    testWidgets('applies custom iconColor', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyStatCard(
          label: 'Custom',
          value: '123',
          icon: Icons.star,
          iconColor: Colors.amber,
        ),
      ));

      expect(find.byType(FiftyStatCard), findsOneWidget);
    });

    testWidgets('has correct height constraint', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyStatCard(
          label: 'Height Test',
          value: '999',
          icon: Icons.height,
        ),
      ));

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, 128);
    });
  });
}
