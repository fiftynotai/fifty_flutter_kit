import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';

import '/engine/global_fade_presets.dart';
import '/engine/core/audio_logger.dart';
import '/engine/storage/audio_storage.dart';
import '/engine/core/base_audio_channel.dart';

/// **BGM Channel**
///
/// Controls background music playback, including persistent playlist management,
/// shuffle logic, reactive crossfade transitions, and volume storage.
///
/// **Key Features:**
/// - Loads a default playlist with shuffle and resume support
/// - Persists playlist and index between sessions
/// - Crossfades before track ends using [onPositionChanged]
/// - Fires [onDefaultPlaylistComplete] when default playlist loops
/// - Fires [onTrackAboutToChange] before transitioning to next track
/// - Manual controls: [playNext], [playAtIndex], [playCustomPlaylist]
/// - Persists volume and active state via [AudioStorage]
///
/// **Usage:**
/// ```dart
/// await BgmChannel.initialize(storage, audioContext);
/// await BgmChannel.instance.loadDefaultPlaylist(['assets/bgm/a.mp3', 'assets/bgm/b.mp3']);
/// await BgmChannel.instance.resumeDefaultPlaylist();
/// ```
///
/// ─────────────────────────────────────────────────────────────────────────────
class BgmChannel extends BaseAudioChannel {
  /// **Singleton Instance**
  ///
  /// Must be initialized via [initialize] before use.
  static late final BgmChannel instance;

  /// **Persistent Storage**
  ///
  /// Persists playlist contents, current index, volume, and active state.
  final AudioStorage _storage;

  BgmChannel._(this._storage) : super('bgm_player');

  /// **Bootstrap**
  ///
  /// Creates the singleton and (optionally) applies an [audioContext].
  ///
  /// > Note: This is intentionally `void` to keep call sites simple.
  /// > If you need strict ordering for `setAudioContext`, await it at the call site
  /// > (and change this to `Future<void>` accordingly).
  static void initialize(AudioStorage storage, [AudioContext? audioContext]) {
    instance = BgmChannel._(storage);
    if (audioContext != null) {
      instance.setAudioContext(audioContext);
    }
    instance.enableLifecycle();
  }

  /// **Player Mode**
  ///
  /// Use `mediaPlayer` for long-form background tracks.
  @override
  PlayerMode get playerMode => PlayerMode.mediaPlayer;

  /// **Release Mode**
  ///
  /// Use `loop` to keep BGM running indefinitely.
  @override
  ReleaseMode get releaseMode => ReleaseMode.loop;

  /// **Default Playlist (Unshuffled Source)**
  ///
  /// The original list passed in by the host app. Used to rebuild state.
  List<String> _defaultPlaylist = [];

  /// **Current Playlist (Playable Order)**
  ///
  /// May be a shuffled copy of [_defaultPlaylist] or a custom list.
  List<String> _currentPlaylist = [];

  /// **Current Track Index** within [_currentPlaylist].
  int _index = 0;

  /// **Default vs Custom Flag**
  ///
  /// `true` = default playlist is active & persisted. `false` = custom session.
  bool _isUsingDefaultPlaylist = true;

  /// **Default Playlist Completed**
  ///
  /// Fired when a full loop completes **while using the default playlist**.
  VoidCallback? onDefaultPlaylistComplete;

  /// **Track About to Change**
  ///
  /// Fired **right before** we crossfade into the next track.
  VoidCallback? onTrackAboutToChange;

  /// **Crossfade Offset**
  ///
  /// How long **before the end** of the current track the crossfade should begin.
  static const Duration _crossfadeOffset = Duration(seconds: 3);

  /// **Crossfade Subscription**
  ///
  /// Bound to [onPositionChanged] while a track is playing.
  StreamSubscription<Duration>? _positionSub;

  // ───────────────────────────────────────────────────────────────────────────
  // Playlist Management
  // ───────────────────────────────────────────────────────────────────────────

  /// **Load Default Playlist**
  ///
  /// - Attempts to restore saved playlist & index from storage
  /// - If nothing is saved and [shuffle] is true, shuffles the playlist
  /// - Marks this channel as using the **default** playlist (persistent)
  ///
  /// **Parameters:**
  /// - [paths]: List of asset paths for the playlist
  /// - [shuffle]: Whether to shuffle on first load (default: false)
  Future<void> loadDefaultPlaylist(List<String> paths, {bool shuffle = false}) async {
    _isUsingDefaultPlaylist = true;

    final saved = _storage.getPlaylist();
    final index = _storage.getIndex();

    if (saved != null && saved.isNotEmpty && index != null) {
      _currentPlaylist = saved;
      _index = index;
    } else {
      _currentPlaylist = List.from(paths);
      if (shuffle) {
        _currentPlaylist.shuffle();
      }
      _index = 0;
      _storage.save(_currentPlaylist, _index);
    }

    _defaultPlaylist = paths;
  }

  /// **Play a Custom (Non-Persistent) Playlist**
  ///
  /// - Disables default playlist persistence
  /// - Starts from index 0
  /// - Executes a themed fade transition
  Future<void> playCustomPlaylist(List<String> paths) async {
    if (paths.isEmpty) return;

    _isUsingDefaultPlaylist = false;
    _currentPlaylist = List.from(paths);
    _index = 0;

    await withFade(
          () async => play(_currentPlaylist[_index]),
      fadeOut: GlobalFadePresets.ambientShift,
      fadeIn: GlobalFadePresets.bossEntrance,
    );
  }

  /// **Play Next Track (Looping)**
  ///
  /// Advances index (with wrap), persists if default, and starts playback.
  Future<void> playNext() async {
    if (_currentPlaylist.isEmpty) return;

    _advanceIndex();
    _handlePlaylistWrap();
    _persistIfDefault();

    await play(_currentPlaylist[_index]);
  }

  /// **Play at Specific Index**
  ///
  /// Safely clamps out-of-range calls (ignored).
  Future<void> playAtIndex(int index) async {
    if (_currentPlaylist.isEmpty || index < 0 || index >= _currentPlaylist.length) return;

    _index = index;
    _persistIfDefault();

    await play(_currentPlaylist[_index]);
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Playback Overrides
  // ───────────────────────────────────────────────────────────────────────────

  /// **Play a Track by Path**
  ///
  /// Cancels any pending crossfade listener, resolves the path using the
  /// configured source builder (default: AssetSource), and wires a new
  /// crossfade schedule for the new track.
  ///
  /// To play URLs, call `changeSource(UrlSource.new)` before playing.
  @override
  Future<void> play(String path) async {
    _positionSub?.cancel();
    await playFromSource(resolveSource(path)); // Uses _sourceBuilder (respects changeSource)
    _scheduleCrossfade();
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Crossfade Scheduling
  // ───────────────────────────────────────────────────────────────────────────

  /// **Schedule Crossfade**
  ///
  /// Subscribes to [onPositionChanged] and triggers a fade when we reach
  /// `duration - _crossfadeOffset`. On trigger:
  /// 1) notifies [onTrackAboutToChange]
  /// 2) fades out current track
  /// 3) advances index (with wrap + optional loop callback)
  /// 4) persists if default
  /// 5) plays next track
  /// 6) fades to stored target volume
  ///
  /// **Note:** If duration is not available (track still loading), this method
  /// will retry up to [_maxDurationRetries] times with delays.
  void _scheduleCrossfade() async {
    final targetVolume = _storage.bgmVolume;

    // Retry getting duration - it may not be available immediately after play()
    Duration? duration;
    for (int retry = 0; retry < _maxDurationRetries; retry++) {
      duration = await getDuration();
      if (duration != null && duration > _crossfadeOffset) break;

      // Wait before retrying (track may still be loading)
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Check if we're still playing - stop retrying if not
      if (!isActive || !isPlaying) return;
    }

    // If duration is still not available or too short, skip crossfade scheduling
    // The track will loop (due to ReleaseMode.loop) but won't auto-advance
    if (duration == null || duration <= _crossfadeOffset) return;

    final fadeTriggerTime = duration - _crossfadeOffset;

    _positionSub = onPositionChanged.listen((position) async {
      if (!isActive || !isPlaying) return;

      if (position >= fadeTriggerTime) {
        _positionSub?.cancel(); // prevent multiple triggers

        if (onTrackAboutToChange != null) {
          onTrackAboutToChange!(); // 🔔 notify before transition
        }

        await fadeOut();
        _advanceIndex();
        _handlePlaylistWrap();
        _persistIfDefault();
        await play(_currentPlaylist[_index]);
        await fadeTo(targetVolume);
      }
    });
  }

  /// Maximum retries to get track duration during crossfade scheduling.
  static const int _maxDurationRetries = 6;

  // ───────────────────────────────────────────────────────────────────────────
  // Persistence-aware Controls
  // ───────────────────────────────────────────────────────────────────────────

  /// **Set Volume (Persistent)**
  ///
  /// Persists BGM volume to storage before delegating to the base.
  @override
  Future<void> setVolume(double volume) async {
    _storage.bgmVolume = volume;
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
  /// Restores volume from storage.
  @override
  Future<void> unmute() async {
    await setVolume(_storage.bgmVolume);
  }

  /// **Toggle Active (Persistent)**
  ///
  /// Flips active state, persists it, then resumes/pauses accordingly.
  @override
  void toggleActive() {
    super.toggleActive();
    _storage.isBgmActive = isActive;
    _handleToggleAction();
  }

  /// **Handle Toggle Side-Effects**
  ///
  /// - If deactivated while playing → `pause()`
  /// - If activated and we have a playlist → `resume()`
  ///
  /// > Fire-and-forget by design: caller UX isn’t blocked on these transitions.
  void _handleToggleAction() {
    if (!isActive && isPlaying) {
      pause();
    } else if (_currentPlaylist.isNotEmpty) {
      resume();
    }
  }

  /// **Resume Default Playlist**
  ///
  /// Rebuilds the current list and index from storage or falls back
  /// to the original default list. Executes a gentle fade.
  Future<void> resumeDefaultPlaylist() async {
    final saved = _storage.getPlaylist();
    final index = _storage.getIndex();

    _currentPlaylist = saved ?? List.from(_defaultPlaylist);
    _index = index ?? 0;
    _isUsingDefaultPlaylist = true;

    await withFade(
          () async => play(_currentPlaylist[_index]),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Helpers
  // ───────────────────────────────────────────────────────────────────────────

  /// **Advance Index** (no wrap)
  void _advanceIndex() {
    _index++;
  }

  /// **Wrap & Loop Callback**
  ///
  /// Wraps to 0 when we hit the end, and if using the default playlist,
  /// fires [onDefaultPlaylistComplete].
  void _handlePlaylistWrap() {
    if (_index >= _currentPlaylist.length) {
      _index = 0;
      if (_isUsingDefaultPlaylist && onDefaultPlaylistComplete != null) {
        onDefaultPlaylistComplete!();
      }
    }
  }

  /// **Persist If Default**
  ///
  /// Saves the current playlist and index when using the default playlist.
  void _persistIfDefault() {
    if (_isUsingDefaultPlaylist) {
      _storage.save(_currentPlaylist, _index);
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // State Hook
  // ───────────────────────────────────────────────────────────────────────────

  /// **State Change Hook**
  ///
  /// Logs start/completion. Crossfades typically prevent `completed` from
  /// firing, but this remains as a safety fallback.
  @override
  void onStateChanged(PlayerState state) {
    // Guard: skip logging if no playlist is loaded (e.g., direct playFromSource usage)
    if (_currentPlaylist.isEmpty) return;

    switch (state) {
      case PlayerState.playing:
        FiftyAudioLogger.log('[${_currentPlaylist[_index]}] Started');
        break;
      case PlayerState.completed:
        FiftyAudioLogger.log('[${_currentPlaylist[_index]}] Completed');
        // Normally handled by crossfade — fallback if ever needed.
        break;
      default:
      // no-op
        break;
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ───────────────────────────────────────────────────────────────────────────

  /// **Dispose**
  ///
  /// Cancels crossfade listener and releases base resources.
  @override
  Future<void> dispose() async {
    _positionSub?.cancel();
    await super.dispose();
  }
}
