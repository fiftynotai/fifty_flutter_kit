import '../../services/audio_service.dart';

/// Actions for Global audio controls.
///
/// Handles user interactions and delegates to the audio engine.
class GlobalActions {
  GlobalActions();

  final AudioService _audio = AudioService.instance;

  /// Toggles mute all state.
  Future<void> onMuteAllToggled() async {
    await _audio.toggleMuteAll();
  }

  /// Stops all audio playback.
  Future<void> onStopAll() async {
    await _audio.stopAll();
  }

  /// Changes the fade preset.
  void onFadePresetChanged(DemoFadePreset preset) {
    _audio.setFadePreset(preset);
  }

  /// Fades all audio out using current preset.
  Future<void> onFadeOut() async {
    await _audio.fadeAllOut();
  }

  /// Fades all audio in using current preset.
  Future<void> onFadeIn() async {
    await _audio.fadeAllIn();
  }
}
