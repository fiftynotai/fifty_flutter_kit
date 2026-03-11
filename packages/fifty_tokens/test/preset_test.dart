import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyPreset', () {
    group('fdlV2', () {
      test('colors have correct FDL values', () {
        final colors = FiftyPreset.fdlV2.colors;
        expect(colors.primary, const Color(0xFF88292F));
        expect(colors.primaryHover, const Color(0xFF6E2126));
        expect(colors.background, const Color(0xFFFEFEE3));
        expect(colors.backgroundDark, const Color(0xFF1A0D0E));
        expect(colors.secondary, const Color(0xFF335C67));
        expect(colors.secondaryHover, const Color(0xFF274750));
        expect(colors.success, const Color(0xFF4B644A));
        expect(colors.accent, const Color(0xFFFFC9B9));
        expect(colors.surface, const Color(0xFFFAF9DE));
        expect(colors.surfaceDark, const Color(0xFF2A1517));
        expect(colors.warning, const Color(0xFFF7A100));
        expect(colors.error, const Color(0xFF88292F));
        expect(colors.onPrimary, const Color(0xFFFEFEE3));
        expect(colors.onBackground, const Color(0xFF1A0D0E));
        expect(colors.borderOpacity, closeTo(0.05, 0.001));
        expect(colors.focusOpacity, closeTo(0.5, 0.001));
      });

      test('typography has correct FDL values', () {
        final typo = FiftyPreset.fdlV2.typography;
        expect(typo.fontFamily, 'Manrope');
        expect(typo.fontSource, FontSource.googleFonts);
        expect(typo.regular, FontWeight.w400);
        expect(typo.medium, FontWeight.w500);
        expect(typo.semiBold, FontWeight.w600);
        expect(typo.bold, FontWeight.w700);
        expect(typo.extraBold, FontWeight.w800);
        expect(typo.displayLarge, 32);
        expect(typo.displayMedium, 24);
        expect(typo.titleLarge, 20);
        expect(typo.titleMedium, 18);
        expect(typo.titleSmall, 16);
        expect(typo.bodyLarge, 16);
        expect(typo.bodyMedium, 14);
        expect(typo.bodySmall, 12);
        expect(typo.labelLarge, 14);
        expect(typo.labelMedium, 12);
        expect(typo.labelSmall, 10);
        expect(typo.letterSpacingDisplay, -0.5);
        expect(typo.letterSpacingDisplayMedium, -0.25);
        expect(typo.letterSpacingBody, 0.5);
        expect(typo.letterSpacingBodyMedium, 0.25);
        expect(typo.letterSpacingBodySmall, 0.4);
        expect(typo.letterSpacingLabel, 0.5);
        expect(typo.letterSpacingLabelMedium, 1.5);
        expect(typo.lineHeightDisplay, 1.2);
        expect(typo.lineHeightTitle, 1.3);
        expect(typo.lineHeightBody, 1.5);
        expect(typo.lineHeightLabel, 1.2);
      });

      test('spacing has correct FDL values', () {
        final spacing = FiftyPreset.fdlV2.spacing;
        expect(spacing.base, 4);
        expect(spacing.tight, 8);
        expect(spacing.standard, 12);
        expect(spacing.xxs, 2);
        expect(spacing.xs, 4);
        expect(spacing.sm, 8);
        expect(spacing.md, 12);
        expect(spacing.lg, 16);
        expect(spacing.xl, 20);
        expect(spacing.xxl, 24);
        expect(spacing.xxxl, 32);
        expect(spacing.huge, 40);
        expect(spacing.massive, 48);
        expect(spacing.gutterDesktop, 24);
        expect(spacing.gutterTablet, 16);
        expect(spacing.gutterMobile, 12);
      });

      test('radii has correct FDL values', () {
        final radii = FiftyPreset.fdlV2.radii;
        expect(radii.none, 0);
        expect(radii.sm, 4);
        expect(radii.md, 8);
        expect(radii.lg, 12);
        expect(radii.xl, 16);
        expect(radii.xxl, 24);
        expect(radii.xxxl, 32);
        expect(radii.full, 9999);
      });

      test('motion has correct FDL values', () {
        final motion = FiftyPreset.fdlV2.motion;
        expect(motion.instant, Duration.zero);
        expect(motion.fast, const Duration(milliseconds: 150));
        expect(motion.compiling, const Duration(milliseconds: 300));
        expect(motion.systemLoad, const Duration(milliseconds: 800));
        expect(motion.standard, isA<Cubic>());
        expect(motion.enter, isA<Cubic>());
        expect(motion.exit, isA<Cubic>());
      });

      test('shadows has correct FDL values', () {
        final shadows = FiftyPreset.fdlV2.shadows;
        expect(shadows.sm.length, 1);
        expect(shadows.sm.first.offset, const Offset(0, 1));
        expect(shadows.sm.first.blurRadius, 2);
        expect(shadows.md.length, 1);
        expect(shadows.md.first.offset, const Offset(0, 4));
        expect(shadows.lg.length, 1);
        expect(shadows.lg.first.offset, const Offset(0, 10));
        expect(shadows.primaryOpacity, 0.2);
        expect(shadows.glowOpacity, 0.1);
      });

      test('gradients has correct FDL values', () {
        final gradients = FiftyPreset.fdlV2.gradients;
        expect(gradients.primaryEnd, const Color(0xFF5A1B1F));
      });

      test('breakpoints has correct FDL values', () {
        final breakpoints = FiftyPreset.fdlV2.breakpoints;
        expect(breakpoints.mobile, 768);
        expect(breakpoints.tablet, 768);
        expect(breakpoints.desktop, 1024);
      });

      test('iconSizes has correct FDL values', () {
        final iconSizes = FiftyPreset.fdlV2.iconSizes;
        expect(iconSizes.sm, 16);
        expect(iconSizes.md, 20);
        expect(iconSizes.lg, 24);
        expect(iconSizes.xl, 36);
        expect(iconSizes.xxl, 44);
        expect(iconSizes.hero, 48);
      });
    });

    group('fromMap()', () {
      test('empty map returns fdlV2 values', () {
        final preset = FiftyPreset.fromMap({});

        expect(preset.colors.primary, FiftyPreset.fdlV2.colors.primary);
        expect(
          preset.typography.fontFamily,
          FiftyPreset.fdlV2.typography.fontFamily,
        );
        expect(preset.spacing.base, FiftyPreset.fdlV2.spacing.base);
        expect(preset.radii.sm, FiftyPreset.fdlV2.radii.sm);
        expect(preset.motion.fast, FiftyPreset.fdlV2.motion.fast);
        expect(
          preset.shadows.primaryOpacity,
          FiftyPreset.fdlV2.shadows.primaryOpacity,
        );
        expect(
          preset.gradients.primaryEnd,
          FiftyPreset.fdlV2.gradients.primaryEnd,
        );
        expect(
          preset.breakpoints.desktop,
          FiftyPreset.fdlV2.breakpoints.desktop,
        );
        expect(
          preset.iconSizes.sm,
          FiftyPreset.fdlV2.iconSizes.sm,
        );
      });

      test('partial data uses fallback for missing categories', () {
        final preset = FiftyPreset.fromMap({
          'colors': {'primary': 0xFF0000FF},
          'spacing': {'base': 8},
        });

        expect(preset.colors.primary, const Color(0xFF0000FF));
        expect(preset.spacing.base, 8);
        // Other categories unchanged
        expect(
          preset.typography.fontFamily,
          FiftyPreset.fdlV2.typography.fontFamily,
        );
        expect(preset.radii.sm, FiftyPreset.fdlV2.radii.sm);
        expect(preset.motion.fast, FiftyPreset.fdlV2.motion.fast);
        expect(preset.iconSizes.sm, FiftyPreset.fdlV2.iconSizes.sm);
      });

      test('partial color data uses fallback for missing fields', () {
        final preset = FiftyPreset.fromMap({
          'colors': {'primary': 0xFF0000FF},
        });

        expect(preset.colors.primary, const Color(0xFF0000FF));
        expect(
          preset.colors.background,
          FiftyPreset.fdlV2.colors.background,
        );
        expect(
          preset.colors.secondary,
          FiftyPreset.fdlV2.colors.secondary,
        );
      });

      test('custom fallback preset is used', () {
        final customFallback = FiftyPreset(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFFAAAAAA),
          ),
          typography: FiftyPreset.fdlV2.typography.copyWith(
            fontFamily: 'CustomFont',
          ),
          spacing: FiftyPreset.fdlV2.spacing.copyWith(base: 8),
          radii: FiftyPreset.fdlV2.radii.copyWith(sm: 6),
          motion: FiftyPreset.fdlV2.motion.copyWith(
            fast: Duration(milliseconds: 200),
          ),
          shadows: FiftyShadowsConfig(
            sm: [],
            md: [],
            lg: [],
            primaryOpacity: 0.5,
            glowOpacity: 0.3,
          ),
          gradients: FiftyGradientsConfig(
            primaryEnd: Color(0xFF112233),
          ),
          breakpoints: FiftyPreset.fdlV2.breakpoints.copyWith(desktop: 1280),
          iconSizes: FiftyPreset.fdlV2.iconSizes.copyWith(sm: 12),
        );

        final preset = FiftyPreset.fromMap({}, fallback: customFallback);

        expect(preset.colors.primary, const Color(0xFFAAAAAA));
        expect(preset.typography.fontFamily, 'CustomFont');
        expect(preset.spacing.base, 8);
        expect(preset.radii.sm, 6);
        expect(preset.motion.fast, const Duration(milliseconds: 200));
        expect(preset.shadows.primaryOpacity, 0.5);
        expect(preset.gradients.primaryEnd, const Color(0xFF112233));
        expect(preset.breakpoints.desktop, 1280);
        expect(preset.iconSizes.sm, 12);
      });

      test('iconSizes data in map is parsed', () {
        final preset = FiftyPreset.fromMap({
          'iconSizes': {'sm': 10, 'hero': 64},
        });

        expect(preset.iconSizes.sm, 10);
        expect(preset.iconSizes.hero, 64);
        // Fallback for unset fields
        expect(preset.iconSizes.md, FiftyPreset.fdlV2.iconSizes.md);
      });
    });

    group('copyWith()', () {
      test('replaces individual categories', () {
        final custom = FiftyPreset.fdlV2.copyWith(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
        );

        expect(custom.colors.primary, const Color(0xFF0000FF));
        // Other categories unchanged
        expect(custom.typography.fontFamily, 'Manrope');
        expect(custom.spacing.base, 4);
      });

      test('replaces multiple categories', () {
        final custom = FiftyPreset.fdlV2.copyWith(
          colors: FiftyPreset.fdlV2.colors.copyWith(
            primary: Color(0xFF0000FF),
          ),
          spacing: FiftyPreset.fdlV2.spacing.copyWith(base: 8),
        );

        expect(custom.colors.primary, const Color(0xFF0000FF));
        expect(custom.spacing.base, 8);
        expect(custom.typography.fontFamily, 'Manrope');
      });

      test('replaces iconSizes category', () {
        final custom = FiftyPreset.fdlV2.copyWith(
          iconSizes: FiftyPreset.fdlV2.iconSizes.copyWith(sm: 12),
        );

        expect(custom.iconSizes.sm, 12);
        expect(custom.iconSizes.md, FiftyPreset.fdlV2.iconSizes.md);
        // Other categories unchanged
        expect(custom.colors.primary, FiftyPreset.fdlV2.colors.primary);
      });

      test('no arguments returns equivalent preset', () {
        final copy = FiftyPreset.fdlV2.copyWith();

        expect(copy.colors.primary, FiftyPreset.fdlV2.colors.primary);
        expect(
          copy.typography.fontFamily,
          FiftyPreset.fdlV2.typography.fontFamily,
        );
        expect(copy.spacing.base, FiftyPreset.fdlV2.spacing.base);
        expect(copy.radii.sm, FiftyPreset.fdlV2.radii.sm);
        expect(copy.motion.fast, FiftyPreset.fdlV2.motion.fast);
        expect(
          copy.shadows.primaryOpacity,
          FiftyPreset.fdlV2.shadows.primaryOpacity,
        );
        expect(
          copy.gradients.primaryEnd,
          FiftyPreset.fdlV2.gradients.primaryEnd,
        );
        expect(
          copy.breakpoints.desktop,
          FiftyPreset.fdlV2.breakpoints.desktop,
        );
        expect(
          copy.iconSizes.sm,
          FiftyPreset.fdlV2.iconSizes.sm,
        );
      });
    });
  });
}
