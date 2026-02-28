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

    group('override breakpoints', () {
      test('override desktop', () {
        FiftyTokens.configure(
          breakpoints: const FiftyBreakpointsConfig(desktop: 1280),
        );
        expect(FiftyBreakpoints.desktop, 1280);
        // Others unchanged
        expect(FiftyBreakpoints.mobile, 768);
        expect(FiftyBreakpoints.tablet, 768);
      });

      test('override all breakpoints', () {
        FiftyTokens.configure(
          breakpoints: const FiftyBreakpointsConfig(
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
          breakpoints: const FiftyBreakpointsConfig(
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
