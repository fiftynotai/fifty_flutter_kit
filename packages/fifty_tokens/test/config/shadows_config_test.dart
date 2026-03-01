import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyShadowsConfig', () {
    const defaultConfig = FiftyShadowsConfig(
      sm: [BoxShadow(offset: Offset(0, 1), blurRadius: 2, color: Color(0x0D000000))],
      md: [BoxShadow(offset: Offset(0, 4), blurRadius: 6, color: Color(0x12000000))],
      lg: [BoxShadow(offset: Offset(0, 10), blurRadius: 15, color: Color(0x1A000000))],
      primaryOpacity: 0.2,
      glowOpacity: 0.1,
    );

    group('construction', () {
      test('stores all fields', () {
        expect(defaultConfig.sm.length, 1);
        expect(defaultConfig.md.length, 1);
        expect(defaultConfig.lg.length, 1);
        expect(defaultConfig.primaryOpacity, 0.2);
        expect(defaultConfig.glowOpacity, 0.1);
      });

      test('sm shadow has correct values', () {
        final shadow = defaultConfig.sm.first;
        expect(shadow.offset, const Offset(0, 1));
        expect(shadow.blurRadius, 2);
      });

      test('md shadow has correct values', () {
        final shadow = defaultConfig.md.first;
        expect(shadow.offset, const Offset(0, 4));
        expect(shadow.blurRadius, 6);
      });

      test('lg shadow has correct values', () {
        final shadow = defaultConfig.lg.first;
        expect(shadow.offset, const Offset(0, 10));
        expect(shadow.blurRadius, 15);
      });
    });

    group('fromMap()', () {
      test('full map overrides all fields', () {
        final config = FiftyShadowsConfig.fromMap(
          {
            'sm': [
              {'dx': 0, 'dy': 2, 'blurRadius': 4, 'spreadRadius': 0, 'color': 0x1A000000},
            ],
            'md': [
              {'dx': 0, 'dy': 8, 'blurRadius': 12, 'spreadRadius': 0, 'color': 0x20000000},
            ],
            'lg': [
              {'dx': 0, 'dy': 16, 'blurRadius': 24, 'spreadRadius': 0, 'color': 0x33000000},
            ],
            'primaryOpacity': 0.3,
            'glowOpacity': 0.15,
          },
          fallback: defaultConfig,
        );

        expect(config.sm.first.offset, const Offset(0, 2));
        expect(config.sm.first.blurRadius, 4);
        expect(config.md.first.offset, const Offset(0, 8));
        expect(config.lg.first.offset, const Offset(0, 16));
        expect(config.primaryOpacity, 0.3);
        expect(config.glowOpacity, 0.15);
      });

      test('partial map uses fallback for missing keys', () {
        final config = FiftyShadowsConfig.fromMap(
          {'primaryOpacity': 0.5},
          fallback: defaultConfig,
        );

        expect(config.sm.length, 1);
        expect(config.md.length, 1);
        expect(config.lg.length, 1);
        expect(config.primaryOpacity, 0.5);
        expect(config.glowOpacity, 0.1);
      });

      test('empty map returns fallback values', () {
        final config = FiftyShadowsConfig.fromMap(
          {},
          fallback: defaultConfig,
        );

        expect(config.sm.length, 1);
        expect(config.md.length, 1);
        expect(config.lg.length, 1);
        expect(config.primaryOpacity, 0.2);
        expect(config.glowOpacity, 0.1);
      });

      test('parses hex string colors', () {
        final config = FiftyShadowsConfig.fromMap(
          {
            'sm': [
              {'dx': 0, 'dy': 1, 'blurRadius': 2, 'color': '#FF0000'},
            ],
          },
          fallback: defaultConfig,
        );

        expect(config.sm.first.color, const Color(0xFFFF0000));
      });

      test('parses 0x-prefixed hex string colors', () {
        final config = FiftyShadowsConfig.fromMap(
          {
            'sm': [
              {'dx': 0, 'dy': 1, 'blurRadius': 2, 'color': '0xFF00FF00'},
            ],
          },
          fallback: defaultConfig,
        );

        expect(config.sm.first.color, const Color(0xFF00FF00));
      });

      test('non-list shadow value returns empty list', () {
        final config = FiftyShadowsConfig.fromMap(
          {'sm': 'invalid'},
          fallback: defaultConfig,
        );

        expect(config.sm, isEmpty);
      });
    });

    group('copyWith()', () {
      test('replaces specified fields', () {
        final copy = defaultConfig.copyWith(primaryOpacity: 0.5);

        expect(copy.primaryOpacity, 0.5);
        expect(copy.glowOpacity, 0.1);
        expect(copy.sm.length, 1);
      });

      test('replaces shadow lists', () {
        const newSm = [BoxShadow(offset: Offset(0, 3), blurRadius: 5)];
        final copy = defaultConfig.copyWith(sm: newSm);

        expect(copy.sm.first.offset, const Offset(0, 3));
        expect(copy.md.first.offset, const Offset(0, 4));
      });

      test('no arguments returns equivalent config', () {
        final copy = defaultConfig.copyWith();

        expect(copy.sm.length, defaultConfig.sm.length);
        expect(copy.md.length, defaultConfig.md.length);
        expect(copy.lg.length, defaultConfig.lg.length);
        expect(copy.primaryOpacity, defaultConfig.primaryOpacity);
        expect(copy.glowOpacity, defaultConfig.glowOpacity);
      });
    });
  });
}
