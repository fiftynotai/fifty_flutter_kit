# BR-029: FiftyAudioEngine URL Source Support

**Type:** Bug Fix / Enhancement
**Priority:** P1-High
**Effort:** M-Medium (4-8h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Ready
**Created:** 2026-01-05
**Completed:** _(pending)_

---

## Problem

**What's broken or missing?**

`BgmChannel.play()` overrides `BaseAudioChannel.play()` and **hardcodes** `AssetSource`, ignoring the `changeSource()` configuration. This prevents URL-based BGM playback.

**Evidence:**

```dart
// packages/fifty_audio_engine/lib/engine/channels/bgm_channel.dart:190-194
@override
Future<void> play(String path) async {
  _positionSub?.cancel();
  await playFromSource(AssetSource(path)); // HARDCODED - ignores _sourceBuilder!
  _scheduleCrossfade();
}
```

**Additional Issue:**

When using `playFromSource()` directly (to bypass the hardcoded AssetSource), `onStateChanged()` crashes because `_currentPlaylist` is empty:

```dart
// Line 350 - crashes when playlist is empty
FiftyAudioLogger.log('[${_currentPlaylist[_index]}] Started');
```

**Why does it matter?**

1. Demo apps using network URLs cannot use FiftyAudioEngine
2. Games streaming BGM from CDNs cannot use the engine
3. Inconsistent API - `changeSource()` works for base class but not BGM

---

## Goal

**What should happen after this brief is completed?**

`BgmChannel` properly supports URL-based audio:
- `changeSource(UrlSource.new)` works correctly
- `play(url)` uses the configured source builder
- `playFromSource()` works without playlist requirement
- `onStateChanged()` handles empty playlist gracefully

---

## Context & Inputs

### Current Architecture

```
BaseAudioChannel
├── _sourceBuilder = AssetSource (default)
├── changeSource(builder) → updates _sourceBuilder
├── play(path) → resolveSource(path) → playFromSource() ✓ WORKS
└── playFromSource(source) → _player.play(source)

BgmChannel extends BaseAudioChannel
├── play(path) → playFromSource(AssetSource(path)) ✗ IGNORES _sourceBuilder!
├── _currentPlaylist: List<String> (required for logging)
└── onStateChanged() → _currentPlaylist[_index] (CRASHES if empty)
```

### Expected Architecture

```
BgmChannel extends BaseAudioChannel
├── play(path) → super.play(path) OR playFromSource(resolveSource(path)) ✓
├── _currentPlaylist: List<String> (optional)
└── onStateChanged() → guard against empty playlist ✓
```

### Files to Modify

| File | Change |
|------|--------|
| `packages/fifty_audio_engine/lib/engine/channels/bgm_channel.dart` | Fix `play()` to use source builder, guard `onStateChanged()` |

---

## Constraints

### Must Preserve
- Playlist functionality for asset-based apps
- Crossfade behavior
- Volume persistence
- All existing tests must pass

### Technical Requirements
- `play(path)` must respect `changeSource()` configuration
- `playFromSource()` must work without playlist
- Backward compatible with existing asset-based usage

---

## Tasks

### Pending
- [ ] Task 1: Update `BgmChannel.play()` to use `resolveSource(path)` instead of hardcoded `AssetSource`
- [ ] Task 2: Add guard in `onStateChanged()` for empty `_currentPlaylist`
- [ ] Task 3: Add unit tests for URL-based BGM playback
- [ ] Task 4: Test with demo app using URL sources
- [ ] Task 5: Run analyzer and ensure zero issues
- [ ] Task 6: Update demo app to use fixed engine

### In Progress
_(None)_

### Completed
_(None)_

---

## Acceptance Criteria

1. [ ] `BgmChannel.play()` uses `resolveSource(path)`
2. [ ] `changeSource(UrlSource.new)` works for BGM
3. [ ] `playFromSource(UrlSource(url))` works without crash
4. [ ] `onStateChanged()` handles empty playlist
5. [ ] Existing asset-based tests still pass
6. [ ] Demo app plays BGM from URLs without errors
7. [ ] `flutter analyze` passes

---

## Implementation Notes

### Option A: Use resolveSource (Preferred)

```dart
@override
Future<void> play(String path) async {
  _positionSub?.cancel();
  await playFromSource(resolveSource(path)); // Uses _sourceBuilder
  _scheduleCrossfade();
}
```

### Option B: Call super.play (May skip crossfade setup)

```dart
@override
Future<void> play(String path) async {
  _positionSub?.cancel();
  await super.play(path); // Delegates to BaseAudioChannel
  _scheduleCrossfade();
}
```

### Guard for onStateChanged

```dart
@override
void onStateChanged(PlayerState state) {
  if (_currentPlaylist.isEmpty) return; // Guard

  switch (state) {
    case PlayerState.playing:
      FiftyAudioLogger.log('[${_currentPlaylist[_index]}] Started');
      break;
    // ...
  }
}
```

---

## Test Plan

### Unit Tests
- [ ] BGM with AssetSource (existing behavior)
- [ ] BGM with UrlSource after changeSource()
- [ ] playFromSource() with empty playlist
- [ ] onStateChanged() with empty playlist

### Integration Tests
- [ ] Demo app plays BGM from URL
- [ ] Crossfade works with URL sources
- [ ] Volume/mute persistence works

---

## Workflow State

**Phase:** INIT
**Active Agent:** none
**Retry Count:** 0

### Agent Log
_(Timestamped subagent invocations)_

---

**Created:** 2026-01-05
**Last Updated:** 2026-01-05
**Brief Owner:** Igris AI
