# BR-064: BGM Playlist UI Redesign

**Type:** Feature / UI Enhancement
**Priority:** P2 - Medium
**Status:** Ready
**Effort:** M - Medium
**Module:** apps/fifty_demo/lib/features/audio_demo
**Created:** 2026-02-03

---

## Problem

The current BGM section in the audio demo uses a tab-based design which doesn't match the natural mental model for music playback. Users expect a playlist-style interface similar to music apps.

### Current Design

- Tab bar with track names as tabs
- Selected tab = current track
- Playback controls below tabs
- Not intuitive for music browsing

### Desired Design

- Scrollable playlist/list view of tracks
- Currently playing track highlighted
- Track metadata visible (title, duration)
- Playback controls at bottom (mini-player style)
- Album art or track icon (optional)

---

## Goal

Redesign the BGM section to use a playlist-style UI:

1. Replace tab bar with vertical track list
2. Show track metadata (title, artist/source, duration)
3. Highlight currently playing track
4. Keep playback controls accessible (bottom bar or inline)
5. Support track selection by tapping list item

---

## Context & Inputs

### Files to Modify

**Primary:**
- `apps/fifty_demo/lib/features/audio_demo/views/audio_demo_page.dart`
  - BGM section widget needs redesign

**May need new widgets:**
- `track_list_tile.dart` - Individual track row
- `now_playing_bar.dart` - Bottom playback controls
- `playlist_view.dart` - Container for track list

### Design References

Consider patterns from:
- Spotify (playlist view with mini-player)
- Apple Music (list with now playing indicator)
- YouTube Music (queue view)

### FDL Components Available

- `FiftyCard` - For track tiles
- `FiftyListTile` - Base for track rows
- `FiftyButton` - Playback controls
- `FiftyColors` - For highlighting current track

---

## Constraints

- Must use FDL components (fifty_ui)
- Must work with existing ViewModel (no business logic changes)
- Should be responsive (work on various screen sizes)
- Maintain existing functionality (play, pause, skip, volume)

---

## Acceptance Criteria

1. [ ] Track list displayed vertically (scrollable)
2. [ ] Each track shows: title, duration
3. [ ] Currently playing track visually highlighted
4. [ ] Tapping track plays it
5. [ ] Playback controls accessible (play/pause, skip, progress)
6. [ ] Volume control accessible
7. [ ] Shuffle toggle visible
8. [ ] Progress bar/slider functional
9. [ ] Matches FDL aesthetic (kinetic brutalism)

---

## Test Plan

### Manual Testing
1. Open audio demo → BGM section
2. Verify track list is visible
3. Tap a track → verify it plays
4. Verify current track is highlighted
5. Use playback controls → verify functionality
6. Scroll list if many tracks
7. Test on different screen sizes

### Visual Review
- Matches FDL design language
- Proper spacing and typography
- Accessible touch targets

---

## Design Mockup (Text)

```
┌─────────────────────────────────────┐
│  BGM PLAYLIST                       │
├─────────────────────────────────────┤
│ ▶ Exploration          ●  03:45     │  ← Currently playing (highlighted)
│   Combat                   02:30     │
│   Peaceful                 04:15     │
├─────────────────────────────────────┤
│   advancement          03:45 / 03:45 │  ← Progress bar
│  ◀◀  ▶/❚❚  ▶▶    🔀    🔊 ━━━━━    │  ← Controls
└─────────────────────────────────────┘
```

---

## Delivery

- [ ] Track list view implemented
- [ ] Now playing indicator
- [ ] Playback controls bar
- [ ] All existing functionality preserved
- [ ] FDL compliant styling
- [ ] Manual testing complete
- [ ] Brief status → Done

---
