# Fifty Audio Engine

A modular, reactive audio system for Flutter games and applications. Built for Fifty Flutter Kit.

---

## Overview

Fifty Audio Engine provides a three-channel audio architecture designed for games and interactive applications:

| Channel | Purpose | Optimization |
|---------|---------|--------------|
| **BGM** | Background music | Crossfade, playlist, loop |
| **SFX** | Sound effects | Low-latency pooling |
| **Voice** | Voice acting / VO | BGM ducking |

All channels share:
- Persistent volume and state via `GetStorage`
- Fade presets aligned with `FiftyMotion` tokens
- Platform-specific audio context configuration
- Lifecycle-aware pause/resume behavior

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_audio_engine:
    git:
      url: https://github.com/fiftynotai/fifty_flutter_kit.git
      path: packages/fifty_audio_engine
```

**Dependencies:**
- `audioplayers: ^6.4.0`
- `get_storage: ^2.1.1`
- `fifty_tokens` (for motion token integration)

---

## Quick Start

```dart
import 'package:fifty_audio_engine/fifty_audio_engine.dart';

// 1. Initialize once at app startup
await FiftyAudioEngine.instance.initialize([
  'assets/bgm/title.mp3',
  'assets/bgm/gameplay.mp3',
]);

// 2. Play background music
FiftyAudioEngine.instance.bgm.playNext();

// 3. Fire sound effects
FiftyAudioEngine.instance.sfx.play('assets/sfx/click.wav');

// 4. Play voice lines (auto-ducks BGM)
FiftyAudioEngine.instance.voice.playVoice('https://cdn.example.com/vo/greeting.mp3');
```

---

## Architecture

```
FiftyAudioEngine (Singleton)
    |
    +-- bgm: BgmChannel
    |       Playlist management, crossfade, shuffle, persistence
    |
    +-- sfx: SfxChannel
    |       Pooled playback, sound groups, throttling
    |
    +-- voice: VoiceActingChannel
    |       URL streaming, BGM ducking hooks
    |
    +-- AudioStorage
            Persistent state (volumes, mute flags, playlist index)
```

### Core Components

| Component | Description |
|-----------|-------------|
| `FiftyAudioEngine` | Singleton entry point; wires ducking hooks |
| `BaseAudioChannel` | Abstract base with play/pause/fade logic |
| `BgmChannel` | Long-form tracks with crossfade |
| `SfxChannel` | Short clips with pooling mixin |
| `VoiceActingChannel` | VO playback with ducking callbacks |
| `FadePreset` | Duration + curve combinations |
| `AudioStorage` | GetStorage wrapper for persistence |

---

## API Reference

### FiftyAudioEngine

Main singleton controller.

```dart
/// Access the singleton
FiftyAudioEngine.instance

/// Initialize with optional BGM playlist
Future<void> initialize([List<String>? bgmTracks])

/// Global controls
Future<void> muteAll()
Future<void> unmuteAll()
Future<void> stopAll()
Future<void> fadeAllIn({FadePreset preset = FadePreset.normal})
Future<void> fadeAllOut({FadePreset preset = FadePreset.fast})

/// Channel accessors
BgmChannel get bgm
SfxChannel get sfx
VoiceActingChannel get voice
```

---

### BgmChannel

Background music with playlist management.

```dart
/// Playlist operations
Future<void> loadDefaultPlaylist(List<String> paths)
Future<void> resumeDefaultPlaylist()
Future<void> playCustomPlaylist(List<String> paths)
Future<void> playNext()
Future<void> playAtIndex(int index)

/// Playback
Future<void> play(String path)
Future<void> pause()
Future<void> resume()
Future<void> stop()

/// Volume (persisted)
Future<void> setVolume(double volume)
Future<void> mute()
Future<void> unmute()

/// Callbacks
VoidCallback? onDefaultPlaylistComplete  // Fired when playlist loops
VoidCallback? onTrackAboutToChange       // Fired before crossfade
```

**Features:**
- Automatic crossfade 3 seconds before track end
- Shuffle and index persistence across sessions
- Custom vs default playlist distinction
- Loop mode by default

---

### SfxChannel

Sound effects with pooling for instant retrigger.

```dart
/// Configure pooling
void enablePooling({
  bool enabled = true,
  int poolSizePerSound = 4,
})

/// Register sound groups
void registerGroup(String name, List<String> paths)

/// Playback
Future<void> play(String path)           // Pooled, path-based
Future<void> playGroup(String name)      // Random from group, throttled
Future<void> playSfxSource(Source source, {String? cacheKey})

/// Volume (persisted)
Future<void> setVolume(double volume)
Future<void> mute()
Future<void> unmute()

/// Swap source loader
void changeSource(AudioSourceBuilder builder)
```

**Features:**
- 4 concurrent players per sound by default
- 150ms throttle per group to prevent spam
- Supports assets, device files, and URLs
- Low-latency `PlayerMode.lowLatency`

**Group Example:**
```dart
// Register multiple variations
sfx.registerGroup('click', [
  'assets/sfx/click1.wav',
  'assets/sfx/click2.wav',
  'assets/sfx/click3.wav',
]);

// Play random variation (throttled)
await sfx.playGroup('click');
```

---

### VoiceActingChannel

Voice-over playback with automatic BGM ducking.

```dart
/// Play voice line (triggers ducking)
Future<void> playVoice(String url, [bool withDucking = true])

/// Direct play (no ducking)
Future<void> play(String path)

/// Volume (persisted)
Future<void> setVolume(double volume)
Future<void> mute()
Future<void> unmute()

/// Hooks (set by FiftyAudioEngine)
Future<void> Function()? onDucking    // Called before voice starts
Future<void> Function()? onRestore    // Called when voice ends
Future<void> Function()? onCompleted  // Called on natural completion
```

**Ducking Behavior:**
1. `onDucking` fires - BGM fades to 30%
2. Voice plays
3. Voice completes or stops
4. `onRestore` fires - BGM returns to original volume

---

### FadePreset

Reusable fade configurations integrated with FiftyMotion tokens.

| Preset | Duration | Curve | Use Case |
|--------|----------|-------|----------|
| `fast` | 150ms | linear | UI feedback, quick transitions |
| `panel` | 300ms | standard | Panel reveals |
| `normal` | 800ms | easeInOut | Scene transitions |
| `cinematic` | 2000ms | easeInOutCubic | Dramatic moments |
| `ambient` | 3000ms | decelerate | Environmental changes |
| `buildTension` | 1200ms | easeIn | Boss entrances |
| `smoothExit` | 1000ms | easeOut | Scene fade outs |

**Usage:**
```dart
await bgm.fadeOutVolume(FadePreset.cinematic);
await bgm.fadeInVolume(FadePreset.normal);

// Or wrap actions
await bgm.withFade(
  () async => bgm.playAtIndex(3),
  fadeOut: FadePreset.fast,
  fadeIn: FadePreset.normal,
);
```

---

### GlobalFadePresets

Semantic aliases for common scenarios.

```dart
GlobalFadePresets.uiClick           // fast
GlobalFadePresets.sceneChange       // normal
GlobalFadePresets.ambientShift      // ambient
GlobalFadePresets.bossEntrance      // buildTension
GlobalFadePresets.cinematic         // cinematic
GlobalFadePresets.voiceDuckingOut   // fast
GlobalFadePresets.voiceDuckingIn    // normal
GlobalFadePresets.levelTransition   // normal
```

---

## BaseAudioChannel

Abstract base class providing shared functionality.

```dart
/// Playback
Future<void> play(String path)
Future<void> playFromSource(Source source)
Future<void> pause()
Future<void> resume()
Future<void> stop()

/// Volume
Future<void> setVolume(double volume)
Future<void> mute()
Future<void> unmute()
double get volume
bool get isMuted

/// Activation
void activate()
void deactivate()
void toggleActive()
bool get isActive

/// Fades
Future<void> fadeTo(double target, {Duration duration, Curve curve})
Future<void> fadeIn({Duration duration, Curve curve})
Future<void> fadeOut({Duration duration, Curve curve})
Future<void> withFade(Future<void> Function() action, {FadePreset fadeOut, FadePreset fadeIn})

/// Lifecycle
void enableLifecycle([ChannelLifecycleConfig cfg])
void disableLifecycle()

/// Sync helpers (non-looping, non-pooled only)
Future<bool> waitUntilStarted({Duration timeout})
Future<bool> waitUntilStopped({Duration startTimeout, Duration timeout})
Future<bool> playAndWait(String path, {...})

/// Streams
Stream<bool> get onIsPlayingChanged
Stream<Duration> get onPositionChanged
Stream<Duration> get onDurationChanged
Stream<void> get onPlayerComplete
```

### Reactive Streams

All channels expose reactive streams for building responsive UIs:

| Stream | Type | Description |
|--------|------|-------------|
| `onIsPlayingChanged` | `Stream<bool>` | Emits when playback starts or stops |
| `onPositionChanged` | `Stream<Duration>` | Emits current playback position continuously |
| `onDurationChanged` | `Stream<Duration>` | Emits when duration becomes available or changes |
| `onPlayerComplete` | `Stream<void>` | Emits when the current track completes |

**Duration Stream Example:**

The `onDurationChanged` stream is useful for UIs that need to update when tracks change, such as progress bars or time displays:

```dart
// Subscribe to duration updates
final bgm = FiftyAudioEngine.instance.bgm;

bgm.onDurationChanged.listen((duration) {
  print('Track duration: ${duration.inSeconds}s');
  // Update your progress bar max value
  setState(() {
    _totalDuration = duration;
  });
});

// Combine with position for a complete progress indicator
StreamBuilder<Duration>(
  stream: bgm.onPositionChanged,
  builder: (context, positionSnapshot) {
    return StreamBuilder<Duration>(
      stream: bgm.onDurationChanged,
      builder: (context, durationSnapshot) {
        final position = positionSnapshot.data ?? Duration.zero;
        final duration = durationSnapshot.data ?? Duration.zero;

        final progress = duration.inMilliseconds > 0
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0;

        return LinearProgressIndicator(value: progress);
      },
    );
  },
);
```

---

## Advanced Usage

### Source Swapping

Change how paths are resolved at runtime:

```dart
// Default: assets
sfx.play('assets/sfx/click.wav');

// Switch to device files
sfx.changeSource((path) => DeviceFileSource(path));
sfx.play('/storage/emulated/0/sounds/click.wav');

// Switch to URLs
sfx.changeSource((path) => UrlSource(path));
sfx.play('https://cdn.example.com/sfx/click.wav');
```

### Audio Context Configuration

Each channel uses platform-specific audio contexts:

| Channel | Android | iOS |
|---------|---------|-----|
| BGM | `game` usage, `music` content, no focus | `ambient` category |
| SFX | Mix with others | Mix with others |
| Voice | Duck others (transient) | Duck others |

### Lifecycle Handling

Channels can auto-pause/resume with app lifecycle:

```dart
bgm.enableLifecycle(ChannelLifecycleConfig(
  pauseOnBackground: true,
  fadeOnPause: FadePreset.fast,
  fadeOnResume: FadePreset.normal,
));
```

### Waiting for Playback

For scripted sequences (non-looping, non-pooled channels only):

```dart
// Play and wait for completion
await voice.playAndWait('https://cdn.example.com/vo/intro.mp3');

// Wait for already-playing audio
await voice.waitUntilStopped();
```

---

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android | Supported | `audioplayers` native |
| iOS | Supported | AVAudioPlayer |
| macOS | Supported | AVAudioPlayer |
| Linux | Supported | GStreamer |
| Windows | Supported | Windows Media Foundation |
| Web | Supported | Web Audio API |

---

## Fifty Design Language Integration

This package is part of Fifty Flutter Kit:

- **FiftyMotion tokens** - Fade durations align with motion system
- **Namespace isolation** - Storage keys prefixed with `fifty_audio_*`
- **Compatible packages** - Works with `fifty_tokens`, `fifty_theme`, `fifty_ui`

---

## Persistence

All channel states are persisted via `GetStorage`:

| Key | Type | Description |
|-----|------|-------------|
| `fifty_audio_bgm_volume` | double | BGM volume (0.0-1.0) |
| `fifty_audio_sfx_volume` | double | SFX volume |
| `fifty_audio_voice_volume` | double | Voice volume |
| `fifty_audio_bgm_active` | bool | BGM enabled flag |
| `fifty_audio_sfx_active` | bool | SFX enabled flag |
| `fifty_audio_voice_active` | bool | Voice enabled flag |
| `fifty_audio_playlist` | List | Current BGM playlist |
| `fifty_audio_index` | int | Current track index |

---

## Version

**Current:** 0.7.0

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
