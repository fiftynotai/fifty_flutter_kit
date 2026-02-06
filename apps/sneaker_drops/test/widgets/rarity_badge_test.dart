import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sneaker_drops/features/sneaker_marketplace/data/models/sneaker_model.dart';
import 'package:sneaker_drops/features/sneaker_marketplace/views/widgets/product/rarity_badge.dart';

void main() {
  group('RarityBadge', () {
    testWidgets('displays COMMON text for common rarity', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RarityBadge(rarity: SneakerRarity.common),
          ),
        ),
      );

      expect(find.text('COMMON'), findsOneWidget);
    });

    testWidgets('displays RARE text for rare rarity', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RarityBadge(rarity: SneakerRarity.rare),
          ),
        ),
      );

      expect(find.text('RARE'), findsOneWidget);
    });

    testWidgets('displays GRAIL text for grail rarity', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RarityBadge(rarity: SneakerRarity.grail),
          ),
        ),
      );

      expect(find.text('GRAIL'), findsOneWidget);
    });

    testWidgets('hides label when showLabel is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RarityBadge(
              rarity: SneakerRarity.rare,
              showLabel: false,
            ),
          ),
        ),
      );

      expect(find.text('RARE'), findsNothing);
    });

    testWidgets('shows star icon for rare rarity', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RarityBadge(rarity: SneakerRarity.rare),
          ),
        ),
      );

      expect(find.byIcon(Icons.star_outline_rounded), findsOneWidget);
    });

    testWidgets('shows sparkle icon for grail rarity', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RarityBadge(rarity: SneakerRarity.grail),
          ),
        ),
      );

      expect(find.byIcon(Icons.auto_awesome_rounded), findsOneWidget);
    });

    testWidgets('common rarity has no icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RarityBadge(rarity: SneakerRarity.common),
          ),
        ),
      );

      expect(find.byIcon(Icons.star_outline_rounded), findsNothing);
      expect(find.byIcon(Icons.auto_awesome_rounded), findsNothing);
    });

    testWidgets('respects size parameter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RarityBadge(
              rarity: SneakerRarity.rare,
              size: RarityBadgeSize.large,
            ),
          ),
        ),
      );

      // Widget should build without errors with large size
      expect(find.text('RARE'), findsOneWidget);
    });
  });
}
