import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyListTile', () {
    testWidgets('renders with title and leading icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyListTile(
          title: 'Subscription',
          leadingIcon: Icons.subscriptions,
        ),
      ));

      expect(find.text('Subscription'), findsOneWidget);
      expect(find.byIcon(Icons.subscriptions), findsOneWidget);
    });

    testWidgets('renders with subtitle', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyListTile(
          title: 'Subscription',
          subtitle: 'Adobe Creative Cloud',
          leadingIcon: Icons.subscriptions,
        ),
      ));

      expect(find.text('Subscription'), findsOneWidget);
      expect(find.text('Adobe Creative Cloud'), findsOneWidget);
    });

    testWidgets('renders with custom leading widget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyListTile(
          title: 'Custom',
          leading: CircleAvatar(child: Text('A')),
        ),
      ));

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('renders with trailing text and subtext', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyListTile(
          title: 'Transaction',
          leadingIcon: Icons.payment,
          trailingText: '-\$54.00',
          trailingSubtext: 'Today',
        ),
      ));

      expect(find.text('-\$54.00'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('renders with custom trailing widget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyListTile(
          title: 'Settings',
          leadingIcon: Icons.settings,
          trailing: Icon(Icons.chevron_right),
        ),
      ));

      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('applies custom trailing text color', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyListTile(
          title: 'Deposit',
          leadingIcon: Icons.attach_money,
          trailingText: '+\$850.00',
          trailingTextColor: FiftyColors.hunterGreen,
        ),
      ));

      expect(find.text('+\$850.00'), findsOneWidget);
    });

    testWidgets('renders divider when showDivider is true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyListTile(
          title: 'Item',
          showDivider: true,
        ),
      ));

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('hides divider when showDivider is false', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyListTile(
          title: 'Item',
          showDivider: false,
        ),
      ));

      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('triggers onTap callback', (tester) async {
      var tapped = false;

      await tester.pumpWidget(wrapWithTheme(
        FiftyListTile(
          title: 'Tappable',
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.byType(FiftyListTile));
      expect(tapped, isTrue);
    });

    testWidgets('applies custom icon colors', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        FiftyListTile(
          title: 'Colored',
          leadingIcon: Icons.star,
          leadingIconColor: Colors.amber,
          leadingIconBackgroundColor: Colors.amber.withValues(alpha: 0.2),
        ),
      ));

      expect(find.byType(FiftyListTile), findsOneWidget);
    });
  });
}
