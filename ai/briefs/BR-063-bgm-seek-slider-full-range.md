# BR-063: BGM Seek Slider Full Range Support

**Type:** Feature Enhancement
**Priority:** P2 - Medium
**Status:** Done
**Effort:** S - Small
**Module:** apps/fifty_demo/lib/features/audio_demo
**Created:** 2026-02-03

---

## Problem

The BGM seek slider in the audio demo only works when dragged to the very beginning (< 10% position). Seeking to any other position in the track does not work.

### Current Behavior

- Drag slider to start (< 10%) → Track restarts ✓
- Drag slider to middle → Nothing happens ✗
- Drag slider forward → Nothing happens ✗

### Root Cause

The `seekBgm()` method only handles the restart case:

```dart
Future<void> seekBgm(double progress) async {
  // Only support restart for now (engine doesn't expose seek)
  if (progress < 0.1) {
    // ... restart logic
  }
  // No else case - other positions ignored!
}
```

---

## Goal

Enable full seek functionality for BGM playback:

1. Seek to any position in the track (0% - 100%)
2. Works in both directions (forward and backward)
3. Smooth position update in UI after seek

---

## Context & Inputs

### Files to Modify

**Primary:**
- `apps/fifty_demo/lib/features/audio_demo/controllers/audio_demo_view_model.dart`
  - `seekBgm(double progress)` method needs full implementation

**Engine Reference:**
- `packages/fifty_audio_engine/lib/engine/core/base_audio_channel.dart`
  - Check if `seek()` is exposed or needs to be added

### audioplayers API

The underlying `AudioPlayer` from audioplayers supports seeking:

```dart
await player.seek(Duration(seconds: 30));
```

This may need to be exposed in `BaseAudioChannel` if not already available.

---

## Constraints

- Must not break existing restart functionality
- Should handle edge cases (seeking past end, seeking while paused)
- Position display should update after seek

---

## Acceptance Criteria

1. [ ] Dragging slider to any position seeks to that position
2. [ ] Seeking forward works
3. [ ] Seeking backward works
4. [ ] Position label updates after seek
5. [ ] Works while playing
6. [ ] Works while paused (then resumes from new position)

---

## Test Plan

### Manual Testing
1. Play a BGM track
2. Drag slider to 50% → verify track jumps to middle
3. Drag slider to 25% → verify track jumps backward
4. Drag slider to 75% → verify track jumps forward
5. Pause track, seek, resume → verify position maintained

---

## Implementation Hints

1. Add `seek(Duration position)` to `BaseAudioChannel` if not present
2. Calculate target position: `Duration(milliseconds: (progress * duration.inMilliseconds).toInt())`
3. Call `_engine.bgm.seek(targetPosition)`
4. Update `_bgmPosition` for immediate UI feedback

---

## Delivery

- [ ] Seek method added to engine (if needed)
- [ ] `seekBgm()` handles full range
- [ ] Manual testing complete
- [ ] Brief status → Done

---
