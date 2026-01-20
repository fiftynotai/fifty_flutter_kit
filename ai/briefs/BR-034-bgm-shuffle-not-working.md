# BR-034: BGM Shuffle Toggle Not Working

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

In the fifty_audio_engine example app, the BGM shuffle toggle does not actually shuffle the playlist. The toggle switches visually but has no effect on track playback order.

**Why does it matter?**

- Example app should demonstrate working shuffle functionality
- Users testing the package will think shuffle is broken
- Undermines confidence in the fifty_audio_engine package

---

## Goal

**What should happen after this brief is completed?**

The BGM shuffle toggle should actually randomize the playlist order. When enabled, pressing "Next" should play a random track instead of the sequential next track.

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
- `packages/fifty_audio_engine/example/lib/features/bgm/bgm_view.dart`
- `packages/fifty_audio_engine/example/lib/features/bgm/bgm_actions.dart`
- `packages/fifty_audio_engine/example/lib/features/bgm/bgm_view_model.dart`

---

## Constraints

### Architecture Rules
- Must follow MVVM + Actions pattern
- Actions should call AudioService to enable/disable shuffle mode

### Technical Constraints
- Shuffle should affect "Next" track selection
- Current track should continue playing when shuffle is toggled

### Timeline
- **Deadline:** N/A
- **Milestones:** None

### Out of Scope
- Changes to fifty_audio_engine package itself
- Shuffle for other channels (only BGM has playlist)

---

## Tasks

### Pending
- [ ] Task 1: Investigate why shuffle toggle doesn't affect playback order
- [ ] Task 2: Fix BgmActions.onShuffleToggled to call AudioService
- [ ] Task 3: Verify shuffle randomizes next track selection

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Investigate bgm_actions.dart
**Last Updated:** 2026-01-21
**Blockers:** None

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Shuffle toggle enables/disables shuffle mode
2. [ ] When shuffle ON, "Next" plays random track (not sequential)
3. [ ] When shuffle OFF, "Next" plays sequential track
4. [ ] Shuffle state persists during playback
5. [ ] `flutter analyze` passes (zero issues)
6. [ ] Manual smoke test: toggle shuffle, press next multiple times, verify random order

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Shuffle Functionality
**Preconditions:** App running, BGM tab selected, music playing
**Steps:**
1. Note current track order (1, 2, 3, 4...)
2. Enable shuffle toggle
3. Press "Next" button 5+ times
4. Note track order played

**Expected Result:** Tracks play in random order, not sequential
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Shuffle Off
**Preconditions:** Shuffle enabled
**Steps:**
1. Disable shuffle toggle
2. Press "Next" button multiple times

**Expected Result:** Tracks play in sequential order
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

---

## Notes

Bug discovered during UI-006 FDL v2 redesign of fifty_audio_engine example.

Likely issue: BgmActions.onShuffleToggled may only update ViewModel state without calling AudioService shuffle method.

---

**Created:** 2026-01-21
**Last Updated:** 2026-01-21
**Brief Owner:** Igris AI
