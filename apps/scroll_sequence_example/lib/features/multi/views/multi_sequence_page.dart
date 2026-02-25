/// Scroll Sequence Example - Multi-Sequence Demo Page
///
/// Demonstrates two independent ScrollSequence widgets on the same page,
/// each with its own GeneratedFrameLoader and frame count.
library;

import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/frame_generator.dart';

/// Multi-sequence demo with two independent pinned sequences.
///
/// Shows that multiple [ScrollSequence] widgets can coexist on the same
/// scrollable page without interfering with each other. Each sequence
/// has its own [GeneratedFrameLoader] and frame count.
class MultiSequencePage extends StatelessWidget {
  /// Creates the multi-sequence demo page.
  const MultiSequencePage({super.key});

  /// Frame count for the first sequence.
  static const int _sequence1FrameCount = 40;

  /// Frame count for the second sequence.
  static const int _sequence2FrameCount = 60;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'MULTI',
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
            const SizedBox(height: 100),

            // Label for sequence 1.
            _SequenceLabel(label: 'SEQUENCE 1', colorScheme: colorScheme),
            const SizedBox(height: FiftySpacing.md),

            // First pinned sequence (40 frames).
            ScrollSequence(
              frameCount: _sequence1FrameCount,
              framePath: '',
              loader: GeneratedFrameLoader(
                frameCount: _sequence1FrameCount,
                width: 360,
                height: 360,
              ),
              scrollExtent: 1500,
              pin: true,
              fit: BoxFit.cover,
              builder: (context, frameIndex, progress, child) {
                return Stack(
                  children: [
                    child,
                    Positioned(
                      top: FiftySpacing.md,
                      right: FiftySpacing.md,
                      child: _FrameBadge(
                        label:
                            '${frameIndex + 1} / $_sequence1FrameCount',
                        colorScheme: colorScheme,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 200),

            // Label for sequence 2.
            _SequenceLabel(label: 'SEQUENCE 2', colorScheme: colorScheme),
            const SizedBox(height: FiftySpacing.md),

            // Second pinned sequence (60 frames).
            ScrollSequence(
              frameCount: _sequence2FrameCount,
              framePath: '',
              loader: GeneratedFrameLoader(
                frameCount: _sequence2FrameCount,
                width: 360,
                height: 480,
              ),
              scrollExtent: 2000,
              pin: true,
              fit: BoxFit.cover,
              builder: (context, frameIndex, progress, child) {
                return Stack(
                  children: [
                    child,
                    Positioned(
                      top: FiftySpacing.md,
                      right: FiftySpacing.md,
                      child: _FrameBadge(
                        label:
                            '${frameIndex + 1} / $_sequence2FrameCount',
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
}

/// Label widget shown between sequences.
class _SequenceLabel extends StatelessWidget {
  const _SequenceLabel({
    required this.label,
    required this.colorScheme,
  });

  final String label;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FiftySpacing.xxl),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.labelMedium,
            fontWeight: FiftyTypography.bold,
            letterSpacing: FiftyTypography.letterSpacingLabelMedium,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

/// Small badge overlay showing the current frame number.
class _FrameBadge extends StatelessWidget {
  const _FrameBadge({
    required this.label,
    required this.colorScheme,
  });

  final String label;
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
        label,
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
