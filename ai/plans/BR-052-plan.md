# Implementation Plan: BR-052

**Complexity:** M (Medium)
**Estimated Duration:** 1-2 days
**Risk Level:** Medium

## Summary

Refactor the Audio Demo page to connect to the actual `FiftyAudioEngine` for real audio playback, replace all custom UI widgets with fifty_ui components, and follow the DRY principle by eliminating component duplication.

## Current State Analysis

### Custom Components to Replace

| Component | Location | Lines | Replacement |
|-----------|----------|-------|-------------|
| `_buildVolumeRow` | audio_demo_page.dart:195-289 | 94 lines | Composition: `FiftySlider` + icon + label + `FiftyIconButton` (mute) |
| `_ControlButton` | audio_demo_page.dart:669-725 | 56 lines | `FiftyIconButton` with `secondary` variant |
| Raw `Slider` (BGM seek) | audio_demo_page.dart:411-423 | 12 lines | `FiftyProgressBar` (read-only) or `FiftySlider` (interactive) |
| Track selector buttons | audio_demo_page.dart:317-350 | 33 lines | Keep as layout-specific |
| SFX grid items | audio_demo_page.dart:491-533 | 42 lines | Keep layout but simplify using FDL components |

### Mock State to Replace with Real Audio

| ViewModel Property | FiftyAudioEngine Equivalent |
|-------------------|----------------------------|
| `_bgmPlaying` | `FiftyAudioEngine.instance.bgm.isPlaying` |
| `_bgmVolume` | `FiftyAudioEngine.instance.bgm.volume` |
| `_bgmMuted` | Volume == 0 check |
| `_sfxVolume` | `FiftyAudioEngine.instance.sfx.volume` |
| `_voiceVolume` | `FiftyAudioEngine.instance.voice.volume` |

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `audio_demo_page.dart` | MODIFY | Replace custom widgets, use fifty_ui components |
| `audio_demo_view_model.dart` | MODIFY | Integrate with FiftyAudioEngine, add stream listeners |
| `audio_demo_actions.dart` | MODIFY | Wire actions to real audio engine calls |
| `audio_demo_bindings.dart` | MODIFY | Add FiftyAudioEngine initialization |

## Implementation Steps

### Phase 1: Component Decision (AUTO-APPROVED)

**Decision: Do NOT create FiftyVolumeControl in fifty_ui**

Rationale:
1. Layout-specific composition, not a reusable primitive
2. Can be achieved by composing existing fifty_ui components
3. Follows "Promotion Pattern" - domain widgets stay in feature

### Phase 2: ViewModel Integration with FiftyAudioEngine

1. Import `package:fifty_audio_engine/fifty_audio_engine.dart`
2. Remove mock state, add engine references
3. Listen to audio state streams
4. Expose computed properties from engine state
5. Keep UI-only state (selected track, category) locally

### Phase 3: View Refactoring

1. Replace `_buildVolumeRow` with `FiftySlider` + `FiftyIconButton` composition
2. Replace `_ControlButton` with `FiftyIconButton`
3. Replace raw `Slider` for BGM seek with `FiftySlider`
4. Delete `_ControlButton` class (lines 669-725)

### Phase 4: Audio Assets Strategy

1. BGM: Bundle 1-2 short royalty-free MP3 loops
2. SFX: Use existing assets (click.mp3, hover.mp3, select.mp3)
3. Voice: Use placeholder URLs for ducking demo

### Phase 5: Actions Layer Updates

Update `AudioDemoActions` to call real FiftyAudioEngine methods.

### Phase 6: Bindings & Initialization

Ensure `FiftyAudioEngine.instance.initialize()` called at app startup.

### Phase 7: Testing & Validation

- Manual: BGM, SFX, Voice playback
- Static: `flutter analyze` (zero issues)

## Estimated Effort

| Phase | Time |
|-------|------|
| Phase 1: Component Decision | 0.5h |
| Phase 2: ViewModel Integration | 2-3h |
| Phase 3: View Refactoring | 2-3h |
| Phase 4: Audio Assets | 1h |
| Phase 5: Actions Updates | 1h |
| Phase 6: Bindings | 0.5h |
| Phase 7: Testing | 1h |
| **Total** | **8-10h** |

---

**Created:** 2026-01-30
**Agent:** ARCHITECT (planner)
