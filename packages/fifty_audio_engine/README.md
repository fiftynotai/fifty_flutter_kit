# Fifty Audio Engine

A modular and reactive audio system for Flutter games and apps, part of the Fifty Design Language ecosystem.

## Features

- **Multi-Channel Architecture**: Separate channels for BGM, SFX, and Voice with independent volume controls
- **Reactive State**: Volume, mute states, and playlists persist across app sessions
- **BGM Management**: Playlist support with shuffle, cross-fading, and auto-resume
- **SFX Pooling**: Efficient sound effect playback with grouping and throttling
- **Voice Ducking**: Automatic BGM volume reduction during voice playback
- **Fade Presets**: Consistent audio transitions using Fifty Design Language motion tokens
- **Multi-Platform**: Android, iOS, Linux, macOS, Windows, and Web support

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_audio_engine:
    git:
      url: https://github.com/fiftynotai/fifty_eco_system.git
      path: packages/fifty_audio_engine
```

## Usage

### Initialize

```dart
import 'package:fifty_audio_engine/fifty_audio_engine.dart';

// Initialize with optional BGM playlist
await FiftyAudioEngine.instance.initialize([
  'assets/bgm/title.mp3',
  'assets/bgm/gameplay.mp3',
]);
```

### Background Music

```dart
final bgm = FiftyAudioEngine.instance.bgm;

// Play next track
await bgm.playNext();

// Volume control
await bgm.setVolume(0.8);

// Mute/unmute
await bgm.mute();
await bgm.unmute();
```

### Sound Effects

```dart
final sfx = FiftyAudioEngine.instance.sfx;

// Play a sound effect
await sfx.play('assets/sfx/click.mp3');

// Play from a group
await sfx.playGroup('button_clicks');
```

### Voice Acting

```dart
final voice = FiftyAudioEngine.instance.voice;

// Play voice line (auto-ducks BGM)
await voice.playVoice('assets/voice/greeting.mp3');
```

### Fade Transitions

```dart
// Use Fifty Design Language motion tokens
await FiftyAudioEngine.instance.fadeAllOut(preset: FadePreset.panel);
await FiftyAudioEngine.instance.fadeAllIn(preset: FadePreset.normal);
```

## Fade Presets

| Preset | Duration | Use Case |
|--------|----------|----------|
| `fast` | 150ms | Quick UI feedback |
| `panel` | 300ms | UI panel reveals |
| `normal` | 800ms | Standard scene transitions |
| `cinematic` | 2000ms | Dramatic moments |
| `ambient` | 3000ms | Slow environmental changes |

## Architecture

```
FiftyAudioEngine (Singleton)
├── BgmChannel     - Background music management
├── SfxChannel     - Sound effects with pooling
├── VoiceChannel   - Voice acting with ducking
└── AudioStorage   - Persistent state management
```

## Fifty Ecosystem Integration

This package integrates with the Fifty Design Language:

- **FiftyMotion tokens** for consistent fade timing
- Storage keys prefixed with `fifty_audio_*` for namespace isolation
- Compatible with fifty_tokens, fifty_theme, and fifty_ui

## Platform Support

| Platform | Support |
|----------|---------|
| Android | Yes |
| iOS | Yes |
| macOS | Yes |
| Linux | Yes |
| Windows | Yes |
| Web | Yes |

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of the [Fifty Design Language](https://github.com/fiftynotai/fifty_eco_system) ecosystem.
