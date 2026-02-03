# BR-066: Duration Stream Subscription

**Type:** Bug Fix
**Priority:** P2 - Medium
**Status:** Done
**Effort:** S - Small
**Module:** apps/fifty_demo + packages/fifty_audio_engine
**Created:** 2026-02-03

---

## Problem

When BGM tracks auto-switch via crossfade, the duration label in the UI doesn't update. It continues showing the previous track's duration.

### Root Cause

The ViewModel uses `getDuration()` (one-time call) instead of subscribing to `onDurationChanged` stream. When track changes, `_handleTrackAboutToChange()` callback doesn't fetch new duration.

### Current Flow

1. Track ends, crossfade triggers `onTrackAboutToChange` callback
2. Callback updates track index, resets position to zero
3. **Duration NOT updated** - still shows old track duration
4. User sees wrong duration until they manually interact

---

## Goal

Subscribe to `onDurationChanged` stream so duration updates automatically when tracks change.

---

## Context & Inputs

### Files to Modify

**Package (expose stream):**
- `packages/fifty_audio_engine/lib/engine/core/base_audio_channel.dart`
  - Add: `Stream<Duration> get onDurationChanged => _player.onDurationChanged;`

**App (subscribe):**
- `apps/fifty_demo/lib/features/audio_demo/controllers/audio_demo_view_model.dart`
  - Add: `StreamSubscription<Duration>? _durationSubscription;`
  - Subscribe in `_initializeAudioEngine()`
  - Cancel in `onClose()`
  - Remove one-time `_fetchDuration()` calls (optional, keep for initial load)

---

## Acceptance Criteria

1. [x] `BaseAudioChannel` exposes `onDurationChanged` stream
2. [x] ViewModel subscribes to duration stream
3. [x] Duration updates automatically on track change
4. [x] Subscription cancelled in `onClose()`
5. [x] No memory leaks

---

## Test Plan

### Manual Testing
1. Open audio demo, start BGM playback
2. Let track play until it auto-crossfades to next
3. Verify duration label updates to new track's duration
4. Skip to next track manually, verify duration updates
5. Skip to previous track, verify duration updates

---

## Delivery

- [ ] Stream exposed in base channel
- [ ] ViewModel subscribed to duration stream
- [ ] Tested auto-switch updates duration
- [ ] Brief status → Done

---
