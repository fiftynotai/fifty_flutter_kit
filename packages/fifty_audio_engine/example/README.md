# Fifty Audio Engine Example

A comprehensive demonstration of the `fifty_audio_engine` package with real audio playback.

---

## Overview

This example app showcases all audio engine features using:

- **Real audio playback** via `AudioService` (not mocks)
- **URL-based streaming** from royalty-free sources
- **MVVM + Actions** architecture pattern
- **Fifty Design Language** styling

**Note:** Requires internet connection for audio streaming.

---

## Features

### BGM (Background Music)

- Playlist with 3 demo tracks
- Play, pause, stop, next, previous controls
- Volume slider with mute toggle
- Shuffle mode toggle
- Real-time progress bar with time display
- Track metadata display (title, artist)

### SFX (Sound Effects)

- 6 sound effect buttons: click, hover, success, error, notify, toggle
- Visual feedback on trigger
- Volume control with mute toggle
- Demonstrates pooling and throttling concepts

### Voice Acting

- Voice line playback demonstration
- BGM ducking toggle (auto-lowers BGM during voice)
- Volume control with mute toggle
- Playing status indicator

### Global Controls

- Master mute toggle (mutes all channels)
- Stop all button
- Fade preset selector (5 presets)
- Fade in/out controls with animated transitions
- Channel status overview panel

---

## Architecture

This example follows the **MVVM + Actions** pattern:

```
lib/
+-- main.dart                    # App entry point
+-- app/
|   +-- audio_demo_app.dart      # Main app shell with navigation
+-- features/
|   +-- bgm/
|   |   +-- bgm_view.dart        # UI
|   |   +-- bgm_actions.dart     # User action handlers
|   |   +-- bgm_view_model.dart  # State
|   +-- sfx/
|   |   +-- sfx_view.dart
|   |   +-- sfx_actions.dart
|   |   +-- sfx_view_model.dart
|   +-- voice/
|   |   +-- voice_view.dart
|   |   +-- voice_actions.dart
|   |   +-- voice_view_model.dart
|   +-- global/
|       +-- global_view.dart
|       +-- global_actions.dart
|       +-- global_view_model.dart
+-- services/
|   +-- audio_service.dart       # Real audio implementation
+-- widgets/
    +-- channel_card.dart        # Reusable card wrapper
    +-- volume_control.dart      # Volume slider with mute
    +-- playback_controls.dart   # Transport controls
```

### Pattern Explanation

| Layer | Responsibility |
|-------|----------------|
| **View** | UI widgets that observe ViewModel state |
| **Actions** | Handle user interactions, delegate to AudioService |
| **ViewModel** | Expose AudioService state for views to observe |
| **Service** | AudioService singleton with real AudioPlayers |

---

## Audio Service

The `AudioService` class wraps `audioplayers` directly for this demo:

```dart
// Three audio players, one per channel
late final AudioPlayer _bgmPlayer;   // PlayerMode.mediaPlayer
late final AudioPlayer _sfxPlayer;   // PlayerMode.lowLatency
late final AudioPlayer _voicePlayer; // PlayerMode.mediaPlayer

// Initialize
await AudioService.instance.initialize();

// BGM controls
await AudioService.instance.playBgm();
await AudioService.instance.pauseBgm();
await AudioService.instance.setBgmVolume(0.8);

// SFX controls
await AudioService.instance.playSfx('click');

// Voice controls (with ducking)
await AudioService.instance.playVoice('greeting');
```

### Sample Audio Sources

The demo uses royalty-free audio from public sources:

| Type | Source | Format |
|------|--------|--------|
| BGM | SoundHelix samples | MP3 |
| SFX | SoundJay button sounds | MP3 |
| Voice | SoundHelix samples | MP3 |

---

## Running the Example

```bash
cd packages/fifty_audio_engine/example

# Install dependencies
flutter pub get

# Generate platform files (required after cloning)
flutter create . --org dev.fifty.audio_engine_example

# Run the app
flutter run
```

**Platform Folder Note:** The `ios/`, `android/`, `web/`, etc. folders are gitignored by convention. Run `flutter create .` once after cloning to generate them.

---

## Adding Custom Audio

To use your own audio files:

### 1. Bundled Assets

```dart
// Add to pubspec.yaml
flutter:
  assets:
    - assets/audio/

// Update audio_service.dart
final List<TrackInfo> bgmTracks = const [
  TrackInfo(
    id: 'custom_track',
    title: 'MY TRACK',
    artist: 'My Artist',
    url: 'assets/audio/my_track.mp3',  // Note: use AssetSource for assets
    duration: Duration(minutes: 3),
  ),
];
```

### 2. Network URLs

```dart
final List<TrackInfo> bgmTracks = const [
  TrackInfo(
    id: 'network_track',
    title: 'STREAMED TRACK',
    artist: 'Artist',
    url: 'https://your-cdn.com/audio/track.mp3',
    duration: Duration(minutes: 4),
  ),
];
```

### 3. Device Files

For local device files, modify the player call:

```dart
await _bgmPlayer.play(DeviceFileSource('/path/to/file.mp3'));
```

---

## Fade Presets

The demo includes 5 fade presets matching `FiftyAudioEngine`:

| Preset | Duration | Use Case |
|--------|----------|----------|
| **FAST** | 150ms | UI feedback |
| **PANEL** | 300ms | Panel transitions |
| **NORMAL** | 800ms | Standard crossfade |
| **CINEMATIC** | 2000ms | Scene transitions |
| **AMBIENT** | 3000ms | Atmospheric changes |

Select a preset from the Global Controls section, then use Fade In/Out buttons.

---

## Design System

This example uses the Fifty Design Language (FDL):

| Element | Value |
|---------|-------|
| Background | voidBlack (#0A0A0A) |
| Cards | gunmetal (#1A1A1A) |
| Accent | crimsonPulse (#FF073A) |
| Text | terminalWhite (#F5F5F5) |
| Headlines | Monument Extended |
| Body | JetBrains Mono |

All components come from the `fifty_ui` package.

---

## Key Differences from Production Code

This demo differs from the actual `FiftyAudioEngine` package:

| Demo (AudioService) | Production (FiftyAudioEngine) |
|---------------------|-------------------------------|
| Direct AudioPlayer usage | BaseAudioChannel abstraction |
| Manual state management | Reactive streams + persistence |
| URL sources only | Assets, files, URLs, bytes |
| No pooling | SFX pooling with configurable size |
| Simple ducking | Hook-based ducking with restore |
| No crossfade | Automatic 3s crossfade |

The demo illustrates concepts; the package provides the full implementation.

---

## Dependencies

| Package | Purpose |
|---------|---------|
| `audioplayers` | Audio playback |
| `fifty_ui` | FDL component library |
| `fifty_theme` | Theme configuration |
| `fifty_tokens` | Design tokens |

---

## Troubleshooting

### No Audio on iOS Simulator

iOS Simulator may have limited audio support. Test on a real device.

### Audio Doesn't Play

1. Check internet connection (URL-based sources)
2. Check console for playback errors
3. Verify volume is not 0 and channel is not muted

### Platform Folder Missing

Run `flutter create .` in the example directory to generate platform files.

---

## License

Part of the fifty.dev ecosystem.
