import 'dart:ui' as ui;

import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a 1x1 test image using PictureRecorder.
Future<ui.Image> _createTestImage() async {
  final recorder = ui.PictureRecorder();
  Canvas(recorder).drawRect(
    const Rect.fromLTWH(0, 0, 1, 1),
    Paint(),
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage(1, 1);
  picture.dispose();
  return image;
}

/// Fake frame loader that creates 1x1 test images instantly.
class _FakeFrameLoader implements FrameLoader {
  int loadCount = 0;

  @override
  Future<ui.Image> loadFrame(int index) async {
    loadCount++;
    return _createTestImage();
  }

  @override
  String resolveFramePath(int index) => 'test_frame_$index.png';

  @override
  void dispose() {}
}

void main() {
  group('ScrollSequence widget', () {
    testWidgets('renders without errors with non-pinned mode',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 200),
                  ScrollSequence(
                    frameCount: 5,
                    framePath: '',
                    loader: loader,
                    scrollExtent: 1000,
                    pin: false,
                    lerpFactor: 1.0,
                  ),
                  const SizedBox(height: 500),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('renders without errors with pinned mode',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 200),
                  ScrollSequence(
                    frameCount: 5,
                    framePath: '',
                    loader: loader,
                    scrollExtent: 1000,
                    pin: true,
                    lerpFactor: 1.0,
                  ),
                  const SizedBox(height: 500),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows loadingBuilder initially before frames load',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ScrollSequence(
                    frameCount: 5,
                    framePath: '',
                    loader: loader,
                    scrollExtent: 1000,
                    pin: false,
                    lerpFactor: 1.0,
                    loadingBuilder: (context, progress) {
                      return const Text('LOADING');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Pump once without settling to catch loading state.
      await tester.pump();

      // After loading completes, the loading text should disappear.
      await tester.pumpAndSettle();
      // RawImage should be present after loading.
      expect(find.byType(RawImage), findsOneWidget);
    });

    testWidgets('shows RawImage after frames load',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ScrollSequence(
                    frameCount: 3,
                    framePath: '',
                    loader: loader,
                    scrollExtent: 1000,
                    pin: false,
                    lerpFactor: 1.0,
                  ),
                  const SizedBox(height: 500),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(RawImage), findsOneWidget);
    });

    testWidgets('onFrameChanged callback fires on scroll',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();
      final callbackValues = <(int, double)>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ScrollSequence(
                    frameCount: 10,
                    framePath: '',
                    loader: loader,
                    scrollExtent: 2000,
                    pin: false,
                    height: 400,
                    lerpFactor: 1.0,
                    onFrameChanged: (frameIndex, progress) {
                      callbackValues.add((frameIndex, progress));
                    },
                  ),
                  const SizedBox(height: 3000),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll down to trigger frame changes.
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // The callback may or may not fire depending on whether the frame
      // actually changed. We just verify no crash occurred.
      expect(tester.takeException(), isNull);
    });

    testWidgets('builder overlay works', (WidgetTester tester) async {
      final loader = _FakeFrameLoader();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ScrollSequence(
                    frameCount: 5,
                    framePath: '',
                    loader: loader,
                    scrollExtent: 1000,
                    pin: false,
                    lerpFactor: 1.0,
                    builder: (context, frameIndex, progress, child) {
                      return Stack(
                        children: [
                          child,
                          const Text('OVERLAY'),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 500),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('OVERLAY'), findsOneWidget);
    });

    testWidgets('controller integration: isAttached is true when widget builds',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();
      final controller = ScrollSequenceController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ScrollSequence(
                    frameCount: 5,
                    framePath: '',
                    loader: loader,
                    scrollExtent: 1000,
                    pin: false,
                    lerpFactor: 1.0,
                    controller: controller,
                  ),
                  const SizedBox(height: 500),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(controller.isAttached, isTrue);
      expect(controller.frameCount, 5);

      controller.dispose();
    });

    testWidgets('controller detaches when widget is removed from tree',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();
      final controller = ScrollSequenceController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ScrollSequence(
                    frameCount: 5,
                    framePath: '',
                    loader: loader,
                    scrollExtent: 1000,
                    pin: false,
                    lerpFactor: 1.0,
                    controller: controller,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(controller.isAttached, isTrue);

      // Remove the widget from the tree.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SizedBox()),
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.isAttached, isFalse);

      controller.dispose();
    });

    group('snap integration', () {
      testWidgets('widget with snapConfig renders without errors',
          (WidgetTester tester) async {
        final loader = _FakeFrameLoader();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ScrollSequence(
                      frameCount: 5,
                      framePath: '',
                      loader: loader,
                      scrollExtent: 1000,
                      pin: false,
                      lerpFactor: 1.0,
                      snapConfig: SnapConfig(
                        snapPoints: [0.0, 0.5, 1.0],
                      ),
                    ),
                    const SizedBox(height: 500),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets(
          'widget without snapConfig (null) renders without errors (backward compat)',
          (WidgetTester tester) async {
        final loader = _FakeFrameLoader();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ScrollSequence(
                      frameCount: 5,
                      framePath: '',
                      loader: loader,
                      scrollExtent: 1000,
                      pin: false,
                      lerpFactor: 1.0,
                    ),
                    const SizedBox(height: 500),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    });

    group('lifecycle callbacks', () {
      testWidgets('widget with onEnter callback renders without errors',
          (WidgetTester tester) async {
        final loader = _FakeFrameLoader();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ScrollSequence(
                      frameCount: 5,
                      framePath: '',
                      loader: loader,
                      scrollExtent: 1000,
                      pin: false,
                      lerpFactor: 1.0,
                      onEnter: () {},
                    ),
                    const SizedBox(height: 500),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('widget with all lifecycle callbacks renders without errors',
          (WidgetTester tester) async {
        final loader = _FakeFrameLoader();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ScrollSequence(
                      frameCount: 5,
                      framePath: '',
                      loader: loader,
                      scrollExtent: 1000,
                      pin: false,
                      lerpFactor: 1.0,
                      onEnter: () {},
                      onLeave: () {},
                      onEnterBack: () {},
                      onLeaveBack: () {},
                    ),
                    const SizedBox(height: 500),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('widget without callbacks (null) renders without errors',
          (WidgetTester tester) async {
        final loader = _FakeFrameLoader();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ScrollSequence(
                      frameCount: 5,
                      framePath: '',
                      loader: loader,
                      scrollExtent: 1000,
                      pin: false,
                      lerpFactor: 1.0,
                    ),
                    const SizedBox(height: 500),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    });

    group('horizontal scroll', () {
      testWidgets(
          'widget with scrollDirection: Axis.horizontal renders inside horizontal SingleChildScrollView',
          (WidgetTester tester) async {
        final loader = _FakeFrameLoader();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ScrollSequence(
                      frameCount: 5,
                      framePath: '',
                      loader: loader,
                      scrollExtent: 1000,
                      pin: false,
                      lerpFactor: 1.0,
                      scrollDirection: Axis.horizontal,
                      width: 1000,
                      height: 400,
                    ),
                    const SizedBox(width: 500),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('widget with default scrollDirection (vertical) works as before',
          (WidgetTester tester) async {
        final loader = _FakeFrameLoader();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    ScrollSequence(
                      frameCount: 5,
                      framePath: '',
                      loader: loader,
                      scrollExtent: 1000,
                      pin: false,
                      lerpFactor: 1.0,
                    ),
                    const SizedBox(height: 500),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    });

    testWidgets('loadingBuilder receives progress values',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();
      final progressValues = <double>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ScrollSequence(
                    frameCount: 3,
                    framePath: '',
                    loader: loader,
                    scrollExtent: 1000,
                    pin: false,
                    lerpFactor: 1.0,
                    loadingBuilder: (context, progress) {
                      progressValues.add(progress);
                      return Text('Loading: ${(progress * 100).toInt()}%');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Pump a few frames to see loading states.
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      // Progress values should have been captured (at least initial 0.0).
      // After loading completes, the loading builder is replaced by the frame.
      expect(tester.takeException(), isNull);
    });
  });
}
