# BR-035: Voice Playback Behavior Review - Multiple Voices Playing

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

In the fifty_audio_engine example app, clicking a voice line always starts a new voice playback without stopping the currently playing voice. This results in multiple voice lines playing simultaneously or unexpected behavior.

**Expected behavior options:**
1. Clicking same voice → stop/toggle playback
2. Clicking different voice → stop current, play new one
3. Only one voice should play at a time

**Why does it matter?**

- Voice lines overlapping creates audio chaos
- Poor UX - user expects single voice playback
- Doesn't demonstrate proper voice channel management

---

## Goal

**What should happen after this brief is completed?**

Voice playback should be properly managed:
- Only one voice line plays at a time
- Clicking a playing voice should stop it (toggle behavior)
- Clicking a different voice should stop current and play new one

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_audio_engine/example`

### Layers Touched
- [ ] View (UI widgets)
- [x] Actions (UX orchestration)
- [x] ViewModel (business logic)
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
- Actions should manage voice state properly

### Technical Constraints
- Only one voice should play at a time
- Should stop current voice before playing new one

### Timeline
- **Deadline:** N/A
- **Milestones:** None

### Out of Scope
- Changes to fifty_audio_engine package itself
- BGM/SFX playback behavior

---

## Tasks

### Pending
- [ ] Task 1: Review current voice playback logic in VoiceActions
- [ ] Task 2: Implement stop-before-play behavior
- [ ] Task 3: Implement toggle behavior for same voice
- [ ] Task 4: Verify only one voice plays at a time

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Review voice_actions.dart onPlayVoice method
**Last Updated:** 2026-01-21
**Blockers:** None

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Only one voice line plays at a time
2. [ ] Clicking playing voice stops it (toggle)
3. [ ] Clicking different voice stops current and plays new
4. [ ] UI correctly reflects playing state
5. [ ] `flutter analyze` passes (zero issues)
6. [ ] Manual smoke test: rapid click different voices, only one plays

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Single Voice Playback
**Preconditions:** App running, Voice tab selected
**Steps:**
1. Click Voice Line 1
2. While playing, click Voice Line 2
3. Listen for audio

**Expected Result:** Voice 1 stops, Voice 2 plays (no overlap)
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Toggle Same Voice
**Preconditions:** Voice line playing
**Steps:**
1. Click the currently playing voice line
2. Listen for audio

**Expected Result:** Voice stops playing
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 3: Rapid Clicking
**Preconditions:** Voice tab selected
**Steps:**
1. Rapidly click different voice lines
2. Listen for audio

**Expected Result:** Only last clicked voice plays, no audio overlap
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

---

## Notes

Bug discovered during UI-006 FDL v2 redesign of fifty_audio_engine example.

Likely issue: VoiceActions.onPlayVoice doesn't check if a voice is already playing and doesn't stop it before starting new playback.

---

**Created:** 2026-01-21
**Last Updated:** 2026-01-21
**Brief Owner:** Igris AI
