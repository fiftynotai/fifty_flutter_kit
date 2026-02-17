# BR-081: centerMap() Crashes in Debug Mode When Camera Already Centered

## Metadata
- **Type:** Bug Fix
- **Priority:** P2-Medium
- **Effort:** S-Small (< 4h)
- **Status:** Done
- **Created:** 2026-02-16
- **Related:** BR-078 (example app), BR-077 (engine v2)

---

## Problem

**What's broken?**

`FiftyMapBuilder.centerMap()` crashes with an assertion error in debug mode when the camera is already at the center position (distance = 0):

```
Unhandled Exception: 'package:flame/src/effects/controllers/effect_controller.dart':
Failed assertion: line 115 pos 7: '(speed ?? 1) > 0': Speed must be positive: 0.0
```

**Stack trace:**
```
CameraComponent.moveTo (package:flame/src/camera/camera_component.dart:379:27)
FiftyMapBuilder.centerMap (package:fifty_map_engine/src/view/map_builder.dart:475:21)
FiftyMapController.centerMap (package:fifty_map_engine/src/controller/controller.dart:236:10)
_TacticalSkirmishPageState._setupDecorators (main.dart:320:17)
```

**Root cause:** Line 472 of `map_builder.dart`:
```dart
final speed = distance / duration.inSeconds;
```
When the camera viewfinder is already at the computed center point, `distance` is 0, making `speed` = 0.0. Flame's `EffectController` asserts `speed > 0`.

**Why does it matter?**

- Crashes the app in debug mode on startup (when camera starts at origin and entities are centered near origin)
- Only manifests in debug mode (release strips assertions), so it's silent in production but breaks development workflow
- Affects `centerMap()` and likely `centerOnEntity()` which has the same pattern

---

## Goal

`centerMap()` and `centerOnEntity()` should gracefully handle the case where the camera is already at the target position, with no crash in either debug or release mode.

---

## Context & Inputs

### Affected Files
- `packages/fifty_map_engine/lib/src/view/map_builder.dart` (lines 457-476, 479-493)

### Layers Touched
- Engine internals only (no UI/example changes needed)

---

## Scope

### Fix
Add a guard in `centerMap()` and `centerOnEntity()` to early-return when distance is 0 (or near-zero):

```dart
void centerMap({Duration duration = const Duration(seconds: 1)}) {
  if (_componentsRegistry.isEmpty) return;
  // ... compute center ...
  final distance = currentPos.distanceTo(center);
  if (distance < 0.01) return; // Already centered
  final speed = distance / duration.inSeconds;
  cameraComponent.moveTo(center, speed: speed);
}
```

Apply the same guard to `centerOnEntity()`.

### Secondary concern
Both methods use `duration.inSeconds` (integer). Sub-second durations would also produce `speed = distance / 0 = Infinity`. Consider using `duration.inMilliseconds / 1000.0` for safety. This is already noted in the code comments but not fixed.

---

## Acceptance Criteria

1. [ ] `centerMap()` does not crash when camera is already at center (distance = 0)
2. [ ] `centerOnEntity()` does not crash when camera is already on the entity
3. [ ] No regression in normal centering behavior (camera still moves when not at center)
4. [ ] Debug mode `flutter run` of example app launches without assertion error
5. [ ] 122+ tests still passing
6. [ ] `flutter analyze` clean

---

## Test Plan

### Automated Tests
- [ ] Unit test: `centerMap()` with camera already at entity center (distance = 0)
- [ ] Unit test: `centerOnEntity()` with camera on entity position

### Manual Test
1. Run `flutter run` (debug mode) on example app
2. App should launch without assertion crash
3. Grid and units should render correctly with camera centered

---

## Notes

- Only manifests in debug mode (assertions stripped in release)
- Discovered during BR-080 `flutter run` debug session
- The release build (installed via `flutter build ios --simulator`) works fine
