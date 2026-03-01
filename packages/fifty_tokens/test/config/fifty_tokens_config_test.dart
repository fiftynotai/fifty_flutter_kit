import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyTokens', () {
    setUp(() => FiftyTokens.reset());

    group('configure()', () {
      test('applies all categories', () {
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
          typography: FiftyPreset.fdlV2.typography.copyWith(
            fontFamily: 'Inter',
          ),
          spacing: FiftyPreset.fdlV2.spacing.copyWith(base: 8),
          radii: FiftyPreset.fdlV2.radii.copyWith(sm: 6),
          motion: FiftyPreset.fdlV2.motion.copyWith(
            fast: Duration(milliseconds: 200),
          ),
          breakpoints: FiftyPreset.fdlV2.breakpoints.copyWith(desktop: 1280),
        );

        expect(FiftyColors.primary, Color(0xFF0000FF));
        expect(FiftyTypography.fontFamily, 'Inter');
        expect(FiftySpacing.base, 8);
        expect(FiftyRadii.sm, 6);
        expect(FiftyMotion.fast, const Duration(milliseconds: 200));
        expect(FiftyBreakpoints.desktop, 1280);
      });

      test('applies partial categories', () {
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
        );

        expect(FiftyColors.primary, Color(0xFF0000FF));
        // Others stay at defaults
        expect(FiftyTypography.fontFamily, 'Manrope');
        expect(FiftySpacing.base, 4);
        expect(FiftyRadii.sm, 4);
        expect(FiftyMotion.fast, const Duration(milliseconds: 150));
        expect(FiftyBreakpoints.desktop, 1024);
      });

      test('multiple calls replace previous config per category', () {
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
        );
        expect(FiftyColors.primary, Color(0xFF0000FF));

        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF00FF00),
          ),
        );
        expect(FiftyColors.primary, Color(0xFF00FF00));
      });

      test('configure then reset then configure again', () {
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
        );
        expect(FiftyColors.primary, Color(0xFF0000FF));

        FiftyTokens.reset();
        expect(FiftyColors.primary, Color(0xFF88292F));

        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF00FF00),
          ),
        );
        expect(FiftyColors.primary, Color(0xFF00FF00));
      });
    });

    group('reset()', () {
      test('clears all config', () {
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
          typography: FiftyPreset.fdlV2.typography.copyWith(
            fontFamily: 'Inter',
          ),
          spacing: FiftyPreset.fdlV2.spacing.copyWith(base: 8),
          radii: FiftyPreset.fdlV2.radii.copyWith(sm: 6),
          motion: FiftyPreset.fdlV2.motion.copyWith(
            fast: Duration(milliseconds: 200),
          ),
          breakpoints: FiftyPreset.fdlV2.breakpoints.copyWith(desktop: 1280),
        );

        FiftyTokens.reset();

        expect(FiftyColors.primary, Color(0xFF88292F));
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
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
        );
        expect(FiftyTokens.isConfigured, isTrue);
      });

      test('returns false after reset', () {
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
        );
        FiftyTokens.reset();
        expect(FiftyTokens.isConfigured, isFalse);
      });
    });

    group('load()', () {
      test('loads a complete preset', () {
        final preset = FiftyPreset.fdlV2.copyWith(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
          spacing: FiftyPreset.fdlV2.spacing.copyWith(base: 8),
        );

        FiftyTokens.load(preset);

        expect(FiftyColors.primary, const Color(0xFF0000FF));
        expect(FiftySpacing.base, 8);
        // Other categories from fdlV2
        expect(FiftyTypography.fontFamily, 'Manrope');
      });

      test('load sets isConfigured to true', () {
        FiftyTokens.load(FiftyPreset.fdlV2.copyWith(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
        ));

        expect(FiftyTokens.isConfigured, isTrue);
      });
    });

    group('active', () {
      test('returns fdlV2 by default', () {
        final active = FiftyTokens.active;
        expect(active.colors.primary, FiftyPreset.fdlV2.colors.primary);
        expect(
          active.typography.fontFamily,
          FiftyPreset.fdlV2.typography.fontFamily,
        );
      });

      test('returns loaded preset after load()', () {
        final custom = FiftyPreset.fdlV2.copyWith(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFFAABBCC),
          ),
        );
        FiftyTokens.load(custom);

        expect(FiftyTokens.active.colors.primary, const Color(0xFFAABBCC));
      });

      test('returns updated preset after configure()', () {
        FiftyTokens.configure(
          spacing: FiftyPreset.fdlV2.spacing.copyWith(base: 16),
        );

        expect(FiftyTokens.active.spacing.base, 16);
      });

      test('returns fdlV2 after reset()', () {
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
        );
        FiftyTokens.reset();

        expect(
          FiftyTokens.active.colors.primary,
          FiftyPreset.fdlV2.colors.primary,
        );
      });
    });
  });
}
