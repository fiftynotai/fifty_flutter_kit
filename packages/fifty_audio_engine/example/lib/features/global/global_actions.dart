import '../../services/mock_audio_engine.dart';

/// Actions for Global audio controls.
///
/// Handles user interactions and delegates to the audio engine.
class GlobalActions {
  GlobalActions();

  final MockAudioEngine _engine = MockAudioEngine.instance;

  /// Toggles mute all state.
  void onMuteAllToggled() {
    _engine.toggleMuteAll();
  }

  /// Stops all audio playback.
  void onStopAll() {
    _engine.stopAll();
  }

  /// Changes the fade preset.
  void onFadePresetChanged(FadePreset preset) {
    _engine.setFadePreset(preset);
  }

  /// Fades all audio out using current preset.
  Future<void> onFadeOut() async {
    await _engine.fadeAllOut();
  }

  /// Fades all audio in using current preset.
  Future<void> onFadeIn() async {
    await _engine.fadeAllIn();
  }
}
