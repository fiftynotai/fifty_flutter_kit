import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sneaker_drops/features/sneaker_marketplace/views/widgets/product/price_trend.dart';

void main() {
  group('PriceTrend', () {
    testWidgets('displays market price with dollar sign', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTrend(
              price: 170.0,
              marketPrice: 250.0,
            ),
          ),
        ),
      );

      // The widget formats price as currency (e.g., "$250")
      expect(find.textContaining('\$250'), findsOneWidget);
    });

    testWidgets('shows up arrow for positive trend (market > retail)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTrend(
              price: 170.0,
              marketPrice: 250.0, // Market is higher than retail
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
    });

    testWidgets('shows down arrow for negative trend (market < retail)',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTrend(
              price: 250.0,
              marketPrice: 170.0, // Market is lower than retail
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_downward_rounded), findsOneWidget);
    });

    testWidgets('hides trend indicator when showTrend is false',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTrend(
              price: 170.0,
              marketPrice: 250.0,
              showTrend: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_upward_rounded), findsNothing);
      expect(find.byIcon(Icons.arrow_downward_rounded), findsNothing);
    });

    testWidgets('shows market label when enabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTrend(
              price: 170.0,
              marketPrice: 250.0,
              showMarketLabel: true,
            ),
          ),
        ),
      );

      expect(find.text('Market Price'), findsOneWidget);
    });

    testWidgets('shows retail price comparison when prices differ',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTrend(
              price: 170.0,
              marketPrice: 250.0,
            ),
          ),
        ),
      );

      expect(find.textContaining('Retail:'), findsOneWidget);
    });

    testWidgets('respects size parameter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTrend(
              price: 170.0,
              marketPrice: 250.0,
              size: PriceTrendSize.large,
            ),
          ),
        ),
      );

      // Widget should build without errors with large size
      expect(find.textContaining('\$250'), findsOneWidget);
    });
  });

  group('PriceTrendCompact', () {
    testWidgets('displays price with dollar sign', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTrendCompact(
              price: 170.0,
              marketPrice: 650.0,
            ),
          ),
        ),
      );

      expect(find.textContaining('\$650'), findsOneWidget);
    });

    testWidgets('shows up arrow for positive trend', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTrendCompact(
              price: 170.0,
              marketPrice: 650.0,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_upward_rounded), findsOneWidget);
    });

    testWidgets('shows down arrow for negative trend', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTrendCompact(
              price: 650.0,
              marketPrice: 170.0,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_downward_rounded), findsOneWidget);
    });

    testWidgets('displays percentage change', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PriceTrendCompact(
              price: 100.0,
              marketPrice: 150.0, // 50% increase
            ),
          ),
        ),
      );

      expect(find.textContaining('50%'), findsOneWidget);
    });
  });
}
