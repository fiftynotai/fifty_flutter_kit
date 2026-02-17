/// Audio Settings Section
///
/// Displays master mute toggle and volume sliders for BGM, SFX, and Voice
/// channels. Sliders are disabled when the master mute is active.
///
/// Uses FDL components: [FiftySectionHeader], [FiftySettingsRow], [FiftySlider].
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../actions/settings_actions.dart';
import '../../controllers/settings_view_model.dart';

/// Audio controls section with mute toggle and three volume sliders.
///
/// Observes [SettingsViewModel] reactively via `Obx()`. All interactions
/// are delegated to [SettingsActions].
///
/// **Components:**
/// - Master mute toggle ([FiftySettingsRow] with switch).
/// - BGM volume slider (0.0 - 1.0, percentage label).
/// - SFX volume slider (0.0 - 1.0, percentage label).
/// - Voice volume slider (0.0 - 1.0, percentage label).
class AudioSettingsSection extends StatelessWidget {
  /// Creates the audio settings section.
  const AudioSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<SettingsViewModel>();
    final actions = Get.find<SettingsActions>();

    return Obx(() {
      final muted = vm.isMuted.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          const FiftySectionHeader(
            title: 'Audio',
            size: FiftySectionHeaderSize.medium,
          ),

          // Master mute toggle
          FiftySettingsRow(
            label: 'Master Mute',
            subtitle: 'Silence all audio channels',
            icon: muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
            value: muted,
            onChanged: (_) => actions.onMuteToggled(),
          ),

          const SizedBox(height: FiftySpacing.lg),

          // BGM Volume
          _VolumeSliderRow(
            label: 'BGM VOLUME',
            value: vm.bgmVolume.value,
            enabled: !muted,
            onChanged: actions.onBgmVolumeChanged,
          ),

          const SizedBox(height: FiftySpacing.lg),

          // SFX Volume
          _VolumeSliderRow(
            label: 'SFX VOLUME',
            value: vm.sfxVolume.value,
            enabled: !muted,
            onChanged: actions.onSfxVolumeChanged,
          ),

          const SizedBox(height: FiftySpacing.lg),

          // Voice Volume
          _VolumeSliderRow(
            label: 'VOICE VOLUME',
            value: vm.voiceVolume.value,
            enabled: !muted,
            onChanged: actions.onVoiceVolumeChanged,
          ),
        ],
      );
    });
  }
}

/// A labeled volume slider row showing a percentage value.
class _VolumeSliderRow extends StatelessWidget {
  const _VolumeSliderRow({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  /// Label text displayed above the slider.
  final String label;

  /// Current volume value (0.0 - 1.0).
  final double value;

  /// Whether the slider is interactive.
  final bool enabled;

  /// Callback when the slider value changes.
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final percentage = (value * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelMedium,
                fontWeight: FiftyTypography.bold,
                color: enabled
                    ? FiftyColors.cream
                    : FiftyColors.cream.withAlpha(100),
                letterSpacing: FiftyTypography.letterSpacingLabelMedium,
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelMedium,
                fontWeight: FiftyTypography.medium,
                color: enabled
                    ? FiftyColors.slateGrey
                    : FiftyColors.slateGrey.withAlpha(100),
              ),
            ),
          ],
        ),
        const SizedBox(height: FiftySpacing.sm),

        // Slider
        FiftySlider(
          value: value,
          onChanged: enabled ? onChanged : null,
          min: 0.0,
          max: 1.0,
          enabled: enabled,
        ),
      ],
    );
  }
}
