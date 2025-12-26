# Fifty Audio Engine Example

A comprehensive example app demonstrating the `fifty_audio_engine` package capabilities.

## Features

This example showcases all audio engine features across four sections:

### BGM (Background Music)
- Playlist management with track selection
- Play, pause, stop, next, previous controls
- Volume control with mute toggle
- Shuffle mode
- Progress bar with time display

### SFX (Sound Effects)
- Grid of sound effect buttons
- Visual feedback on play
- Volume control with mute toggle
- Pooling demonstration

### Voice
- Voice line playback
- BGM ducking toggle (auto-lowers BGM during voice)
- Volume control with mute toggle
- Status indicators

### Global Controls
- Master mute toggle (mutes all channels)
- Stop all button
- Fade preset selector (5 presets: fast, panel, normal, cinematic, ambient)
- Fade in/out controls
- Channel status overview

## Architecture

This example follows the **MVVM + Actions** pattern:

```
lib/
├── main.dart                    # App entry point
├── app/
│   └── audio_demo_app.dart      # Main app shell with navigation
├── features/
│   ├── bgm/
│   │   ├── bgm_view.dart        # UI
│   │   ├── bgm_actions.dart     # User action handlers
│   │   └── bgm_view_model.dart  # State
│   ├── sfx/
│   │   ├── sfx_view.dart
│   │   ├── sfx_actions.dart
│   │   └── sfx_view_model.dart
│   ├── voice/
│   │   ├── voice_view.dart
│   │   ├── voice_actions.dart
│   │   └── voice_view_model.dart
│   └── global/
│       ├── global_view.dart
│       ├── global_actions.dart
│       └── global_view_model.dart
├── services/
│   └── mock_audio_engine.dart   # Mock implementation
└── widgets/
    ├── channel_card.dart        # Reusable card wrapper
    ├── volume_control.dart      # Volume slider with mute
    └── playback_controls.dart   # Transport controls
```

### Pattern Explanation

- **View** - UI widgets that observe ViewModel state
- **Actions** - Handle user interactions, delegate to services
- **ViewModel** - Expose service state for views to observe
- **Service** - MockAudioEngine (simulates real audio engine)

## Running the Example

```bash
cd packages/fifty_audio_engine/example
flutter pub get

# Generate platform files (required after cloning - they are gitignored)
flutter create . --org dev.fifty.audio_engine_example

flutter run
```

> **Note:** Platform folders (ios/, android/, etc.) are gitignored by convention. Run `flutter create .` once after cloning to generate them.

## Design System

This example uses the Fifty Design Language (FDL):

- **Background**: voidBlack (#0A0A0A)
- **Cards**: gunmetal (#1A1A1A) with halftone texture
- **Accent**: crimsonPulse (#FF073A)
- **Text**: terminalWhite (#F5F5F5)
- **Typography**: Monument Extended (headlines), JetBrains Mono (body)

All components come from the `fifty_ui` package.

## Fade Presets

| Preset | Duration | Use Case |
|--------|----------|----------|
| Fast | 150ms | UI feedback |
| Panel | 300ms | Panel transitions |
| Normal | 800ms | Standard crossfade |
| Cinematic | 2000ms | Scene transitions |
| Ambient | 3000ms | Atmospheric changes |

## Mock Audio Engine

Since the actual `fifty_audio_engine` package is under development, this example uses a mock implementation that simulates the intended API:

```dart
// BGM
MockAudioEngine.instance.bgm.play();
MockAudioEngine.instance.bgm.pause();
MockAudioEngine.instance.bgm.setVolume(0.8);
MockAudioEngine.instance.bgm.mute();

// SFX
MockAudioEngine.instance.sfx.play('click');
MockAudioEngine.instance.sfx.setVolume(0.8);

// Voice
MockAudioEngine.instance.voice.playVoice('greeting', withDucking: true);

// Global
MockAudioEngine.instance.muteAll();
MockAudioEngine.instance.fadeAllOut(preset: FadePreset.normal);
```

## Dependencies

- `fifty_ui` - FDL component library
- `fifty_theme` - Theme configuration
- `fifty_tokens` - Design tokens

## License

Part of the fifty.dev ecosystem.
