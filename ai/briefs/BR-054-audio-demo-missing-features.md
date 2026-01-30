# BR-054: Audio Demo Missing Features

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M
**Status:** Done
**Created:** 2026-01-30

---

## Summary

Add missing audio engine features to the Audio Demo page that are supported by the engine but not exposed in the UI.

---

## Background

After completing position tracking (BR-053) and voice channel fixes, an analysis revealed several engine capabilities that aren't exposed in the demo UI. These features would make the demo more comprehensive and showcase the full power of FiftyAudioEngine.

---

## Requirements

### Quick Wins (XS-S)

1. **Fix voice stop button** - Currently only updates state, doesn't call `_engine.voice.stop()`
   - File: `audio_demo_view_model.dart:427-430`

2. **Skip/Previous track buttons** - Add UI for `playNext()` and previous track
   - Engine has: `BgmChannel.playNext()`, `BgmChannel.playAtIndex()`

3. **Voice ducking toggle** - Show toggle for ducking BGM during voice playback
   - Engine has: `VoiceActingChannel.withDucking` flag

4. **Loop mode indicator** - Show that BGM is in loop mode
   - Engine uses: `ReleaseMode.loop`

### Medium Effort (S-M)

5. **Shuffle toggle** - Add button to toggle shuffle on/off with visual indicator
   - Engine shuffles playlist in `loadDefaultPlaylist()`

6. **Fade demo section** - Show fade presets (fast, normal, slow, dramatic)
   - Engine has: `FadePreset`, `withFade()`, `fadeIn()`, `fadeOut()`

### Engine Enhancement Required (Deferred)

7. **Seek/scrub support** - Requires adding `seek(Duration)` to `BaseAudioChannel`
   - Current workaround: restart only (< 10% position)

---

## Acceptance Criteria

- [ ] Voice stop button actually stops engine playback
- [ ] Skip forward button advances to next track
- [ ] Previous/restart button goes to previous or restarts current track
- [ ] Voice ducking toggle shows and controls `withDucking` flag
- [ ] Loop mode indicator shows BGM is looping
- [ ] Shuffle toggle works and persists state
- [ ] Fade demo section with 4 preset buttons

---

## Technical Notes

### Files to Modify

1. `audio_demo_view_model.dart`
   - Fix `stopVoice()` to call `_engine.voice.stop()`
   - Add `toggleShuffle()`, `skipNext()`, `skipPrevious()` methods
   - Add `toggleVoiceDucking()` method
   - Add fade demo methods

2. `audio_demo_actions.dart`
   - Add action wrappers for new methods

3. `audio_demo_page.dart`
   - Add skip/previous buttons to BGM controls
   - Add ducking toggle to voice section
   - Add shuffle toggle with indicator
   - Add fade demo section

### Engine API Reference

```dart
// BGM
_engine.bgm.playNext()
_engine.bgm.playAtIndex(int index)

// Voice
_engine.voice.withDucking = true/false
_engine.voice.stop()

// Fades
_engine.bgm.fadeIn()
_engine.bgm.fadeOut()
_engine.bgm.fadeTo(double volume)
_engine.bgm.withFade(() async { ... })
```

---

## Out of Scope

- Seek/scrub functionality (requires engine enhancement)
- Custom playlist UI (would need significant UI work)
- Crossfade configuration (internal to engine)

---

## References

- BR-052: Audio Demo Refactoring (completed)
- BR-053: Audio Demo Position Tracking (completed)
- Engine: `packages/fifty_audio_engine/`
