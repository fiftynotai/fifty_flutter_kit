import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyColorConfig', () {
    setUp(() => FiftyTokens.reset());

    group('default values (FDL defaults when unconfigured)', () {
      test('semantic color defaults', () {
        expect(FiftyColors.primary, Color(0xFF88292F));
        expect(FiftyColors.primaryHover, Color(0xFF6E2126));
        expect(FiftyColors.background, Color(0xFFFEFEE3));
        expect(FiftyColors.backgroundDark, Color(0xFF1A0D0E));
        expect(FiftyColors.secondary, Color(0xFF335C67));
        expect(FiftyColors.secondaryHover, Color(0xFF274750));
        expect(FiftyColors.success, Color(0xFF4B644A));
        expect(FiftyColors.accent, Color(0xFFFFC9B9));
        expect(FiftyColors.surface, Color(0xFFFAF9DE));
        expect(FiftyColors.surfaceDark, Color(0xFF2A1517));
        expect(FiftyColors.warning, Color(0xFFF7A100));
        expect(FiftyColors.error, Color(0xFF88292F));
        expect(FiftyColors.onPrimary, Color(0xFFFEFEE3));
        expect(FiftyColors.onBackground, Color(0xFF1A0D0E));
      });

      test('focus helpers default correctly', () {
        expect(FiftyColors.focusLight, FiftyColors.primary);
      });

      test('border opacity defaults to 0.05', () {
        expect(
          FiftyTokens.active.colors.borderOpacity,
          closeTo(0.05, 0.001),
        );
      });

      test('focus opacity defaults to 0.5', () {
        expect(
          FiftyTokens.active.colors.focusOpacity,
          closeTo(0.5, 0.001),
        );
      });
    });

    group('full override', () {
      test('all colors overridden return custom values', () {
        const customColor = Color(0xFF111111);
        FiftyTokens.configure(
          colors: FiftyColorConfig(
            primary: customColor,
            primaryHover: customColor,
            background: customColor,
            backgroundDark: customColor,
            secondary: customColor,
            secondaryHover: customColor,
            success: customColor,
            accent: customColor,
            surface: customColor,
            surfaceDark: customColor,
            warning: customColor,
            error: customColor,
            onPrimary: customColor,
            onBackground: customColor,
            borderOpacity: 0.1,
            focusOpacity: 0.8,
          ),
        );

        expect(FiftyColors.primary, customColor);
        expect(FiftyColors.primaryHover, customColor);
        expect(FiftyColors.background, customColor);
        expect(FiftyColors.backgroundDark, customColor);
        expect(FiftyColors.secondary, customColor);
        expect(FiftyColors.secondaryHover, customColor);
        expect(FiftyColors.success, customColor);
        expect(FiftyColors.accent, customColor);
        expect(FiftyColors.surface, customColor);
        expect(FiftyColors.surfaceDark, customColor);
        expect(FiftyColors.warning, customColor);
        expect(FiftyColors.error, customColor);
        expect(FiftyColors.onPrimary, customColor);
        expect(FiftyColors.onBackground, customColor);
        expect(FiftyColors.borderLight.a, closeTo(0.1, 0.01));
        expect(FiftyColors.focusDark.a, closeTo(0.8, 0.01));
      });
    });

    group('partial override via copyWith', () {
      test('only primary overridden, others stay default', () {
        const customPrimary = Color(0xFF0000FF);
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(primary: customPrimary),
        );

        expect(FiftyColors.primary, customPrimary);
        // Others unchanged
        expect(FiftyColors.secondary, Color(0xFF335C67));
        expect(FiftyColors.background, Color(0xFFFEFEE3));
      });
    });

    group('copyWith', () {
      test('overrides specific fields only', () {
        const customPrimary = Color(0xFFFF0000);
        final config =
            FiftyPreset.fdlV2.colors.copyWith(primary: customPrimary);

        expect(config.primary, customPrimary);
        // Others unchanged
        expect(config.secondary, FiftyPreset.fdlV2.colors.secondary);
        expect(config.background, FiftyPreset.fdlV2.colors.background);
      });

      test('override error independently from primary', () {
        const customError = Color(0xFFFF0000);
        final config =
            FiftyPreset.fdlV2.colors.copyWith(error: customError);

        expect(config.error, customError);
        expect(config.primary, FiftyPreset.fdlV2.colors.primary);
      });
    });

    group('reset restores defaults', () {
      test('after reset all return FDL defaults', () {
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
        );

        FiftyTokens.reset();

        expect(FiftyColors.primary, Color(0xFF88292F));
        expect(FiftyColors.error, Color(0xFF88292F));
      });
    });

    group('fromMap()', () {
      final fallback = FiftyPreset.fdlV2.colors;

      test('full valid map overrides all fields', () {
        final config = FiftyColorConfig.fromMap(
          {
            'primary': 0xFF111111,
            'primaryHover': 0xFF222222,
            'background': 0xFF333333,
            'backgroundDark': 0xFF444444,
            'secondary': 0xFF555555,
            'secondaryHover': 0xFF666666,
            'success': 0xFF777777,
            'accent': 0xFF888888,
            'surface': 0xFF999999,
            'surfaceDark': 0xFFAAAAAA,
            'warning': 0xFFBBBBBB,
            'error': 0xFFCCCCCC,
            'onPrimary': 0xFFDDDDDD,
            'onBackground': 0xFFEEEEEE,
            'borderOpacity': 0.1,
            'focusOpacity': 0.8,
          },
          fallback: fallback,
        );

        expect(config.primary, const Color(0xFF111111));
        expect(config.primaryHover, const Color(0xFF222222));
        expect(config.background, const Color(0xFF333333));
        expect(config.backgroundDark, const Color(0xFF444444));
        expect(config.secondary, const Color(0xFF555555));
        expect(config.secondaryHover, const Color(0xFF666666));
        expect(config.success, const Color(0xFF777777));
        expect(config.accent, const Color(0xFF888888));
        expect(config.surface, const Color(0xFF999999));
        expect(config.surfaceDark, const Color(0xFFAAAAAA));
        expect(config.warning, const Color(0xFFBBBBBB));
        expect(config.error, const Color(0xFFCCCCCC));
        expect(config.onPrimary, const Color(0xFFDDDDDD));
        expect(config.onBackground, const Color(0xFFEEEEEE));
        expect(config.borderOpacity, 0.1);
        expect(config.focusOpacity, 0.8);
      });

      test('empty map returns all fallback values', () {
        final config = FiftyColorConfig.fromMap({}, fallback: fallback);

        expect(config.primary, fallback.primary);
        expect(config.secondary, fallback.secondary);
        expect(config.borderOpacity, fallback.borderOpacity);
        expect(config.focusOpacity, fallback.focusOpacity);
      });

      test('partial map uses fallback for missing keys', () {
        final config = FiftyColorConfig.fromMap(
          {'primary': 0xFFFF0000},
          fallback: fallback,
        );

        expect(config.primary, const Color(0xFFFF0000));
        expect(config.secondary, fallback.secondary);
        expect(config.background, fallback.background);
      });

      test('parses hex string colors (#RRGGBB format)', () {
        final config = FiftyColorConfig.fromMap(
          {'primary': '#FF0000'},
          fallback: fallback,
        );

        expect(config.primary, const Color(0xFFFF0000));
      });

      test('parses 0x-prefixed hex strings', () {
        final config = FiftyColorConfig.fromMap(
          {'primary': '0xFFAABBCC'},
          fallback: fallback,
        );

        expect(config.primary, const Color(0xFFAABBCC));
      });

      test('parses int color values', () {
        final config = FiftyColorConfig.fromMap(
          {'primary': 0xFF00FF00},
          fallback: fallback,
        );

        expect(config.primary, const Color(0xFF00FF00));
      });

      test('malformed hex falls back gracefully', () {
        final config = FiftyColorConfig.fromMap(
          {'primary': 'not-a-color'},
          fallback: fallback,
        );

        expect(config.primary, fallback.primary);
      });

      test('non-color value (boolean) falls back', () {
        final config = FiftyColorConfig.fromMap(
          {'primary': true},
          fallback: fallback,
        );

        expect(config.primary, fallback.primary);
      });

      test('non-num borderOpacity throws TypeError', () {
        expect(
          () => FiftyColorConfig.fromMap(
            {'borderOpacity': 'abc'},
            fallback: fallback,
          ),
          throwsA(isA<TypeError>()),
        );
      });

      test('non-num focusOpacity throws TypeError', () {
        expect(
          () => FiftyColorConfig.fromMap(
            {'focusOpacity': true},
            fallback: fallback,
          ),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('mode helpers', () {
      test('borderLight still works', () {
        expect(FiftyColors.borderLight.a, closeTo(0.05, 0.01));
      });

      test('borderDark still works', () {
        expect(FiftyColors.borderDark.a, closeTo(0.05, 0.01));
      });

      test('focusDark follows accent getter', () {
        const customAccent = Color(0xFFAABBCC);
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(accent: customAccent),
        );

        final focusDark = FiftyColors.focusDark;
        expect(focusDark.a, closeTo(0.5, 0.01));
        // RGB should match customAccent
        expect(
          focusDark.toARGB32() & 0x00FFFFFF,
          customAccent.toARGB32() & 0x00FFFFFF,
        );
      });
    });
  });
}
