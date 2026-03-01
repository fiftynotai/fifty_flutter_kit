import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Playback transport controls for audio.
///
/// Provides previous, play/pause, stop, and next buttons.
class PlaybackControls extends StatelessWidget {
  /// Creates playback controls.
  const PlaybackControls({
    super.key,
    required this.isPlaying,
    required this.onPlayPressed,
    required this.onStopPressed,
    this.onPreviousPressed,
    this.onNextPressed,
    this.showPrevNext = true,
  });

  /// Whether audio is currently playing.
  final bool isPlaying;

  /// Callback when play/pause is pressed.
  final VoidCallback onPlayPressed;

  /// Callback when stop is pressed.
  final VoidCallback onStopPressed;

  /// Callback when previous is pressed.
  final VoidCallback? onPreviousPressed;

  /// Callback when next is pressed.
  final VoidCallback? onNextPressed;

  /// Whether to show previous/next buttons.
  final bool showPrevNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showPrevNext) ...[
          FiftyIconButton(
            icon: Icons.skip_previous,
            tooltip: 'Previous',
            onPressed: onPreviousPressed,
            variant: FiftyIconButtonVariant.ghost,
            size: FiftyIconButtonSize.large,
          ),
          SizedBox(width: FiftySpacing.md),
        ],
        FiftyIconButton(
          icon: isPlaying ? Icons.pause : Icons.play_arrow,
          tooltip: isPlaying ? 'Pause' : 'Play',
          onPressed: onPlayPressed,
          variant: FiftyIconButtonVariant.primary,
          size: FiftyIconButtonSize.large,
        ),
        SizedBox(width: FiftySpacing.md),
        FiftyIconButton(
          icon: Icons.stop,
          tooltip: 'Stop',
          onPressed: onStopPressed,
          variant: FiftyIconButtonVariant.secondary,
          size: FiftyIconButtonSize.large,
        ),
        if (showPrevNext) ...[
          SizedBox(width: FiftySpacing.md),
          FiftyIconButton(
            icon: Icons.skip_next,
            tooltip: 'Next',
            onPressed: onNextPressed,
            variant: FiftyIconButtonVariant.ghost,
            size: FiftyIconButtonSize.large,
          ),
        ],
      ],
    );
  }
}
