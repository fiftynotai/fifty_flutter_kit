/// Scroll Sequence Example - Horizontal Demo Page
///
/// Demonstrates horizontal scroll direction with [ScrollSequence]
/// in pinned mode using landscape frame dimensions.
library;

import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/frame_generator.dart';

/// Horizontal scroll sequence demo with landscape frames.
///
/// Features:
/// - Pinned mode (`pin: true`) with 80 frames
/// - Horizontal scroll direction (`scrollDirection: Axis.horizontal`)
/// - Landscape frame dimensions (640x360)
/// - Frame counter overlay
class HorizontalPage extends StatelessWidget {
  /// Creates the horizontal demo page.
  const HorizontalPage({super.key});

  /// Number of frames for this demo.
  static const int _frameCount = 80;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'HORIZONTAL',
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
      body: Column(
        children: [
          // Instruction text.
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: FiftySpacing.xxl,
              vertical: FiftySpacing.lg,
            ),
            child: Text(
              'SWIPE HORIZONTALLY TO SCRUB',
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

          // Horizontal scroll sequence.
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Lead-in spacing.
                  const SizedBox(width: 200),

                  // Horizontal pinned scroll sequence.
                  ScrollSequence(
                    frameCount: _frameCount,
                    framePath: '',
                    loader: GeneratedFrameLoader(
                      frameCount: _frameCount,
                      width: 640,
                      height: 360,
                    ),
                    scrollExtent: 2000,
                    pin: true,
                    scrollDirection: Axis.horizontal,
                    fit: BoxFit.cover,
                    builder: (context, frameIndex, progress, child) {
                      return Stack(
                        children: [
                          child,

                          // Frame counter overlay.
                          Positioned(
                            top: FiftySpacing.lg,
                            right: FiftySpacing.lg,
                            child: _HorizontalFrameBadge(
                              frameIndex: frameIndex,
                              frameCount: _frameCount,
                              progress: progress,
                              colorScheme: colorScheme,
                            ),
                          ),

                          // Progress bar at the bottom.
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: _HorizontalProgressBar(
                              progress: progress,
                              colorScheme: colorScheme,
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // Trail-out spacing.
                  const SizedBox(width: 500),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Frame counter badge for the horizontal demo.
class _HorizontalFrameBadge extends StatelessWidget {
  const _HorizontalFrameBadge({
    required this.frameIndex,
    required this.frameCount,
    required this.progress,
    required this.colorScheme,
  });

  final int frameIndex;
  final int frameCount;
  final double progress;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: FiftySpacing.md,
        vertical: FiftySpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: FiftyRadii.mdRadius,
        border: Border.all(color: FiftyColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'FRAME ${frameIndex + 1} / $frameCount',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelMedium,
              fontWeight: FiftyTypography.bold,
              letterSpacing: FiftyTypography.letterSpacingLabelMedium,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: FiftySpacing.xs),
          Text(
            '${(progress * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FiftyTypography.regular,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Thin progress bar at the bottom of the horizontal sequence.
class _HorizontalProgressBar extends StatelessWidget {
  const _HorizontalProgressBar({
    required this.progress,
    required this.colorScheme,
  });

  final double progress;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3,
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: colorScheme.onSurface.withValues(alpha: 0.1),
        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
      ),
    );
  }
}
