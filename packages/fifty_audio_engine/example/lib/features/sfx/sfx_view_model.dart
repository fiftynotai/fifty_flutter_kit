import 'package:flutter/foundation.dart';

import '../../services/audio_service.dart';

/// ViewModel for SFX (Sound Effects) feature.
///
/// Exposes SFX channel state for the view to observe.
class SfxViewModel extends ChangeNotifier {
  SfxViewModel() {
    _audio = AudioService.instance;
    _audio.addListener(_onAudioChanged);
  }

  late final AudioService _audio;

  /// Whether SFX channel is muted.
  bool get isMuted => _audio.sfxMuted;

  /// Current volume level (0.0 to 1.0).
  double get volume => _audio.sfxVolume;

  /// List of available SFX sounds.
  List<SfxInfo> get sounds => _audio.sfxSounds;

  /// ID of last played sound.
  String? get lastPlayed => _audio.lastSfxPlayed;

  /// Timestamp for tracking recently played state.
  DateTime? _lastPlayedAt;

  /// Whether a sound was recently played (within 500ms).
  bool get isRecentlyPlayed {
    if (_lastPlayedAt == null) return false;
    return DateTime.now().difference(_lastPlayedAt!).inMilliseconds < 500;
  }

  void _onAudioChanged() {
    if (_audio.lastSfxPlayed != null) {
      _lastPlayedAt = DateTime.now();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _audio.removeListener(_onAudioChanged);
    super.dispose();
  }
}
