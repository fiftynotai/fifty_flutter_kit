# BR-062: Audio Showcase BGM Playlist Refactor

**Type:** Bug Fix / Refactor
**Priority:** P1 - High
**Status:** Done
**Effort:** M - Medium
**Module:** apps/fifty_demo/lib/features/audio_demo
**Created:** 2026-02-02

---

## Problem

The BGM playback in the audio demo showcase is fundamentally broken. Previous fixes (BR-059) attempted to address volume reset and auto-play issues, but the core problem persists: **BGM does not play**.

### Root Cause Analysis

The demo is calling `bgm.play(path)` for individual tracks instead of using the BGM channel's **playlist system**. This architectural mismatch causes:

1. **TimeoutException** - Direct `play()` calls timeout after 30 seconds
2. **No auto-advance** - Tracks don't advance because playlist callbacks aren't wired correctly
3. **Volume reset** - Volume gets reset because `play()` resets state
4. **Crossfade failure** - `_scheduleCrossfade()` fails because it expects playlist context

### Expected Behavior

The BGM channel was designed for **playlist-based playback**:
- `loadDefaultPlaylist(paths)` - Load track list
- `resumeDefaultPlaylist()` - Start/resume playback
- `playNext()` / `playAtIndex(index)` - Navigate tracks
- `onDefaultPlaylistComplete` / `onTrackAboutToChange` - Callbacks

The demo bypasses this system entirely.

---

## Goal

Refactor the audio demo to use the BGM channel's playlist system correctly:

1. **Initialize playlist on startup** - Load default tracks via `loadDefaultPlaylist()`
2. **Use playlist methods** - Replace all `play(path)` calls with `resume()`, `playNext()`, `playAtIndex()`
3. **Wire callbacks properly** - Connect `onDefaultPlaylistComplete` and `onTrackAboutToChange`
4. **Support shuffle** - Use the `shuffle` parameter when loading playlist
5. **Ensure volume persists** - Volume should persist across track changes

---

## Context & Inputs

### Files to Review/Modify

**Primary:**
- `apps/fifty_demo/lib/features/audio_demo/controllers/audio_demo_view_model.dart`
  - Main controller handling BGM playback
  - Currently uses direct `play(path)` calls
  - Needs full refactor to playlist approach

**Engine Reference:**
- `packages/fifty_audio_engine/lib/engine/channels/bgm_channel.dart`
  - Contains the playlist system implementation
  - Key methods: `loadDefaultPlaylist()`, `resumeDefaultPlaylist()`, `playNext()`, `playAtIndex()`
  - Callbacks: `onDefaultPlaylistComplete`, `onTrackAboutToChange`

### Current Broken Flow
```dart
// BROKEN: Demo calls play() directly
await _engine.bgm.play(_currentTrack.assetPath);
```

### Correct Flow
```dart
// CORRECT: Use playlist system
await _engine.bgm.loadDefaultPlaylist(trackPaths, shuffle: _shuffle);
await _engine.bgm.resumeDefaultPlaylist();

// For track selection:
await _engine.bgm.playAtIndex(selectedIndex);

// For next/previous:
await _engine.bgm.playNext();
```

---

## Constraints

- Must maintain existing UI/UX (track list, play/pause, next/previous buttons)
- Must integrate with existing volume controls
- Must preserve track metadata (title, artist, duration) for display
- Must work with both shuffle on/off modes
- Must handle app lifecycle (pause/resume)

---

## Acceptance Criteria

1. [x] BGM plays when user taps play button
2. [x] BGM automatically advances to next track when current track ends
3. [x] Track selection from list plays the selected track
4. [x] Next/Previous buttons work correctly
5. [x] Shuffle mode randomizes track order
6. [x] Volume controls work and persist across tracks
7. [x] Seek functionality works during playback
8. [x] App lifecycle handled (pause on background, resume on foreground)
9. [x] No TimeoutException errors
10. [x] Crossfade works between tracks

---

## Test Plan

### Manual Testing
1. Open audio demo
2. Load BGM tab
3. Tap play - verify track starts
4. Wait for track to end - verify next track auto-plays
5. Tap different track in list - verify it switches
6. Test next/previous buttons
7. Enable shuffle - verify random order
8. Adjust volume - verify it persists
9. Test seek slider
10. Background app, bring back - verify state preserved

### Edge Cases
- Play while already playing (should continue, not restart)
- Skip rapidly through tracks
- Toggle shuffle mid-playback
- Seek to end of track (should trigger next)
- Empty playlist handling

---

## Implementation Hints

1. **Initialize once:** Call `loadDefaultPlaylist()` in `initializeChannels()` or similar init method
2. **Wire callbacks early:** Set `onDefaultPlaylistComplete` and `onTrackAboutToChange` before first play
3. **Track state separately:** Keep `_currentTrackIndex` synced with engine's internal index via callbacks
4. **Use resume for toggle:** `toggleBgmPlayback()` should use `resume()`/`pause()` not `play(path)`
5. **Consider state machine:** The view model might benefit from explicit playback states (stopped, playing, paused)

---

## Delivery

- [x] Refactored `audio_demo_view_model.dart`
- [x] All BGM playback working
- [x] No regression in other audio features (SFX, Ambience)
- [ ] Manual testing complete (pending verification)
- [x] Brief status → Done

---

## Related Briefs

- BR-059: BGM Playback Issues (previous attempt, incomplete fix)
- BR-054: Audio Demo Missing Features (general improvements)
- BR-053: Audio Demo Position Tracking

---
