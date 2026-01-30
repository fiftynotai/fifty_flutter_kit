/// Audio Demo Page
///
/// Demonstrates the Audio Engine with BGM, SFX, and Voice channels.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/status_indicator.dart';
import '../actions/audio_demo_actions.dart';
import '../controllers/audio_demo_view_model.dart';

/// Audio demo page widget.
///
/// Shows BGM, SFX, and Voice controls with a channel mixer.
class AudioDemoPage extends GetView<AudioDemoViewModel> {
  const AudioDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<AudioDemoActions>();
        return DemoScaffold(
          title: 'Audio Engine',
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Row
                _buildStatusRow(viewModel),
                const SizedBox(height: FiftySpacing.xl),

                // Channel Mixer Section
                const SectionHeader(
                  title: 'Channel Mixer',
                  subtitle: 'Master volume and mute controls',
                ),
                _buildChannelMixer(context, viewModel, actions),
                const SizedBox(height: FiftySpacing.xl),

                // BGM Section
                const SectionHeader(
                  title: 'Background Music',
                  subtitle: 'Track selection and playback controls',
                ),
                _buildBgmSection(context, viewModel, actions),
                const SizedBox(height: FiftySpacing.xl),

                // SFX Section
                const SectionHeader(
                  title: 'Sound Effects',
                  subtitle: 'Trigger sound effects by category',
                ),
                _buildSfxSection(context, viewModel, actions),
                const SizedBox(height: FiftySpacing.xl),

                // Voice Section
                const SectionHeader(
                  title: 'Voice Channel',
                  subtitle: 'Voice line playback',
                ),
                _buildVoiceSection(context, viewModel, actions),
                const SizedBox(height: FiftySpacing.xl),

                // Fade Demo Section
                const SectionHeader(
                  title: 'Fade Effects',
                  subtitle: 'Demonstrate volume fade presets',
                ),
                _buildFadeSection(context, viewModel, actions),
                const SizedBox(height: FiftySpacing.xl),

                // Reset Button
                Center(
                  child: FiftyButton(
                    label: 'RESET ALL',
                    onPressed: actions.onResetAll,
                    variant: FiftyButtonVariant.ghost,
                    size: FiftyButtonSize.small,
                  ),
                ),
                const SizedBox(height: FiftySpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusRow(AudioDemoViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusIndicator(
                label: 'BGM',
                state: viewModel.bgmPlaying ? StatusState.ready : StatusState.idle,
              ),
              const SizedBox(width: FiftySpacing.lg),
              StatusIndicator(
                label: 'SFX',
                state: viewModel.sfxMuted ? StatusState.idle : StatusState.ready,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusIndicator(
                label: 'VOICE',
                state: viewModel.voicePlaying ? StatusState.loading : StatusState.idle,
              ),
              const SizedBox(width: FiftySpacing.lg),
              StatusIndicator(
                label: 'MASTER',
                state: viewModel.masterMuted ? StatusState.error : StatusState.ready,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChannelMixer(
    BuildContext context,
    AudioDemoViewModel viewModel,
    AudioDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        children: [
          // Master Volume
          _buildVolumeRow(
            context: context,
            label: 'MASTER',
            icon: Icons.volume_up,
            volume: viewModel.masterVolume,
            isMuted: viewModel.masterMuted,
            onVolumeChanged: actions.onMasterVolumeChanged,
            onToggleMute: actions.onToggleMasterMute,
            color: colorScheme.primary,
          ),
          const SizedBox(height: FiftySpacing.md),
          Container(height: 1, color: colorScheme.outline),
          const SizedBox(height: FiftySpacing.md),

          // BGM Volume
          _buildVolumeRow(
            context: context,
            label: 'BGM',
            icon: Icons.music_note,
            volume: viewModel.bgmVolume,
            isMuted: viewModel.bgmMuted,
            onVolumeChanged: actions.onBgmVolumeChanged,
            onToggleMute: actions.onToggleBgmMute,
            color: colorScheme.secondary,
          ),
          const SizedBox(height: FiftySpacing.sm),

          // SFX Volume
          _buildVolumeRow(
            context: context,
            label: 'SFX',
            icon: Icons.speaker,
            volume: viewModel.sfxVolume,
            isMuted: viewModel.sfxMuted,
            onVolumeChanged: actions.onSfxVolumeChanged,
            onToggleMute: actions.onToggleSfxMute,
            color: colorScheme.tertiary,
          ),
          const SizedBox(height: FiftySpacing.sm),

          // Voice Volume
          _buildVolumeRow(
            context: context,
            label: 'VOICE',
            icon: Icons.record_voice_over,
            volume: viewModel.voiceVolume,
            isMuted: viewModel.voiceMuted,
            onVolumeChanged: actions.onVoiceVolumeChanged,
            onToggleMute: actions.onToggleVoiceMute,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeRow({
    required BuildContext context,
    required String label,
    required IconData icon,
    required double volume,
    required bool isMuted,
    required ValueChanged<double> onVolumeChanged,
    required VoidCallback onToggleMute,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveVolume = isMuted ? 0.0 : volume;

    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isMuted
                    ? colorScheme.onSurface.withValues(alpha: 0.3)
                    : color,
              ),
              const SizedBox(width: FiftySpacing.xs),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: isMuted
                        ? colorScheme.onSurface.withValues(alpha: 0.3)
                        : colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FiftySlider(
            value: effectiveVolume,
            onChanged: isMuted ? null : onVolumeChanged,
            enabled: !isMuted,
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(
            '${(effectiveVolume * 100).round()}%',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: isMuted
                  ? colorScheme.onSurface.withValues(alpha: 0.3)
                  : colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        const SizedBox(width: FiftySpacing.sm),
        FiftyIconButton(
          icon: isMuted ? Icons.volume_off : Icons.volume_up,
          tooltip: isMuted ? 'Unmute' : 'Mute',
          onPressed: onToggleMute,
          variant: isMuted
              ? FiftyIconButtonVariant.secondary
              : FiftyIconButtonVariant.ghost,
          size: FiftyIconButtonSize.small,
        ),
      ],
    );
  }

  Widget _buildBgmSection(
    BuildContext context,
    AudioDemoViewModel viewModel,
    AudioDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Track Selector
          Text(
            'SELECT TRACK',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
          Wrap(
            spacing: FiftySpacing.sm,
            runSpacing: FiftySpacing.sm,
            children: viewModel.availableTracks.map((track) {
              final isSelected = track == viewModel.currentTrack;
              return GestureDetector(
                onTap: () => actions.onTrackSelected(track),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FiftySpacing.md,
                    vertical: FiftySpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: FiftyRadii.lgRadius,
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                  ),
                  child: Text(
                    track.displayName.toUpperCase(),
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: FiftySpacing.lg),

          // Now Playing
          Container(
            padding: const EdgeInsets.all(FiftySpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: FiftyRadii.lgRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      viewModel.bgmPlaying
                          ? Icons.play_circle_filled
                          : Icons.play_circle_outline,
                      color: viewModel.bgmPlaying
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 24,
                    ),
                    const SizedBox(width: FiftySpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  viewModel.currentTrack.displayName,
                                  style: TextStyle(
                                    fontFamily: FiftyTypography.fontFamily,
                                    fontSize: FiftyTypography.bodyMedium,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              // Loop indicator
                              if (viewModel.loopEnabled)
                                Icon(
                                  Icons.repeat,
                                  size: 14,
                                  color: colorScheme.primary.withValues(alpha: 0.7),
                                ),
                            ],
                          ),
                          Text(
                            viewModel.currentTrack.assetPath.split('/').last,
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.bodySmall,
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${viewModel.bgmPositionLabel} / ${viewModel.bgmDurationLabel}',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FiftySpacing.sm),
                // Progress bar
                FiftySlider(
                  value: viewModel.bgmProgress,
                  onChanged: actions.onBgmSeek,
                ),
              ],
            ),
          ),
          const SizedBox(height: FiftySpacing.md),

          // Playback Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Shuffle toggle
              FiftyIconButton(
                icon: Icons.shuffle,
                tooltip: viewModel.shuffleEnabled ? 'Shuffle On' : 'Shuffle Off',
                onPressed: actions.onToggleShuffle,
                variant: viewModel.shuffleEnabled
                    ? FiftyIconButtonVariant.secondary
                    : FiftyIconButtonVariant.ghost,
                size: FiftyIconButtonSize.small,
              ),
              const SizedBox(width: FiftySpacing.sm),
              FiftyIconButton(
                icon: Icons.skip_previous,
                tooltip: 'Previous',
                onPressed: actions.onSkipPrevious,
                variant: FiftyIconButtonVariant.ghost,
                size: FiftyIconButtonSize.medium,
              ),
              const SizedBox(width: FiftySpacing.sm),
              FiftyIconButton(
                icon: Icons.stop,
                tooltip: 'Stop',
                onPressed: actions.onStopBgm,
                variant: FiftyIconButtonVariant.secondary,
                size: FiftyIconButtonSize.medium,
              ),
              const SizedBox(width: FiftySpacing.sm),
              FiftyIconButton(
                icon: viewModel.bgmPlaying ? Icons.pause : Icons.play_arrow,
                tooltip: viewModel.bgmPlaying ? 'Pause' : 'Play',
                onPressed: actions.onToggleBgmPlayback,
                variant: FiftyIconButtonVariant.primary,
                size: FiftyIconButtonSize.large,
              ),
              const SizedBox(width: FiftySpacing.sm),
              FiftyIconButton(
                icon: Icons.skip_next,
                tooltip: 'Next',
                onPressed: actions.onSkipNext,
                variant: FiftyIconButtonVariant.ghost,
                size: FiftyIconButtonSize.medium,
              ),
              const SizedBox(width: FiftySpacing.sm),
              FiftyIconButton(
                icon: viewModel.bgmMuted ? Icons.volume_off : Icons.volume_up,
                tooltip: viewModel.bgmMuted ? 'Unmute' : 'Mute',
                onPressed: actions.onToggleBgmMute,
                variant: viewModel.bgmMuted
                    ? FiftyIconButtonVariant.secondary
                    : FiftyIconButtonVariant.ghost,
                size: FiftyIconButtonSize.small,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSfxSection(
    BuildContext context,
    AudioDemoViewModel viewModel,
    AudioDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Selector using FiftyChip in Wrap layout
          Wrap(
            spacing: FiftySpacing.sm,
            runSpacing: FiftySpacing.sm,
            children: viewModel.sfxCategories.map((cat) {
              final isSelected = cat == viewModel.selectedCategory;
              return FiftyChip(
                label: cat.displayName,
                selected: isSelected,
                onTap: () => actions.onSfxCategorySelected(cat),
              );
            }).toList(),
          ),
          const SizedBox(height: FiftySpacing.lg),

          // Sound Effect Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: FiftySpacing.sm,
            crossAxisSpacing: FiftySpacing.sm,
            childAspectRatio: 2.5,
            children: viewModel.categorySoundEffects.map((sfx) {
              final isLastPlayed = sfx == viewModel.lastPlayedSfx;
              return GestureDetector(
                onTap: () => actions.onPlaySfx(context, sfx),
                child: Container(
                  padding: const EdgeInsets.all(FiftySpacing.sm),
                  decoration: BoxDecoration(
                    color: isLastPlayed
                        ? colorScheme.primary.withValues(alpha: 0.2)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: FiftyRadii.mdRadius,
                    border: Border.all(
                      color: isLastPlayed
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 20,
                        color: isLastPlayed
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: FiftySpacing.sm),
                      Expanded(
                        child: Text(
                          sfx.displayName,
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: FiftyTypography.bodySmall,
                            color: isLastPlayed
                                ? colorScheme.primary
                                : colorScheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          // Last played indicator
          if (viewModel.lastPlayedSfx != null) ...[
            const SizedBox(height: FiftySpacing.md),
            Container(
              padding: const EdgeInsets.all(FiftySpacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: FiftyRadii.smRadius,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.speaker,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  Text(
                    'Last played: ${viewModel.lastPlayedSfx!.displayName}',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVoiceSection(
    BuildContext context,
    AudioDemoViewModel viewModel,
    AudioDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current voice line display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(FiftySpacing.lg),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: FiftyRadii.lgRadius,
              border: Border.all(
                color: viewModel.voicePlaying
                    ? colorScheme.primary
                    : colorScheme.outline,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  viewModel.voicePlaying
                      ? Icons.record_voice_over
                      : Icons.voice_over_off,
                  size: 32,
                  color: viewModel.voicePlaying
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: FiftySpacing.sm),
                Text(
                  viewModel.voicePlaying
                      ? '"${viewModel.currentVoiceLine}"'
                      : 'Select a voice line',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    fontStyle: viewModel.voicePlaying
                        ? FontStyle.italic
                        : FontStyle.normal,
                    color: viewModel.voicePlaying
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FiftySpacing.lg),

          // Voice line buttons
          Text(
            'VOICE LINES',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
          Wrap(
            spacing: FiftySpacing.sm,
            runSpacing: FiftySpacing.sm,
            children: viewModel.voiceLines.map((voiceLine) {
              return FiftyButton(
                label: voiceLine.displayText,
                onPressed: () => actions.onPlayVoiceLine(context, voiceLine),
                variant: FiftyButtonVariant.secondary,
                size: FiftyButtonSize.small,
              );
            }).toList(),
          ),
          const SizedBox(height: FiftySpacing.md),

          // Stop button
          if (viewModel.voicePlaying)
            Center(
              child: FiftyButton(
                label: 'STOP',
                onPressed: actions.onStopVoice,
                variant: FiftyButtonVariant.ghost,
                size: FiftyButtonSize.small,
              ),
            ),
          const SizedBox(height: FiftySpacing.md),

          // Voice Ducking Toggle
          Container(
            padding: const EdgeInsets.all(FiftySpacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: FiftyRadii.smRadius,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tune,
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                const SizedBox(width: FiftySpacing.sm),
                Expanded(
                  child: Text(
                    'Auto-duck BGM',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                FiftySwitch(
                  value: viewModel.voiceDucking,
                  onChanged: (_) => actions.onToggleVoiceDucking(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFadeSection(
    BuildContext context,
    AudioDemoViewModel viewModel,
    AudioDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    // Define fade presets with their display info
    const fadePresets = [
      ('fast', 'Fast', '150ms'),
      ('normal', 'Normal', '800ms'),
      ('cinematic', 'Cinematic', '2s'),
      ('ambient', 'Ambient', '3s'),
    ];

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info text
          Container(
            padding: const EdgeInsets.all(FiftySpacing.md),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: FiftyRadii.lgRadius,
            ),
            child: Row(
              children: [
                Icon(
                  viewModel.isFading ? Icons.waves : Icons.info_outline,
                  size: 20,
                  color: viewModel.isFading
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: FiftySpacing.sm),
                Expanded(
                  child: Text(
                    viewModel.isFading
                        ? 'Fading with ${viewModel.lastFadePreset ?? 'preset'}...'
                        : 'Play BGM first, then tap a preset to see fade effect',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: viewModel.isFading
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FiftySpacing.lg),

          // Preset buttons
          Text(
            'FADE PRESETS',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: FiftySpacing.sm,
            crossAxisSpacing: FiftySpacing.sm,
            childAspectRatio: 2.5,
            children: fadePresets.map((preset) {
              final (name, label, duration) = preset;
              final isActive =
                  viewModel.isFading && viewModel.lastFadePreset == name;
              return GestureDetector(
                onTap: viewModel.isFading || !viewModel.bgmPlaying
                    ? null
                    : () => actions.onDemonstrateFade(context, name),
                child: Container(
                  padding: const EdgeInsets.all(FiftySpacing.sm),
                  decoration: BoxDecoration(
                    color: isActive
                        ? colorScheme.primary.withValues(alpha: 0.2)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: FiftyRadii.mdRadius,
                    border: Border.all(
                      color: isActive ? colorScheme.primary : colorScheme.outline,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        label.toUpperCase(),
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: FiftyTypography.bodySmall,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? colorScheme.primary
                              : (!viewModel.bgmPlaying
                                  ? colorScheme.onSurface.withValues(alpha: 0.3)
                                  : colorScheme.onSurface),
                        ),
                      ),
                      Text(
                        duration,
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: FiftyTypography.bodySmall,
                          color: isActive
                              ? colorScheme.primary.withValues(alpha: 0.7)
                              : colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
