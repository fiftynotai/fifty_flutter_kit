import 'package:audioplayers/audioplayers.dart';

import '../core/base_audio_channel.dart';
import '../storage/audio_storage.dart';

/// **VoiceActingChannel — Voice Acting Manager**
///
/// Handles VO (voice-over) playback for in-game characters. Supports
/// ducking background music (BGM) at start and restoring it on finish,
/// with persisted per-channel volume.
///
/// **Key Features**
/// - One-shot voice playback using `mediaPlayer`
/// - Streamed audio via [UrlSource] (CDN-friendly)
/// - Optional [onDucking] / [onRestore] hooks to coordinate with BGM
/// - Persists voice volume (and active flag) via [AudioStorage]
///
/// **Usage**
/// ```dart
/// VoiceActingChannel.initialize(AudioStorage.instance, audioContext);
///
/// VoiceActingChannel.instance.onDucking = () => BgmChannel.instance.fadeTo(0.3);
/// VoiceActingChannel.instance.onRestore = () => BgmChannel.instance.fadeTo(1.0);
///
/// await VoiceActingChannel.instance.playVoice(voiceUrl); // ducks, plays, restores
/// ```
///
/// **Notes**
/// - Call [playVoice] for duck/restore semantics.
/// - [play] only sets the source and starts playback (no ducking).
///
/// ─────────────────────────────────────────────────────────────────────────────
class VoiceActingChannel extends BaseAudioChannel {
  /// **Singleton Instance**
  ///
  /// Initialize once via [initialize] before using.
  static late final VoiceActingChannel instance;

  /// **Persistent Storage**
  ///
  /// Stores voice volume and active state.
  final AudioStorage _storage;

  VoiceActingChannel._(this._storage) : super('voice_acting_player');

  /// **Ducking Flag**
  ///
  /// When `true`, VO will reduce BGM volume on start and restore it on finish.
  bool withDucking = true;

  /// **Bootstrap**
  ///
  /// Creates the singleton and (optionally) applies an [audioContext].
  /// If you need strict ordering for `setAudioContext`, await it at the call site.
  static void initialize(AudioStorage storage, [AudioContext? audioContext]) {
    instance = VoiceActingChannel._(storage);
    if (audioContext != null) {
      instance.setAudioContext(audioContext);
    }
  }

  /// **Mode: mediaPlayer**
  ///
  /// Best for streamed / longer voice clips.
  @override
  PlayerMode get playerMode => PlayerMode.mediaPlayer;

  /// **Release: stop**
  ///
  /// VO plays once and stops automatically.
  @override
  ReleaseMode get releaseMode => ReleaseMode.stop;

  /// **Hooks**
  ///
  /// - [onDucking]: called **before** a voice line starts (e.g., lower BGM).
  /// - [onRestore]: called when a voice line ends or is stopped (restore BGM).
  /// - [onCompleted]: called when a voice line *finishes* (completed).
  Future<void> Function()? onDucking;
  Future<void> Function()? onRestore;
  Future<void> Function()? onCompleted;

  // ───────────────────────────────────────────────────────────────────────────
  // Playback
  // ───────────────────────────────────────────────────────────────────────────

  /// **Play a Voice Line (URL)**
  ///
  /// Triggers [onDucking] if [withDucking] is `true`, then plays the URL.
  ///
  /// **Params**
  /// - [path]: remote audio URL (CDN, server, etc.)
  /// - [withDucking]: override for this call (default `true`)
  Future<void> playVoice(String path, [bool withDucking = true]) async {
    this.withDucking = withDucking;
    if (path.isEmpty) return;

    if (this.withDucking && onDucking != null) {
      await onDucking!();
    }
    await play(path);
  }

  /// **Play (Override)**
  ///
  /// Starts playback using the configured source builder. This method
  /// **does not** trigger ducking; call [playVoice] for duck/restore semantics.
  ///
  /// By default uses the source builder set via [changeSource]. Call
  /// `changeSource(AssetSource.new)` for bundled assets or
  /// `changeSource(UrlSource.new)` for network audio (default).
  @override
  Future<void> play(String path) async {
    if (path.isEmpty) return;
    await playFromSource(resolveSource(path));
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Persistence-aware Controls
  // ───────────────────────────────────────────────────────────────────────────

  /// **Set Volume (Persistent)**
  ///
  /// Persists voice volume to storage, then applies it.
  @override
  Future<void> setVolume(double volume) async {
    _storage.voiceVolume = volume;
    await super.setVolume(volume);
  }

  /// **Mute (Persistent)**
  ///
  /// Sets volume to `0.0` and persists.
  @override
  Future<void> mute() async {
    await setVolume(0.0);
  }

  /// **Unmute (Persistent)**
  ///
  /// Restores volume from storage (**voice** volume).
  @override
  Future<void> unmute() async {
    await setVolume(_storage.voiceVolume);
  }

  /// **Toggle Active (Persistent)**
  ///
  /// Flips active state and persists it as **voice active**.
  @override
  void toggleActive() {
    super.toggleActive();
    _storage.isVoiceActive = isActive;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // State Hook
  // ───────────────────────────────────────────────────────────────────────────

  /// **onStateChanged**
  ///
  /// - Restores BGM (via [onRestore]) when voice **completes** or is **stopped**,
  ///   but only if [withDucking] is enabled.
  /// - Invokes [onCompleted] when the voice **completes**.
  @override
  void onStateChanged(PlayerState state) {
    if (state == PlayerState.completed || state == PlayerState.stopped) {
      if (withDucking && onRestore != null) {
        onRestore!();
      }
      if (state == PlayerState.completed && onCompleted != null) {
        onCompleted!();
      }
    }
  }
}
