import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyShadows', () {
    group('Shadow Tokens (v2)', () {
      test('sm has correct offset and blur', () {
        expect(FiftyShadows.sm.length, 1);
        expect(FiftyShadows.sm[0].offset, const Offset(0, 1));
        expect(FiftyShadows.sm[0].blurRadius, 2);
      });

      test('md has correct offset and blur', () {
        expect(FiftyShadows.md.length, 1);
        expect(FiftyShadows.md[0].offset, const Offset(0, 4));
        expect(FiftyShadows.md[0].blurRadius, 6);
      });

      test('lg has correct offset and blur', () {
        expect(FiftyShadows.lg.length, 1);
        expect(FiftyShadows.lg[0].offset, const Offset(0, 10));
        expect(FiftyShadows.lg[0].blurRadius, 15);
      });

      test('primary uses burgundy color', () {
        final primary = FiftyShadows.primary;
        expect(primary.length, 1);
        expect(primary[0].blurRadius, 14);
        // Check that color is based on burgundy
        expect(
          primary[0].color.toARGB32() & 0x00FFFFFF,
          FiftyColors.burgundy.toARGB32() & 0x00FFFFFF,
        );
      });

      test('glow uses cream color', () {
        final glow = FiftyShadows.glow;
        expect(glow.length, 1);
        expect(glow[0].blurRadius, 15);
        // Check that color is based on cream
        expect(
          glow[0].color.toARGB32() & 0x00FFFFFF,
          FiftyColors.cream.toARGB32() & 0x00FFFFFF,
        );
      });

      test('none is empty list', () {
        expect(FiftyShadows.none, isEmpty);
      });
    });

    group('Shadow Opacity', () {
      test('sm has 5% opacity', () {
        final alpha = (FiftyShadows.sm[0].color.a * 255.0).round();
        expect(alpha, closeTo(13, 1)); // 5% of 255 = ~13
      });

      test('md has 7% opacity', () {
        final alpha = (FiftyShadows.md[0].color.a * 255.0).round();
        expect(alpha, closeTo(18, 1)); // 7% of 255 = ~18
      });

      test('lg has 10% opacity', () {
        final alpha = (FiftyShadows.lg[0].color.a * 255.0).round();
        expect(alpha, closeTo(26, 1)); // 10% of 255 = ~26
      });
    });
  });

  group('FiftyElevation (deprecated)', () {
    test('focusGlow returns list with shadow', () {
      // ignore: deprecated_member_use_from_same_package
      final glow = FiftyElevation.focusGlow(FiftyColors.burgundy);
      expect(glow.length, 1);
      expect(glow[0].blurRadius, 8);
    });

    test('scanlineOverlay returns empty widget', () {
      // ignore: deprecated_member_use_from_same_package
      final widget = FiftyElevation.scanlineOverlay();
      expect(widget, isA<SizedBox>());
    });
  });
}
