# BR-058: Extract Audio Controls to fifty_audio_engine

**Type:** Feature
**Priority:** P3-Low
**Effort:** S (Small)
**Status:** Ready

---

## Summary

Extract `AudioControlsWidget` from fifty_demo to fifty_audio_engine package as a reusable UI component for BGM/SFX control.

---

## Motivation

- Audio control pattern is reusable across any app with audio features
- Keeps UI close to the engine it controls
- Provides standard audio settings widget for engine users
- Complements BR-056 (speech controls extraction)

---

## Scope

### In Scope

1. **AudioControlsPanel** (from `AudioControlsWidget`)
   - Source: `apps/fifty_demo/lib/features/map_demo/views/widgets/audio_controls.dart`
   - Destination: `packages/fifty_audio_engine/lib/src/widgets/audio_controls_panel.dart`
   - Features:
     - BGM enable/disable toggle
     - SFX enable/disable toggle
     - Volume sliders (optional)
     - Callback-based API

2. **Update fifty_demo** to use engine widget

### Out of Scope

- Changes to audio engine core functionality
- Audio player UI (playback controls) - different use case

---

## Technical Details

### AudioControlsPanel API

```dart
class AudioControlsPanel extends StatelessWidget {
  const AudioControlsPanel({
    // BGM controls
    this.bgmEnabled = true,
    this.onBgmEnabledChanged,
    this.bgmVolume = 1.0,
    this.onBgmVolumeChanged,
    this.showBgmVolume = false,

    // SFX controls
    this.sfxEnabled = true,
    this.onSfxEnabledChanged,
    this.sfxVolume = 1.0,
    this.onSfxVolumeChanged,
    this.showSfxVolume = false,

    // Layout
    this.compact = false,
    this.title,
    super.key,
  });

  // BGM
  final bool bgmEnabled;
  final ValueChanged<bool>? onBgmEnabledChanged;
  final double bgmVolume;
  final ValueChanged<double>? onBgmVolumeChanged;
  final bool showBgmVolume;

  // SFX
  final bool sfxEnabled;
  final ValueChanged<bool>? onSfxEnabledChanged;
  final double sfxVolume;
  final ValueChanged<double>? onSfxVolumeChanged;
  final bool showSfxVolume;

  // Layout
  final bool compact;
  final String? title;
}
```

---

## Acceptance Criteria

- [ ] `AudioControlsPanel` created in fifty_audio_engine
- [ ] Widget is callback-based (no ViewModel dependencies)
- [ ] Exported from `fifty_audio_engine.dart`
- [ ] fifty_demo updated to use engine widget
- [ ] Original widget removed from fifty_demo
- [ ] Documentation with usage examples

---

## Files to Create

- `packages/fifty_audio_engine/lib/src/widgets/widgets.dart` (barrel)
- `packages/fifty_audio_engine/lib/src/widgets/audio_controls_panel.dart`

## Files to Modify

- `packages/fifty_audio_engine/lib/fifty_audio_engine.dart` (add export)
- `apps/fifty_demo/lib/features/map_demo/views/widgets/audio_controls.dart` (remove)
- `apps/fifty_demo/lib/features/map_demo/views/map_demo_page.dart` (update import)
- `apps/fifty_demo/lib/features/audio_demo/views/audio_demo_page.dart` (potentially use)

---

## Dependencies

- fifty_ui (FiftySwitch, FiftySlider, FiftyCard)
- fifty_tokens (spacing, typography)
- fifty_theme (theme-aware colors)

---

## Notes

- Simpler than speech controls - single widget
- Consider adding master volume control option
- Could add preset buttons (mute all, reset defaults)
