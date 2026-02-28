import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyTokens', () {
    setUp(() => FiftyTokens.reset());

    group('configure()', () {
      test('applies all categories', () {
        FiftyTokens.configure(
          colors: const FiftyColorConfig(
            burgundy: Color(0xFF0000FF),
          ),
          typography: const FiftyTypographyConfig(
            fontFamily: 'Inter',
          ),
          spacing: const FiftySpacingConfig(base: 8),
          radii: const FiftyRadiiConfig(sm: 6),
          motion: const FiftyMotionConfig(
            fast: Duration(milliseconds: 200),
          ),
          breakpoints: const FiftyBreakpointsConfig(desktop: 1280),
        );

        expect(FiftyColors.burgundy, Color(0xFF0000FF));
        expect(FiftyTypography.fontFamily, 'Inter');
        expect(FiftySpacing.base, 8);
        expect(FiftyRadii.sm, 6);
        expect(FiftyMotion.fast, const Duration(milliseconds: 200));
        expect(FiftyBreakpoints.desktop, 1280);
      });

      test('applies partial categories', () {
        FiftyTokens.configure(
          colors: const FiftyColorConfig(
            burgundy: Color(0xFF0000FF),
          ),
        );

        expect(FiftyColors.burgundy, Color(0xFF0000FF));
        // Others stay at defaults
        expect(FiftyTypography.fontFamily, 'Manrope');
        expect(FiftySpacing.base, 4);
        expect(FiftyRadii.sm, 4);
        expect(FiftyMotion.fast, const Duration(milliseconds: 150));
        expect(FiftyBreakpoints.desktop, 1024);
      });

      test('multiple calls replace previous config per category', () {
        FiftyTokens.configure(
          colors: const FiftyColorConfig(
            burgundy: Color(0xFF0000FF),
          ),
        );
        expect(FiftyColors.burgundy, Color(0xFF0000FF));

        FiftyTokens.configure(
          colors: const FiftyColorConfig(
            burgundy: Color(0xFF00FF00),
          ),
        );
        expect(FiftyColors.burgundy, Color(0xFF00FF00));
      });

      test('configure then reset then configure again', () {
        FiftyTokens.configure(
          colors: const FiftyColorConfig(
            burgundy: Color(0xFF0000FF),
          ),
        );
        expect(FiftyColors.burgundy, Color(0xFF0000FF));

        FiftyTokens.reset();
        expect(FiftyColors.burgundy, Color(0xFF88292F));

        FiftyTokens.configure(
          colors: const FiftyColorConfig(
            burgundy: Color(0xFF00FF00),
          ),
        );
        expect(FiftyColors.burgundy, Color(0xFF00FF00));
      });
    });

    group('reset()', () {
      test('clears all config', () {
        FiftyTokens.configure(
          colors: const FiftyColorConfig(
            burgundy: Color(0xFF0000FF),
          ),
          typography: const FiftyTypographyConfig(fontFamily: 'Inter'),
          spacing: const FiftySpacingConfig(base: 8),
          radii: const FiftyRadiiConfig(sm: 6),
          motion: const FiftyMotionConfig(
            fast: Duration(milliseconds: 200),
          ),
          breakpoints: const FiftyBreakpointsConfig(desktop: 1280),
        );

        FiftyTokens.reset();

        expect(FiftyColors.burgundy, Color(0xFF88292F));
        expect(FiftyTypography.fontFamily, 'Manrope');
        expect(FiftySpacing.base, 4);
        expect(FiftyRadii.sm, 4);
        expect(FiftyMotion.fast, const Duration(milliseconds: 150));
        expect(FiftyBreakpoints.desktop, 1024);
      });
    });

    group('isConfigured', () {
      test('returns false when no config applied', () {
        expect(FiftyTokens.isConfigured, isFalse);
      });

      test('returns true when any config applied', () {
        FiftyTokens.configure(
          colors: const FiftyColorConfig(
            burgundy: Color(0xFF0000FF),
          ),
        );
        expect(FiftyTokens.isConfigured, isTrue);
      });

      test('returns false after reset', () {
        FiftyTokens.configure(
          colors: const FiftyColorConfig(
            burgundy: Color(0xFF0000FF),
          ),
        );
        FiftyTokens.reset();
        expect(FiftyTokens.isConfigured, isFalse);
      });
    });
  });
}
