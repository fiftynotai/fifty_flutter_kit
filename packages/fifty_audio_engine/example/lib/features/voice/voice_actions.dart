import '../../services/audio_service.dart';

/// Actions for Voice feature.
///
/// Handles user interactions and delegates to the audio engine.
class VoiceActions {
  VoiceActions();

  final AudioService _audio = AudioService.instance;

  /// Plays a voice line.
  Future<void> onPlayVoice(String voiceId) async {
    await _audio.playVoice(voiceId);
  }

  /// Stops voice playback.
  Future<void> onStopPressed() async {
    await _audio.stopVoice();
  }

  /// Updates volume level.
  Future<void> onVolumeChanged(double value) async {
    await _audio.setVoiceVolume(value);
  }

  /// Toggles mute state.
  Future<void> onMuteToggled() async {
    await _audio.toggleVoiceMute();
  }

  /// Toggles BGM ducking.
  void onDuckingToggled() {
    _audio.toggleVoiceDucking();
  }
}
