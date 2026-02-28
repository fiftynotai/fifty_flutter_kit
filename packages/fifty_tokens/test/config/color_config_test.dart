import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyColorConfig', () {
    setUp(() => FiftyTokens.reset());

    group('default values (FDL defaults when unconfigured)', () {
      test('core palette defaults', () {
        expect(FiftyColors.burgundy, Color(0xFF88292F));
        expect(FiftyColors.burgundyHover, Color(0xFF6E2126));
        expect(FiftyColors.cream, Color(0xFFFEFEE3));
        expect(FiftyColors.darkBurgundy, Color(0xFF1A0D0E));
        expect(FiftyColors.slateGrey, Color(0xFF335C67));
        expect(FiftyColors.slateGreyHover, Color(0xFF274750));
        expect(FiftyColors.hunterGreen, Color(0xFF4B644A));
        expect(FiftyColors.powderBlush, Color(0xFFFFC9B9));
        expect(FiftyColors.surfaceLight, Color(0xFFFAF9DE));
        expect(FiftyColors.surfaceDark, Color(0xFF2A1517));
      });

      test('semantic defaults fall back to core palette', () {
        expect(FiftyColors.primary, FiftyColors.burgundy);
        expect(FiftyColors.primaryHover, FiftyColors.burgundyHover);
        expect(FiftyColors.secondary, FiftyColors.slateGrey);
        expect(FiftyColors.secondaryHover, FiftyColors.slateGreyHover);
        expect(FiftyColors.success, FiftyColors.hunterGreen);
        expect(FiftyColors.warning, Color(0xFFF7A100));
        expect(FiftyColors.error, FiftyColors.burgundy);
      });

      test('focus helpers default correctly', () {
        expect(FiftyColors.focusLight, FiftyColors.burgundy);
      });
    });

    group('full override', () {
      test('all colors overridden return custom values', () {
        const customColor = Color(0xFF111111);
        FiftyTokens.configure(
          colors: FiftyColorConfig(
            burgundy: customColor,
            burgundyHover: customColor,
            cream: customColor,
            darkBurgundy: customColor,
            slateGrey: customColor,
            slateGreyHover: customColor,
            hunterGreen: customColor,
            powderBlush: customColor,
            surfaceLight: customColor,
            surfaceDark: customColor,
            primary: customColor,
            primaryHover: customColor,
            secondary: customColor,
            secondaryHover: customColor,
            success: customColor,
            warning: customColor,
            error: customColor,
            focusLight: customColor,
          ),
        );

        expect(FiftyColors.burgundy, customColor);
        expect(FiftyColors.burgundyHover, customColor);
        expect(FiftyColors.cream, customColor);
        expect(FiftyColors.darkBurgundy, customColor);
        expect(FiftyColors.slateGrey, customColor);
        expect(FiftyColors.slateGreyHover, customColor);
        expect(FiftyColors.hunterGreen, customColor);
        expect(FiftyColors.powderBlush, customColor);
        expect(FiftyColors.surfaceLight, customColor);
        expect(FiftyColors.surfaceDark, customColor);
        expect(FiftyColors.primary, customColor);
        expect(FiftyColors.primaryHover, customColor);
        expect(FiftyColors.secondary, customColor);
        expect(FiftyColors.secondaryHover, customColor);
        expect(FiftyColors.success, customColor);
        expect(FiftyColors.warning, customColor);
        expect(FiftyColors.error, customColor);
        expect(FiftyColors.focusLight, customColor);
      });
    });

    group('partial override', () {
      test('only primary overridden, others stay default', () {
        const customPrimary = Color(0xFF0000FF);
        FiftyTokens.configure(
          colors: FiftyColorConfig(primary: customPrimary),
        );

        expect(FiftyColors.primary, customPrimary);
        // Core palette unchanged
        expect(FiftyColors.burgundy, Color(0xFF88292F));
        expect(FiftyColors.slateGrey, Color(0xFF335C67));
      });
    });

    group('semantic fallback chain', () {
      test('override burgundy but not primary -> primary returns overridden burgundy', () {
        const customBurgundy = Color(0xFF0000FF);
        FiftyTokens.configure(
          colors: FiftyColorConfig(burgundy: customBurgundy),
        );

        expect(FiftyColors.burgundy, customBurgundy);
        expect(FiftyColors.primary, customBurgundy);
      });

      test('override burgundy but not error -> error follows primary which follows burgundy', () {
        const customBurgundy = Color(0xFF0000FF);
        FiftyTokens.configure(
          colors: FiftyColorConfig(burgundy: customBurgundy),
        );

        expect(FiftyColors.error, customBurgundy);
      });

      test('override primary directly -> error follows primary', () {
        const customPrimary = Color(0xFFFF0000);
        FiftyTokens.configure(
          colors: FiftyColorConfig(primary: customPrimary),
        );

        expect(FiftyColors.primary, customPrimary);
        expect(FiftyColors.error, customPrimary);
        // burgundy unchanged
        expect(FiftyColors.burgundy, Color(0xFF88292F));
      });

      test('override burgundy and primary independently', () {
        const customBurgundy = Color(0xFF0000FF);
        const customPrimary = Color(0xFFFF0000);
        FiftyTokens.configure(
          colors: FiftyColorConfig(
            burgundy: customBurgundy,
            primary: customPrimary,
          ),
        );

        expect(FiftyColors.burgundy, customBurgundy);
        expect(FiftyColors.primary, customPrimary);
      });

      test('focusLight follows primary getter', () {
        const customPrimary = Color(0xFFFF0000);
        FiftyTokens.configure(
          colors: FiftyColorConfig(primary: customPrimary),
        );

        expect(FiftyColors.focusLight, customPrimary);
      });

      test('slateGrey override cascades to secondary', () {
        const customSlateGrey = Color(0xFF0000FF);
        FiftyTokens.configure(
          colors: FiftyColorConfig(slateGrey: customSlateGrey),
        );

        expect(FiftyColors.secondary, customSlateGrey);
      });

      test('hunterGreen override cascades to success', () {
        const customGreen = Color(0xFF00FF00);
        FiftyTokens.configure(
          colors: FiftyColorConfig(hunterGreen: customGreen),
        );

        expect(FiftyColors.success, customGreen);
      });
    });

    group('reset restores defaults', () {
      test('after reset all return FDL defaults', () {
        FiftyTokens.configure(
          colors: FiftyColorConfig(
            burgundy: Color(0xFF0000FF),
            primary: Color(0xFFFF0000),
          ),
        );

        FiftyTokens.reset();

        expect(FiftyColors.burgundy, Color(0xFF88292F));
        expect(FiftyColors.primary, Color(0xFF88292F));
        expect(FiftyColors.error, Color(0xFF88292F));
      });
    });

    group('mode helpers', () {
      test('borderLight still works', () {
        expect(FiftyColors.borderLight.a, closeTo(0.05, 0.01));
      });

      test('borderDark still works', () {
        expect(FiftyColors.borderDark.a, closeTo(0.05, 0.01));
      });

      test('focusDark follows powderBlush getter', () {
        const customPowderBlush = Color(0xFFAABBCC);
        FiftyTokens.configure(
          colors: FiftyColorConfig(powderBlush: customPowderBlush),
        );

        final focusDark = FiftyColors.focusDark;
        expect(focusDark.a, closeTo(0.5, 0.01));
        // RGB should match customPowderBlush
        expect(
          focusDark.toARGB32() & 0x00FFFFFF,
          customPowderBlush.toARGB32() & 0x00FFFFFF,
        );
      });
    });
  });
}
