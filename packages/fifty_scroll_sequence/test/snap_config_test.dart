import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SnapConfig', () {
    group('default constructor', () {
      test('snapPoints are sorted after construction', () {
        final config = SnapConfig(snapPoints: [0.8, 0.2, 0.5, 1.0, 0.0]);
        expect(config.snapPoints, [0.0, 0.2, 0.5, 0.8, 1.0]);
      });

      test('empty list throws assertion error', () {
        expect(
          () => SnapConfig(snapPoints: []),
          throwsA(isA<AssertionError>()),
        );
      });

      test('points below 0.0 throw assertion error', () {
        expect(
          () => SnapConfig(snapPoints: [-0.1, 0.5]),
          throwsA(isA<AssertionError>()),
        );
      });

      test('points above 1.0 throw assertion error', () {
        expect(
          () => SnapConfig(snapPoints: [0.5, 1.1]),
          throwsA(isA<AssertionError>()),
        );
      });

      test('snapDuration uses default', () {
        final config = SnapConfig(snapPoints: [0.0, 1.0]);
        expect(config.snapDuration, const Duration(milliseconds: 300));
      });

      test('snapCurve uses default', () {
        final config = SnapConfig(snapPoints: [0.0, 1.0]);
        expect(config.snapCurve, Curves.easeOut);
      });

      test('idleTimeout uses default', () {
        final config = SnapConfig(snapPoints: [0.0, 1.0]);
        expect(config.idleTimeout, const Duration(milliseconds: 150));
      });
    });

    group('nearestSnapPoint', () {
      test('returns first point when below all points', () {
        final config = SnapConfig(snapPoints: [0.2, 0.5, 0.8]);
        expect(config.nearestSnapPoint(0.0), 0.2);
      });

      test('returns last point when above all points', () {
        final config = SnapConfig(snapPoints: [0.2, 0.5, 0.8]);
        expect(config.nearestSnapPoint(1.0), 0.8);
      });

      test('returns correct point when between two points', () {
        final config = SnapConfig(snapPoints: [0.0, 0.5, 1.0]);
        // 0.3 is closer to 0.0 (distance 0.3) than to 0.5 (distance 0.2)
        // Actually 0.3 is closer to 0.5 (0.2) than to 0.0 (0.3)
        expect(config.nearestSnapPoint(0.3), 0.5);
      });

      test('prefers lower point when equidistant', () {
        final config = SnapConfig(snapPoints: [0.0, 0.4, 0.8]);
        // 0.6 is exactly equidistant from 0.4 and 0.8 (distance 0.2 each)
        expect(config.nearestSnapPoint(0.6), 0.4);
      });

      test('returns exact match', () {
        final config = SnapConfig(snapPoints: [0.0, 0.5, 1.0]);
        expect(config.nearestSnapPoint(0.5), 0.5);
      });

      test('returns the only point when single point', () {
        final config = SnapConfig(snapPoints: [0.5]);
        expect(config.nearestSnapPoint(0.0), 0.5);
        expect(config.nearestSnapPoint(1.0), 0.5);
        expect(config.nearestSnapPoint(0.5), 0.5);
      });
    });

    group('everyNFrames', () {
      test('n=50, frameCount=150 generates correct points', () {
        final config = SnapConfig.everyNFrames(n: 50, frameCount: 150);
        // maxIndex = 149, frames at 0, 50, 100 -> progress 0/149, 50/149, 100/149, 1.0
        expect(config.snapPoints.length, 4);
        expect(config.snapPoints[0], closeTo(0.0, 0.001));
        expect(config.snapPoints[1], closeTo(50 / 149, 0.001));
        expect(config.snapPoints[2], closeTo(100 / 149, 0.001));
        expect(config.snapPoints[3], closeTo(1.0, 0.001));
      });

      test('n=1, frameCount=5 generates a point for every frame', () {
        final config = SnapConfig.everyNFrames(n: 1, frameCount: 5);
        // maxIndex = 4, frames at 0, 1, 2, 3, 4 -> progress 0/4, 1/4, 2/4, 3/4, 4/4
        expect(config.snapPoints.length, 5);
        expect(config.snapPoints[0], 0.0);
        expect(config.snapPoints[4], 1.0);
      });

      test('n > frameCount-1 generates [0.0, 1.0]', () {
        final config = SnapConfig.everyNFrames(n: 200, frameCount: 10);
        // maxIndex = 9, only frame 0 in the loop -> progress 0.0, then 1.0 appended
        expect(config.snapPoints, [0.0, 1.0]);
      });

      test('frameCount=1 generates [0.0]', () {
        final config = SnapConfig.everyNFrames(n: 1, frameCount: 1);
        // maxIndex = 0, only frame 0, progress = 0.0
        expect(config.snapPoints, [0.0]);
      });

      test('n=0 throws assertion', () {
        expect(
          () => SnapConfig.everyNFrames(n: 0, frameCount: 10),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('scenes', () {
      test('converts scene start frames correctly', () {
        final config = SnapConfig.scenes(
          sceneStartFrames: [0, 50, 100, 148],
          frameCount: 149,
        );
        // maxIndex = 148
        // points: 0/148, 50/148, 100/148, 148/148
        expect(config.snapPoints.length, 4);
        expect(config.snapPoints[0], closeTo(0.0, 0.001));
        expect(config.snapPoints[1], closeTo(50 / 148, 0.001));
        expect(config.snapPoints[2], closeTo(100 / 148, 0.001));
        expect(config.snapPoints[3], closeTo(1.0, 0.001));
      });

      test('single scene [0] generates [0.0]', () {
        final config = SnapConfig.scenes(
          sceneStartFrames: [0],
          frameCount: 100,
        );
        expect(config.snapPoints, [0.0]);
      });

      test('duplicate indices are deduplicated', () {
        final config = SnapConfig.scenes(
          sceneStartFrames: [0, 50, 50, 100],
          frameCount: 101,
        );
        // maxIndex = 100; 0/100, 50/100, 100/100
        expect(config.snapPoints.length, 3);
      });

      test('out-of-range indices are clamped', () {
        final config = SnapConfig.scenes(
          sceneStartFrames: [-10, 200],
          frameCount: 100,
        );
        // maxIndex = 99
        // -10 clamped to 0 -> 0/99 = 0.0
        // 200 clamped to 99 -> 99/99 = 1.0
        expect(config.snapPoints.length, 2);
        expect(config.snapPoints[0], closeTo(0.0, 0.001));
        expect(config.snapPoints[1], closeTo(1.0, 0.001));
      });

      test('empty list throws assertion', () {
        expect(
          () => SnapConfig.scenes(
            sceneStartFrames: [],
            frameCount: 100,
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('equality / hashCode', () {
      test('same config equals', () {
        final a = SnapConfig(snapPoints: [0.0, 0.5, 1.0]);
        final b = SnapConfig(snapPoints: [0.0, 0.5, 1.0]);
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('different snapPoints not equals', () {
        final a = SnapConfig(snapPoints: [0.0, 0.5, 1.0]);
        final b = SnapConfig(snapPoints: [0.0, 0.3, 1.0]);
        expect(a, isNot(equals(b)));
      });

      test('different duration not equals', () {
        final a = SnapConfig(
          snapPoints: [0.0, 1.0],
          snapDuration: const Duration(milliseconds: 300),
        );
        final b = SnapConfig(
          snapPoints: [0.0, 1.0],
          snapDuration: const Duration(milliseconds: 500),
        );
        expect(a, isNot(equals(b)));
      });
    });
  });
}
