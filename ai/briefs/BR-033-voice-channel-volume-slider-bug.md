# BR-033: Voice Channel Volume Slider Not Changing Volume

**Type:** Bug Fix
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Ready
**Created:** 2026-01-21
**Completed:**

---

## Problem

**What's broken or missing?**

In the fifty_audio_engine example app, the Voice channel's volume slider does not actually change the voice playback volume. The slider moves visually but has no effect on the audio output.

**Why does it matter?**

- Example app should demonstrate working audio controls
- Users testing the package will think voice volume control is broken
- Undermines confidence in the fifty_audio_engine package

---

## Goal

**What should happen after this brief is completed?**

The Voice channel volume slider should actually control the voice playback volume. Moving the slider should audibly change how loud voice lines play.

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_audio_engine/example`

### Layers Touched
- [ ] View (UI widgets)
- [x] Actions (UX orchestration)
- [ ] ViewModel (business logic)
- [ ] Service (data layer)
- [ ] Model (domain objects)

### API Changes
- [x] No API changes

### Dependencies
- [x] Existing service: `AudioService` from fifty_audio_engine

### Related Files
- `packages/fifty_audio_engine/example/lib/features/voice/voice_view.dart`
- `packages/fifty_audio_engine/example/lib/features/voice/voice_actions.dart`
- `packages/fifty_audio_engine/example/lib/features/voice/voice_view_model.dart`

---

## Constraints

### Architecture Rules
- Must follow MVVM + Actions pattern
- Actions should call AudioService to actually change volume

### Technical Constraints
- Volume range: 0.0 to 1.0

### Timeline
- **Deadline:** N/A
- **Milestones:** None

### Out of Scope
- Changes to fifty_audio_engine package itself
- Other channel volume controls (BGM, SFX work correctly)

---

## Tasks

### Pending
- [ ] Task 1: Investigate why voice volume slider doesn't affect playback
- [ ] Task 2: Fix VoiceActions.onVolumeChanged to call AudioService
- [ ] Task 3: Verify volume changes are audible

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Investigate voice_actions.dart
**Last Updated:** 2026-01-21
**Blockers:** None

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Voice volume slider changes actual playback volume
2. [ ] Volume persists across voice line switches
3. [ ] Mute toggle works correctly
4. [ ] `flutter analyze` passes (zero issues)
5. [ ] Manual smoke test: play voice line, adjust slider, hear volume change

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Voice Volume Control
**Preconditions:** App running, Voice tab selected
**Steps:**
1. Play a voice line
2. While playing, drag volume slider from 100% to 50%
3. Listen for volume change
4. Drag slider to 0%
5. Listen for silence

**Expected Result:** Voice playback volume changes audibly with slider
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

---

## Notes

Bug discovered during UI-006 FDL v2 redesign of fifty_audio_engine example.

Likely issue: VoiceActions.onVolumeChanged may not be calling AudioService.setVoiceVolume() or similar method.

---

**Created:** 2026-01-21
**Last Updated:** 2026-01-21
**Brief Owner:** Igris AI
