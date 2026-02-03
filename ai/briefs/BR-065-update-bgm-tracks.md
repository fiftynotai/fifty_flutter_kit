# BR-065: Update BGM Tracks and Playlist

**Type:** Feature / Asset Update
**Priority:** P1 - High
**Status:** Ready
**Effort:** S - Small
**Module:** apps/fifty_demo
**Created:** 2026-02-03

---

## Problem

The old BGM tracks (exploration.mp3, combat.mp3, peaceful.mp3) were too short and have been removed. Four new tracks have been added but need proper naming and integration.

### Current State

New files in `assets/audio/bgm/`:
```
Clockwork Grove (1).mp3
Clockwork Grove.mp3
Path of the First Light (1).mp3
Path of the First Light.mp3
```

Issues:
- Filenames have spaces and parentheses (not ideal for assets)
- `AudioTrack` enum still references old files
- Playlist references old paths

---

## Goal

1. **Rename files** to clean snake_case format
2. **Update `AudioTrack` enum** with new track metadata
3. **Update any hardcoded references** to old tracks

---

## Context & Inputs

### Files to Modify

**Assets (rename):**
- `Clockwork Grove.mp3` → `clockwork_grove.mp3`
- `Clockwork Grove (1).mp3` → `clockwork_grove_alt.mp3` (or similar)
- `Path of the First Light.mp3` → `path_of_the_first_light.mp3`
- `Path of the First Light (1).mp3` → `path_of_the_first_light_alt.mp3` (or similar)

**Code:**
- `apps/fifty_demo/lib/features/audio_demo/controllers/audio_demo_view_model.dart`
  - Update `AudioTrack` enum with new tracks

### Current AudioTrack Enum (to replace)

```dart
enum AudioTrack {
  exploration('Exploration', 'audio/bgm/exploration.mp3'),
  combat('Combat', 'audio/bgm/combat.mp3'),
  peaceful('Peaceful', 'audio/bgm/peaceful.mp3');
  // ...
}
```

### New AudioTrack Enum (target)

```dart
enum AudioTrack {
  clockworkGrove('Clockwork Grove', 'audio/bgm/clockwork_grove.mp3'),
  clockworkGroveAlt('Clockwork Grove II', 'audio/bgm/clockwork_grove_alt.mp3'),
  pathOfFirstLight('Path of the First Light', 'audio/bgm/path_of_the_first_light.mp3'),
  pathOfFirstLightAlt('Path of the First Light II', 'audio/bgm/path_of_the_first_light_alt.mp3');
  // ...
}
```

---

## Constraints

- Filenames must be snake_case (no spaces, no parentheses)
- Must update pubspec.yaml if asset paths change (folder already registered)
- Display names should be human-readable

---

## Acceptance Criteria

1. [ ] All 4 BGM files renamed to clean snake_case
2. [ ] `AudioTrack` enum updated with 4 new tracks
3. [ ] Display names are readable (e.g., "Clockwork Grove")
4. [ ] Asset paths correct in enum
5. [ ] BGM playback works with new tracks
6. [ ] No references to old tracks remain

---

## Test Plan

### Manual Testing
1. Open audio demo
2. Verify 4 tracks appear in BGM section
3. Play each track → verify audio plays
4. Skip between tracks → verify all work
5. No errors in console about missing assets

---

## Delivery

- [ ] Files renamed in `assets/audio/bgm/`
- [ ] `AudioTrack` enum updated
- [ ] Tested all 4 tracks play correctly
- [ ] Brief status → Done

---
