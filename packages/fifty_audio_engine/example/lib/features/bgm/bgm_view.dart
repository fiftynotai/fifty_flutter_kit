import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/channel_card.dart';
import '../../widgets/playback_controls.dart';
import '../../widgets/volume_control.dart';
import 'bgm_actions.dart';
import 'bgm_view_model.dart';

/// View for BGM (Background Music) feature.
///
/// Displays BGM controls including:
/// - Now playing info
/// - Playback controls (prev, play/pause, stop, next)
/// - Volume slider with mute
/// - Shuffle toggle
/// - Track list
class BgmView extends StatefulWidget {
  const BgmView({super.key});

  @override
  State<BgmView> createState() => _BgmViewState();
}

class _BgmViewState extends State<BgmView> {
  late final BgmViewModel _viewModel;
  late final BgmActions _actions;

  @override
  void initState() {
    super.initState();
    _viewModel = BgmViewModel();
    _actions = BgmActions();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BGM Player')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(FiftySpacing.lg),
            children: [
              _buildNowPlaying(),
              const SizedBox(height: FiftySpacing.lg),
              _buildControls(),
              const SizedBox(height: FiftySpacing.lg),
              _buildTrackList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNowPlaying() {
    return ChannelCard(
      title: 'Now Playing',
      statusLabel: _viewModel.isPlaying ? 'PLAYING' : 'STOPPED',
      statusActive: _viewModel.isPlaying,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _viewModel.currentTrack.title,
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.titleLarge,
              fontWeight: FiftyTypography.extraBold,
              color: FiftyColors.cream,
            ),
          ),
          const SizedBox(height: FiftySpacing.xs),
          Text(
            _viewModel.currentTrack.artist,
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyLarge,
              color: FiftyColors.slateGrey,
            ),
          ),
          const SizedBox(height: FiftySpacing.lg),
          // Progress bar
          FiftyProgressBar(
            value: _viewModel.progress,
            showPercentage: false,
          ),
          const SizedBox(height: FiftySpacing.sm),
          // Time display
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _viewModel.positionString,
                style: const TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  color: FiftyColors.slateGrey,
                ),
              ),
              Text(
                _viewModel.durationString,
                style: const TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  color: FiftyColors.slateGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return ChannelCard(
      title: 'Controls',
      child: Column(
        children: [
          // Playback controls
          PlaybackControls(
            isPlaying: _viewModel.isPlaying,
            onPlayPressed: _actions.onPlayPressed,
            onStopPressed: _actions.onStopPressed,
            onPreviousPressed: _actions.onPreviousPressed,
            onNextPressed: _actions.onNextPressed,
          ),
          const SizedBox(height: FiftySpacing.xl),
          // Volume control
          VolumeControl(
            volume: _viewModel.volume,
            onVolumeChanged: _actions.onVolumeChanged,
            isMuted: _viewModel.isMuted,
            onMuteToggled: _actions.onMuteToggled,
          ),
          const SizedBox(height: FiftySpacing.lg),
          // Shuffle toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shuffle',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodyLarge,
                  color: FiftyColors.cream,
                ),
              ),
              FiftySwitch(
                value: _viewModel.isShuffled,
                onChanged: (_) => _actions.onShuffleToggled(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackList() {
    return ChannelCard(
      title: 'Playlist',
      child: Column(
        children: [
          for (int i = 0; i < _viewModel.tracks.length; i++)
            _TrackListItem(
              track: _viewModel.tracks[i],
              isSelected: i == _viewModel.currentTrackIndex,
              isPlaying: i == _viewModel.currentTrackIndex && _viewModel.isPlaying,
              onTap: () => _actions.onTrackSelected(i),
            ),
        ],
      ),
    );
  }
}

class _TrackListItem extends StatelessWidget {
  const _TrackListItem({
    required this.track,
    required this.isSelected,
    required this.isPlaying,
    required this.onTap,
  });

  final dynamic track;
  final bool isSelected;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return KineticEffect(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: FiftySpacing.md,
            vertical: FiftySpacing.md,
          ),
          margin: const EdgeInsets.only(bottom: FiftySpacing.sm),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: FiftyRadii.lgRadius,
            border: Border.all(
              color: isSelected ? colorScheme.primary : FiftyColors.borderDark,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Play indicator
              SizedBox(
                width: 24,
                child: isPlaying
                    ? Icon(
                        Icons.equalizer,
                        size: 20,
                        color: colorScheme.primary,
                      )
                    : Icon(
                        Icons.music_note,
                        size: 20,
                        color: isSelected
                            ? colorScheme.primary
                            : FiftyColors.slateGrey,
                      ),
              ),
              const SizedBox(width: FiftySpacing.md),
              // Track info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyLarge,
                        fontWeight: isSelected
                            ? FiftyTypography.medium
                            : FiftyTypography.regular,
                        color: isSelected
                            ? colorScheme.primary
                            : FiftyColors.cream,
                      ),
                    ),
                    Text(
                      track.artist,
                      style: const TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: FiftyColors.slateGrey,
                      ),
                    ),
                  ],
                ),
              ),
              // Duration
              Text(
                _formatDuration(track.duration),
                style: const TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  color: FiftyColors.slateGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
