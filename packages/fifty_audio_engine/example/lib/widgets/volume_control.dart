import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// A volume control widget with slider and mute toggle.
///
/// Combines a FiftySlider with a FiftyIconButton for mute functionality.
class VolumeControl extends StatelessWidget {
  /// Creates a volume control.
  const VolumeControl({
    super.key,
    required this.volume,
    required this.onVolumeChanged,
    required this.isMuted,
    required this.onMuteToggled,
    this.label = 'VOLUME',
    this.showLabel = true,
  });

  /// Current volume level (0.0 to 1.0).
  final double volume;

  /// Callback when volume changes.
  final ValueChanged<double> onVolumeChanged;

  /// Whether the channel is muted.
  final bool isMuted;

  /// Callback when mute is toggled.
  final VoidCallback onMuteToggled;

  /// Label text for the volume slider.
  final String label;

  /// Whether to show the volume value label.
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FiftyIconButton(
          icon: isMuted ? Icons.volume_off : Icons.volume_up,
          tooltip: isMuted ? 'Unmute' : 'Mute',
          onPressed: onMuteToggled,
          variant: isMuted
              ? FiftyIconButtonVariant.secondary
              : FiftyIconButtonVariant.ghost,
        ),
        const SizedBox(width: FiftySpacing.md),
        Expanded(
          child: Opacity(
            opacity: isMuted ? 0.5 : 1.0,
            child: FiftySlider(
              value: volume * 100,
              min: 0,
              max: 100,
              onChanged: isMuted
                  ? null
                  : (value) => onVolumeChanged(value / 100),
              label: label,
              showLabel: showLabel,
              labelBuilder: (value) => '${value.round()}%',
              enabled: !isMuted,
            ),
          ),
        ),
      ],
    );
  }
}
