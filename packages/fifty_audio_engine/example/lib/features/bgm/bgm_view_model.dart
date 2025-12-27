import 'package:flutter/foundation.dart';

import '../../services/audio_service.dart';

/// ViewModel for BGM (Background Music) feature.
///
/// Exposes BGM channel state for the view to observe.
/// All state changes flow through the AudioService.
class BgmViewModel extends ChangeNotifier {
  BgmViewModel() {
    _audio = AudioService.instance;
    _audio.addListener(_onAudioChanged);
  }

  late final AudioService _audio;

  /// Whether BGM is currently playing (not paused).
  bool get isPlaying => _audio.bgmPlaying;

  /// Whether BGM is paused.
  bool get isPaused => _audio.bgmPaused;

  /// Whether BGM channel is muted.
  bool get isMuted => _audio.bgmMuted;

  /// Whether shuffle mode is enabled.
  bool get isShuffled => _audio.bgmShuffled;

  /// Current volume level (0.0 to 1.0).
  double get volume => _audio.bgmVolume;

  /// Index of currently playing track.
  int get currentTrackIndex => _audio.bgmTrackIndex;

  /// Currently playing track info.
  TrackInfo get currentTrack => _audio.currentTrack;

  /// List of all available tracks.
  List<TrackInfo> get tracks => _audio.bgmTracks;

  /// Current playback position.
  Duration get position => _audio.bgmPosition;

  /// Playback progress (0.0 to 1.0).
  double get progress => _audio.bgmProgress;

  /// Formatted position string (MM:SS).
  String get positionString => _formatDuration(_audio.bgmPosition);

  /// Formatted duration string (MM:SS).
  String get durationString => _formatDuration(currentTrack.duration);

  void _onAudioChanged() {
    notifyListeners();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audio.removeListener(_onAudioChanged);
    super.dispose();
  }
}
