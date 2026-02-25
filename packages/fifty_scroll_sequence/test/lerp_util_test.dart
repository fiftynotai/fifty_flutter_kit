import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LerpUtil', () {
    group('lerp', () {
      test('moves 15% of the distance at factor 0.15', () {
        expect(LerpUtil.lerp(0.0, 1.0, 0.15), closeTo(0.15, 1e-10));
      });

      test('moves from midpoint correctly', () {
        // 0.5 + (1.0 - 0.5) * 0.15 = 0.5 + 0.075 = 0.575
        expect(LerpUtil.lerp(0.5, 1.0, 0.15), closeTo(0.575, 1e-10));
      });

      test('snaps to target when within snapThreshold', () {
        expect(LerpUtil.lerp(0.9995, 1.0, 0.15), 1.0);
      });

      test('returns target when already at target', () {
        expect(LerpUtil.lerp(0.0, 0.0, 0.15), 0.0);
      });

      test('handles backward lerp (target < current)', () {
        // 1.0 + (0.0 - 1.0) * 0.15 = 1.0 - 0.15 = 0.85
        expect(LerpUtil.lerp(1.0, 0.0, 0.15), closeTo(0.85, 1e-10));
      });

      test('factor 1.0 jumps directly to target', () {
        // 0.0 + (1.0 - 0.0) * 1.0 = 1.0
        expect(LerpUtil.lerp(0.0, 1.0, 1.0), 1.0);
      });

      test('factor 0.01 moves slowly', () {
        // 0.0 + (1.0 - 0.0) * 0.01 = 0.01
        expect(LerpUtil.lerp(0.0, 1.0, 0.01), closeTo(0.01, 1e-10));
      });
    });

    group('hasConverged', () {
      test('returns true when values are equal', () {
        expect(LerpUtil.hasConverged(0.0, 0.0), isTrue);
      });

      test('returns true when within threshold', () {
        expect(LerpUtil.hasConverged(0.9995, 1.0), isTrue);
      });

      test('returns false when above threshold', () {
        expect(LerpUtil.hasConverged(0.0, 0.01), isFalse);
      });

      test('returns false for large difference', () {
        expect(LerpUtil.hasConverged(0.0, 1.0), isFalse);
      });

      test('works symmetrically', () {
        expect(LerpUtil.hasConverged(1.0, 0.9995), isTrue);
      });
    });

    group('convergence', () {
      test('converges from 0.0 to 1.0 within 60 iterations at factor 0.15',
          () {
        double current = 0.0;
        const target = 1.0;
        int iterations = 0;

        while (!LerpUtil.hasConverged(current, target) && iterations < 60) {
          current = LerpUtil.lerp(current, target, 0.15);
          iterations++;
        }

        expect(LerpUtil.hasConverged(current, target), isTrue);
        expect(iterations, lessThan(60));
      });

      test('converges from 1.0 to 0.0 within 60 iterations at factor 0.15',
          () {
        double current = 1.0;
        const target = 0.0;
        int iterations = 0;

        while (!LerpUtil.hasConverged(current, target) && iterations < 60) {
          current = LerpUtil.lerp(current, target, 0.15);
          iterations++;
        }

        expect(LerpUtil.hasConverged(current, target), isTrue);
        expect(iterations, lessThan(60));
      });
    });
  });
}
