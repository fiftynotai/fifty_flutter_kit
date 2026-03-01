import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyMotionConfig', () {
    setUp(() => FiftyTokens.reset());

    group('default durations and curves', () {
      test('default durations', () {
        expect(FiftyMotion.instant, Duration.zero);
        expect(FiftyMotion.fast, const Duration(milliseconds: 150));
        expect(FiftyMotion.compiling, const Duration(milliseconds: 300));
        expect(FiftyMotion.systemLoad, const Duration(milliseconds: 800));
      });

      test('default curves', () {
        expect(FiftyMotion.standard, isA<Cubic>());
        expect(FiftyMotion.enter, isA<Cubic>());
        expect(FiftyMotion.exit, isA<Cubic>());
      });
    });

    group('fromMap()', () {
      final fallback = FiftyPreset.fdlV2.motion;

      test('full valid map overrides durations', () {
        final config = FiftyMotionConfig.fromMap(
          {
            'instant': 50,
            'fast': 100,
            'compiling': 200,
            'systemLoad': 500,
          },
          fallback: fallback,
        );

        expect(config.instant, const Duration(milliseconds: 50));
        expect(config.fast, const Duration(milliseconds: 100));
        expect(config.compiling, const Duration(milliseconds: 200));
        expect(config.systemLoad, const Duration(milliseconds: 500));
      });

      test('empty map returns all fallback values', () {
        final config = FiftyMotionConfig.fromMap({}, fallback: fallback);

        expect(config.instant, fallback.instant);
        expect(config.fast, fallback.fast);
        expect(config.compiling, fallback.compiling);
        expect(config.systemLoad, fallback.systemLoad);
        expect(config.standard, fallback.standard);
        expect(config.enter, fallback.enter);
        expect(config.exit, fallback.exit);
      });

      test('partial map uses fallback for missing keys', () {
        final config = FiftyMotionConfig.fromMap(
          {'fast': 200},
          fallback: fallback,
        );

        expect(config.fast, const Duration(milliseconds: 200));
        expect(config.instant, fallback.instant);
        expect(config.compiling, fallback.compiling);
      });

      test('always uses fallback curves (not parseable from JSON)', () {
        final config = FiftyMotionConfig.fromMap(
          {
            'standard': 'easeInOut',
            'enter': 'easeIn',
            'exit': 'easeOut',
          },
          fallback: fallback,
        );

        expect(config.standard, fallback.standard);
        expect(config.enter, fallback.enter);
        expect(config.exit, fallback.exit);
      });

      test('non-int duration value uses fallback', () {
        final config = FiftyMotionConfig.fromMap(
          {'fast': 'abc'},
          fallback: fallback,
        );

        expect(config.fast, fallback.fast);
      });

      test('null duration value uses fallback', () {
        final config = FiftyMotionConfig.fromMap(
          {'fast': null},
          fallback: fallback,
        );

        expect(config.fast, fallback.fast);
      });
    });

    group('override durations', () {
      test('override fast', () {
        FiftyTokens.configure(
          motion: FiftyPreset.fdlV2.motion.copyWith(
            fast: Duration(milliseconds: 200),
          ),
        );
        expect(FiftyMotion.fast, const Duration(milliseconds: 200));
        // Others unchanged
        expect(FiftyMotion.compiling, const Duration(milliseconds: 300));
      });

      test('override all durations', () {
        FiftyTokens.configure(
          motion: FiftyPreset.fdlV2.motion.copyWith(
            instant: Duration(milliseconds: 50),
            fast: Duration(milliseconds: 100),
            compiling: Duration(milliseconds: 200),
            systemLoad: Duration(milliseconds: 500),
          ),
        );
        expect(FiftyMotion.instant, const Duration(milliseconds: 50));
        expect(FiftyMotion.fast, const Duration(milliseconds: 100));
        expect(FiftyMotion.compiling, const Duration(milliseconds: 200));
        expect(FiftyMotion.systemLoad, const Duration(milliseconds: 500));
      });
    });

    group('override curves', () {
      test('override standard curve', () {
        FiftyTokens.configure(
          motion: FiftyPreset.fdlV2.motion.copyWith(
            standard: Curves.easeInOut,
          ),
        );
        expect(FiftyMotion.standard, Curves.easeInOut);
        // Others unchanged
        expect(FiftyMotion.enter, isA<Cubic>());
      });

      test('override all curves', () {
        FiftyTokens.configure(
          motion: FiftyPreset.fdlV2.motion.copyWith(
            standard: Curves.linear,
            enter: Curves.easeIn,
            exit: Curves.easeOut,
          ),
        );
        expect(FiftyMotion.standard, Curves.linear);
        expect(FiftyMotion.enter, Curves.easeIn);
        expect(FiftyMotion.exit, Curves.easeOut);
      });
    });

    group('reset', () {
      test('reset restores defaults', () {
        FiftyTokens.configure(
          motion: FiftyPreset.fdlV2.motion.copyWith(
            fast: Duration(milliseconds: 200),
            standard: Curves.linear,
          ),
        );

        FiftyTokens.reset();

        expect(FiftyMotion.fast, const Duration(milliseconds: 150));
        expect(FiftyMotion.standard, isA<Cubic>());
      });
    });
  });
}
