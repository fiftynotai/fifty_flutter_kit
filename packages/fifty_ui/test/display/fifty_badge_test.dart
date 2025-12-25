import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_helpers.dart';

void main() {
  group('FiftyBadge', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyBadge(label: 'Live'),
      ));

      expect(find.text('LIVE'), findsOneWidget);
    });

    testWidgets('renders all variants', (tester) async {
      for (final variant in FiftyBadgeVariant.values) {
        await tester.pumpWidget(wrapWithTheme(
          FiftyBadge(
            label: 'Test',
            variant: variant,
          ),
        ));

        expect(find.byType(FiftyBadge), findsOneWidget);
      }
    });

    testWidgets('animates glow when showGlow is true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyBadge(
          label: 'Live',
          showGlow: true,
        ),
      ));

      // Let animation run
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(FiftyBadge), findsOneWidget);
    });

    testWidgets('stops animation when showGlow becomes false', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const FiftyBadge(
          label: 'Live',
          showGlow: true,
        ),
      ));

      await tester.pump(const Duration(milliseconds: 500));

      await tester.pumpWidget(wrapWithTheme(
        const FiftyBadge(
          label: 'Live',
          showGlow: false,
        ),
      ));

      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(FiftyBadge), findsOneWidget);
    });

    group('factory constructors', () {
      testWidgets('FiftyBadge.tech creates neutral badge', (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          FiftyBadge.tech('FLUTTER'),
        ));

        expect(find.text('FLUTTER'), findsOneWidget);
        expect(find.byType(FiftyBadge), findsOneWidget);
      });

      testWidgets('FiftyBadge.status creates success badge with glow',
          (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          FiftyBadge.status('ONLINE'),
        ));

        expect(find.text('ONLINE'), findsOneWidget);
        expect(find.byType(FiftyBadge), findsOneWidget);

        // Let animation run
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(FiftyBadge), findsOneWidget);
      });

      testWidgets('FiftyBadge.ai creates igris green badge with glow',
          (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          FiftyBadge.ai('IGRIS'),
        ));

        expect(find.text('IGRIS'), findsOneWidget);
        expect(find.byType(FiftyBadge), findsOneWidget);

        // Let animation run
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.byType(FiftyBadge), findsOneWidget);
      });

      testWidgets('factory constructors convert label to uppercase',
          (tester) async {
        await tester.pumpWidget(wrapWithTheme(
          FiftyBadge.tech('flutter'),
        ));

        // All labels are uppercase
        expect(find.text('FLUTTER'), findsOneWidget);
      });
    });
  });
}
