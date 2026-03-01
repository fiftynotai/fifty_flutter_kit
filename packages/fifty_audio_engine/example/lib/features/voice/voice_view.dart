import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/channel_card.dart';
import '../../widgets/volume_control.dart';
import 'voice_actions.dart';
import 'voice_view_model.dart';

/// View for Voice feature.
///
/// Displays Voice controls including:
/// - Voice playback button
/// - BGM ducking toggle
/// - Volume slider with mute
/// - Status indicator
class VoiceView extends StatefulWidget {
  const VoiceView({super.key});

  @override
  State<VoiceView> createState() => _VoiceViewState();
}

class _VoiceViewState extends State<VoiceView> {
  late final VoiceViewModel _viewModel;
  late final VoiceActions _actions;

  @override
  void initState() {
    super.initState();
    _viewModel = VoiceViewModel();
    _actions = VoiceActions();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return ListView(
          padding: EdgeInsets.all(FiftySpacing.lg),
          children: [
            _buildVoiceLines(),
            SizedBox(height: FiftySpacing.lg),
            _buildSettings(),
            SizedBox(height: FiftySpacing.lg),
            _buildVolumeControl(),
          ],
        );
      },
    );
  }

  Widget _buildVoiceLines() {
    final voiceLines = _viewModel.voiceLines;

    return ChannelCard(
      title: 'Voice Lines',
      statusLabel: _viewModel.isPlaying ? 'PLAYING' : null,
      statusActive: _viewModel.isPlaying,
      child: Column(
        children: [
          for (final voice in voiceLines)
            _VoiceLineButton(
              id: voice.id,
              label: voice.label,
              description: 'Duration: ${voice.duration.inSeconds}s',
              isPlaying:
                  _viewModel.isPlaying && _viewModel.currentVoice == voice.id,
              onPressed: () => _actions.onPlayVoice(voice.id),
            ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return ChannelCard(
      title: 'Voice Settings',
      child: Column(
        children: [
          // Ducking toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BGM Ducking',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodyLarge,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: FiftySpacing.xs),
                  Text(
                    _viewModel.duckingEnabled
                        ? 'BGM volume lowers during voice'
                        : 'BGM plays at full volume',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              FiftySwitch(
                value: _viewModel.duckingEnabled,
                onChanged: (_) => _actions.onDuckingToggled(),
              ),
            ],
          ),
          SizedBox(height: FiftySpacing.lg),
          // Info display
          FiftyDataSlate(
            title: 'Ducking Info',
            data: {
              'Mode': _viewModel.duckingEnabled ? 'AUTO' : 'DISABLED',
              'Duck Level': '30%',
              'Fade Time': '150ms',
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeControl() {
    return ChannelCard(
      title: 'Volume',
      child: VolumeControl(
        volume: _viewModel.volume,
        onVolumeChanged: _actions.onVolumeChanged,
        isMuted: _viewModel.isMuted,
        onMuteToggled: _actions.onMuteToggled,
        label: 'VOICE VOLUME',
      ),
    );
  }
}

class _VoiceLineButton extends StatelessWidget {
  const _VoiceLineButton({
    required this.id,
    required this.label,
    required this.description,
    required this.isPlaying,
    required this.onPressed,
  });

  final String id;
  final String label;
  final String description;
  final bool isPlaying;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: FiftySpacing.md),
      child: KineticEffect(
        child: GestureDetector(
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.all(FiftySpacing.md),
            decoration: BoxDecoration(
              color: isPlaying
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: FiftyRadii.lgRadius,
              border: Border.all(
                color: isPlaying ? colorScheme.primary : colorScheme.outline,
                width: isPlaying ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isPlaying
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    isPlaying ? Icons.graphic_eq : Icons.play_arrow,
                    color: isPlaying
                        ? colorScheme.onPrimary
                        : colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: FiftySpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: FiftyTypography.bodyLarge,
                          fontWeight: FiftyTypography.medium,
                          color: isPlaying
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: FiftyTypography.bodySmall,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isPlaying)
                  const FiftyLoadingIndicator(
                    size: FiftyLoadingSize.small,
                    style: FiftyLoadingStyle.dots,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
