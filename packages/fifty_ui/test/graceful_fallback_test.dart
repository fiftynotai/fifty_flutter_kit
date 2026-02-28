import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a widget in a MaterialApp WITHOUT FiftyThemeExtension to verify
/// widgets gracefully handle the missing extension (no crash, uses fallbacks).
Widget buildWithoutExtension(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: Colors.blue,
        onPrimary: Colors.white,
        secondary: Colors.teal,
        tertiary: Colors.green,
        error: Colors.red,
        surface: Color(0xFF121212),
        onSurface: Colors.white,
        onSurfaceVariant: Color(0xFF999999),
        outline: Color(0xFF555555),
        surfaceContainerHighest: Color(0xFF333333),
        inverseSurface: Color(0xFFEEEEEE),
        onInverseSurface: Color(0xFF1A1A1A),
        scrim: Color(0x88000000),
      ),
    ),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('Graceful fallback without FiftyThemeExtension', () {
    testWidgets('FiftyButton renders without FiftyThemeExtension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithoutExtension(
          FiftyButton(
            label: 'Test',
            onPressed: () {},
          ),
        ),
      );
      await tester.pump();

      // Should render without crashing
      expect(find.text('TEST'), findsOneWidget);
      expect(find.byType(FiftyButton), findsOneWidget);
    });

    testWidgets('FiftyButton all variants render without extension', (
      tester,
    ) async {
      for (final variant in FiftyButtonVariant.values) {
        await tester.pumpWidget(
          buildWithoutExtension(
            FiftyButton(
              label: variant.name,
              onPressed: () {},
              variant: variant,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(FiftyButton), findsOneWidget);
      }
    });

    testWidgets('FiftyBadge renders without FiftyThemeExtension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithoutExtension(
          const FiftyBadge(
            label: 'LIVE',
            variant: FiftyBadgeVariant.success,
          ),
        ),
      );
      await tester.pump();

      // Should render without crashing and use colorScheme.tertiary fallback
      expect(find.text('LIVE'), findsOneWidget);
      expect(find.byType(FiftyBadge), findsOneWidget);
    });

    testWidgets('FiftyBadge all variants render without extension', (
      tester,
    ) async {
      for (final variant in FiftyBadgeVariant.values) {
        await tester.pumpWidget(
          buildWithoutExtension(
            FiftyBadge(
              label: variant.name,
              variant: variant,
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(FiftyBadge), findsOneWidget);
      }
    });

    testWidgets('FiftyCard renders without FiftyThemeExtension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithoutExtension(
          const FiftyCard(
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );
      await tester.pump();

      // Should render without crashing, falls back to FDL defaults
      expect(find.byType(FiftyCard), findsOneWidget);
    });

    testWidgets('FiftyDataSlate renders without FiftyThemeExtension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithoutExtension(
          const FiftyDataSlate(
            data: {'Key': 'Value'},
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(FiftyDataSlate), findsOneWidget);
      expect(find.text('Key:'), findsOneWidget);
    });

    testWidgets('FiftyStatCard renders without FiftyThemeExtension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithoutExtension(
          const FiftyStatCard(
            label: 'Views',
            value: '100',
            icon: Icons.visibility,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(FiftyStatCard), findsOneWidget);
      expect(find.text('Views'), findsOneWidget);
    });

    testWidgets('FiftyProgressCard renders without FiftyThemeExtension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithoutExtension(
          const FiftyProgressCard(
            title: 'Goal',
            progress: 0.5,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(FiftyProgressCard), findsOneWidget);
      expect(find.text('Goal'), findsOneWidget);
    });

    testWidgets('FiftyTooltip renders without FiftyThemeExtension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithoutExtension(
          const FiftyTooltip(
            message: 'Info',
            child: Icon(Icons.info),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(FiftyTooltip), findsOneWidget);
      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('FiftyDialog renders without FiftyThemeExtension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithoutExtension(
          const FiftyDialog(
            title: 'Test',
            content: Text('Content'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('TEST'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('GlowContainer renders without FiftyThemeExtension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithoutExtension(
          const GlowContainer(
            showGlow: true,
            child: SizedBox(width: 50, height: 50),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(GlowContainer), findsOneWidget);
    });

    testWidgets('KineticEffect renders without FiftyThemeExtension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithoutExtension(
          KineticEffect(
            onTap: () {},
            child: const SizedBox(width: 50, height: 50),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(KineticEffect), findsOneWidget);
    });

    testWidgets(
      'FiftySegmentedControl renders without FiftyThemeExtension',
      (tester) async {
        await tester.pumpWidget(
          buildWithoutExtension(
            FiftySegmentedControl<String>(
              segments: const [
                FiftySegment(value: 'a', label: 'A'),
                FiftySegment(value: 'b', label: 'B'),
              ],
              selected: 'a',
              onChanged: (_) {},
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(FiftySegmentedControl<String>), findsOneWidget);
      },
    );

    testWidgets('FiftyDropdown renders without FiftyThemeExtension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithoutExtension(
          FiftyDropdown<String>(
            items: const [
              FiftyDropdownItem(value: 'a', label: 'Option A'),
              FiftyDropdownItem(value: 'b', label: 'Option B'),
            ],
            onChanged: (_) {},
            hint: 'Select',
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(FiftyDropdown<String>), findsOneWidget);
    });
  });
}
