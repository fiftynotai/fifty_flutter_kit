import '../../services/mock_audio_engine.dart';

/// Actions for SFX (Sound Effects) feature.
///
/// Handles user interactions and delegates to the audio engine.
class SfxActions {
  SfxActions();

  final MockSfxChannel _sfx = MockAudioEngine.instance.sfx;

  /// Plays a sound effect by ID.
  void onPlaySound(String soundId) {
    _sfx.play(soundId);
  }

  /// Updates volume level.
  void onVolumeChanged(double value) {
    _sfx.setVolume(value);
  }

  /// Toggles mute state.
  void onMuteToggled() {
    _sfx.toggleMute();
  }
}
