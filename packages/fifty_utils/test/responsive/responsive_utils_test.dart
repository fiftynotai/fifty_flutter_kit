import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_utils/fifty_utils.dart';

void main() {
  group('ResponsiveUtils', () {
    // For portrait mode, width < height, so device width = actual width
    // For landscape mode, width > height, so device width = height
    // We use portrait mode (height > width) for all tests to keep behavior predictable
    Widget buildTestWidget({
      required Size size,
      required Widget child,
    }) {
      return MediaQuery(
        data: MediaQueryData(size: size),
        child: child,
      );
    }

    group('Device Type Detection', () {
      testWidgets('isMobile returns true for width < 600 (portrait)', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(400, 800), // portrait: width=400 < 600 = mobile
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isMobile(context), isTrue);
                expect(ResponsiveUtils.isTablet(context), isFalse);
                expect(ResponsiveUtils.isDesktop(context), isFalse);
                expect(ResponsiveUtils.isWideDesktop(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('isTablet returns true for width >= 600 && < 1024 (portrait)', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(800, 1200), // portrait: width=800, 600 <= 800 < 1024 = tablet
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isMobile(context), isFalse);
                expect(ResponsiveUtils.isTablet(context), isTrue);
                expect(ResponsiveUtils.isDesktop(context), isFalse);
                expect(ResponsiveUtils.isWideDesktop(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('isDesktop returns true for width >= 1024 && < 1440 (portrait)', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1200, 1600), // portrait: width=1200, 1024 <= 1200 < 1440 = desktop
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isMobile(context), isFalse);
                expect(ResponsiveUtils.isTablet(context), isFalse);
                expect(ResponsiveUtils.isDesktop(context), isTrue);
                expect(ResponsiveUtils.isWideDesktop(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('isWideDesktop returns true for width >= 1440 (portrait)', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1920, 2400), // portrait: width=1920 >= 1440 = wide
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isMobile(context), isFalse);
                expect(ResponsiveUtils.isTablet(context), isFalse);
                expect(ResponsiveUtils.isDesktop(context), isFalse);
                expect(ResponsiveUtils.isWideDesktop(context), isTrue);
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('deviceType', () {
      testWidgets('returns DeviceType.mobile for mobile size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(400, 800),
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.deviceType(context), equals(DeviceType.mobile));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns DeviceType.tablet for tablet size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(800, 1200),
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.deviceType(context), equals(DeviceType.tablet));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns DeviceType.desktop for desktop size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1200, 1600), // portrait
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.deviceType(context), equals(DeviceType.desktop));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns DeviceType.wide for wide desktop size', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1920, 2400), // portrait
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.deviceType(context), equals(DeviceType.wide));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('valueByDevice', () {
      testWidgets('returns mobile value on mobile', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(400, 800),
            child: Builder(
              builder: (context) {
                final value = ResponsiveUtils.valueByDevice<int>(
                  context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                  wide: 4,
                );
                expect(value, equals(1));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns tablet value on tablet', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(800, 1200),
            child: Builder(
              builder: (context) {
                final value = ResponsiveUtils.valueByDevice<int>(
                  context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                  wide: 4,
                );
                expect(value, equals(2));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns desktop value on desktop', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1200, 1600), // portrait
            child: Builder(
              builder: (context) {
                final value = ResponsiveUtils.valueByDevice<int>(
                  context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                  wide: 4,
                );
                expect(value, equals(3));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns wide value on wide desktop', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1920, 2400), // portrait
            child: Builder(
              builder: (context) {
                final value = ResponsiveUtils.valueByDevice<int>(
                  context,
                  mobile: 1,
                  tablet: 2,
                  desktop: 3,
                  wide: 4,
                );
                expect(value, equals(4));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('falls back to mobile when tablet not specified', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(800, 1200),
            child: Builder(
              builder: (context) {
                final value = ResponsiveUtils.valueByDevice<int>(
                  context,
                  mobile: 1,
                );
                expect(value, equals(1));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('falls back to tablet when desktop not specified', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1200, 1600), // portrait = desktop
            child: Builder(
              builder: (context) {
                final value = ResponsiveUtils.valueByDevice<int>(
                  context,
                  mobile: 1,
                  tablet: 2,
                );
                expect(value, equals(2));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('screenDimensions', () {
      testWidgets('screenWidth returns correct value', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1000, 1200),
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.screenWidth(context), equals(1000));
                expect(ResponsiveUtils.screenWidth(context, 0.5), equals(500));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('screenHeight returns correct value', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1000, 1200),
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.screenHeight(context), equals(1200));
                expect(ResponsiveUtils.screenHeight(context, 0.5), equals(600));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('scaledFontSize', () {
      testWidgets('returns base size on mobile', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(400, 800),
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.scaledFontSize(context, 16), equals(16));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns 1.1x on tablet', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(800, 1200),
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.scaledFontSize(context, 16), equals(17.6));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns 1.15x on desktop', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1200, 1600), // portrait
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.scaledFontSize(context, 16), closeTo(18.4, 0.01));
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('returns 1.2x on wide desktop', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1920, 2400), // portrait
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.scaledFontSize(context, 16), closeTo(19.2, 0.01));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('padding', () {
      testWidgets('returns correct padding per device', (tester) async {
        // Mobile
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(400, 800),
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.padding(context), equals(16));
                return const SizedBox();
              },
            ),
          ),
        );

        // Tablet
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(800, 1200),
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.padding(context), equals(24));
                return const SizedBox();
              },
            ),
          ),
        );

        // Desktop
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1200, 1600), // portrait
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.padding(context), equals(32));
                return const SizedBox();
              },
            ),
          ),
        );

        // Wide
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1920, 2400), // portrait
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.padding(context), equals(40));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('gridColumns', () {
      testWidgets('returns correct column count per device', (tester) async {
        // Mobile
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(400, 800),
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.gridColumns(context), equals(2));
                return const SizedBox();
              },
            ),
          ),
        );

        // Tablet
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(800, 1200),
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.gridColumns(context), equals(3));
                return const SizedBox();
              },
            ),
          ),
        );

        // Desktop
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1200, 1600), // portrait
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.gridColumns(context), equals(4));
                return const SizedBox();
              },
            ),
          ),
        );

        // Wide
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(1920, 2400), // portrait
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.gridColumns(context), equals(5));
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('orientation', () {
      testWidgets('isPortrait returns true when height > width', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(400, 800),
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isPortrait(context), isTrue);
                expect(ResponsiveUtils.isLandscape(context), isFalse);
                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('isLandscape returns true when width > height', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            size: const Size(800, 400),
            child: Builder(
              builder: (context) {
                expect(ResponsiveUtils.isPortrait(context), isFalse);
                expect(ResponsiveUtils.isLandscape(context), isTrue);
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });
  });

  group('DeviceType', () {
    test('has correct enum values', () {
      expect(DeviceType.values.length, equals(4));
      expect(DeviceType.values, contains(DeviceType.mobile));
      expect(DeviceType.values, contains(DeviceType.tablet));
      expect(DeviceType.values, contains(DeviceType.desktop));
      expect(DeviceType.values, contains(DeviceType.wide));
    });
  });
}
