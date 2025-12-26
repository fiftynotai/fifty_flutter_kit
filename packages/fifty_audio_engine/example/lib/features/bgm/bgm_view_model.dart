import 'package:flutter/foundation.dart';

import '../../services/mock_audio_engine.dart';

/// ViewModel for BGM (Background Music) feature.
///
/// Exposes BGM channel state for the view to observe.
/// All state changes flow through the MockBgmChannel.
class BgmViewModel extends ChangeNotifier {
  BgmViewModel() {
    _bgm = MockAudioEngine.instance.bgm;
    _bgm.addListener(_onBgmChanged);
  }

  late final MockBgmChannel _bgm;

  /// Whether BGM is currently playing (not paused).
  bool get isPlaying => _bgm.isPlaying;

  /// Whether BGM is paused.
  bool get isPaused => _bgm.isPaused;

  /// Whether BGM channel is muted.
  bool get isMuted => _bgm.isMuted;

  /// Whether shuffle mode is enabled.
  bool get isShuffled => _bgm.isShuffled;

  /// Current volume level (0.0 to 1.0).
  double get volume => _bgm.volume;

  /// Index of currently playing track.
  int get currentTrackIndex => _bgm.currentTrackIndex;

  /// Currently playing track info.
  BgmTrack get currentTrack => _bgm.currentTrack;

  /// List of all available tracks.
  List<BgmTrack> get tracks => _bgm.tracks;

  /// Current playback position.
  Duration get position => _bgm.position;

  /// Playback progress (0.0 to 1.0).
  double get progress => _bgm.progress;

  /// Formatted position string (MM:SS).
  String get positionString => _formatDuration(_bgm.position);

  /// Formatted duration string (MM:SS).
  String get durationString => _formatDuration(currentTrack.duration);

  void _onBgmChanged() {
    notifyListeners();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _bgm.removeListener(_onBgmChanged);
    super.dispose();
  }
}
