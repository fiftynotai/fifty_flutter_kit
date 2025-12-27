import 'package:flutter/foundation.dart';

import '../../services/audio_service.dart';

/// ViewModel for Voice feature.
///
/// Exposes Voice channel state for the view to observe.
class VoiceViewModel extends ChangeNotifier {
  VoiceViewModel() {
    _audio = AudioService.instance;
    _audio.addListener(_onAudioChanged);
  }

  late final AudioService _audio;

  /// Whether voice is currently playing.
  bool get isPlaying => _audio.voicePlaying;

  /// Whether voice channel is muted.
  bool get isMuted => _audio.voiceMuted;

  /// Whether BGM ducking is enabled.
  bool get duckingEnabled => _audio.voiceDuckingEnabled;

  /// Current volume level (0.0 to 1.0).
  double get volume => _audio.voiceVolume;

  /// List of available voice lines.
  List<VoiceInfo> get voiceLines => _audio.voiceLines;

  /// Currently playing voice ID (null if not playing).
  String? get currentVoice => _audio.voicePlaying ? 'greeting' : null;

  void _onAudioChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _audio.removeListener(_onAudioChanged);
    super.dispose();
  }
}
