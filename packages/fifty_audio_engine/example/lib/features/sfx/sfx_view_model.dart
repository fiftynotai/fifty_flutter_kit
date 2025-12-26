import 'package:flutter/foundation.dart';

import '../../services/mock_audio_engine.dart';

/// ViewModel for SFX (Sound Effects) feature.
///
/// Exposes SFX channel state for the view to observe.
class SfxViewModel extends ChangeNotifier {
  SfxViewModel() {
    _sfx = MockAudioEngine.instance.sfx;
    _sfx.addListener(_onSfxChanged);
  }

  late final MockSfxChannel _sfx;

  /// Whether SFX channel is muted.
  bool get isMuted => _sfx.isMuted;

  /// Current volume level (0.0 to 1.0).
  double get volume => _sfx.volume;

  /// List of available SFX sounds.
  List<SfxSound> get sounds => _sfx.sounds;

  /// ID of last played sound.
  String? get lastPlayed => _sfx.lastPlayed;

  /// Timestamp of last played sound.
  DateTime? get lastPlayedAt => _sfx.lastPlayedAt;

  /// Whether a sound was recently played (within 500ms).
  bool get isRecentlyPlayed {
    if (_sfx.lastPlayedAt == null) return false;
    return DateTime.now().difference(_sfx.lastPlayedAt!).inMilliseconds < 500;
  }

  void _onSfxChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _sfx.removeListener(_onSfxChanged);
    super.dispose();
  }
}
