/// Coffee Showcase - Main Showcase Page
///
/// Full-screen pinned scroll sequence with FDL chrome.
/// Demonstrates fifty_scroll_sequence with real video-extracted
/// WebP frames from a coffee product animation.
library;

import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Frame configuration constants.
const int _frameCount = 151;
const String _framePath = 'assets/frames/frame_{index}.webp';
const int _indexOffset = 1;
const int _indexPadWidth = 4;
const double _scrollExtent = 5000.0;

/// Main showcase page with pinned scroll sequence.
///
/// Presents a full-bleed dark layout with:
/// - Hero title section ("COFFEE")
/// - Scroll hint label
/// - Pinned [ScrollSequence] that scrubs through 151 WebP frames
/// - Frame counter overlay badge
/// - Loading progress indicator during frame preload
class ShowcasePage extends StatefulWidget {
  /// Creates the showcase page.
  const ShowcasePage({super.key});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  final _controller = ScrollSequenceController();

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Lead-in spacer.
            const SizedBox(height: 300),

            // Hero title section.
            const _HeroTitle(),

            const SizedBox(height: FiftySpacing.md),

            // Scroll hint.
            _ScrollHint(colorScheme: colorScheme),

            const SizedBox(height: FiftySpacing.xl),

            // Pinned scroll sequence.
            ScrollSequence(
              frameCount: _frameCount,
              framePath: _framePath,
              indexOffset: _indexOffset,
              indexPadWidth: _indexPadWidth,
              scrollExtent: _scrollExtent,
              pin: true,
              fit: BoxFit.contain,
              lerpFactor: 0.15,
              controller: _controller,
              loadingBuilder: _buildLoadingState,
              builder: _buildOverlay,
            ),

            // Trail-out spacer.
            const SizedBox(height: 500),
          ],
        ),
      ),
    );
  }

  /// Builds the loading indicator shown during frame preload.
  Widget _buildLoadingState(BuildContext context, double progress) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FiftySpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FiftyProgressBar(value: progress),
            const SizedBox(height: FiftySpacing.md),
            Text(
              'LOADING ${(progress * 100).toInt()}%',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelMedium,
                fontWeight: FiftyTypography.semiBold,
                letterSpacing: FiftyTypography.letterSpacingLabelMedium,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the frame overlay with counter badge.
  Widget _buildOverlay(
    BuildContext context,
    int frameIndex,
    double progress,
    Widget child,
  ) {
    return Stack(
      children: [
        child,

        // Frame counter badge (bottom-left).
        Positioned(
          bottom: FiftySpacing.xl,
          left: FiftySpacing.lg,
          child: _FrameCounterBadge(
            frameIndex: frameIndex,
            progress: progress,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Private widgets
// -----------------------------------------------------------------------------

/// Large hero title section displayed before the scroll sequence.
class _HeroTitle extends StatelessWidget {
  const _HeroTitle();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'COFFEE',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.displayLarge,
            fontWeight: FiftyTypography.bold,
            letterSpacing: 8,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: FiftySpacing.xs),
        Text(
          'SHOWCASE',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.titleLarge,
            fontWeight: FiftyTypography.regular,
            letterSpacing: 6,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

/// Scroll hint label shown below the hero title.
class _ScrollHint extends StatelessWidget {
  const _ScrollHint({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      'SCROLL TO EXPLORE',
      style: TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.labelMedium,
        fontWeight: FiftyTypography.semiBold,
        letterSpacing: FiftyTypography.letterSpacingLabelMedium,
        color: colorScheme.onSurface.withValues(alpha: 0.3),
      ),
    );
  }
}

/// Frame counter badge overlay showing current frame and progress.
class _FrameCounterBadge extends StatelessWidget {
  const _FrameCounterBadge({
    required this.frameIndex,
    required this.progress,
  });

  final int frameIndex;
  final double progress;

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
            'FRAME ${frameIndex + 1} / $_frameCount',
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
