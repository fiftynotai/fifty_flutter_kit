/// Scroll Sequence Example - Snap Demo Page
///
/// Demonstrates snap-to-keyframe behavior using [SnapConfig.scenes],
/// with scene indicator dots and a builder overlay showing the active scene.
library;

import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/frame_generator.dart';

/// Snap-to-keyframe demo with scene indicators.
///
/// Features:
/// - Pinned mode (`pin: true`) with 120 frames
/// - [SnapConfig.scenes] with 4 scene boundaries (0, 40, 80, 119)
/// - Builder overlay showing the current scene label
/// - Scene indicator dots at the bottom highlighting the active scene
class SnapPage extends StatelessWidget {
  /// Creates the snap demo page.
  const SnapPage({super.key});

  /// Number of frames for this demo.
  static const int _frameCount = 120;

  /// Scene boundary frames (4 scenes).
  static const List<int> _sceneStartFrames = [0, 40, 80, 119];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'SNAP',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontWeight: FiftyTypography.bold,
            letterSpacing: FiftyTypography.letterSpacingLabelMedium,
          ),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 200),

            // Instruction text.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.xxl,
                vertical: FiftySpacing.lg,
              ),
              child: Text(
                'SCROLL AND RELEASE \u2014 SNAPS TO NEAREST SCENE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.labelMedium,
                  fontWeight: FiftyTypography.semiBold,
                  letterSpacing: FiftyTypography.letterSpacingLabelMedium,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),

            // Pinned scroll sequence with snap.
            ScrollSequence(
              frameCount: _frameCount,
              framePath: '',
              loader: GeneratedFrameLoader(frameCount: _frameCount),
              scrollExtent: 3000,
              pin: true,
              snapConfig: SnapConfig.scenes(
                sceneStartFrames: _sceneStartFrames,
                frameCount: _frameCount,
              ),
              builder: (context, frameIndex, progress, child) {
                final activeScene = _activeSceneIndex(frameIndex);

                return Stack(
                  children: [
                    child,

                    // Scene label overlay.
                    Positioned(
                      top: FiftySpacing.lg,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: _SceneBadge(
                          sceneNumber: activeScene + 1,
                          colorScheme: colorScheme,
                        ),
                      ),
                    ),

                    // Frame counter.
                    Positioned(
                      top: FiftySpacing.lg,
                      right: FiftySpacing.lg,
                      child: _FrameCounter(
                        frameIndex: frameIndex,
                        frameCount: _frameCount,
                        colorScheme: colorScheme,
                      ),
                    ),

                    // Scene indicator dots.
                    Positioned(
                      bottom: FiftySpacing.xxl,
                      left: 0,
                      right: 0,
                      child: _SceneDots(
                        sceneCount: _sceneStartFrames.length,
                        activeScene: activeScene,
                        colorScheme: colorScheme,
                      ),
                    ),
                  ],
                );
              },
            ),

            // Trail-out spacing.
            const SizedBox(height: 500),
          ],
        ),
      ),
    );
  }

  /// Returns the zero-based scene index for a given frame.
  static int _activeSceneIndex(int frameIndex) {
    for (var i = _sceneStartFrames.length - 1; i >= 0; i--) {
      if (frameIndex >= _sceneStartFrames[i]) return i;
    }
    return 0;
  }
}

/// Badge overlay showing the current scene number.
class _SceneBadge extends StatelessWidget {
  const _SceneBadge({
    required this.sceneNumber,
    required this.colorScheme,
  });

  final int sceneNumber;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.lg,
        vertical: FiftySpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.9),
        borderRadius: FiftyRadii.mdRadius,
      ),
      child: Text(
        'SCENE $sceneNumber',
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontSize: FiftyTypography.labelLarge,
          fontWeight: FiftyTypography.bold,
          letterSpacing: FiftyTypography.letterSpacingLabelMedium,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}

/// Small frame counter overlay.
class _FrameCounter extends StatelessWidget {
  const _FrameCounter({
    required this.frameIndex,
    required this.frameCount,
    required this.colorScheme,
  });

  final int frameIndex;
  final int frameCount;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.sm,
        vertical: FiftySpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: FiftyRadii.smRadius,
        border: Border.all(color: FiftyColors.borderDark),
      ),
      child: Text(
        '${frameIndex + 1} / $frameCount',
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontSize: FiftyTypography.labelSmall,
          fontWeight: FiftyTypography.bold,
          letterSpacing: FiftyTypography.letterSpacingLabel,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}

/// Scene indicator dots showing which scene is active.
class _SceneDots extends StatelessWidget {
  const _SceneDots({
    required this.sceneCount,
    required this.activeScene,
    required this.colorScheme,
  });

  final int sceneCount;
  final int activeScene;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(sceneCount, (index) {
        final isActive = index == activeScene;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: FiftySpacing.xs),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isActive ? 24 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.3),
              borderRadius: FiftyRadii.smRadius,
            ),
          ),
        );
      }),
    );
  }
}
