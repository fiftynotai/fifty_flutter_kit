import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_utils/fifty_utils.dart';

void main() {
  group('HexColor', () {
    group('fromHex', () {
      test('parses 6-character hex without hash', () {
        final color = HexColor.fromHex('aabbcc');
        expect(color.r, closeTo(170 / 255, 0.01)); // 0xaa
        expect(color.g, closeTo(187 / 255, 0.01)); // 0xbb
        expect(color.b, closeTo(204 / 255, 0.01)); // 0xcc
        expect(color.a, closeTo(1.0, 0.01)); // 0xff (default)
      });

      test('parses 6-character hex with hash', () {
        final color = HexColor.fromHex('#aabbcc');
        expect(color.r, closeTo(170 / 255, 0.01));
        expect(color.g, closeTo(187 / 255, 0.01));
        expect(color.b, closeTo(204 / 255, 0.01));
        expect(color.a, closeTo(1.0, 0.01));
      });

      test('parses 8-character hex with alpha', () {
        final color = HexColor.fromHex('80aabbcc');
        expect(color.a, closeTo(128 / 255, 0.01)); // 0x80
        expect(color.r, closeTo(170 / 255, 0.01));
        expect(color.g, closeTo(187 / 255, 0.01));
        expect(color.b, closeTo(204 / 255, 0.01));
      });

      test('parses pure white', () {
        final color = HexColor.fromHex('#ffffff');
        expect(color.r, closeTo(1.0, 0.01));
        expect(color.g, closeTo(1.0, 0.01));
        expect(color.b, closeTo(1.0, 0.01));
      });

      test('parses pure black', () {
        final color = HexColor.fromHex('#000000');
        expect(color.r, closeTo(0.0, 0.01));
        expect(color.g, closeTo(0.0, 0.01));
        expect(color.b, closeTo(0.0, 0.01));
      });

      test('parses pure red', () {
        final color = HexColor.fromHex('#ff0000');
        expect(color.r, closeTo(1.0, 0.01));
        expect(color.g, closeTo(0.0, 0.01));
        expect(color.b, closeTo(0.0, 0.01));
      });
    });

    group('toHex', () {
      test('converts color to hex with leading hash', () {
        const color = Color.fromARGB(255, 170, 187, 204);
        expect(color.toHex(), equals('#ffaabbcc'));
      });

      test('converts color to hex without leading hash', () {
        const color = Color.fromARGB(255, 170, 187, 204);
        expect(color.toHex(leadingHashSign: false), equals('ffaabbcc'));
      });

      test('converts transparent color', () {
        const color = Color.fromARGB(128, 170, 187, 204);
        expect(color.toHex(), equals('#80aabbcc'));
      });

      test('converts pure white', () {
        const color = Color.fromARGB(255, 255, 255, 255);
        expect(color.toHex(), equals('#ffffffff'));
      });

      test('converts pure black', () {
        const color = Color.fromARGB(255, 0, 0, 0);
        expect(color.toHex(), equals('#ff000000'));
      });

      test('roundtrip conversion', () {
        final original = HexColor.fromHex('#80aabbcc');
        final hex = original.toHex();
        final restored = HexColor.fromHex(hex);

        expect(restored.a, closeTo(original.a, 0.01));
        expect(restored.r, closeTo(original.r, 0.01));
        expect(restored.g, closeTo(original.g, 0.01));
        expect(restored.b, closeTo(original.b, 0.01));
      });
    });
  });
}
