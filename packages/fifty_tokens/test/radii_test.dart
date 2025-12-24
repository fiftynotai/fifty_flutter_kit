import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyRadii', () {
    group('Radius Values (FDL Brand Sheet)', () {
      test('standard is 12px', () {
        expect(FiftyRadii.standard, 12);
      });

      test('smooth is 24px', () {
        expect(FiftyRadii.smooth, 24);
      });

      test('full is 999px', () {
        expect(FiftyRadii.full, 999);
      });
    });

    group('BorderRadius Objects', () {
      test('standardRadius uses standard value', () {
        expect(FiftyRadii.standardRadius, BorderRadius.circular(12));
      });

      test('smoothRadius uses smooth value', () {
        expect(FiftyRadii.smoothRadius, BorderRadius.circular(24));
      });

      test('fullRadius uses full value', () {
        expect(FiftyRadii.fullRadius, BorderRadius.circular(999));
      });
    });
  });
}
