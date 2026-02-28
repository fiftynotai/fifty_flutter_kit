import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FiftyFontResolver', () {
    setUp(() {
      // Prevent actual HTTP requests during tests
      GoogleFonts.config.allowRuntimeFetching = false;
    });

    group('asset source', () {
      test('resolve returns TextStyle with fontFamily set', () {
        final style = FiftyFontResolver.resolve(
          fontFamily: 'CustomFont',
          source: FontSource.asset,
        );

        expect(style.fontFamily, 'CustomFont');
      });

      test('resolve with baseStyle preserves properties', () {
        const baseStyle = TextStyle(fontSize: 14, letterSpacing: 0.5);
        final style = FiftyFontResolver.resolve(
          fontFamily: 'CustomFont',
          source: FontSource.asset,
          baseStyle: baseStyle,
        );

        expect(style.fontFamily, 'CustomFont');
        expect(style.fontSize, 14);
        expect(style.letterSpacing, 0.5);
      });

      test('resolveFamilyName returns name as-is', () {
        final name = FiftyFontResolver.resolveFamilyName(
          fontFamily: 'CustomFont',
          source: FontSource.asset,
        );

        expect(name, 'CustomFont');
      });
    });

    group('googleFonts source', () {
      // GoogleFonts.getFont() synchronously returns a TextStyle with the
      // correct fontFamily, then asynchronously loads the font file. In
      // test environments without bundled font assets, the async load
      // throws. Use testWidgets to handle the async lifecycle properly.

      testWidgets('resolve returns a TextStyle with fontFamily',
          (tester) async {
        final style = FiftyFontResolver.resolve(
          fontFamily: 'Manrope',
          source: FontSource.googleFonts,
        );

        expect(style, isA<TextStyle>());
        expect(style.fontFamily, isNotNull);
        expect(style.fontFamily, isNotEmpty);

        // Pump to let async font loading complete/fail gracefully
        await tester.pump();
      });

      testWidgets('resolve with baseStyle preserves fontSize',
          (tester) async {
        const baseStyle = TextStyle(fontSize: 16);
        final style = FiftyFontResolver.resolve(
          fontFamily: 'Manrope',
          source: FontSource.googleFonts,
          baseStyle: baseStyle,
        );

        expect(style, isA<TextStyle>());
        expect(style.fontSize, 16);

        await tester.pump();
      });

      testWidgets('resolveFamilyName returns a non-empty string',
          (tester) async {
        final name = FiftyFontResolver.resolveFamilyName(
          fontFamily: 'Manrope',
          source: FontSource.googleFonts,
        );

        expect(name, isNotEmpty);

        await tester.pump();
      });
    });

    group('null baseStyle', () {
      test('asset source with null baseStyle works', () {
        final style = FiftyFontResolver.resolve(
          fontFamily: 'CustomFont',
          source: FontSource.asset,
        );

        expect(style.fontFamily, 'CustomFont');
      });

      testWidgets('googleFonts source with null baseStyle works',
          (tester) async {
        final style = FiftyFontResolver.resolve(
          fontFamily: 'Manrope',
          source: FontSource.googleFonts,
        );

        expect(style, isA<TextStyle>());

        await tester.pump();
      });
    });
  });
}
