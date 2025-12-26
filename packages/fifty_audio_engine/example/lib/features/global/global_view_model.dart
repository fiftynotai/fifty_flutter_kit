import 'package:flutter/foundation.dart';

import '../../services/audio_service.dart';

/// ViewModel for Global audio controls.
///
/// Exposes global audio engine state for the view to observe.
class GlobalViewModel extends ChangeNotifier {
  GlobalViewModel() {
    _audio = AudioService.instance;
    _audio.addListener(_onAudioChanged);
  }

  late final AudioService _audio;

  /// Whether all channels are muted.
  bool get allMuted => _audio.allMuted;

  /// Currently selected fade preset.
  DemoFadePreset get fadePreset => _audio.fadePreset;

  /// Whether a fade operation is in progress.
  bool get isFading => _audio.isFading;

  /// Whether BGM is currently playing.
  bool get bgmPlaying => _audio.bgmPlaying;

  /// Whether voice is currently playing.
  bool get voicePlaying => _audio.voicePlaying;

  /// BGM volume level.
  double get bgmVolume => _audio.bgmVolume;

  /// SFX volume level.
  double get sfxVolume => _audio.sfxVolume;

  /// Voice volume level.
  double get voiceVolume => _audio.voiceVolume;

  /// Whether BGM is muted.
  bool get bgmMuted => _audio.bgmMuted;

  /// Whether SFX is muted.
  bool get sfxMuted => _audio.sfxMuted;

  /// Whether voice is muted.
  bool get voiceMuted => _audio.voiceMuted;

  void _onAudioChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _audio.removeListener(_onAudioChanged);
    super.dispose();
  }
}
