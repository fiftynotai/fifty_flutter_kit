import 'package:flutter/foundation.dart';

import '../../services/mock_audio_engine.dart';

/// ViewModel for Voice feature.
///
/// Exposes Voice channel state for the view to observe.
class VoiceViewModel extends ChangeNotifier {
  VoiceViewModel() {
    _voice = MockAudioEngine.instance.voice;
    _voice.addListener(_onVoiceChanged);
  }

  late final MockVoiceChannel _voice;

  /// Whether voice is currently playing.
  bool get isPlaying => _voice.isPlaying;

  /// Whether voice channel is muted.
  bool get isMuted => _voice.isMuted;

  /// Whether BGM ducking is enabled.
  bool get duckingEnabled => _voice.duckingEnabled;

  /// Current volume level (0.0 to 1.0).
  double get volume => _voice.volume;

  /// Currently playing voice ID.
  String? get currentVoice => _voice.currentVoice;

  void _onVoiceChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _voice.removeListener(_onVoiceChanged);
    super.dispose();
  }
}
