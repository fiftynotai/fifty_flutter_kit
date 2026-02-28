import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps a widget with a custom (non-FDL) theme to verify that colors
/// and shadows propagate from the theme extension rather than being
/// hardcoded to FDL token constants.
Widget buildWithCustomTheme(Widget child) {
  return MaterialApp(
    theme: ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: Colors.purple,
        onPrimary: Colors.white,
        secondary: Colors.teal,
        tertiary: Colors.lime,
        error: Colors.orange,
        surface: Color(0xFF1A1A1A),
        onSurface: Colors.white,
        onSurfaceVariant: Color(0xFF9E9E9E),
        outline: Colors.blueGrey,
        surfaceContainerHighest: Color(0xFF2A2A2A),
        inverseSurface: Color(0xFFEEEEEE),
        onInverseSurface: Color(0xFF1A1A1A),
        scrim: Color(0x88000000),
      ),
      extensions: const [
        FiftyThemeExtension(
          accent: Colors.purple,
          success: Colors.lime,
          warning: Colors.amber,
          info: Colors.cyan,
          shadowSm: [BoxShadow(color: Colors.purple, blurRadius: 2)],
          shadowMd: [BoxShadow(color: Colors.purple, blurRadius: 4)],
          shadowLg: [BoxShadow(color: Colors.purple, blurRadius: 8)],
          shadowPrimary: [
            BoxShadow(color: Colors.purple, blurRadius: 6),
          ],
          shadowGlow: [
            BoxShadow(color: Colors.purple, blurRadius: 12),
          ],
          instant: Duration.zero,
          fast: Duration(milliseconds: 100),
          compiling: Duration(milliseconds: 200),
          systemLoad: Duration(milliseconds: 500),
          standardCurve: Curves.linear,
          enterCurve: Curves.linear,
          exitCurve: Curves.linear,
        ),
      ],
    ),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('Theme propagation', () {
    testWidgets('FiftyButton primary uses custom shadowPrimary', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithCustomTheme(
          FiftyButton(
            label: 'Test',
            onPressed: () {},
            variant: FiftyButtonVariant.primary,
          ),
        ),
      );
      await tester.pump();

      // Find the AnimatedContainer that holds the button decoration
      final animatedContainers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      // The button's AnimatedContainer has BoxDecoration with shadow
      final buttonContainer = animatedContainers.firstWhere((container) {
        final decoration = container.decoration;
        if (decoration is BoxDecoration) {
          return decoration.boxShadow != null &&
              decoration.boxShadow!.isNotEmpty;
        }
        return false;
      });

      final boxDecoration = buttonContainer.decoration! as BoxDecoration;
      // The shadow should be our custom purple shadow (blurRadius 6)
      expect(boxDecoration.boxShadow, isNotNull);
      expect(boxDecoration.boxShadow!.first.color, Colors.purple);
      expect(boxDecoration.boxShadow!.first.blurRadius, 6.0);
    });

    testWidgets('FiftyButton secondary uses custom shadowSm', (tester) async {
      await tester.pumpWidget(
        buildWithCustomTheme(
          FiftyButton(
            label: 'Test',
            onPressed: () {},
            variant: FiftyButtonVariant.secondary,
          ),
        ),
      );
      await tester.pump();

      final animatedContainers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      final buttonContainer = animatedContainers.firstWhere((container) {
        final decoration = container.decoration;
        if (decoration is BoxDecoration) {
          return decoration.boxShadow != null &&
              decoration.boxShadow!.isNotEmpty;
        }
        return false;
      });

      final boxDecoration = buttonContainer.decoration! as BoxDecoration;
      // The shadow should be our custom purple shadow (blurRadius 2)
      expect(boxDecoration.boxShadow, isNotNull);
      expect(boxDecoration.boxShadow!.first.color, Colors.purple);
      expect(boxDecoration.boxShadow!.first.blurRadius, 2.0);
    });

    testWidgets('FiftyBadge success uses custom success color from extension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithCustomTheme(
          const FiftyBadge(
            label: 'ONLINE',
            variant: FiftyBadgeVariant.success,
          ),
        ),
      );
      await tester.pump();

      // The badge border should use the custom extension success color (lime)
      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration! as BoxDecoration;
      final border = decoration.border! as Border;
      expect(border.top.color, Colors.lime);
    });

    testWidgets('FiftyBadge warning uses custom warning color from extension', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithCustomTheme(
          const FiftyBadge(
            label: 'WARN',
            variant: FiftyBadgeVariant.warning,
          ),
        ),
      );
      await tester.pump();

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final decoration = container.decoration! as BoxDecoration;
      final border = decoration.border! as Border;
      expect(border.top.color, Colors.amber);
    });

    testWidgets(
      'FiftyBadge.tech uses colorScheme.onSurfaceVariant (not hardcoded)',
      (tester) async {
        await tester.pumpWidget(
          buildWithCustomTheme(FiftyBadge.tech('FLUTTER')),
        );
        await tester.pump();

        // The badge uses neutral variant which maps to colorScheme.onSurfaceVariant
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration! as BoxDecoration;
        final border = decoration.border! as Border;
        // Our custom onSurfaceVariant is Color(0xFF9E9E9E)
        expect(border.top.color, const Color(0xFF9E9E9E));
      },
    );

    testWidgets(
      'FiftyBadge.ai uses extension success color (not hardcoded hunterGreen)',
      (tester) async {
        await tester.pumpWidget(
          buildWithCustomTheme(FiftyBadge.ai('IGRIS')),
        );
        await tester.pump();

        // The badge uses success variant which maps to extension.success (lime)
        final container = tester.widget<Container>(
          find.byType(Container).first,
        );
        final decoration = container.decoration! as BoxDecoration;
        final border = decoration.border! as Border;
        expect(border.top.color, Colors.lime);
      },
    );

    testWidgets('FiftyCard uses custom shadowMd', (tester) async {
      await tester.pumpWidget(
        buildWithCustomTheme(
          const FiftyCard(
            child: SizedBox(width: 100, height: 100),
          ),
        ),
      );
      await tester.pump();

      // Find the AnimatedContainer with shadow
      final animatedContainers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      final cardContainer = animatedContainers.firstWhere((container) {
        final decoration = container.decoration;
        if (decoration is BoxDecoration) {
          return decoration.boxShadow != null &&
              decoration.boxShadow!.isNotEmpty;
        }
        return false;
      });

      final boxDecoration = cardContainer.decoration! as BoxDecoration;
      // Should use custom shadowMd (blurRadius 4, purple)
      expect(boxDecoration.boxShadow, isNotNull);
      expect(boxDecoration.boxShadow!.first.color, Colors.purple);
      expect(boxDecoration.boxShadow!.first.blurRadius, 4.0);
    });

    testWidgets('FiftyTooltip uses custom shadowSm', (tester) async {
      await tester.pumpWidget(
        buildWithCustomTheme(
          const FiftyTooltip(
            message: 'Hello',
            child: Icon(Icons.info),
          ),
        ),
      );
      await tester.pump();

      // Get the Tooltip widget
      final tooltip = tester.widget<Tooltip>(find.byType(Tooltip));
      final decoration = tooltip.decoration! as BoxDecoration;
      // Should use custom shadowSm (blurRadius 2, purple)
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow!.first.color, Colors.purple);
      expect(decoration.boxShadow!.first.blurRadius, 2.0);
    });

    testWidgets('FiftyDialog uses custom shadowLg when glow is off', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithCustomTheme(
          const FiftyDialog(
            content: Text('Hello'),
            showGlow: false,
          ),
        ),
      );
      await tester.pump();

      // Find the AnimatedContainer with shadow in the dialog
      final animatedContainers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      final dialogContainer = animatedContainers.firstWhere((container) {
        final decoration = container.decoration;
        if (decoration is BoxDecoration) {
          return decoration.boxShadow != null &&
              decoration.boxShadow!.isNotEmpty;
        }
        return false;
      });

      final boxDecoration = dialogContainer.decoration! as BoxDecoration;
      // Should use custom shadowLg (blurRadius 8, purple)
      expect(boxDecoration.boxShadow, isNotNull);
      expect(boxDecoration.boxShadow!.first.color, Colors.purple);
      expect(boxDecoration.boxShadow!.first.blurRadius, 8.0);
    });

    testWidgets('FiftySegmentedControl uses extension motion duration', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWithCustomTheme(
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

      // Find AnimatedContainers from segments
      final animatedContainers = tester.widgetList<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );

      // At least one segment AnimatedContainer should use our custom duration
      final segmentContainer = animatedContainers.firstWhere((container) {
        return container.duration == const Duration(milliseconds: 100);
      });

      expect(segmentContainer, isNotNull);
    });
  });
}
