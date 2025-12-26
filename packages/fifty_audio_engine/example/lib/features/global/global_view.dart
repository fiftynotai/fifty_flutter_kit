import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../services/mock_audio_engine.dart';
import '../../widgets/channel_card.dart';
import 'global_actions.dart';
import 'global_view_model.dart';

/// View for Global audio controls.
///
/// Displays global controls including:
/// - Master mute toggle
/// - Fade preset selector
/// - Fade in/out buttons
/// - Stop all button
/// - Channel status overview
class GlobalView extends StatefulWidget {
  const GlobalView({super.key});

  @override
  State<GlobalView> createState() => _GlobalViewState();
}

class _GlobalViewState extends State<GlobalView> {
  late final GlobalViewModel _viewModel;
  late final GlobalActions _actions;

  @override
  void initState() {
    super.initState();
    _viewModel = GlobalViewModel();
    _actions = GlobalActions();
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
          padding: const EdgeInsets.all(FiftySpacing.lg),
          children: [
            _buildMasterControls(),
            const SizedBox(height: FiftySpacing.lg),
            _buildFadeControls(),
            const SizedBox(height: FiftySpacing.lg),
            _buildChannelStatus(),
          ],
        );
      },
    );
  }

  Widget _buildMasterControls() {
    return ChannelCard(
      title: 'Master Controls',
      statusLabel: _viewModel.allMuted ? 'MUTED' : 'ACTIVE',
      statusActive: !_viewModel.allMuted,
      child: Column(
        children: [
          // Master mute toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Master Mute',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.body,
                      color: FiftyColors.terminalWhite,
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.xs),
                  Text(
                    _viewModel.allMuted
                        ? 'All channels muted'
                        : 'All channels active',
                    style: const TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.mono,
                      color: FiftyColors.hyperChrome,
                    ),
                  ),
                ],
              ),
              FiftySwitch(
                value: _viewModel.allMuted,
                onChanged: (_) => _actions.onMuteAllToggled(),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),
          // Stop all button
          FiftyButton(
            label: 'STOP ALL',
            onPressed: _actions.onStopAll,
            variant: FiftyButtonVariant.danger,
            icon: Icons.stop,
            expanded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFadeControls() {
    final fadeItems = FadePreset.values
        .map((p) => FiftyDropdownItem(value: p, label: p.label))
        .toList();

    return ChannelCard(
      title: 'Fade Controls',
      statusLabel: _viewModel.isFading ? 'FADING' : null,
      statusActive: _viewModel.isFading,
      child: Column(
        children: [
          // Fade preset dropdown
          FiftyDropdown<FadePreset>(
            items: fadeItems,
            value: _viewModel.fadePreset,
            onChanged: (preset) {
              if (preset != null) {
                _actions.onFadePresetChanged(preset);
              }
            },
            label: 'Fade Preset',
            hint: 'Select fade duration',
          ),
          const SizedBox(height: FiftySpacing.lg),
          // Preset info
          FiftyDataSlate(
            title: 'Preset Info',
            data: {
              'Duration': '${_viewModel.fadePreset.duration.inMilliseconds}ms',
              'Use Case': _getPresetUseCase(_viewModel.fadePreset),
            },
          ),
          const SizedBox(height: FiftySpacing.lg),
          // Fade buttons
          Row(
            children: [
              Expanded(
                child: FiftyButton(
                  label: 'FADE IN',
                  onPressed: _viewModel.isFading ? null : _actions.onFadeIn,
                  variant: FiftyButtonVariant.secondary,
                  icon: Icons.volume_up,
                  loading: _viewModel.isFading,
                ),
              ),
              const SizedBox(width: FiftySpacing.md),
              Expanded(
                child: FiftyButton(
                  label: 'FADE OUT',
                  onPressed: _viewModel.isFading ? null : _actions.onFadeOut,
                  variant: FiftyButtonVariant.secondary,
                  icon: Icons.volume_off,
                  loading: _viewModel.isFading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChannelStatus() {
    return ChannelCard(
      title: 'Channel Status',
      child: Column(
        children: [
          _ChannelStatusRow(
            label: 'BGM',
            isActive: _viewModel.bgmPlaying,
            isMuted: _viewModel.bgmMuted,
            volume: _viewModel.bgmVolume,
          ),
          const SizedBox(height: FiftySpacing.md),
          _ChannelStatusRow(
            label: 'SFX',
            isActive: true,
            isMuted: _viewModel.sfxMuted,
            volume: _viewModel.sfxVolume,
          ),
          const SizedBox(height: FiftySpacing.md),
          _ChannelStatusRow(
            label: 'VOICE',
            isActive: _viewModel.voicePlaying,
            isMuted: _viewModel.voiceMuted,
            volume: _viewModel.voiceVolume,
          ),
        ],
      ),
    );
  }

  String _getPresetUseCase(FadePreset preset) {
    switch (preset) {
      case FadePreset.fast:
        return 'UI feedback';
      case FadePreset.panel:
        return 'Panel transitions';
      case FadePreset.normal:
        return 'Standard crossfade';
      case FadePreset.cinematic:
        return 'Scene transitions';
      case FadePreset.ambient:
        return 'Atmospheric changes';
    }
  }
}

class _ChannelStatusRow extends StatelessWidget {
  const _ChannelStatusRow({
    required this.label,
    required this.isActive,
    required this.isMuted,
    required this.volume,
  });

  final String label;
  final bool isActive;
  final bool isMuted;
  final double volume;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(FiftySpacing.md),
      decoration: BoxDecoration(
        color: FiftyColors.voidBlack,
        borderRadius: FiftyRadii.standardRadius,
        border: Border.all(
          color: FiftyColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isMuted
                  ? FiftyColors.hyperChrome
                  : (isActive ? FiftyColors.igrisGreen : colorScheme.primary),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: FiftySpacing.md),
          // Label
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.body,
                fontWeight: FiftyTypography.medium,
                color: FiftyColors.terminalWhite,
              ),
            ),
          ),
          const SizedBox(width: FiftySpacing.md),
          // Volume bar
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: FiftyColors.hyperChrome.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: isMuted ? 0 : volume,
                child: Container(
                  decoration: BoxDecoration(
                    color: isMuted ? FiftyColors.hyperChrome : colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: FiftySpacing.md),
          // Volume percentage
          SizedBox(
            width: 40,
            child: Text(
              isMuted ? 'MUTE' : '${(volume * 100).round()}%',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.mono,
                color: isMuted ? FiftyColors.hyperChrome : FiftyColors.terminalWhite,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
