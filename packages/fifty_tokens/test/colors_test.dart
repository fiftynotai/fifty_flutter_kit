import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyColors', () {
    setUp(() => FiftyTokens.reset());

    group('Core Palette v2 (Sophisticated Warm)', () {
      test('burgundy is #88292F', () {
        expect(FiftyColors.burgundy, Color(0xFF88292F));
      });

      test('burgundyHover is #6E2126', () {
        expect(FiftyColors.burgundyHover, Color(0xFF6E2126));
      });

      test('cream is #FEFEE3', () {
        expect(FiftyColors.cream, Color(0xFFFEFEE3));
      });

      test('darkBurgundy is #1A0D0E', () {
        expect(FiftyColors.darkBurgundy, Color(0xFF1A0D0E));
      });

      test('slateGrey is #335C67', () {
        expect(FiftyColors.slateGrey, Color(0xFF335C67));
      });

      test('slateGreyHover is #274750', () {
        expect(FiftyColors.slateGreyHover, Color(0xFF274750));
      });

      test('hunterGreen is #4B644A', () {
        expect(FiftyColors.hunterGreen, Color(0xFF4B644A));
      });

      test('powderBlush is #FFC9B9', () {
        expect(FiftyColors.powderBlush, Color(0xFFFFC9B9));
      });

      test('surfaceLight is #FAF9DE', () {
        expect(FiftyColors.surfaceLight, Color(0xFFFAF9DE));
      });

      test('surfaceDark is #2A1517', () {
        expect(FiftyColors.surfaceDark, Color(0xFF2A1517));
      });
    });

    group('Semantic Colors', () {
      test('primary is burgundy', () {
        expect(FiftyColors.primary, FiftyColors.burgundy);
      });

      test('primaryHover is burgundyHover', () {
        expect(FiftyColors.primaryHover, FiftyColors.burgundyHover);
      });

      test('secondary is slateGrey', () {
        expect(FiftyColors.secondary, FiftyColors.slateGrey);
      });

      test('secondaryHover is slateGreyHover', () {
        expect(FiftyColors.secondaryHover, FiftyColors.slateGreyHover);
      });

      test('success is hunterGreen', () {
        expect(FiftyColors.success, FiftyColors.hunterGreen);
      });

      test('warning is #F7A100', () {
        expect(FiftyColors.warning, Color(0xFFF7A100));
      });

      test('error is burgundy', () {
        expect(FiftyColors.error, FiftyColors.burgundy);
      });
    });

    group('Mode-Specific Helpers', () {
      test('borderLight is black at 5% opacity', () {
        expect(FiftyColors.borderLight.a, closeTo(0.05, 0.01));
      });

      test('borderDark is white at 5% opacity', () {
        expect(FiftyColors.borderDark.a, closeTo(0.05, 0.01));
      });

      test('focusLight is burgundy', () {
        expect(FiftyColors.focusLight, FiftyColors.burgundy);
      });

      test('focusDark is powderBlush at 50% opacity', () {
        expect(FiftyColors.focusDark.a, closeTo(0.5, 0.01));
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

    test('all v2 colors are non-null', () {
      expect(FiftyColors.burgundy, isNotNull);
      expect(FiftyColors.burgundyHover, isNotNull);
      expect(FiftyColors.cream, isNotNull);
      expect(FiftyColors.darkBurgundy, isNotNull);
      expect(FiftyColors.slateGrey, isNotNull);
      expect(FiftyColors.slateGreyHover, isNotNull);
      expect(FiftyColors.hunterGreen, isNotNull);
      expect(FiftyColors.powderBlush, isNotNull);
      expect(FiftyColors.surfaceLight, isNotNull);
      expect(FiftyColors.surfaceDark, isNotNull);
      expect(FiftyColors.primary, isNotNull);
      expect(FiftyColors.secondary, isNotNull);
      expect(FiftyColors.success, isNotNull);
      expect(FiftyColors.warning, isNotNull);
      expect(FiftyColors.error, isNotNull);
    });
  });
}
