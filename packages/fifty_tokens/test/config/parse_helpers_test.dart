import 'package:fifty_tokens/src/config/parse_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseColor', () {
    test('null input returns null', () {
      expect(parseColor(null), isNull);
    });

    test('int value returns Color', () {
      expect(parseColor(0xFFAABBCC), const Color(0xFFAABBCC));
    });

    test('hex string without prefix returns Color with FF alpha', () {
      expect(parseColor('#FF0000'), const Color(0xFFFF0000));
    });

    test('hex string with 0x prefix returns correct Color', () {
      expect(parseColor('0xFFAABBCC'), const Color(0xFFAABBCC));
    });

    test('8-char hex string returns correct Color', () {
      expect(parseColor('FFAABBCC'), const Color(0xFFAABBCC));
    });

    test('6-char hex string gets FF prefix', () {
      expect(parseColor('AABBCC'), const Color(0xFFAABBCC));
    });

    test('malformed hex string returns null', () {
      expect(parseColor('not-a-color'), isNull);
    });

    test('empty string returns null', () {
      expect(parseColor(''), isNull);
    });

    test('boolean value returns null', () {
      expect(parseColor(true), isNull);
    });

    test('double value returns null', () {
      expect(parseColor(3.14), isNull);
    });

    test('list value returns null', () {
      expect(parseColor([1, 2, 3]), isNull);
    });

    test('hash-only string returns null', () {
      expect(parseColor('#'), isNull);
    });

    test('0x-only string returns null', () {
      expect(parseColor('0x'), isNull);
    });
  });
}
