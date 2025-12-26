import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

import '../storage/audio_storage.dart';
import '../core/base_audio_channel.dart';
import '../core/pooled_playback.dart';

/// **SfxChannel — Sound Effects Manager (pooled)**
///
/// Handles ultra-snappy SFX playback with simple grouping and throttling.
/// Adds **pooled playback** for instant retrigger/overlap across assets,
/// device files, or URLs while preserving the channel's audio context.
///
/// **Key Features**
/// - Sound **groups** (e.g., `click`, `hover`, `hit`) with randomized pick
/// - **Cooldown** per group to prevent spam
/// - **Low-latency** playback mode (best for short clips)
/// - **Pooling** (opt-in, enabled by default): instant retrigger of same file
/// - **Persistent** volume and active state via [AudioStorage]
///
/// **Usage**
/// ```dart
/// // Bootstrap once
/// SfxChannel.initialize(AudioStorage.instance, audioContext);
/// SfxChannel.instance.enablePooling(enabled: true, poolSizePerSound: 4);
///
/// // Register sounds
/// SfxChannel.instance.registerGroup('click', [
///   'assets/sfx/click1.wav',
///   'assets/sfx/click2.wav',
/// ]);
///
/// // Play randomized click (pooled)
/// await SfxChannel.instance.playGroup('click');
///
/// // Play a specific sfx (pooled; asset/file/url supported)
/// await SfxChannel.instance.playSfx('assets/sfx/button_tap.wav');
/// ```
///
/// **Notes**
/// - Uses the channel’s current source builder via `resolveSource(path)`,
///   so `changeSource((p) => DeviceFileSource(p))` works seamlessly.
/// - For long or streamed audio, use a non-lowLatency channel instead.
///
/// ─────────────────────────────────────────────────────────────────────────────
class SfxChannel extends BaseAudioChannel with PooledPlayback {
  /// **Singleton Instance**
  ///
  /// Initialize once with [initialize] before using.
  static late final SfxChannel instance;

  /// **Persistent Storage**
  ///
  /// Stores SFX volume and active state.
  final AudioStorage _storage;

  SfxChannel._(this._storage) : super('sfx_player');

  /// **Initialize**
  ///
  /// Creates the singleton and (optionally) applies an [audioContext].
  /// Call this during app startup before any SFX is played.
  ///
  /// Pooling is enabled by default; adjust pool size to taste.
  static void initialize(AudioStorage storage, [AudioContext? audioContext]) {
    instance = SfxChannel._(storage);
    if (audioContext != null) {
      instance.setAudioContext(audioContext);
    }
    instance.enablePooling(enabled: true, poolSizePerSound: 4);
  }

  /// **Mode: Low Latency**
  ///
  /// Optimized for short, frequent sounds.
  @override
  PlayerMode get playerMode => PlayerMode.lowLatency;

  /// **Release: Stop**
  ///
  /// Each SFX plays once and stops.
  @override
  ReleaseMode get releaseMode => ReleaseMode.stop;

  /// **Registered Groups**
  ///
  /// Map of `groupName -> list of paths` (asset/file/url).
  final _groups = <String, List<String>>{};

  /// **Per-Group Cooldown**
  ///
  /// Tracks last time a group was played to apply throttling.
  final _lastPlayedTimestamps = <String, DateTime>{};

  /// **Throttle Window**
  ///
  /// Prevents re-playing the same group too frequently (spam control).
  final Duration _cooldown = const Duration(milliseconds: 150);

  /// **Randomizer** for group selection.
  final _random = Random();

  // ───────────────────────────────────────────────────────────────────────────
  // Registration
  // ───────────────────────────────────────────────────────────────────────────

  /// **Register a Group**
  ///
  /// Associate a [name] with a list of paths.
  void registerGroup(String name, List<String> paths) {
    _groups[name] = paths;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Playback
  // ───────────────────────────────────────────────────────────────────────────

  /// **Play a Random Sound from a Group**
  ///
  /// - Skips if the group is unknown or throttled by [_cooldown].
  /// - Chooses a random path from the registered list and plays it (pooled).
  Future<void> playGroup(String name) async {
    final now = DateTime.now();
    final lastPlayed = _lastPlayedTimestamps[name];

    // Throttle per group to avoid audio spam
    if (lastPlayed != null && now.difference(lastPlayed) < _cooldown) return;

    final sounds = _groups[name];
    if (sounds == null || sounds.isEmpty) return;

    final randomPath = sounds[_random.nextInt(sounds.length)];
    await play(randomPath);

    _lastPlayedTimestamps[name] = now;
  }

  /// **Play a Specific SFX Path (pooled)**
  ///
  /// No-op if [path] is empty. Resolves using the channel's current source
  /// builder (assets by default, but can be files/urls via `changeSource`).
  @override
  Future<void> play(String path) async {
    if (path.isEmpty) return;
    final src = resolveSource(path); // provided by BaseAudioChannel
    await playPooled(path, src, volume: _storage.sfxVolume); // from PooledPlayback
  }

  /// **Play from an explicit [Source] (pooled)**
  ///
  /// Provide an optional stable [cacheKey] to share the pool for equivalent sources.
  Future<void> playSfxSource(Source source, {String? cacheKey}) async {
    final key = cacheKey ?? source.toString();
    await playPooled(key, source, volume: _storage.sfxVolume);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Persistence-aware Controls
  // ───────────────────────────────────────────────────────────────────────────

  /// **Set Volume (Persistent)**
  ///
  /// Persists SFX volume to storage, then applies it.
  @override
  Future<void> setVolume(double volume) async {
    _storage.sfxVolume = volume;
    await super.setVolume(volume);
    // New pool starts will use the updated volume via playPooled(..., volume: ...)
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
  /// Restores volume from storage (**SFX volume**, not BGM).
  @override
  Future<void> unmute() async {
    await setVolume(_storage.sfxVolume);
  }

  /// **Toggle Active (Persistent)**
  ///
  /// Flips active state and persists it as **SFX active**.
  @override
  void toggleActive() {
    super.toggleActive();
    _storage.isSfxActive = isActive;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ───────────────────────────────────────────────────────────────────────────

  @override
  Future<void> dispose() async {
    await disposePools(); // from PooledPlayback mixin
    await super.dispose();
  }
}
