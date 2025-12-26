import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'base_audio_channel.dart';

/// **PooledPlayback**
///
/// Opt-in audio pooling for **instant retrigger/overlap** of short sounds.
/// Intended for SFX-style channels that often replay the **same** clip rapidly.
///
/// ### What it does
/// - Keeps a tiny pool of pre-prepared `AudioPlayer`s **per sound key**.
/// - Inherits the channel’s `AudioContext` so focus/ducking rules match.
/// - Supports **assets**, **device files**, **URLs**, and **bytes** sources.
/// - Automatically marks the channel as **multi-player capable**, so
///   `BaseAudioChannel.waitUntilStopped()` / `playAndWait()` will **throw**
///   (waiting is ambiguous when multiple players can run).
///
/// ### Typical usage
/// ```dart
/// class SfxChannel extends BaseAudioChannel with PooledPlayback {
///   SfxChannel() : super('sfx_player');
///
///   @override PlayerMode get playerMode => PlayerMode.lowLatency;
///   @override ReleaseMode get releaseMode => ReleaseMode.stop;
///
///   // Make pooling transparent for .play(path)
///   @override
///   Future<void> play(String path) async {
///     await playPooledPath(path, key: path, volume: volume);
///   }
///
///   @override
///   Future<void> dispose() async {
///     await disposePools();  // ← clean pooled players
///     return super.dispose();
///   }
/// }
///
/// // Configure pooling (optional; defaults shown)
/// SoundEngine.instance.sfx.enablePooling(
///   enabled: true,
///   poolSizePerSound: 4,     // max concurrent players for a given sound
///   minPlayersPerSound: 1,   // pre-warmed instances per sound
/// );
///
/// // Fire-and-forget retriggers (instant overlaps)
/// await SoundEngine.instance.sfx.play('assets/sfx/click.mp3');
/// ```
///
/// ### When to refresh pools
/// If you change a channel’s `AudioContext` **after** some pools were built,
/// call [refreshPoolsAudioContext] to recreate existing pools with the new
/// context:
/// ```dart
/// await sfx.setAudioContext(newCtx);
/// await sfx.refreshPoolsAudioContext();
/// ```
///
/// ### Waiting caveat
/// Pooling enables **concurrent** playbacks; a single “wait until stop” has no
/// unambiguous target. The mixin reports concurrency via
/// [hasMultipleConcurrentPlayers], so `waitUntilStopped` / `playAndWait` will
/// throw `UnsupportedError`. If you need blocking behavior, disable pooling
/// (globally or for the duration) or use a dedicated non-pooled channel.
mixin PooledPlayback on BaseAudioChannel {
  /// Internal map of **sound key → AudioPool**.
  ///
  /// *Key tips*:
  /// - Use the **path string** for simple setups.
  /// - Use a **logical key** if multiple paths should share the same pool
  ///   (e.g., localized variants).
  final Map<String, AudioPool> _pools = {};

  bool _poolingEnabled = true;
  int _poolSizePerSound = 4;
  int _minPlayersPerSound = 1;

  /// Whether pooling is currently enabled.
  bool get isPoolingEnabled => _poolingEnabled;

  /// Maximum concurrent players per **sound key**.
  ///
  /// Higher numbers allow more overlaps but cost more memory/handles.
  int get poolSizePerSound => _poolSizePerSound;

  /// Pre-warmed players per **sound key**.
  ///
  /// More pre-warm improves first-hit latency at the cost of startup work.
  int get minPlayersPerSound => _minPlayersPerSound;

  /// **Enable/disable pooling** and configure pool sizes.
  ///
  /// - When `enabled=false`, calls to [playPooled]/[playPooledPath] **fall back**
  ///   to the channel’s single player (`playFromSource`), i.e., **no overlap**.
  /// - Size changes affect **newly created** pools. Existing pools keep their
  ///   size until rebuilt (see [refreshPoolsAudioContext]).
  void enablePooling({
    bool enabled = true,
    int poolSizePerSound = 4,
    int minPlayersPerSound = 1,
  }) {
    _poolingEnabled = enabled;
    _poolSizePerSound = poolSizePerSound.clamp(1, 16);
    _minPlayersPerSound = minPlayersPerSound.clamp(1, _poolSizePerSound);
  }

  /// **Report concurrency** to the base so wait-helpers throw automatically.
  @override
  @protected
  bool get hasMultipleConcurrentPlayers =>
      _poolingEnabled && _poolSizePerSound > 1;

  /// Get or create a pool for [key] using [source], inheriting the channel’s
  /// current `AudioContext`. Pre-warms [minPlayersPerSound] players.
  Future<AudioPool> _poolFor(String key, Source source) async {
    final existing = _pools[key];
    if (existing != null) return existing;

    final pool = await AudioPool.create(
      source: source,
      maxPlayers: _poolSizePerSound,
      minPlayers: _minPlayersPerSound,
      audioContext: currentAudioContext, // inherit channel context
    );
    _pools[key] = pool;
    return pool;
  }

  /// **Play using a pooled player** (or fallback to the single channel player).
  ///
  /// Returns a [StopFunction] when pooling is active; returns `null` when
  /// falling back to the single player.
  ///
  /// - [key]: pool identifier for this sound (defaults to path if you use
  ///   [playPooledPath]). All plays with the same key share a pool.
  /// - [source]: any audioplayers `Source` (Asset/DeviceFile/Url/Bytes).
  /// - [volume]: defaults to the channel’s current [volume].
  Future<StopFunction?> playPooled(
      String key,
      Source source, {
        double? volume,
      }) async {
    if (!_poolingEnabled) {
      await playFromSource(source);
      return null;
    }
    final pool = await _poolFor(key, source);
    return pool.start(volume: volume ?? this.volume);
  }

  /// **Play a path using pooling**, resolving the path with the channel’s
  /// current loader (respects `changeSource(...)`).
  ///
  /// - [key] defaults to [path]; override to alias multiple paths to one pool.
  /// - [volume] defaults to the channel’s current [volume].
  Future<StopFunction?> playPooledPath(
      String path, {
        String? key,
        double? volume,
      }) async {
    final src = resolveSource(path);
    return playPooled(key ?? path, src, volume: volume);
  }

  /// **Rebuild all pools** so they inherit the channel’s **current**
  /// `AudioContext`. Useful after calling `setAudioContext(...)` at runtime.
  ///
  /// Recreates each pool with its original `source`, preserving each pool’s
  /// `minPlayers`/`maxPlayers` as previously created.
  Future<void> refreshPoolsAudioContext() async {
    if (_pools.isEmpty) return;

    final entries = _pools.entries.toList();
    _pools.clear();

    for (final e in entries) {
      final old = e.value;
      final source = old.source;          // exposed by your AudioPool
      final maxPlayers = old.maxPlayers;
      final minPlayers = old.minPlayers;

      await old.dispose();

      final rebuilt = await AudioPool.create(
        source: source,
        maxPlayers: maxPlayers,
        minPlayers: minPlayers,
        audioContext: currentAudioContext,
      );

      _pools[e.key] = rebuilt;
    }
  }

  /// **Dispose all pools.**
  ///
  /// Call this from your channel’s `dispose()`:
  /// ```dart
  /// @override
  /// Future<void> dispose() async {
  ///   await disposePools();
  ///   return super.dispose();
  /// }
  /// ```
  Future<void> disposePools() async {
    for (final p in _pools.values) {
      await p.dispose();
    }
    _pools.clear();
  }
}
