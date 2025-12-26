import '../../services/mock_audio_engine.dart';

/// Actions for BGM (Background Music) feature.
///
/// Handles user interactions and delegates to the audio engine.
/// Following MVVM + Actions pattern: View -> Actions -> ViewModel/Service.
class BgmActions {
  BgmActions();

  final MockBgmChannel _bgm = MockAudioEngine.instance.bgm;

  /// Toggles play/pause state.
  void onPlayPressed() {
    if (_bgm.isPlaying) {
      _bgm.pause();
    } else if (_bgm.isPaused) {
      _bgm.resume();
    } else {
      _bgm.play();
    }
  }

  /// Stops playback.
  void onStopPressed() {
    _bgm.stop();
  }

  /// Plays next track.
  void onNextPressed() {
    _bgm.next();
  }

  /// Plays previous track.
  void onPreviousPressed() {
    _bgm.previous();
  }

  /// Plays track at specific index.
  void onTrackSelected(int index) {
    _bgm.playAtIndex(index);
  }

  /// Updates volume level.
  void onVolumeChanged(double value) {
    _bgm.setVolume(value);
  }

  /// Toggles mute state.
  void onMuteToggled() {
    _bgm.toggleMute();
  }

  /// Toggles shuffle mode.
  void onShuffleToggled() {
    _bgm.toggleShuffle();
  }
}
