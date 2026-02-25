/// Scroll Sequence Example - Basic Demo Page
///
/// Demonstrates the simplest non-pinned ScrollSequence usage
/// with a GeneratedFrameLoader inside a SingleChildScrollView.
library;

import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/frame_generator.dart';

/// Basic (non-pinned) scroll sequence demo.
///
/// Shows the simplest possible usage of [ScrollSequence]:
/// - 60 procedurally generated frames
/// - Non-pinned mode (`pin: false`)
/// - Lead-in and trail-out spacing so the user can scroll through
class BasicPage extends StatelessWidget {
  /// Creates the basic demo page.
  const BasicPage({super.key});

  /// Number of frames for this demo.
  static const int _frameCount = 60;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'BASIC',
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
            // Lead-in spacing.
            const SizedBox(height: 200),

            // Instruction text.
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.xxl,
                vertical: FiftySpacing.lg,
              ),
              child: Text(
                'SCROLL TO SCRUB THROUGH FRAMES',
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

            // Non-pinned scroll sequence.
            ScrollSequence(
              frameCount: _frameCount,
              framePath: '',
              loader: GeneratedFrameLoader(frameCount: _frameCount),
              scrollExtent: 2000,
              pin: false,
              fit: BoxFit.cover,
            ),

            // Trail-out spacing.
            const SizedBox(height: 500),
          ],
        ),
      ),
    );
  }
}
