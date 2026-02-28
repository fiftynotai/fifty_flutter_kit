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

    group('override durations', () {
      test('override fast', () {
        FiftyTokens.configure(
          motion: const FiftyMotionConfig(
            fast: Duration(milliseconds: 200),
          ),
        );
        expect(FiftyMotion.fast, const Duration(milliseconds: 200));
        // Others unchanged
        expect(FiftyMotion.compiling, const Duration(milliseconds: 300));
      });

      test('override all durations', () {
        FiftyTokens.configure(
          motion: const FiftyMotionConfig(
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
          motion: const FiftyMotionConfig(
            standard: Curves.easeInOut,
          ),
        );
        expect(FiftyMotion.standard, Curves.easeInOut);
        // Others unchanged
        expect(FiftyMotion.enter, isA<Cubic>());
      });

      test('override all curves', () {
        FiftyTokens.configure(
          motion: const FiftyMotionConfig(
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
          motion: const FiftyMotionConfig(
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
