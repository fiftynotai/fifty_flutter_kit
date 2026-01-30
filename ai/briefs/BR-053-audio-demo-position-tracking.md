# BR-053: Audio Demo Position Tracking & Playback Fixes

**Type:** Bug Fix
**Priority:** P1-High
**Effort:** M-Medium (4-8 hours)
**Status:** Done
**Created:** 2026-01-30
**Tags:** audio, fifty_demo, bug-fix

---

## Problem

The Audio Demo page has several non-functional features:

1. **Position counter frozen** - Always displays `00:00 / 00:10` regardless of playback
2. **Progress slider frozen** - Never moves during playback (always at 0%)
3. **Seek not working** - Dragging the slider has no effect
4. **Voice uses wrong channel** - Voice lines play through SFX channel, not Voice channel
5. **Voice playback simulated** - Uses `Future.delayed(2s)` instead of actual completion events

## Goal

Make the BGM position counter, progress slider, and seek functionality work correctly. Fix the voice channel to use the actual voice player and respond to real completion events.

## Context & Inputs

### Files to Modify

| File | Changes |
|------|---------|
| `audio_demo_view_model.dart` | Add position stream subscription, implement seek, fix voice channel |
| `audio_demo_actions.dart` | May need async adjustments for seek |

### Engine APIs Available

From `BaseAudioChannel`:
```dart
Stream<Duration> get onPositionChanged => _player.onPositionChanged;
Future<Duration?> getDuration() => _player.getDuration();
```

From `BgmChannel`:
- `onPositionChanged` - stream of current position
- `getDuration()` - returns track duration

From `VoiceActingChannel`:
- `playVoice(path)` - plays voice with ducking
- `onCompleted` - callback when voice finishes

### Reference Implementation

See `packages/fifty_audio_engine/example/lib/services/audio_service.dart`:
- Lines 64-81: Position tracking with stream subscription
- Lines 209-213: Subscribing to `onPositionChanged`

## Constraints

- Must use existing FiftyAudioEngine APIs (no modifications to engine package)
- Must clean up stream subscriptions on dispose
- Must handle case where duration is null (track not loaded)
- Voice channel uses `UrlSource` by default - may need to call `changeSource(AssetSource.new)` for asset playback

## Acceptance Criteria

### Position Counter
- [ ] Position label updates during BGM playback (e.g., `01:23`)
- [ ] Duration label shows actual track duration (e.g., `03:45`)
- [ ] Position resets to `00:00` when track stops

### Progress Slider
- [ ] Slider thumb moves during playback
- [ ] Progress value accurately reflects position/duration ratio
- [ ] Slider updates smoothly (no jitter)

### Seek Functionality
- [ ] Dragging slider seeks to new position
- [ ] Position counter updates after seek
- [ ] Playback continues from new position

### Voice Channel
- [ ] Voice lines play through `_engine.voice` channel, not SFX
- [ ] Voice playback state updates from actual player events
- [ ] `voicePlaying` becomes false when voice actually completes

## Test Plan

### Manual Testing
1. Start BGM playback → position counter should increment
2. Let BGM play for 30 seconds → progress slider should move ~10%
3. Drag slider to middle → playback should jump to that position
4. Play a voice line → should hear audio through voice channel
5. Wait for voice to finish → `voicePlaying` should become false automatically

### Automated Testing
- Unit test: Position formatting helper (`_formatDuration`)
- Unit test: Progress calculation (`position.inMs / duration.inMs`)

## Delivery

- [ ] Update `audio_demo_view_model.dart` with position tracking
- [ ] Update session file after completion
- [ ] Commit with message: `fix(fifty_demo): implement BGM position tracking and seek in audio demo`

## Workflow State

- **Phase:** COMPLETE
- **Active Agent:** none
- **Retry Count:** 0
- **Agent Log:**
  - `2026-01-30 INIT` - Brief loaded, status updated to In Progress
  - `2026-01-30 PLANNING` - Planner completed. Plan created with 7 phases. Blocker: seek() method not in engine (workaround provided)
  - `2026-01-30 BUILDING` - Coder completed. 2 files modified. Position tracking, voice channel, cleanup implemented.
  - `2026-01-30 TESTING` - PASS. Zero analyzer errors. Web build successful.
  - `2026-01-30 REVIEWING` - APPROVE. Code quality verified, architecture compliant.
  - `2026-01-30 COMMITTING` - Commit abcb442 created successfully.
  - `2026-01-30 COMPLETE` - Brief completed.

## Tasks

- [ ] Add StreamSubscription for position tracking
- [ ] Implement `bgmProgress` getter with actual calculation
- [ ] Implement `bgmPositionLabel` with formatted time
- [ ] Implement `bgmDurationLabel` with actual duration
- [ ] Implement `seekBgm()` with actual seek call
- [ ] Fix voice channel to use `_engine.voice`
- [ ] Listen to voice completion events
- [ ] Clean up subscriptions in `onClose()`
- [ ] Test all functionality

## Next Steps

Ready for implementation via HUNT protocol.
