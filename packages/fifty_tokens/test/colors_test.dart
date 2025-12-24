import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyColors', () {
    group('Core Palette (FDL Brand Sheet)', () {
      test('voidBlack is #050505', () {
        expect(FiftyColors.voidBlack, const Color(0xFF050505));
      });

      test('crimsonPulse is #960E29', () {
        expect(FiftyColors.crimsonPulse, const Color(0xFF960E29));
      });

      test('gunmetal is #1A1A1A', () {
        expect(FiftyColors.gunmetal, const Color(0xFF1A1A1A));
      });

      test('terminalWhite is #EAEAEA', () {
        expect(FiftyColors.terminalWhite, const Color(0xFFEAEAEA));
      });

      test('hyperChrome is #888888', () {
        expect(FiftyColors.hyperChrome, const Color(0xFF888888));
      });

      test('igrisGreen is #00FF41', () {
        expect(FiftyColors.igrisGreen, const Color(0xFF00FF41));
      });
    });

    group('Derived Colors', () {
      test('border is hyperChrome at 10% opacity', () {
        expect(FiftyColors.border, const Color(0x1A888888));
      });
    });

    group('Semantic Colors', () {
      test('success is #00BA33', () {
        expect(FiftyColors.success, const Color(0xFF00BA33));
      });

      test('warning is #F7A100', () {
        expect(FiftyColors.warning, const Color(0xFFF7A100));
      });

      test('error uses crimsonPulse', () {
        expect(FiftyColors.error, FiftyColors.crimsonPulse);
      });
    });

    test('all colors are non-null', () {
      expect(FiftyColors.voidBlack, isNotNull);
      expect(FiftyColors.crimsonPulse, isNotNull);
      expect(FiftyColors.gunmetal, isNotNull);
      expect(FiftyColors.terminalWhite, isNotNull);
      expect(FiftyColors.hyperChrome, isNotNull);
      expect(FiftyColors.igrisGreen, isNotNull);
      expect(FiftyColors.border, isNotNull);
      expect(FiftyColors.success, isNotNull);
      expect(FiftyColors.warning, isNotNull);
      expect(FiftyColors.error, isNotNull);
    });
  });
}
