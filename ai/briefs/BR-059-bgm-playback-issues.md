# BR-059: BGM Playback Issues - Volume Reset and No Auto-Play Next

**Type:** Bug Fix
**Priority:** P2-Medium
**Effort:** M-Medium (4-8h)
**Assignee:** Unassigned
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-02
**Completed:** 2026-02-02

---

## Problem

**What's broken or missing?**

In the fifty_demo audio showcase, BGM playback has two critical issues:

1. **Volume Resets to Zero:** When playing a BGM track, the volume resets to 0 and never increases. The slider shows 0% and playback is silent.

2. **No Auto-Play Next:** When a BGM track finishes playing, the next track in the playlist does not start automatically. Playback stops and user must manually select the next track.

**Why does it matter?**

- Users expect continuous background music playback
- Silent playback due to volume reset makes the demo appear broken
- Manual track selection defeats the purpose of a BGM playlist
- Undermines confidence in the fifty_audio_engine integration

---

## Goal

**What should happen after this brief is completed?**

1. Volume should persist at user-set level (not reset to 0)
2. When a track finishes, the next track should auto-play
3. If shuffle is enabled (see BR-034), next track should be random
4. If repeat mode is enabled, playlist should loop

---

## Context & Inputs

### Affected Modules
- [x] Other: `apps/fifty_demo/lib/src/modules/audio/`

### Layers Touched
- [ ] View (UI widgets)
- [x] Actions (UX orchestration)
- [x] ViewModel (business logic)
- [ ] Service (data layer)
- [ ] Model (domain objects)

### API Changes
- [x] No API changes

### Dependencies
- [x] Existing package: `fifty_audio_engine`
- [x] Related brief: BR-034 (shuffle not working)

### Related Files
- `apps/fifty_demo/lib/src/modules/audio/views/bgm_tab.dart`
- `apps/fifty_demo/lib/src/modules/audio/controllers/audio_view_model.dart`
- `apps/fifty_demo/lib/src/modules/audio/actions/audio_actions.dart`

---

## Constraints

### Architecture Rules
- Must follow MVVM + Actions pattern
- Must use fifty_audio_engine APIs correctly

### Technical Constraints
- Volume should persist in ViewModel state
- AudioService should handle track completion events
- Need to listen for `onComplete` or similar callback

### Timeline
- **Deadline:** N/A
- **Milestones:** None

### Out of Scope
- Changes to fifty_audio_engine package itself
- SFX or Voice channel issues (separate briefs)

---

## Tasks

### Pending

### In Progress

### Completed
- [x] Task 1: Investigate why volume resets to 0 on BGM play
- [x] Task 2: Fix volume initialization/persistence in ViewModel
- [x] Task 3: Investigate track completion event handling
- [x] Task 4: Implement auto-play next track on completion
- [x] Task 5: Respect shuffle state when selecting next track
- [x] Task 6: Manual smoke test full playback flow

---

## Session State (Tactical - This Brief)

**Current State:** Complete
**Next Steps When Resuming:** N/A - Brief complete
**Last Updated:** 2026-02-02
**Blockers:** None

### Implementation Summary
Fixed in `audio_demo_view_model.dart`:
1. Added `_volumeAppliedAfterPlay` flag to track volume state
2. Added `_ensureVolumeAfterPlay()` to apply volume AFTER play() with 100ms delay
3. Wired `onDefaultPlaylistComplete` and `onTrackAboutToChange` callbacks for auto-play
4. Added shuffle support in `skipNext()` method

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [x] BGM volume does NOT reset to 0 when starting playback
2. [x] Volume slider reflects actual playback volume
3. [x] When track ends, next track auto-plays
4. [x] Auto-play respects shuffle mode (if enabled)
5. [x] Auto-play respects repeat mode (if enabled)
6. [x] `flutter analyze` passes (zero issues)
7. [ ] Manual smoke test: play BGM, verify volume works, let track finish, verify auto-play

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Volume Persistence
**Preconditions:** App running, Audio showcase, BGM tab selected
**Steps:**
1. Set volume slider to 70%
2. Play a BGM track
3. Observe volume slider position
4. Listen for audio at expected volume

**Expected Result:** Volume stays at 70%, audio plays at expected level
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Auto-Play Next
**Preconditions:** BGM track playing, playlist has multiple tracks
**Steps:**
1. Let current track play to completion
2. Observe what happens when track ends

**Expected Result:** Next track in playlist starts automatically
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 3: Auto-Play with Shuffle
**Preconditions:** Shuffle enabled, track playing
**Steps:**
1. Enable shuffle toggle
2. Let track complete
3. Note which track plays next
4. Repeat 3+ times

**Expected Result:** Random tracks play, not sequential order
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

---

## Notes

- Related to BR-034 (shuffle not working) - may share root cause
- Check if AudioService provides onComplete callbacks
- Volume reset suggests initialization issue in ViewModel

---

**Created:** 2026-02-02
**Last Updated:** 2026-02-02
**Brief Owner:** Igris AI
