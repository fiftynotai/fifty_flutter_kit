import '../../services/audio_service.dart';

/// Actions for SFX (Sound Effects) feature.
///
/// Handles user interactions and delegates to the audio engine.
class SfxActions {
  SfxActions();

  final AudioService _audio = AudioService.instance;

  /// Plays a sound effect by ID.
  Future<void> onPlaySound(String soundId) async {
    await _audio.playSfx(soundId);
  }

  /// Updates volume level.
  Future<void> onVolumeChanged(double value) async {
    await _audio.setSfxVolume(value);
  }

  /// Toggles mute state.
  Future<void> onMuteToggled() async {
    await _audio.toggleSfxMute();
  }
}
