# BR-052: Audio Demo Page Refactoring

**Type:** Refactor
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2026-01-30

---

## Problem

**What's broken or missing?**

The current audio demo page (`fifty_demo/lib/features/audio_demo/`) has several issues:

1. **Uses non-fifty_ui components**: Custom volume sliders and controls instead of `FiftySlider`, `FiftySwitch`, etc.
2. **Non-functional**: The demo is purely visual mockup - not connected to actual `fifty_audio_engine` package
3. **Component duplication**: Custom widgets like `_ControlButton`, `_buildVolumeRow` duplicate functionality that should be in fifty_ui
4. **Hardcoded mock data**: Uses fake state instead of real audio engine integration

**Why does it matter?**

- Demo app should demonstrate the actual `fifty_audio_engine` package working
- Users expect to see real audio playback when visiting the demo
- Duplicate components violate DRY principle and increase maintenance burden
- Inconsistent UI components break design system cohesion

---

## Goal

**What should happen after this brief is completed?**

1. Audio demo page uses `fifty_audio_engine` for real audio functionality
2. All UI components use fifty_ui library exclusively
3. Any missing components needed are added to fifty_ui (not duplicated in demo)
4. Demo showcases actual BGM, SFX, and Voice channel functionality
5. Volume controls, mute toggles, and playback work with real audio

---

## Context & Inputs

### Current Implementation Issues

| Issue | Location | Resolution |
|-------|----------|------------|
| Custom `_buildVolumeRow` with inline Slider | audio_demo_page.dart:181 | Use `FiftySlider` |
| Custom `_ControlButton` widget | audio_demo_page.dart:658 | Create `FiftyControlButton` in fifty_ui or use existing |
| Mock `AudioDemoViewModel` | audio_demo_view_model.dart | Connect to `FiftyAudioEngine` |
| No audio assets | - | Add sample audio files or use existing from package |

### Fifty UI Components to Use

| Required | fifty_ui Component | Usage |
|----------|-------------------|-------|
| Volume control | `FiftySlider` | Channel volume adjustment |
| Mute toggle | `FiftySwitch` or `FiftyIconButton` | Mute/unmute channels |
| Track selection | `FiftySegmentedControl` | Already used for SFX categories |
| Playback buttons | `FiftyButton` / `FiftyIconButton` | Play, pause, stop, next |
| Channel cards | `FiftyCard` | Already used |
| Status indicators | `StatusIndicator` | Already used |
| Progress bar | `FiftyProgressBar` | BGM playback progress |

### Components That May Need Creation in fifty_ui

| Component | Purpose | Priority |
|-----------|---------|----------|
| `FiftyVolumeControl` | Volume slider with icon, label, percentage, and mute button | High |
| `FiftyPlaybackControls` | Grouped play/pause/stop/next buttons | Medium |

### Affected Modules
- [x] Other: `apps/fifty_demo/lib/features/audio_demo/`
- [x] Other: `packages/fifty_ui/` (if new components needed)

### Layers Touched
- [x] View (UI widgets)
- [x] Actions (UX orchestration)
- [x] ViewModel (business logic)
- [x] Service (FiftyAudioEngine integration)

### Dependencies
- [x] fifty_audio_engine (audio playback)
- [x] fifty_ui (UI components)
- [x] fifty_tokens (design tokens)
- [x] fifty_theme (theming)

### Related Files
- `apps/fifty_demo/lib/features/audio_demo/views/audio_demo_page.dart`
- `apps/fifty_demo/lib/features/audio_demo/controllers/audio_demo_view_model.dart`
- `apps/fifty_demo/lib/features/audio_demo/actions/audio_demo_actions.dart`
- `packages/fifty_audio_engine/lib/fifty_audio_engine.dart`
- `packages/fifty_ui/lib/src/molecules/fifty_slider.dart`

---

## Constraints

### Architecture Rules
- Must follow MVVM + Actions pattern (View → Actions → ViewModel → Service)
- No skipping layers
- Use existing fifty_ui components wherever possible
- Only create new fifty_ui components for genuinely missing functionality

### Technical Constraints
- Must use actual `FiftyAudioEngine` for audio playback
- Audio assets must be bundled or referenced from package example
- Must work offline (no network audio streaming)
- Must follow DRY principle - no duplicate widget code in demo app

### Out of Scope
- Adding new audio channels to fifty_audio_engine
- Creating audio visualization effects
- Recording/microphone features

---

## Tasks

### Pending
- [ ] Audit current audio_demo_page.dart for non-fifty_ui components
- [ ] Determine if `FiftyVolumeControl` should be added to fifty_ui
- [ ] Connect `AudioDemoViewModel` to actual `FiftyAudioEngine`
- [ ] Replace custom volume rows with `FiftySlider` or `FiftyVolumeControl`
- [ ] Replace `_ControlButton` with `FiftyIconButton` or `FiftyButton`
- [ ] Add audio assets to demo app (or reference from package)
- [ ] Test real audio playback (BGM, SFX, Voice)
- [ ] Verify all controls affect actual audio
- [ ] Run `flutter analyze` (zero issues)

### In Progress
_(Tasks currently being worked on)_

### Completed
_(Finished tasks)_

---

## Session State (Tactical - This Brief)

**Current State:** COMMITTING
**Active Agent:** none
**Next Steps When Resuming:** Commit complete, update brief status to Done
**Last Updated:** 2026-01-30
**Blockers:** None

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Audio demo uses `FiftyAudioEngine` for actual audio playback
2. [ ] All volume sliders use `FiftySlider` (or new `FiftyVolumeControl` if created)
3. [ ] All buttons use `FiftyButton` or `FiftyIconButton`
4. [ ] No custom widget classes defined in audio_demo_page.dart (except page-specific layouts)
5. [ ] BGM plays actual audio when play is tapped
6. [ ] SFX triggers actual sound effects
7. [ ] Voice channel plays voice lines with BGM ducking
8. [ ] Volume controls affect real audio output
9. [ ] Mute toggles silence respective channels
10. [ ] `flutter analyze` passes (zero issues)
11. [ ] DRY principle followed - no component duplication

---

## Test Plan

### Manual Test Cases

#### Test Case 1: BGM Playback
**Steps:**
1. Navigate to Audio Engine demo
2. Select a BGM track
3. Tap Play button
4. Adjust volume slider
5. Tap mute button
6. Tap unmute button
7. Tap Stop button

**Expected Result:** Real audio plays, volume changes audibly, mute silences, stop ends playback

#### Test Case 2: SFX Triggers
**Steps:**
1. Navigate to SFX section
2. Tap various sound effect buttons
3. Adjust SFX volume
4. Mute SFX channel
5. Try to trigger sounds while muted

**Expected Result:** Sounds play on tap, volume changes, muted state prevents playback

#### Test Case 3: Voice with Ducking
**Steps:**
1. Start BGM playing
2. Tap a voice line button
3. Observe BGM volume during voice playback

**Expected Result:** BGM volume ducks while voice plays, restores after

---

## Notes

### Audio Assets Strategy

Options for demo audio:
1. **Reference from fifty_audio_engine/example/assets/** - If package has bundled assets
2. **Add to fifty_demo/assets/audio/** - Bundle demo-specific assets
3. **Use short royalty-free clips** - 2-3 second samples sufficient for demo

### Component Decision Tree

For each custom widget in current code:
1. Does fifty_ui have equivalent? → Use it
2. Is it generally useful? → Add to fifty_ui, then use
3. Is it demo-specific layout? → Keep in demo but minimize

---

**Created:** 2026-01-30
**Last Updated:** 2026-01-30
**Brief Owner:** Igris AI
