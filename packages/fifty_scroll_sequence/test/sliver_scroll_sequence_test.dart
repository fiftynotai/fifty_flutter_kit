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
  group('SliverScrollSequence', () {
    testWidgets('renders inside CustomScrollView without errors',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverScrollSequence(
                  frameCount: 5,
                  framePath: '',
                  loader: loader,
                  scrollExtent: 1000,
                  lerpFactor: 1.0,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('shows RawImage after frames load',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverScrollSequence(
                  frameCount: 3,
                  framePath: '',
                  loader: loader,
                  scrollExtent: 1000,
                  lerpFactor: 1.0,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(RawImage), findsOneWidget);
    });

    testWidgets('works alongside other slivers',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverScrollSequence(
                  frameCount: 5,
                  framePath: '',
                  loader: loader,
                  scrollExtent: 500,
                  lerpFactor: 1.0,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => SizedBox(
                      height: 50,
                      child: Text('Item $index'),
                    ),
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // Both sliver types rendered without error.
    });

    testWidgets('controller attachment works',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();
      final controller = ScrollSequenceController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverScrollSequence(
                  frameCount: 5,
                  framePath: '',
                  loader: loader,
                  scrollExtent: 1000,
                  lerpFactor: 1.0,
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(controller.isAttached, isTrue);
      expect(controller.frameCount, 5);

      controller.dispose();
    });

    testWidgets('non-pinned mode renders correctly',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverScrollSequence(
                  frameCount: 3,
                  framePath: '',
                  loader: loader,
                  scrollExtent: 500,
                  lerpFactor: 1.0,
                  pinned: false,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('builder overlay works with sliver',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverScrollSequence(
                  frameCount: 5,
                  framePath: '',
                  loader: loader,
                  scrollExtent: 1000,
                  lerpFactor: 1.0,
                  builder: (context, frameIndex, progress, child) {
                    return SizedBox.expand(
                      child: Stack(
                        children: [
                          child,
                          const Text('SLIVER_OVERLAY'),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('SLIVER_OVERLAY'), findsOneWidget);
    });

    testWidgets('scroll changes are handled without errors',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverScrollSequence(
                  frameCount: 10,
                  framePath: '',
                  loader: loader,
                  scrollExtent: 2000,
                  lerpFactor: 1.0,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => SizedBox(
                      height: 100,
                      child: Text('Item $index'),
                    ),
                    childCount: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Scroll down.
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('controller detaches when widget is removed',
        (WidgetTester tester) async {
      final loader = _FakeFrameLoader();
      final controller = ScrollSequenceController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverScrollSequence(
                  frameCount: 5,
                  framePath: '',
                  loader: loader,
                  scrollExtent: 1000,
                  lerpFactor: 1.0,
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(controller.isAttached, isTrue);

      // Replace with empty view.
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SizedBox()),
        ),
      );
      await tester.pumpAndSettle();

      expect(controller.isAttached, isFalse);

      controller.dispose();
    });
  });
}
