import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SkillTreeTheme', () {
    group('dark factory', () {
      test('creates theme with all required fields', () {
        final theme = SkillTreeTheme.dark();

        expect(theme.lockedNodeColor, isNotNull);
        expect(theme.lockedNodeBorderColor, isNotNull);
        expect(theme.availableNodeColor, isNotNull);
        expect(theme.availableNodeBorderColor, isNotNull);
        expect(theme.unlockedNodeColor, isNotNull);
        expect(theme.unlockedNodeBorderColor, isNotNull);
        expect(theme.maxedNodeColor, isNotNull);
        expect(theme.maxedNodeBorderColor, isNotNull);
        expect(theme.passiveColor, isNotNull);
        expect(theme.activeColor, isNotNull);
        expect(theme.ultimateColor, isNotNull);
        expect(theme.keystoneColor, isNotNull);
        expect(theme.connectionLockedColor, isNotNull);
        expect(theme.connectionUnlockedColor, isNotNull);
        expect(theme.nodeRadius, 28.0);
        expect(theme.nodeBorderWidth, 2.0);
        expect(theme.connectionWidth, 2.0);
      });
    });

    group('light factory', () {
      test('creates theme with all required fields', () {
        final theme = SkillTreeTheme.light();

        expect(theme.lockedNodeColor, isNotNull);
        expect(theme.availableNodeBorderColor, isNotNull);
        expect(theme.unlockedNodeBorderColor, isNotNull);
        expect(theme.nodeRadius, 28.0);
      });
    });

    group('fromContext factory', () {
      late ColorScheme testColorScheme;

      setUp(() {
        testColorScheme = const ColorScheme.dark(
          primary: Color(0xFFFF0000),
          primaryContainer: Color(0xFF880000),
          secondary: Color(0xFF00FF00),
          tertiary: Color(0xFF0000FF),
          tertiaryContainer: Color(0xFF000088),
          error: Color(0xFFFF00FF),
          surface: Color(0xFF111111),
          surfaceContainerHighest: Color(0xFF333333),
          outline: Color(0xFF555555),
          onSurface: Color(0xFFEEEEEE),
          onSurfaceVariant: Color(0xFFCCCCCC),
        );
      });

      Widget buildTestWidget({
        required void Function(BuildContext context) onBuild,
        ColorScheme? colorScheme,
      }) {
        return MaterialApp(
          theme: ThemeData(
            colorScheme: colorScheme ?? testColorScheme,
          ),
          home: Builder(
            builder: (context) {
              onBuild(context);
              return const SizedBox.shrink();
            },
          ),
        );
      }

      testWidgets('reads colorScheme.primary for availableNodeBorderColor',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.availableNodeBorderColor, const Color(0xFFFF0000));
      });

      testWidgets('reads colorScheme.tertiary for unlockedNodeBorderColor',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.unlockedNodeBorderColor, const Color(0xFF0000FF));
      });

      testWidgets(
          'reads colorScheme.surfaceContainerHighest for lockedNodeColor',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.lockedNodeColor, const Color(0xFF333333));
      });

      testWidgets('reads colorScheme.outline for lockedNodeBorderColor',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.lockedNodeBorderColor, const Color(0xFF555555));
      });

      testWidgets('reads colorScheme.primaryContainer for availableNodeColor',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.availableNodeColor, const Color(0xFF880000));
      });

      testWidgets(
          'reads colorScheme.tertiaryContainer for unlockedNodeColor',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.unlockedNodeColor, const Color(0xFF000088));
      });

      testWidgets(
          'reads colorScheme.onSurfaceVariant for passiveColor',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.passiveColor, const Color(0xFFCCCCCC));
      });

      testWidgets('reads colorScheme.primary for activeColor',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.activeColor, const Color(0xFFFF0000));
      });

      testWidgets('reads colorScheme.outline for connectionLockedColor',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.connectionLockedColor, const Color(0xFF555555));
      });

      testWidgets('reads colorScheme.tertiary for connectionUnlockedColor',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.connectionUnlockedColor, const Color(0xFF0000FF));
      });

      testWidgets('reads colorScheme.primary for connectionHighlightColor',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.connectionHighlightColor, const Color(0xFFFF0000));
      });

      testWidgets(
          'falls back to colorScheme.error for keystoneColor (no FiftyThemeExtension)',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.keystoneColor, const Color(0xFFFF00FF));
      });

      testWidgets(
          'falls back to colorScheme.secondary for ultimateColor',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.ultimateColor, const Color(0xFF00FF00));
      });

      testWidgets('uses custom warningColor when provided', (tester) async {
        late SkillTreeTheme theme;
        const customWarning = Color(0xFFAA5500);

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(
              context,
              warningColor: customWarning,
            );
          },
        ));

        expect(theme.keystoneColor, customWarning);
      });

      testWidgets('uses custom accentColor when provided', (tester) async {
        late SkillTreeTheme theme;
        const customAccent = Color(0xFF00AA55);

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(
              context,
              accentColor: customAccent,
            );
          },
        ));

        expect(theme.ultimateColor, customAccent);
      });

      testWidgets('sets default sizes', (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.nodeRadius, 28.0);
        expect(theme.nodeBorderWidth, 2.0);
        expect(theme.connectionWidth, 2.0);
      });

      testWidgets('sets text styles from colorScheme.onSurface',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.nodeNameStyle?.color, const Color(0xFFEEEEEE));
        expect(theme.nodeLevelStyle?.color, const Color(0xFFEEEEEE));
        expect(theme.tooltipTitleStyle?.color, const Color(0xFFEEEEEE));
      });

      testWidgets('sets tooltipBackground from surfaceContainerHighest',
          (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.tooltipBackground, const Color(0xFF333333));
      });

      testWidgets('sets tooltipBorder from outline', (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.tooltipBorder, const Color(0xFF555555));
      });

      testWidgets('uses warning color for nodeCostStyle', (tester) async {
        late SkillTreeTheme theme;

        await tester.pumpWidget(buildTestWidget(
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        // Falls back to colorScheme.error when no custom warning provided
        expect(theme.nodeCostStyle?.color, const Color(0xFFFF00FF));
      });

      testWidgets('respects different colorSchemes', (tester) async {
        late SkillTreeTheme theme;

        const lightScheme = ColorScheme.light(
          primary: Color(0xFF1A73E8),
          tertiary: Color(0xFF4CAF50),
          error: Color(0xFFB00020),
        );

        await tester.pumpWidget(buildTestWidget(
          colorScheme: lightScheme,
          onBuild: (context) {
            theme = SkillTreeTheme.fromContext(context);
          },
        ));

        expect(theme.availableNodeBorderColor, const Color(0xFF1A73E8));
        expect(theme.unlockedNodeBorderColor, const Color(0xFF4CAF50));
        expect(theme.keystoneColor, const Color(0xFFB00020));
      });
    });

    group('copyWith', () {
      test('overrides specified fields', () {
        final original = SkillTreeTheme.dark();
        final modified = original.copyWith(
          lockedNodeColor: const Color(0xFF000000),
          nodeRadius: 32.0,
        );

        expect(modified.lockedNodeColor, const Color(0xFF000000));
        expect(modified.nodeRadius, 32.0);
        // Unmodified fields remain the same
        expect(modified.availableNodeColor, original.availableNodeColor);
        expect(modified.connectionWidth, original.connectionWidth);
      });

      test('returns identical theme when no overrides given', () {
        final original = SkillTreeTheme.dark();
        final copy = original.copyWith();

        expect(copy, equals(original));
      });

      test('overrides all node state colors', () {
        final original = SkillTreeTheme.dark();
        const override = Color(0xFFABCDEF);

        final modified = original.copyWith(
          lockedNodeColor: override,
          lockedNodeBorderColor: override,
          availableNodeColor: override,
          availableNodeBorderColor: override,
          unlockedNodeColor: override,
          unlockedNodeBorderColor: override,
          maxedNodeColor: override,
          maxedNodeBorderColor: override,
        );

        expect(modified.lockedNodeColor, equals(override));
        expect(modified.lockedNodeBorderColor, equals(override));
        expect(modified.availableNodeColor, equals(override));
        expect(modified.availableNodeBorderColor, equals(override));
        expect(modified.unlockedNodeColor, equals(override));
        expect(modified.unlockedNodeBorderColor, equals(override));
        expect(modified.maxedNodeColor, equals(override));
        expect(modified.maxedNodeBorderColor, equals(override));
      });

      test('overrides node type colors', () {
        final original = SkillTreeTheme.dark();
        const override = Color(0xFFABCDEF);

        final modified = original.copyWith(
          passiveColor: override,
          activeColor: override,
          ultimateColor: override,
          keystoneColor: override,
        );

        expect(modified.passiveColor, equals(override));
        expect(modified.activeColor, equals(override));
        expect(modified.ultimateColor, equals(override));
        expect(modified.keystoneColor, equals(override));
      });

      test('overrides connection colors', () {
        final original = SkillTreeTheme.dark();
        const override = Color(0xFFABCDEF);

        final modified = original.copyWith(
          connectionLockedColor: override,
          connectionUnlockedColor: override,
          connectionHighlightColor: override,
        );

        expect(modified.connectionLockedColor, equals(override));
        expect(modified.connectionUnlockedColor, equals(override));
        expect(modified.connectionHighlightColor, equals(override));
      });

      test('overrides size values', () {
        final original = SkillTreeTheme.dark();

        final modified = original.copyWith(
          nodeRadius: 40.0,
          nodeBorderWidth: 4.0,
          connectionWidth: 3.0,
        );

        expect(modified.nodeRadius, equals(40.0));
        expect(modified.nodeBorderWidth, equals(4.0));
        expect(modified.connectionWidth, equals(3.0));
      });

      test('overrides text styles', () {
        final original = SkillTreeTheme.dark();
        const style = TextStyle(color: Color(0xFFABCDEF), fontSize: 20);

        final modified = original.copyWith(
          nodeNameStyle: style,
          nodeLevelStyle: style,
          nodeCostStyle: style,
          tooltipTitleStyle: style,
          tooltipDescriptionStyle: style,
        );

        expect(modified.nodeNameStyle, equals(style));
        expect(modified.nodeLevelStyle, equals(style));
        expect(modified.nodeCostStyle, equals(style));
        expect(modified.tooltipTitleStyle, equals(style));
        expect(modified.tooltipDescriptionStyle, equals(style));
      });

      test('overrides tooltip colors', () {
        final original = SkillTreeTheme.dark();
        const override = Color(0xFFABCDEF);

        final modified = original.copyWith(
          tooltipBackground: override,
          tooltipBorder: override,
        );

        expect(modified.tooltipBackground, equals(override));
        expect(modified.tooltipBorder, equals(override));
      });
    });

    group('dark factory defaults', () {
      test('has specific dark theme colors', () {
        final theme = SkillTreeTheme.dark();

        expect(theme.lockedNodeColor, equals(const Color(0xFF2A2A2A)));
        expect(theme.lockedNodeBorderColor, equals(const Color(0xFF444444)));
        expect(theme.availableNodeColor, equals(const Color(0xFF1A3A5C)));
        expect(
          theme.availableNodeBorderColor,
          equals(const Color(0xFF3A7CA5)),
        );
        expect(theme.unlockedNodeColor, equals(const Color(0xFF1A4D1A)));
        expect(
          theme.unlockedNodeBorderColor,
          equals(const Color(0xFF4CAF50)),
        );
        expect(theme.maxedNodeColor, equals(const Color(0xFF4A3A1A)));
        expect(theme.maxedNodeBorderColor, equals(const Color(0xFFFFD700)));
      });

      test('has text styles', () {
        final theme = SkillTreeTheme.dark();

        expect(theme.nodeNameStyle, isNotNull);
        expect(theme.nodeNameStyle!.fontWeight, equals(FontWeight.bold));
        expect(theme.nodeNameStyle!.fontSize, equals(14));

        expect(theme.nodeLevelStyle, isNotNull);
        expect(theme.nodeLevelStyle!.fontSize, equals(10));

        expect(theme.nodeCostStyle, isNotNull);
        expect(theme.nodeCostStyle!.color, equals(const Color(0xFFFFD700)));
      });

      test('has tooltip properties', () {
        final theme = SkillTreeTheme.dark();

        expect(theme.tooltipBackground, isNotNull);
        expect(theme.tooltipBorder, isNotNull);
        expect(theme.tooltipTitleStyle, isNotNull);
        expect(theme.tooltipDescriptionStyle, isNotNull);
      });

      test('has connection highlight color', () {
        final theme = SkillTreeTheme.dark();

        expect(
          theme.connectionHighlightColor,
          equals(const Color(0xFF64B5F6)),
        );
      });
    });

    group('light factory defaults', () {
      test('has specific light theme colors', () {
        final theme = SkillTreeTheme.light();

        expect(theme.lockedNodeColor, equals(const Color(0xFFE0E0E0)));
        expect(theme.lockedNodeBorderColor, equals(const Color(0xFFBDBDBD)));
        expect(theme.availableNodeColor, equals(const Color(0xFFBBDEFB)));
        expect(
          theme.availableNodeBorderColor,
          equals(const Color(0xFF2196F3)),
        );
      });

      test('has text styles with dark colors', () {
        final theme = SkillTreeTheme.light();

        expect(theme.nodeNameStyle, isNotNull);
        expect(
          theme.nodeNameStyle!.color,
          equals(const Color(0xFF212121)),
        );
      });
    });

    group('equality', () {
      test('equal themes are equal', () {
        final a = SkillTreeTheme.dark();
        final b = SkillTreeTheme.dark();

        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different themes are not equal', () {
        final dark = SkillTreeTheme.dark();
        final light = SkillTreeTheme.light();

        expect(dark, isNot(equals(light)));
      });

      test('identical instance equals itself', () {
        final theme = SkillTreeTheme.dark();

        expect(theme == theme, isTrue);
      });

      test('is not equal to non-SkillTreeTheme', () {
        final theme = SkillTreeTheme.dark();

        // ignore: unrelated_type_equality_checks
        expect(theme == 42, isFalse);
      });

      test('copyWith with change produces different theme', () {
        final original = SkillTreeTheme.dark();
        final modified = original.copyWith(
          lockedNodeColor: const Color(0xFF000000),
        );

        expect(original, isNot(equals(modified)));
      });

      test('copyWith without change produces equal theme', () {
        final original = SkillTreeTheme.dark();
        final copy = original.copyWith();

        expect(original, equals(copy));
        expect(original.hashCode, equals(copy.hashCode));
      });
    });
  });
}
