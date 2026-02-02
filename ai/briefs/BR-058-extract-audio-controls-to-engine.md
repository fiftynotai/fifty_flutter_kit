# BR-058: Extract Audio Controls to fifty_audio_engine

**Type:** Feature
**Priority:** P3-Low
**Effort:** S (Small)
**Status:** Done

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
    required this.bgmEnabled,
    required this.bgmPlaying,
    required this.onPlayBgm,
    required this.onStopBgm,
    required this.onToggleBgm,
    this.bgmVolume,
    this.onBgmVolumeChanged,

    // SFX controls
    required this.sfxEnabled,
    required this.onToggleSfx,
    required this.onTestSfx,
    this.sfxVolume,
    this.onSfxVolumeChanged,

    // Layout
    this.compact = false,
    this.showCard = true,
    this.title,
    super.key,
  });
}
```

---

## Acceptance Criteria

- [x] `AudioControlsPanel` created in fifty_audio_engine
- [x] Widget is callback-based (no ViewModel dependencies)
- [x] Exported from `fifty_audio_engine.dart`
- [x] fifty_demo updated to use engine widget
- [x] Original widget removed from fifty_demo
- [x] Documentation with usage examples

---

## Files Created

- `packages/fifty_audio_engine/lib/src/widgets/widgets.dart` (barrel)
- `packages/fifty_audio_engine/lib/src/widgets/audio_controls_panel.dart`

## Files Modified

- `packages/fifty_audio_engine/lib/fifty_audio_engine.dart` (added widgets export)
- `apps/fifty_demo/lib/features/map_demo/views/map_demo_page.dart` (uses engine widget)

---

## Dependencies

- fifty_ui (FiftyButton, FiftyCard)
- fifty_tokens (FiftySpacing, FiftyTypography, FiftyRadii)
- fifty_theme (FiftyThemeExtension)

---

## Implementation Notes

The widget provides:

- **BGM Controls**: Play/Stop button, enable/disable toggle with status indicator
- **SFX Controls**: Test button, enable/disable toggle with status indicator
- **Volume Sliders**: Optional sliders shown when volume value and callback are provided
- **Compact Mode**: Reduced spacing for space-constrained layouts
- **Card Wrapper**: Optional FiftyCard wrapper (can be disabled for embedding)
- **FDL Compliant**: Uses Fifty Design Language tokens throughout
