import 'activation_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'bgm_storage.dart';
import 'volume_storage.dart';

/// **Persistent Audio Memory Service**
///
/// A singleton service responsible for storing and retrieving audio-related settings,
/// including background music playlists, playback index, and volume levels for
/// BGM, SFX, and Voice Acting.
///
/// This class implements both [BgmStorage] and [VolumeStorage] interfaces to ensure
/// clean separation of responsibilities and allow other components to work with
/// specific subsets of storage data.
///
/// **Core Responsibilities:**
/// - Persist BGM playlist and playback index between sessions
/// - Store and retrieve individual volume levels for each audio channel
/// - Provide a unified access point for all audio-related memory interactions
///
/// **Initialization:**
/// Ensure that [initialize] is called before using this class.
/// Usually done early during app startup.
///
/// **Example Usage:**
/// ```dart
/// await AudioStorage.instance.initialize();
/// final playlist = AudioStorage.instance.getPlaylist();
/// final volume = AudioStorage.instance.bgmVolume;
/// ```
///
/// Part of the Fifty Audio Engine package.
class AudioStorage implements BgmStorage, VolumeStorage, ActivationStorage {
  /// Singleton instance
  static final AudioStorage _instance = AudioStorage._();

  /// Public getter to access the instance
  static AudioStorage get instance => _instance;

  late final GetStorage _storage;

  static const String _storageBox = 'Fifty-Audio';

  // Keys for BGM playlist and index
  static const String _keyPlaylist = 'fifty_audio_playlist';
  static const String _keyIndex = 'fifty_audio_playlist_index';

  // Keys for volume values
  static const String _bgmVolumeKey = 'fifty_audio_bgm_volume';
  static const String _sfxVolumeKey = 'fifty_audio_sfx_volume';
  static const String _voiceVolumeKey = 'fifty_audio_voice_volume';

  static const String _bgmActiveKey = 'fifty_audio_bgm_active';
  static const String _sfxActiveKey = 'fifty_audio_sfx_active';
  static const String _voiceActiveKey = 'fifty_audio_voice_active';

  static const String _shuffleKey = 'fifty_audio_shuffle';

  /// Private constructor
  AudioStorage._() {
    _storage = GetStorage(_storageBox);
  }

  /// Initialize the GetStorage box (must be called before use)
  Future<void> initialize() async {
    await GetStorage.init(_storageBox);
  }

  // ─────────────────────────────────────────────
  // BgmStorage interface implementation
  // ─────────────────────────────────────────────

  /// Returns the saved playlist from storage, or null if not set
  @override
  List<String>? getPlaylist() {
    final data = _storage.read<List<dynamic>>(_keyPlaylist);
    if (data == null) return null;
    return List<String>.from(data);
  }

  /// Returns the current BGM playback index, or null if not set
  @override
  int? getIndex() => _storage.read(_keyIndex);

  /// Saves the current BGM playlist and playback index to storage
  @override
  void save(List<String> playlist, int index) {
    _storage.write(_keyPlaylist, playlist);
    _storage.write(_keyIndex, index);
  }

  /// Clears the stored playlist and index (e.g., for reset or logout)
  @override
  void clear() {
    _storage.remove(_keyPlaylist);
    _storage.remove(_keyIndex);
  }

  // ─────────────────────────────────────────────
  // Optional direct accessors (for convenience)
  // ─────────────────────────────────────────────

  /// Returns the BGM playlist or empty list if not found
  List<String> get bgmPlaylist => getPlaylist() ?? <String>[];

  /// Returns the current index or 0 if not found
  int get bgmPlayingIndex => getIndex() ?? 0;

  /// Returns the shuffle state
  bool get isShuffle => _storage.read(_shuffleKey) ?? false;

  /// Sets the shuffle state
  set isShuffle(bool value) => _storage.write(_shuffleKey, value);

  // ─────────────────────────────────────────────
  // VolumeStorage interface implementation
  // ─────────────────────────────────────────────

  /// BGM volume (range: 0.0 - 1.0), defaults to 1.0
  @override
  double get bgmVolume => _storage.read(_bgmVolumeKey) ?? 1.0;

  @override
  set bgmVolume(double value) => _storage.write(_bgmVolumeKey, value);

  /// SFX volume (range: 0.0 - 1.0), defaults to 1.0
  @override
  double get sfxVolume => _storage.read(_sfxVolumeKey) ?? 1.0;

  @override
  set sfxVolume(double value) => _storage.write(_sfxVolumeKey, value);

  /// Voice Acting volume (range: 0.0 - 1.0), defaults to 1.0
  @override
  double get voiceVolume => _storage.read(_voiceVolumeKey) ?? 1.0;

  @override
  set voiceVolume(double value) => _storage.write(_voiceVolumeKey, value);

  /// **Reset All Audio Settings**
  ///
  /// Clears all saved audio volume related preferences:
  /// - Volume levels for BGM, SFX, and Voice
  ///
  /// Call this when the user logs out or resets the game.
  void resetAllAudioSettings() {
    _storage.remove(_bgmVolumeKey);
    _storage.remove(_sfxVolumeKey);
    _storage.remove(_voiceVolumeKey);
  }

  // ─────────────────────────────────────────────
  // ActivationStorage interface implementation
  // ─────────────────────────────────────────────

  @override
  bool get isBgmActive => _storage.read(_bgmActiveKey) ?? true;

  @override
  set isBgmActive(bool value) => _storage.write(_bgmActiveKey, value);

  @override
  bool get isSfxActive => _storage.read(_sfxActiveKey) ?? true;

  @override
  set isSfxActive(bool value) => _storage.write(_sfxActiveKey, value);

  @override
  bool get isVoiceActive => _storage.read(_voiceActiveKey) ?? true;

  @override
  set isVoiceActive(bool value) => _storage.write(_voiceActiveKey, value);
}
