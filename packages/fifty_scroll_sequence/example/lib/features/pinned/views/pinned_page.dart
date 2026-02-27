/// Scroll Sequence Example - Pinned Demo Page
///
/// Demonstrates pinned mode with ScrollSequenceController,
/// builder overlay, loading indicator, and programmatic jump controls.
library;

import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/frame_generator.dart';

/// Pinned scroll sequence demo with programmatic controls.
///
/// Features:
/// - Pinned mode (`pin: true`) with 120 frames
/// - [ScrollSequenceController] for programmatic navigation
/// - `builder` overlay showing frame index and progress
/// - `loadingBuilder` showing a progress bar during preload
/// - Bottom control bar with jump-to-start, 50%, and end buttons
class PinnedPage extends StatefulWidget {
  /// Creates the pinned demo page.
  const PinnedPage({super.key});

  @override
  State<PinnedPage> createState() => _PinnedPageState();
}

class _PinnedPageState extends State<PinnedPage> {
  final _controller = ScrollSequenceController();

  /// Number of frames for this demo.
  static const int _frameCount = 120;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'PINNED',
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
      body: Stack(
        children: [
          // Scrollable content with pinned sequence.
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 200),
                ScrollSequence(
                  frameCount: _frameCount,
                  framePath: '',
                  loader: GeneratedFrameLoader(frameCount: _frameCount),
                  scrollExtent: 4000,
                  pin: true,
                  controller: _controller,
                  loadingBuilder: (context, progress) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(FiftySpacing.xxxl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FiftyProgressBar(
                              value: progress,
                            ),
                            const SizedBox(height: FiftySpacing.md),
                            Text(
                              'LOADING ${(progress * 100).toInt()}%',
                              style: TextStyle(
                                fontFamily: FiftyTypography.fontFamily,
                                fontSize: FiftyTypography.labelMedium,
                                fontWeight: FiftyTypography.semiBold,
                                letterSpacing:
                                    FiftyTypography.letterSpacingLabelMedium,
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  builder: (context, frameIndex, progress, child) {
                    return Stack(
                      children: [
                        child,
                        // Progress overlay.
                        Positioned(
                          bottom: FiftySpacing.massive + FiftySpacing.xxxl,
                          left: FiftySpacing.lg,
                          child: _ProgressOverlay(
                            controller: _controller,
                            frameIndex: frameIndex,
                            progress: progress,
                            frameCount: _frameCount,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 500),
              ],
            ),
          ),

          // Bottom control bar.
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _ControlBar(controller: _controller),
          ),
        ],
      ),
    );
  }
}

/// Overlay widget displaying frame index and progress percentage.
class _ProgressOverlay extends StatelessWidget {
  const _ProgressOverlay({
    required this.controller,
    required this.frameIndex,
    required this.progress,
    required this.frameCount,
  });

  final ScrollSequenceController controller;
  final int frameIndex;
  final double progress;
  final int frameCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.md,
        vertical: FiftySpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.8),
        borderRadius: FiftyRadii.mdRadius,
        border: Border.all(color: FiftyColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: FiftySpacing.xs),
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

/// Bottom control bar with jump-to buttons.
class _ControlBar extends StatelessWidget {
  const _ControlBar({required this.controller});

  final ScrollSequenceController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: FiftySpacing.lg,
        right: FiftySpacing.lg,
        top: FiftySpacing.md,
        bottom: MediaQuery.paddingOf(context).bottom + FiftySpacing.md,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: FiftyColors.borderDark),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: FiftyButton(
              label: 'START',
              onPressed: () => controller.jumpToProgress(0.0),
              variant: FiftyButtonVariant.outline,
              size: FiftyButtonSize.small,
            ),
          ),
          const SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: FiftyButton(
              label: '50%',
              onPressed: () => controller.jumpToProgress(0.5),
              variant: FiftyButtonVariant.primary,
              size: FiftyButtonSize.small,
            ),
          ),
          const SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: FiftyButton(
              label: 'END',
              onPressed: () => controller.jumpToProgress(1.0),
              variant: FiftyButtonVariant.outline,
              size: FiftyButtonSize.small,
            ),
          ),
        ],
      ),
    );
  }
}
