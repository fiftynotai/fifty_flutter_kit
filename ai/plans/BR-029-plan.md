# Implementation Plan: BR-029 - Fix FiftyAudioEngine URL Source Support

**Created:** 2026-01-05
**Complexity:** S (Small)
**Estimated Duration:** 2-3 hours
**Risk Level:** Low

---

## Summary

Fix `BgmChannel.play()` to use `resolveSource(path)` instead of hardcoded `AssetSource`, and add guard in `onStateChanged()` to prevent crashes when `_currentPlaylist` is empty.

---

## Key Changes

### Change 1: BgmChannel.play() (Line 192)

**Before:**
```dart
await playFromSource(AssetSource(path));
```

**After:**
```dart
await playFromSource(resolveSource(path));
```

### Change 2: BgmChannel.onStateChanged() (Line 347)

**Before:**
```dart
@override
void onStateChanged(PlayerState state) {
  switch (state) {
```

**After:**
```dart
@override
void onStateChanged(PlayerState state) {
  if (_currentPlaylist.isEmpty) return;

  switch (state) {
```

---

## Files to Modify

| File | Change |
|------|--------|
| `packages/fifty_audio_engine/lib/engine/channels/bgm_channel.dart` | Fix play() + guard onStateChanged() |

---

## Rationale

- `resolveSource(path)` is inherited from `BaseAudioChannel` (line 102)
- Uses `_sourceBuilder` which defaults to `AssetSource` but respects `changeSource()`
- Matches pattern used in `SfxChannel.play()` (line 145)
- Backward compatible: default behavior unchanged

---

**Ready for implementation.**
