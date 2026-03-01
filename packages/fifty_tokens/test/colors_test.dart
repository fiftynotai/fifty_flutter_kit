import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyColors', () {
    setUp(() => FiftyTokens.reset());

    group('Semantic Colors (default FDL v2)', () {
      test('primary is #88292F', () {
        expect(FiftyColors.primary, Color(0xFF88292F));
      });

      test('primaryHover is #6E2126', () {
        expect(FiftyColors.primaryHover, Color(0xFF6E2126));
      });

      test('background is #FEFEE3', () {
        expect(FiftyColors.background, Color(0xFFFEFEE3));
      });

      test('backgroundDark is #1A0D0E', () {
        expect(FiftyColors.backgroundDark, Color(0xFF1A0D0E));
      });

      test('secondary is #335C67', () {
        expect(FiftyColors.secondary, Color(0xFF335C67));
      });

      test('secondaryHover is #274750', () {
        expect(FiftyColors.secondaryHover, Color(0xFF274750));
      });

      test('success is #4B644A', () {
        expect(FiftyColors.success, Color(0xFF4B644A));
      });

      test('accent is #FFC9B9', () {
        expect(FiftyColors.accent, Color(0xFFFFC9B9));
      });

      test('surface is #FAF9DE', () {
        expect(FiftyColors.surface, Color(0xFFFAF9DE));
      });

      test('surfaceDark is #2A1517', () {
        expect(FiftyColors.surfaceDark, Color(0xFF2A1517));
      });

      test('warning is #F7A100', () {
        expect(FiftyColors.warning, Color(0xFFF7A100));
      });

      test('error is #88292F', () {
        expect(FiftyColors.error, Color(0xFF88292F));
      });

      test('onPrimary is #FEFEE3', () {
        expect(FiftyColors.onPrimary, Color(0xFFFEFEE3));
      });

      test('onBackground is #1A0D0E', () {
        expect(FiftyColors.onBackground, Color(0xFF1A0D0E));
      });
    });

    group('Mode-Specific Helpers', () {
      test('borderLight is black at 5% opacity', () {
        expect(FiftyColors.borderLight.a, closeTo(0.05, 0.01));
      });

      test('borderDark is white at 5% opacity', () {
        expect(FiftyColors.borderDark.a, closeTo(0.05, 0.01));
      });

      test('focusLight is primary', () {
        expect(FiftyColors.focusLight, FiftyColors.primary);
      });

      test('focusDark is accent at 50% opacity', () {
        expect(FiftyColors.focusDark.a, closeTo(0.5, 0.01));
      });

      test('configurable borderOpacity', () {
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(borderOpacity: 0.1),
        );
        expect(FiftyColors.borderLight.a, closeTo(0.1, 0.01));
        expect(FiftyColors.borderDark.a, closeTo(0.1, 0.01));
      });

      test('configurable focusOpacity', () {
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(focusOpacity: 0.8),
        );
        expect(FiftyColors.focusDark.a, closeTo(0.8, 0.01));
      });
    });

    group('Deprecated v2 palette aliases', () {
      test('burgundy returns primary', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.burgundy, FiftyColors.primary);
      });

      test('burgundyHover returns primaryHover', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.burgundyHover, FiftyColors.primaryHover);
      });

      test('cream returns background', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.cream, FiftyColors.background);
      });

      test('darkBurgundy returns backgroundDark', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.darkBurgundy, FiftyColors.backgroundDark);
      });

      test('slateGrey returns secondary', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.slateGrey, FiftyColors.secondary);
      });

      test('slateGreyHover returns secondaryHover', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.slateGreyHover, FiftyColors.secondaryHover);
      });

      test('hunterGreen returns success', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.hunterGreen, FiftyColors.success);
      });

      test('powderBlush returns accent', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.powderBlush, FiftyColors.accent);
      });

      test('surfaceLight returns surface', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.surfaceLight, FiftyColors.surface);
      });
    });

    group('Deprecated v1 Colors (backward compatibility)', () {
      test('voidBlack still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.voidBlack, const Color(0xFF050505));
      });

      test('crimsonPulse still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.crimsonPulse, const Color(0xFF960E29));
      });

      test('gunmetal still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.gunmetal, const Color(0xFF1A1A1A));
      });

      test('terminalWhite still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.terminalWhite, const Color(0xFFEAEAEA));
      });

      test('hyperChrome still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.hyperChrome, const Color(0xFF888888));
      });

      test('igrisGreen still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.igrisGreen, const Color(0xFF00FF41));
      });

      test('border still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyColors.border, const Color(0x1A888888));
      });
    });

    test('all semantic colors are non-null', () {
      expect(FiftyColors.primary, isNotNull);
      expect(FiftyColors.primaryHover, isNotNull);
      expect(FiftyColors.background, isNotNull);
      expect(FiftyColors.backgroundDark, isNotNull);
      expect(FiftyColors.secondary, isNotNull);
      expect(FiftyColors.secondaryHover, isNotNull);
      expect(FiftyColors.success, isNotNull);
      expect(FiftyColors.accent, isNotNull);
      expect(FiftyColors.surface, isNotNull);
      expect(FiftyColors.surfaceDark, isNotNull);
      expect(FiftyColors.warning, isNotNull);
      expect(FiftyColors.error, isNotNull);
      expect(FiftyColors.onPrimary, isNotNull);
      expect(FiftyColors.onBackground, isNotNull);
    });
  });
}
