import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyMotion', () {
    group('Durations (FDL Brand Sheet)', () {
      test('instant is 0ms', () {
        expect(FiftyMotion.instant, Duration.zero);
      });

      test('fast is 150ms', () {
        expect(FiftyMotion.fast, const Duration(milliseconds: 150));
      });

      test('compiling is 300ms', () {
        expect(FiftyMotion.compiling, const Duration(milliseconds: 300));
      });

      test('systemLoad is 800ms', () {
        expect(FiftyMotion.systemLoad, const Duration(milliseconds: 800));
      });
    });

    group('Easing Curves', () {
      test('standard curve exists', () {
        expect(FiftyMotion.standard, isA<Cubic>());
      });

      test('enter curve exists', () {
        expect(FiftyMotion.enter, isA<Cubic>());
      });

      test('exit curve exists', () {
        expect(FiftyMotion.exit, isA<Cubic>());
      });
    });
  });
}
