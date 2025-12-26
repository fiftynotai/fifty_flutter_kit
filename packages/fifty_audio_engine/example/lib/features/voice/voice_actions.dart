import '../../services/mock_audio_engine.dart';

/// Actions for Voice feature.
///
/// Handles user interactions and delegates to the audio engine.
class VoiceActions {
  VoiceActions();

  final MockVoiceChannel _voice = MockAudioEngine.instance.voice;

  /// Plays a voice line.
  void onPlayVoice(String voiceId) {
    _voice.playVoice(voiceId, withDucking: _voice.duckingEnabled);
  }

  /// Stops voice playback.
  void onStopPressed() {
    _voice.stop();
  }

  /// Updates volume level.
  void onVolumeChanged(double value) {
    _voice.setVolume(value);
  }

  /// Toggles mute state.
  void onMuteToggled() {
    _voice.toggleMute();
  }

  /// Toggles BGM ducking.
  void onDuckingToggled() {
    _voice.toggleDucking();
  }
}
