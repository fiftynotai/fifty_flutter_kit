import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyGradients', () {
    group('Primary Gradient', () {
      test('has correct colors', () {
        expect(FiftyGradients.primary.colors.length, 2);
        expect(FiftyGradients.primary.colors[0], const Color(0xFF88292F));
        expect(FiftyGradients.primary.colors[1], const Color(0xFF5A1B1F));
      });

      test('has correct alignment', () {
        expect(FiftyGradients.primary.begin, Alignment.topLeft);
        expect(FiftyGradients.primary.end, Alignment.bottomRight);
      });
    });

    group('Progress Gradient', () {
      test('has correct colors', () {
        expect(FiftyGradients.progress.colors.length, 2);
        expect(FiftyGradients.progress.colors[0], const Color(0xFFFFC9B9));
        expect(FiftyGradients.progress.colors[1], const Color(0xFF88292F));
      });

      test('has correct alignment', () {
        expect(FiftyGradients.progress.begin, Alignment.centerLeft);
        expect(FiftyGradients.progress.end, Alignment.centerRight);
      });
    });

    group('Surface Gradient', () {
      test('has correct colors', () {
        expect(FiftyGradients.surface.colors.length, 2);
        expect(FiftyGradients.surface.colors[0], const Color(0xFF1A0D0E));
        expect(FiftyGradients.surface.colors[1], const Color(0xFF2A1517));
      });

      test('has correct alignment', () {
        expect(FiftyGradients.surface.begin, Alignment.topCenter);
        expect(FiftyGradients.surface.end, Alignment.bottomCenter);
      });
    });

    test('all gradients are LinearGradient', () {
      expect(FiftyGradients.primary, isA<LinearGradient>());
      expect(FiftyGradients.progress, isA<LinearGradient>());
      expect(FiftyGradients.surface, isA<LinearGradient>());
    });
  });
}
