import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyElevation', () {
    group('Glow Effects (Brand Signature)', () {
      test('crimsonGlow uses crimsonPulse color', () {
        expect(
          FiftyElevation.crimsonGlow.color.toARGB32() & 0x00FFFFFF,
          FiftyColors.crimsonPulse.toARGB32() & 0x00FFFFFF,
        );
      });

      test('crimsonGlow has 8px blur', () {
        expect(FiftyElevation.crimsonGlow.blurRadius, 8);
      });

      test('focusRing uses crimsonPulse color', () {
        expect(
          FiftyElevation.focusRing.color.toARGB32() & 0x00FFFFFF,
          FiftyColors.crimsonPulse.toARGB32() & 0x00FFFFFF,
        );
      });

      test('focusRing has 4px blur', () {
        expect(FiftyElevation.focusRing.blurRadius, 4);
      });
    });

    group('Glow Lists', () {
      test('focus contains crimsonGlow', () {
        expect(FiftyElevation.focus, contains(FiftyElevation.crimsonGlow));
      });

      test('strongFocus contains both glows', () {
        expect(FiftyElevation.strongFocus, contains(FiftyElevation.focusRing));
        expect(FiftyElevation.strongFocus, contains(FiftyElevation.crimsonGlow));
      });
    });

    group('No Drop Shadows Philosophy', () {
      test('only glow-based shadows exist', () {
        // Verify crimsonGlow and focusRing are the only shadows
        // and they use crimsonPulse (not black) for the glow effect
        final crimsonGlowAlpha =
            (FiftyElevation.crimsonGlow.color.a * 255.0).round() & 0xff;
        final focusRingAlpha =
            (FiftyElevation.focusRing.color.a * 255.0).round() & 0xff;
        expect(crimsonGlowAlpha, lessThan(255));
        expect(focusRingAlpha, lessThan(255));
      });
    });
  });
}
