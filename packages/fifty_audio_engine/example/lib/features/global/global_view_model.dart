import 'package:flutter/foundation.dart';

import '../../services/mock_audio_engine.dart';

/// ViewModel for Global audio controls.
///
/// Exposes global audio engine state for the view to observe.
class GlobalViewModel extends ChangeNotifier {
  GlobalViewModel() {
    _engine = MockAudioEngine.instance;
    _engine.addListener(_onEngineChanged);
    _engine.bgm.addListener(_onEngineChanged);
    _engine.sfx.addListener(_onEngineChanged);
    _engine.voice.addListener(_onEngineChanged);
  }

  late final MockAudioEngine _engine;

  /// Whether all channels are muted.
  bool get allMuted => _engine.allMuted;

  /// Currently selected fade preset.
  FadePreset get fadePreset => _engine.fadePreset;

  /// Whether a fade operation is in progress.
  bool get isFading => _engine.isFading;

  /// Whether BGM is currently playing.
  bool get bgmPlaying => _engine.bgm.isPlaying;

  /// Whether voice is currently playing.
  bool get voicePlaying => _engine.voice.isPlaying;

  /// BGM volume level.
  double get bgmVolume => _engine.bgm.volume;

  /// SFX volume level.
  double get sfxVolume => _engine.sfx.volume;

  /// Voice volume level.
  double get voiceVolume => _engine.voice.volume;

  /// Whether BGM is muted.
  bool get bgmMuted => _engine.bgm.isMuted;

  /// Whether SFX is muted.
  bool get sfxMuted => _engine.sfx.isMuted;

  /// Whether voice is muted.
  bool get voiceMuted => _engine.voice.isMuted;

  void _onEngineChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _engine.removeListener(_onEngineChanged);
    _engine.bgm.removeListener(_onEngineChanged);
    _engine.sfx.removeListener(_onEngineChanged);
    _engine.voice.removeListener(_onEngineChanged);
    super.dispose();
  }
}
