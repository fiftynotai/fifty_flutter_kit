import '../../services/audio_service.dart';

/// Actions for BGM (Background Music) feature.
///
/// Handles user interactions and delegates to the audio engine.
/// Following MVVM + Actions pattern: View -> Actions -> ViewModel/Service.
class BgmActions {
  BgmActions();

  final AudioService _audio = AudioService.instance;

  /// Toggles play/pause state.
  Future<void> onPlayPressed() async {
    if (_audio.bgmPlaying) {
      await _audio.pauseBgm();
    } else if (_audio.bgmPaused) {
      await _audio.resumeBgm();
    } else {
      await _audio.playBgm();
    }
  }

  /// Stops playback.
  Future<void> onStopPressed() async {
    await _audio.stopBgm();
  }

  /// Plays next track.
  Future<void> onNextPressed() async {
    await _audio.playNextBgm();
  }

  /// Plays previous track.
  Future<void> onPreviousPressed() async {
    await _audio.playPreviousBgm();
  }

  /// Plays track at specific index.
  Future<void> onTrackSelected(int index) async {
    await _audio.playBgmAtIndex(index);
  }

  /// Updates volume level.
  Future<void> onVolumeChanged(double value) async {
    await _audio.setBgmVolume(value);
  }

  /// Toggles mute state.
  Future<void> onMuteToggled() async {
    await _audio.toggleBgmMute();
  }

  /// Toggles shuffle mode.
  void onShuffleToggled() {
    _audio.toggleBgmShuffle();
  }
}
