import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyGradientsConfig', () {
    const defaultConfig = FiftyGradientsConfig(
      primaryEnd: Color(0xFF5A1B1F),
    );

    group('construction', () {
      test('stores primaryEnd', () {
        expect(defaultConfig.primaryEnd, const Color(0xFF5A1B1F));
      });
    });

    group('fromMap()', () {
      test('full map overrides primaryEnd', () {
        final config = FiftyGradientsConfig.fromMap(
          {'primaryEnd': 0xFF00FF00},
          fallback: defaultConfig,
        );

        expect(config.primaryEnd, const Color(0xFF00FF00));
      });

      test('empty map returns fallback values', () {
        final config = FiftyGradientsConfig.fromMap(
          {},
          fallback: defaultConfig,
        );

        expect(config.primaryEnd, const Color(0xFF5A1B1F));
      });

      test('parses hex string color', () {
        final config = FiftyGradientsConfig.fromMap(
          {'primaryEnd': '#FF0000'},
          fallback: defaultConfig,
        );

        expect(config.primaryEnd, const Color(0xFFFF0000));
      });

      test('parses 0x-prefixed hex string', () {
        final config = FiftyGradientsConfig.fromMap(
          {'primaryEnd': '0xFFAABBCC'},
          fallback: defaultConfig,
        );

        expect(config.primaryEnd, const Color(0xFFAABBCC));
      });

      test('throws on invalid color value', () {
        expect(
          () => FiftyGradientsConfig.fromMap(
            {'primaryEnd': true},
            fallback: defaultConfig,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('copyWith()', () {
      test('replaces primaryEnd', () {
        final copy = defaultConfig.copyWith(
          primaryEnd: const Color(0xFF112233),
        );

        expect(copy.primaryEnd, const Color(0xFF112233));
      });

      test('no arguments returns equivalent config', () {
        final copy = defaultConfig.copyWith();

        expect(copy.primaryEnd, defaultConfig.primaryEnd);
      });
    });
  });
}
