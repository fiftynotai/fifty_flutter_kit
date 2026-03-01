import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyBreakpointsConfig', () {
    setUp(() => FiftyTokens.reset());

    group('defaults match FDL', () {
      test('default breakpoints', () {
        expect(FiftyBreakpoints.mobile, 768);
        expect(FiftyBreakpoints.tablet, 768);
        expect(FiftyBreakpoints.desktop, 1024);
      });
    });

    group('fromMap()', () {
      final fallback = FiftyPreset.fdlV2.breakpoints;

      test('full valid map overrides all fields', () {
        final config = FiftyBreakpointsConfig.fromMap(
          {
            'mobile': 640,
            'tablet': 960,
            'desktop': 1280,
          },
          fallback: fallback,
        );

        expect(config.mobile, 640);
        expect(config.tablet, 960);
        expect(config.desktop, 1280);
      });

      test('empty map returns all fallback values', () {
        final config = FiftyBreakpointsConfig.fromMap({}, fallback: fallback);

        expect(config.mobile, fallback.mobile);
        expect(config.tablet, fallback.tablet);
        expect(config.desktop, fallback.desktop);
      });

      test('partial map uses fallback for missing keys', () {
        final config = FiftyBreakpointsConfig.fromMap(
          {'desktop': 1280},
          fallback: fallback,
        );

        expect(config.desktop, 1280);
        expect(config.mobile, fallback.mobile);
        expect(config.tablet, fallback.tablet);
      });

      test('non-num value throws TypeError', () {
        expect(
          () => FiftyBreakpointsConfig.fromMap(
            {'desktop': 'abc'},
            fallback: fallback,
          ),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('override breakpoints', () {
      test('override desktop', () {
        FiftyTokens.configure(
          breakpoints: FiftyPreset.fdlV2.breakpoints.copyWith(desktop: 1280),
        );
        expect(FiftyBreakpoints.desktop, 1280);
        // Others unchanged
        expect(FiftyBreakpoints.mobile, 768);
        expect(FiftyBreakpoints.tablet, 768);
      });

      test('override all breakpoints', () {
        FiftyTokens.configure(
          breakpoints: FiftyPreset.fdlV2.breakpoints.copyWith(
            mobile: 640,
            tablet: 960,
            desktop: 1280,
          ),
        );
        expect(FiftyBreakpoints.mobile, 640);
        expect(FiftyBreakpoints.tablet, 960);
        expect(FiftyBreakpoints.desktop, 1280);
      });
    });

    group('reset', () {
      test('reset restores defaults', () {
        FiftyTokens.configure(
          breakpoints: FiftyPreset.fdlV2.breakpoints.copyWith(
            mobile: 640,
            tablet: 960,
            desktop: 1280,
          ),
        );

        FiftyTokens.reset();

        expect(FiftyBreakpoints.mobile, 768);
        expect(FiftyBreakpoints.tablet, 768);
        expect(FiftyBreakpoints.desktop, 1024);
      });
    });
  });
}
