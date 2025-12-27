# Implementation Plan: BR-012 - Fifty Audio Engine Example App

**Complexity:** L (Large)
**Estimated Duration:** 3-5 days
**Risk Level:** Medium
**Agent Override:** mvvm_arch_action_agent (replaces coder)

---

## Summary

Create a comprehensive example app demonstrating all fifty_audio_engine capabilities using fifty_ui components with MVVM + Actions architecture. The app will feature four main sections (BGM, SFX, Voice, Global) with tab navigation.

---

## App Structure

```
packages/fifty_audio_engine/example/
├── lib/
│   ├── main.dart                       # Entry point with FiftyTheme
│   ├── app/
│   │   ├── audio_demo_app.dart         # Main shell with FiftyNavBar
│   │   └── audio_service.dart          # Audio engine wrapper
│   ├── features/
│   │   ├── bgm/
│   │   │   ├── bgm_view.dart           # BGM controls UI
│   │   │   ├── bgm_actions.dart        # BGM action handlers
│   │   │   └── bgm_view_model.dart     # BGM state
│   │   ├── sfx/
│   │   │   ├── sfx_view.dart           # SFX controls UI
│   │   │   ├── sfx_actions.dart        # SFX action handlers
│   │   │   └── sfx_view_model.dart     # SFX state
│   │   ├── voice/
│   │   │   ├── voice_view.dart         # Voice controls UI
│   │   │   ├── voice_actions.dart      # Voice action handlers
│   │   │   └── voice_view_model.dart   # Voice state
│   │   └── global/
│   │       ├── global_view.dart        # Global controls UI
│   │       ├── global_actions.dart     # Global action handlers
│   │       └── global_view_model.dart  # Global state
│   └── widgets/
│       ├── channel_card.dart           # Reusable section container
│       ├── volume_control.dart         # Slider + mute toggle
│       ├── playback_controls.dart      # Play/pause/stop/next/prev
│       ├── fade_preset_selector.dart   # Dropdown for presets
│       └── track_display.dart          # Current track info
├── assets/
│   ├── bgm/                            # Sample BGM tracks
│   ├── sfx/                            # Sample SFX clips
│   └── voice/                          # Sample voice line
├── pubspec.yaml
└── README.md
```

---

## MVVM + Actions Architecture

```
View (UI Widgets)
  ↓ user interactions
Actions (UX Orchestration)
  ↓ orchestrates
ViewModel (Business Logic / State)
  ↓ calls
Service (FiftyAudioEngine)
```

---

## Implementation Phases

### Phase 1: Project Setup
- Create example project structure
- Configure pubspec.yaml with ecosystem dependencies
- Create main.dart with FiftyTheme.dark()

### Phase 2: Core Architecture
- Create AudioService wrapper
- Create AudioDemoApp shell with FiftyNavBar
- Implement navigation between 4 sections

### Phase 3: BGM Feature
- BgmViewModel: isPlaying, isMuted, isShuffled, volume, currentTrackIndex
- BgmActions: onPlayPressed, onStopPressed, onNextPressed, onVolumeChanged, etc.
- BgmView: Track display, playback controls, volume, shuffle toggle, playlist

### Phase 4: SFX Feature
- SfxViewModel: volume, isMuted, lastPlayedSound
- SfxActions: onPlaySingle, onPlayGroup, onVolumeChanged
- SfxView: Sound buttons grid, group buttons, volume, rapid-fire test

### Phase 5: Voice Feature
- VoiceViewModel: volume, isMuted, duckingEnabled, isPlaying
- VoiceActions: onPlayVoice, onVolumeChanged, onDuckingToggled
- VoiceView: Play button, ducking toggle, volume, status indicators

### Phase 6: Global Feature
- GlobalViewModel: masterMuted, selectedFadePreset
- GlobalActions: onMuteAllToggled, onFadeOut, onFadeIn, onStopAll
- GlobalView: Master mute, fade preset selector, fade buttons, channel status

### Phase 7: Shared Widgets
- ChannelCard: Section container with title
- VolumeControl: Slider with mute toggle
- PlaybackControls: Transport buttons
- FadePresetSelector: Dropdown for fade presets
- TrackDisplay: Current track info with badge

### Phase 8: Assets & Documentation
- Add sample audio files (or placeholders)
- Create README.md with usage instructions

---

## Fifty UI Components Used

| Component | Usage |
|-----------|-------|
| FiftyHero | App title "AUDIO ENGINE" |
| FiftyNavBar | 4-tab navigation |
| FiftyCard | Section containers |
| FiftyButton | Action buttons |
| FiftyIconButton | Mute, shuffle icons |
| FiftySlider | Volume controls |
| FiftySwitch | Toggle options |
| FiftyDropdown | Fade preset selector |
| FiftyBadge | Status indicators |
| FiftyDataSlate | Track info display |
| GlitchEffect | Title animation |
| KineticEffect | Button feedback |

---

## Audio Engine API

```dart
// BGM
FiftyAudioEngine.instance.bgm.playNext();
FiftyAudioEngine.instance.bgm.playAtIndex(index);
FiftyAudioEngine.instance.bgm.setVolume(0.8);
FiftyAudioEngine.instance.bgm.mute();
FiftyAudioEngine.instance.bgm.pause();
FiftyAudioEngine.instance.bgm.resume();

// SFX
FiftyAudioEngine.instance.sfx.play('path');
FiftyAudioEngine.instance.sfx.playGroup('group_name');
FiftyAudioEngine.instance.sfx.registerGroup('name', [paths]);

// Voice
FiftyAudioEngine.instance.voice.playVoice('path');
FiftyAudioEngine.instance.voice.playVoice('path', false); // no ducking

// Global
FiftyAudioEngine.instance.muteAll();
FiftyAudioEngine.instance.fadeAllOut(preset: FadePreset.fast);
FiftyAudioEngine.instance.fadeAllIn(preset: FadePreset.normal);
FiftyAudioEngine.instance.stopAll();
```

---

## Dependencies

```yaml
dependencies:
  fifty_audio_engine:
    path: ../
  fifty_ui:
    path: ../../fifty_ui
  fifty_theme:
    path: ../../fifty_theme
  fifty_tokens:
    path: ../../fifty_tokens
```

---

## Checklist

- [ ] Project structure created
- [ ] pubspec.yaml configured
- [ ] main.dart with FiftyTheme.dark()
- [ ] AudioDemoApp with FiftyNavBar
- [ ] AudioService wrapper
- [ ] BGM feature (view, actions, view_model)
- [ ] SFX feature (view, actions, view_model)
- [ ] Voice feature (view, actions, view_model)
- [ ] Global feature (view, actions, view_model)
- [ ] Shared widgets created
- [ ] Sample assets added
- [ ] README.md documentation
- [ ] flutter analyze passes
- [ ] App runs successfully

---

**Ready for implementation by mvvm_arch_action_agent**
