import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/channel_card.dart';
import '../../widgets/volume_control.dart';
import 'sfx_actions.dart';
import 'sfx_view_model.dart';

/// View for SFX (Sound Effects) feature.
///
/// Displays SFX controls including:
/// - Grid of sound effect buttons
/// - Volume slider with mute
/// - Last played indicator
class SfxView extends StatefulWidget {
  const SfxView({super.key});

  @override
  State<SfxView> createState() => _SfxViewState();
}

class _SfxViewState extends State<SfxView> {
  late final SfxViewModel _viewModel;
  late final SfxActions _actions;

  @override
  void initState() {
    super.initState();
    _viewModel = SfxViewModel();
    _actions = SfxActions();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SFX Player')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(FiftySpacing.lg),
            children: [
              _buildSoundGrid(),
              const SizedBox(height: FiftySpacing.lg),
              _buildVolumeControl(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSoundGrid() {
    return ChannelCard(
      title: 'Sound Effects',
      statusLabel: _viewModel.isRecentlyPlayed ? _viewModel.lastPlayed : null,
      statusActive: _viewModel.isRecentlyPlayed,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: FiftySpacing.md,
          crossAxisSpacing: FiftySpacing.md,
          childAspectRatio: 1.2,
        ),
        itemCount: _viewModel.sounds.length,
        itemBuilder: (context, index) {
          final sound = _viewModel.sounds[index];
          final isLastPlayed = sound.id == _viewModel.lastPlayed;

          return _SfxButton(
            sound: sound,
            isActive: isLastPlayed && _viewModel.isRecentlyPlayed,
            onPressed: () => _actions.onPlaySound(sound.id),
          );
        },
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
        label: 'SFX VOLUME',
      ),
    );
  }
}

class _SfxButton extends StatelessWidget {
  const _SfxButton({
    required this.sound,
    required this.isActive,
    required this.onPressed,
  });

  final dynamic sound;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return KineticEffect(
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: isActive
                ? colorScheme.primary.withValues(alpha: 0.2)
                : FiftyColors.surfaceDark,
            borderRadius: FiftyRadii.lgRadius,
            border: Border.all(
              color: isActive ? colorScheme.primary : FiftyColors.borderDark,
              width: isActive ? 2 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconData(sound.icon, fontFamily: 'MaterialIcons'),
                size: 28,
                color: isActive
                    ? colorScheme.primary
                    : FiftyColors.cream,
              ),
              const SizedBox(height: FiftySpacing.xs),
              Text(
                sound.label,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: isActive
                      ? FiftyTypography.medium
                      : FiftyTypography.regular,
                  color: isActive
                      ? colorScheme.primary
                      : FiftyColors.slateGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
