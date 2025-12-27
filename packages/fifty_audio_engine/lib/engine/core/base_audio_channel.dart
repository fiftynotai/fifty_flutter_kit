import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'channel_lifecycle_config.dart';
import 'fade_preset.dart';
import 'audio_logger.dart';

/// **Helper Type**
///
/// A function that converts a path string into an audioplayers [Source].
///
/// **Examples:**
/// - `AssetSource(path)` for bundled assets
/// - `DeviceFileSource(path)` for local files
/// - `UrlSource(path)` for network audio
typedef AudioSourceBuilder = Source Function(String path);

/// **BaseAudioChannel**
///
/// An abstract base that encapsulates shared logic for all audio channels
/// (e.g., BGM, SFX, Voice). Subclasses provide concrete configuration for
/// [playerMode] and [releaseMode].
///
/// **Core Responsibilities:**
/// - Maintain a single [AudioPlayer] per channel
/// - Control playback: `play`, `playFromSource`, `pause`, `resume`, `stop`
/// - Manage volume & mute state with cached target restoration
/// - Expose reactive `isPlaying` via [onIsPlayingChanged]
/// - Provide tween-based volume fading with custom [Curve]
/// - Wrap arbitrary actions in **fade-out → action → fade-in** via [withFade]
///
/// **Configurable:**
/// - Override [playerMode] and [releaseMode]
/// - Swap how paths are resolved via [changeSource]
///
/// **Usage Example:**
/// ```dart
/// class SfxChannel extends BaseAudioChannel {
///   SfxChannel() : super('sfx_channel');
///
///   @override PlayerMode get playerMode => PlayerMode.lowLatency;
///   @override ReleaseMode get releaseMode => ReleaseMode.stop;
/// }
///
/// final sfx = SfxChannel();
/// await sfx.play('assets/sfx/click.mp3');        // assets by default
///
/// sfx.changeSource((p) => UrlSource(p));         // swap loader at runtime
/// await sfx.play('https://example.com/alert.mp3');
///
/// await sfx.withFade(() async {                  // wrap any action in fades
///   await sfx.play('assets/sfx/alert.wav');
/// });
/// ```
abstract class BaseAudioChannel {
  /// **Stable Identifier**
  ///
  /// A unique ID for this channel/player. Useful for debugging and routing logs.
  final String playerId;

  /// **Underlying Player**
  ///
  /// Single long-lived [AudioPlayer] instance for this channel.
  late final AudioPlayer _player;

  /// **Runtime State**
  ///
  /// - [_isPlaying]: whether the player is currently playing
  /// - [_volume]: current volume (0.0 → 1.0)
  /// - [_muted]: convenience flag derived from volume == 0
  /// - [_active]: when `false`, `play` requests are ignored (pause/stop still work)
  bool _isPlaying = false;
  double _volume = 1.0;
  bool _muted = false;
  bool _active = true;

  /// **Cached Target Volume**
  ///
  /// Stores the pre-fade target volume so [fadeIn] / [fadeInVolume]
  /// can restore gracefully after a [fadeOut].
  double _cachedTargetVolume = 1.0;

  /// **Playback State Stream**
  ///
  /// Broadcasts `true/false` whenever player state changes to/from playing.
  final StreamController<bool> _isPlayingStream = StreamController<bool>.broadcast();

  /// **Source Builder**
  ///
  /// Determines how `String path` becomes a [Source]. Defaults to assets.
  AudioSourceBuilder _sourceBuilder = (path) => AssetSource(path);

  /// **Last applied AudioContext** (exposed so pools or helpers can inherit it)
  AudioContext? _ctx;

  /// Current audio context getter (nullable if never set).
  AudioContext? get currentAudioContext => _ctx;

  /// Resolve a path into a [Source] using the current builder (assets/files/urls).
  /// Override via [changeSource] to switch the strategy at runtime.
  @protected
  Source resolveSource(String path) => _sourceBuilder(path);

  /// **Completion Event**
  ///
  /// Fires when the underlying player reports completion for the current item.
  /// Note: for `ReleaseMode.loop`, many platforms do **not** emit `completed`
  /// between loops; rely on explicit `stop()`/`pause()` in that case.
  Stream<void> get onPlayerComplete => _player.onPlayerComplete;

  /// Whether this channel may spawn multiple concurrent players.
  /// Mixins like SFX pooling should override this automatically.
  @protected
  bool get hasMultipleConcurrentPlayers => false;

  /// Optional per-channel lifecycle observer (see [enableLifecycle]).
  ChannelLifecycleObserver? _lifecycleObserver;

  BaseAudioChannel(this.playerId) {
    _player = AudioPlayer(playerId: playerId);
    _init(); // fire-and-forget setup
  }

  /// **Apply Platform Audio Context**
  ///
  /// Applies an [AudioContext] (focus, usage, category, etc.) to the underlying
  /// player. **Call early** (before playback) for deterministic behavior.
  ///
  /// The underlying `setAudioContext` is async; we forward the [Future]
  /// so callers can `await` when they need strict ordering.
  ///
  /// ```dart
  /// await channel.setAudioContext(myContext);
  /// await channel.play('assets/bgm/theme.mp3');
  /// ```
  Future<void> setAudioContext(AudioContext audioContext) {
    _ctx = audioContext;
    return _player.setAudioContext(audioContext);
  }

  /// **Swap Loader**
  ///
  /// Replace how paths are turned into sources at any time.
  /// Example: `changeSource((p) => UrlSource(p));`
  void changeSource(AudioSourceBuilder builder) {
    _sourceBuilder = builder;
  }

  /// **Enable per-channel lifecycle handling**
  ///
  /// When enabled, this channel listens to app lifecycle changes and applies
  /// the policy from [ChannelLifecycleConfig]. Defaults:
  /// - Background (`inactive`/`paused`/`hidden`): **pause** with fast fade
  /// - Foreground (`resumed`): **resume** with gentle fade
  /// - Detached: no action
  ///
  /// > Only state changes initiated by the lifecycle are reversed on resume
  /// > (we won’t resume something your game paused intentionally).
  void enableLifecycle([ChannelLifecycleConfig cfg = const ChannelLifecycleConfig()]) {
    _lifecycleObserver ??= ChannelLifecycleObserver(this, cfg);
    WidgetsBinding.instance.addObserver(_lifecycleObserver!);
  }

  /// **Disable lifecycle handling** for this channel.
  void disableLifecycle() {
    if (_lifecycleObserver != null) {
      WidgetsBinding.instance.removeObserver(_lifecycleObserver!);
      _lifecycleObserver = null;
    }
  }

  /// **Player Mode**
  ///
  /// Must be overridden by subclasses (e.g., `PlayerMode.mediaPlayer` for BGM,
  /// `PlayerMode.lowLatency` for SFX).
  PlayerMode get playerMode;

  /// **Release Mode**
  ///
  /// Must be overridden by subclasses (e.g., `ReleaseMode.loop` for BGM,
  /// `ReleaseMode.stop` for SFX).
  ReleaseMode get releaseMode;

  /// **Reactive `isPlaying` Stream**
  Stream<bool> get onIsPlayingChanged => _isPlayingStream.stream;

  /// **Current Status**
  bool get isPlaying => _isPlaying;

  /// **Current Volume** (0.0 → 1.0)
  double get volume => _volume;

  /// **Muted Flag**
  bool get isMuted => _muted;

  /// **Active Flag**
  ///
  /// When `false`, `play` requests are ignored (useful for global disables).
  bool get isActive => _active;

  /// **Current Media Duration**
  Future<Duration?> getDuration() => _player.getDuration();

  /// **Position Stream**
  ///
  /// Emits the playback position of the current media.
  Stream<Duration> get onPositionChanged => _player.onPositionChanged;

  /// **Internal Initialization** (constructor-safe)
  ///
  /// Sets player mode, release mode, initial volume, and subscribes to state.
  /// Fire-and-forget by design—constructor cannot `await`. If call sites need
  /// strict ordering, prefer awaiting `setAudioContext(...)` before first play.
  void _init() {
    unawaited(_player.setPlayerMode(playerMode));
    unawaited(_player.setReleaseMode(releaseMode));
    unawaited(_player.setVolume(_volume));
    _listenToState();
  }

  void _listenToState() {
    _player.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      _isPlayingStream.add(_isPlaying);
      onStateChanged(state);
    });
  }

  /// **Subclass Hook: Player State Changed**
  ///
  /// Override in subclasses to react to low-level state transitions
  /// (`stopped`, `playing`, `paused`, `completed`).
  @protected
  void onStateChanged(PlayerState state) {}

  // ───────────────────────────────────────────────────────────────────────────
  // Playback Controls
  // ───────────────────────────────────────────────────────────────────────────

  /// **Play by Path**
  ///
  /// Resolves [path] via the current builder and delegates to [playFromSource].
  Future<void> play(String path) async {
    final src = _sourceBuilder(path);
    await playFromSource(src);
  }

  /// **Play from [Source]**
  ///
  /// Accepts any [Source] (e.g., [AssetSource], [DeviceFileSource], [UrlSource]).
  /// Skips playback if the channel is **inactive**.
  Future<void> playFromSource(Source source) async {
    if (_active) {
      FiftyAudioLogger.play(source.toString());
      await _player.play(source);
    } else {
      FiftyAudioLogger.log('Skipped (inactive): $source');
    }
  }

  /// **Pause**
  Future<void> pause() async {
    FiftyAudioLogger.pause();
    await _player.pause();
  }

  /// **Resume**
  Future<void> resume() async {
    FiftyAudioLogger.resume();
    await _player.resume();
  }

  /// **Stop**
  Future<void> stop() async {
    FiftyAudioLogger.stop();
    await _player.stop();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Volume & Mute
  // ───────────────────────────────────────────────────────────────────────────

  /// **Set Volume**
  ///
  /// Updates internal state and delegates to the player.
  /// Also maintains [isMuted] based on `volume == 0.0`.
  ///
  /// > Subclasses can override to persist per-channel volume (see SFX/BGM/Voice).
  Future<void> setVolume(double volume) async {
    _volume = volume;
    _muted = volume == 0.0;
    FiftyAudioLogger.volume(volume);
    await _player.setVolume(volume);
  }

  /// **Mute (volume → 0.0)**
  Future<void> mute() async {
    FiftyAudioLogger.mute();
    await setVolume(0.0);
  }

  /// **Unmute (volume → 1.0)**
  ///
  /// If you want to restore to a remembered value, call [setVolume] with that
  /// value instead of using this convenience method.
  Future<void> unmute() async {
    FiftyAudioLogger.unmute();
    await setVolume(1.0);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Activation
  // ───────────────────────────────────────────────────────────────────────────

  /// **Activate**
  ///
  /// Enables this channel to respond to `play` calls.
  void activate() {
    FiftyAudioLogger.activate();
    _active = true;
  }

  /// **Deactivate**
  ///
  /// Disables this channel from responding to `play` calls (useful for global
  /// mutes or scene-based restrictions without changing volume).
  void deactivate() {
    FiftyAudioLogger.deactivate();
    _active = false;
  }

  /// **Toggle Active**
  void toggleActive() {
    if (_active) {
      deactivate();
    } else {
      activate();
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Fades
  // ───────────────────────────────────────────────────────────────────────────

  /// **Fade To Target Volume**
  ///
  /// Tween volume from current level to [targetVolume] over [duration]
  /// following [curve]. Uses a ~60 FPS stepping loop for smoothness.
  ///
  /// **Edge Cases:**
  /// - If [duration] is very small, we still perform at least **one** step.
  Future<void> fadeTo(
      double targetVolume, {
        Duration duration = const Duration(seconds: 2),
        Curve curve = Curves.linear,
      }) async {
    final double start = _volume;
    final double end = targetVolume;
    const int fps = 60;
    int steps = (fps * duration.inMilliseconds / 1000).round();
    if (steps < 1) steps = 1; // ensure at least one step
    final frameDuration = Duration(milliseconds: (1000 / fps).round());

    FiftyAudioLogger.fade(start, end, duration, curve);

    for (int i = 0; i <= steps; i++) {
      final t = curve.transform(i / steps);
      final v = start + (end - start) * t;
      await _player.setVolume(v);
      _muted = v == 0.0;
      await Future.delayed(frameDuration);
    }
    _volume = targetVolume;
  }

  /// **Fade In**
  ///
  /// Fades from `0.0` up to [_cachedTargetVolume].
  Future<void> fadeIn({
    Duration duration = const Duration(seconds: 2),
    Curve curve = Curves.easeInOut,
  }) async {
    final target = _cachedTargetVolume;
    await _player.setVolume(0.0);
    await fadeTo(target, duration: duration, curve: curve);
  }

  /// **Fade Out**
  ///
  /// Caches current volume into [_cachedTargetVolume] and fades to `0.0`.
  Future<void> fadeOut({
    Duration duration = const Duration(seconds: 2),
    Curve curve = Curves.easeOut,
  }) async {
    _cachedTargetVolume = _volume;
    await fadeTo(0.0, duration: duration, curve: curve);
  }

  /// **withFade**
  ///
  /// Executes [action] surrounded by:
  /// 1) fade-out (using [fadeOut] preset)
  /// 2) action
  /// 3) fade-in (using [fadeIn] preset)
  ///
  /// **Tip:** Use this to mask track switches or abrupt UI sounds.
  Future<void> withFade(
      Future<void> Function() action, {
        FadePreset fadeOut = FadePreset.fast,
        FadePreset fadeIn = FadePreset.normal,
      }) async {
    await fadeOutVolume(fadeOut);
    await action();
    await fadeInVolume(fadeIn);
  }

  /// **Helper: Fade Out via [FadePreset]**
  Future<void> fadeOutVolume(FadePreset preset) => fadeTo(
    0.0,
    duration: preset.duration,
    curve: preset.curve,
  );

  /// **Helper: Fade In via [FadePreset]**
  Future<void> fadeInVolume(FadePreset preset) => fadeTo(
    _cachedTargetVolume,
    duration: preset.duration,
    curve: preset.curve,
  );

  // ───────────────────────────────────────────────────────────────────────────
  // Playback Synchronization (wait helpers)
  // ───────────────────────────────────────────────────────────────────────────

  /// Throws if waiting semantics are unsupported for this channel.
  @protected
  void ensureWaitSupported(String methodName) {
    if (releaseMode == ReleaseMode.loop) {
      throw UnsupportedError(
        '$methodName is not supported when releaseMode=loop. '
            'Looping streams never complete; call pause()/stop() explicitly or '
            'override releaseMode for non-looping behavior.',
      );
    }
    if (hasMultipleConcurrentPlayers) {
      throw UnsupportedError(
        '$methodName is not supported on channels that can play multiple sounds '
            'concurrently (e.g., SFX with pooling). Waiting on a single player would '
            'be ambiguous—disable pooling or use a non-pooled channel for scripted waits.',
      );
    }
  }

  /// **Wait until playback starts (first `true`)**
  ///
  /// Returns `true` if playback starts before [timeout], otherwise `false`.
  Future<bool> waitUntilStarted({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    if (_isPlaying) return true;
    try {
      await onIsPlayingChanged.where((v) => v == true).first.timeout(timeout);
      return true;
    } on TimeoutException {
      FiftyAudioLogger.log('waitUntilStarted() timed out.');
      return false;
    }
  }

  /// **Wait until playback stops/completes**
  ///
  /// Flow:
  /// 1) If not already playing, first waits for start (with [startTimeout]).
  /// 2) Resolves when either:
  ///    - [onPlayerComplete] fires, or
  ///    - [onIsPlayingChanged] emits `false`
  ///
  /// Returns `true` if it stopped/completed before [timeout].
  /// Throws [UnsupportedError] if `releaseMode=loop` or the channel supports
  /// multiple concurrent players (e.g., pooling).
  Future<bool> waitUntilStopped({
    Duration startTimeout = const Duration(seconds: 3),
    Duration timeout = const Duration(minutes: 2),
    bool forceStopOnTimeout = true,
  }) async {
    ensureWaitSupported('waitUntilStopped');

    if (!_isPlaying) {
      final started = await waitUntilStarted(timeout: startTimeout);
      if (!started) return false;
    }

    try {
      await Future.any([
        onPlayerComplete.first,
        onIsPlayingChanged.where((v) => v == false).first,
      ]).timeout(timeout);
      return true;
    } on TimeoutException {
      FiftyAudioLogger.log('waitUntilStopped() timed out.');
      if (forceStopOnTimeout) {
        await stop();
      }
      return false;
    }
  }

  /// **Convenience: play a path and wait for completion/stop**
  ///
  /// Returns `true` on success; throws [UnsupportedError] for loop/pooled cases.
  Future<bool> playAndWait(
      String path, {
        Duration startTimeout = const Duration(seconds: 3),
        Duration timeout = const Duration(minutes: 2),
        bool forceStopOnTimeout = true,
      }) async {
    ensureWaitSupported('playAndWait');
    await play(path);
    return waitUntilStopped(
      startTimeout: startTimeout,
      timeout: timeout,
      forceStopOnTimeout: forceStopOnTimeout,
    );
  }

  /// **Convenience: play a Source and wait for completion/stop**
  ///
  /// Returns `true` on success; throws [UnsupportedError] for loop/pooled cases.
  Future<bool> playFromSourceAndWait(
      Source source, {
        Duration startTimeout = const Duration(seconds: 3),
        Duration timeout = const Duration(minutes: 2),
        bool forceStopOnTimeout = true,
      }) async {
    ensureWaitSupported('playFromSourceAndWait');
    await playFromSource(source);
    return waitUntilStopped(
      startTimeout: startTimeout,
      timeout: timeout,
      forceStopOnTimeout: forceStopOnTimeout,
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ───────────────────────────────────────────────────────────────────────────

  /// **Dispose**
  ///
  /// Removes any lifecycle observer, disposes the player, and closes the
  /// broadcast stream. **Subclasses overriding this must call `super.dispose()`**.
  @mustCallSuper
  Future<void> dispose() async {
    disableLifecycle();
    await _player.dispose();
    await _isPlayingStream.close();
  }
}
