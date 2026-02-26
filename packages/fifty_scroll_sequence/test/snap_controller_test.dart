import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SnapController', () {
    group('idle detection', () {
      testWidgets('after onScrollEnd, timer fires after idle timeout',
          (WidgetTester tester) async {
        final config = SnapConfig(
          snapPoints: [0.0, 0.5, 1.0],
          idleTimeout: const Duration(milliseconds: 100),
        );
        final snapController = SnapController(config: config);
        final scrollController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: SingleChildScrollView(
              controller: scrollController,
              child: const SizedBox(height: 5000),
            ),
          ),
        );

        final scrollPosition = scrollController.position;
        snapController.attach(
          scrollPosition,

          scrollExtent: 3000.0,
          currentProgress: () => 0.3, // Not at a snap point
        );

        snapController.onScrollEnd();
        expect(snapController.isSnapping, isFalse);

        // Advance timer past idle timeout to trigger snap.
        await tester.pump(const Duration(milliseconds: 150));
        expect(snapController.isSnapping, isTrue);

        snapController.dispose();
      });

      testWidgets('onScrollUpdate before timeout prevents snap',
          (WidgetTester tester) async {
        final config = SnapConfig(
          snapPoints: [0.0, 0.5, 1.0],
          idleTimeout: const Duration(milliseconds: 200),
        );
        final snapController = SnapController(config: config);
        final scrollController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: SingleChildScrollView(
              controller: scrollController,
              child: const SizedBox(height: 5000),
            ),
          ),
        );

        final scrollPosition = scrollController.position;
        snapController.attach(
          scrollPosition,

          scrollExtent: 3000.0,
          currentProgress: () => 0.3,
        );

        snapController.onScrollEnd();

        // Call onScrollUpdate before timeout fires.
        await tester.pump(const Duration(milliseconds: 50));
        snapController.onScrollUpdate();

        // Advance past original timeout -- should not snap.
        await tester.pump(const Duration(milliseconds: 200));
        expect(snapController.isSnapping, isFalse);

        snapController.dispose();
      });

      testWidgets('multiple rapid onScrollEnd calls only produce one snap',
          (WidgetTester tester) async {
        final config = SnapConfig(
          snapPoints: [0.0, 0.5, 1.0],
          idleTimeout: const Duration(milliseconds: 100),
        );
        final snapController = SnapController(config: config);
        final scrollController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: SingleChildScrollView(
              controller: scrollController,
              child: const SizedBox(height: 5000),
            ),
          ),
        );

        final scrollPosition = scrollController.position;
        snapController.attach(
          scrollPosition,

          scrollExtent: 3000.0,
          currentProgress: () => 0.3,
        );

        // Rapid scroll end calls.
        snapController.onScrollEnd();
        snapController.onScrollEnd();
        snapController.onScrollEnd();

        await tester.pump(const Duration(milliseconds: 150));
        // Only one snap animation should be active.
        expect(snapController.isSnapping, isTrue);

        snapController.dispose();
      });
    });

    group('snap animation', () {
      testWidgets('when already at a snap point, no animation occurs',
          (WidgetTester tester) async {
        final config = SnapConfig(
          snapPoints: [0.0, 0.5, 1.0],
          idleTimeout: const Duration(milliseconds: 50),
        );
        final snapController = SnapController(config: config);
        final scrollController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: SingleChildScrollView(
              controller: scrollController,
              child: const SizedBox(height: 5000),
            ),
          ),
        );

        final scrollPosition = scrollController.position;
        snapController.attach(
          scrollPosition,

          scrollExtent: 3000.0,
          currentProgress: () => 0.5, // Already at a snap point
        );

        snapController.onScrollEnd();
        await tester.pump(const Duration(milliseconds: 100));

        // Should not be snapping because already at snap point.
        expect(snapController.isSnapping, isFalse);

        snapController.dispose();
      });
    });

    group('cancel on resume', () {
      testWidgets('onScrollUpdate during snap sets isSnapping to false',
          (WidgetTester tester) async {
        final config = SnapConfig(
          snapPoints: [0.0, 0.5, 1.0],
          idleTimeout: const Duration(milliseconds: 50),
        );
        final snapController = SnapController(config: config);
        final scrollController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: SingleChildScrollView(
              controller: scrollController,
              child: const SizedBox(height: 5000),
            ),
          ),
        );

        final scrollPosition = scrollController.position;
        snapController.attach(
          scrollPosition,

          scrollExtent: 3000.0,
          currentProgress: () => 0.3,
        );

        // Trigger snap.
        snapController.onScrollEnd();
        await tester.pump(const Duration(milliseconds: 100));
        expect(snapController.isSnapping, isTrue);

        // Resume scrolling during snap.
        snapController.onScrollUpdate();
        expect(snapController.isSnapping, isFalse);

        snapController.dispose();
      });
    });

    group('attach / detach', () {
      testWidgets('operations after detach are no-ops',
          (WidgetTester tester) async {
        final config = SnapConfig(
          snapPoints: [0.0, 0.5, 1.0],
          idleTimeout: const Duration(milliseconds: 50),
        );
        final snapController = SnapController(config: config);
        final scrollController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: SingleChildScrollView(
              controller: scrollController,
              child: const SizedBox(height: 5000),
            ),
          ),
        );

        final scrollPosition = scrollController.position;
        snapController.attach(
          scrollPosition,

          scrollExtent: 3000.0,
          currentProgress: () => 0.3,
        );

        snapController.detach();

        // These should be no-ops (no exception).
        snapController.onScrollEnd();
        await tester.pump(const Duration(milliseconds: 100));
        expect(snapController.isSnapping, isFalse);

        snapController.dispose();
      });

      testWidgets('dispose cancels pending timer',
          (WidgetTester tester) async {
        final config = SnapConfig(
          snapPoints: [0.0, 0.5, 1.0],
          idleTimeout: const Duration(milliseconds: 200),
        );
        final snapController = SnapController(config: config);
        final scrollController = ScrollController();

        await tester.pumpWidget(
          MaterialApp(
            home: SingleChildScrollView(
              controller: scrollController,
              child: const SizedBox(height: 5000),
            ),
          ),
        );

        final scrollPosition = scrollController.position;
        snapController.attach(
          scrollPosition,

          scrollExtent: 3000.0,
          currentProgress: () => 0.3,
        );

        snapController.onScrollEnd();
        snapController.dispose();

        // After dispose, advancing time should not cause any snap.
        await tester.pump(const Duration(milliseconds: 300));
        expect(snapController.isSnapping, isFalse);
      });
    });
  });
}
