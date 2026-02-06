# BR-072: Tactical Grid Audio Not Playing (BGM + SFX)

**Type:** Bug Fix
**Priority:** P1-High
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-05

---

## Problem

**What's broken or missing?**

No audio plays in the tactical_grid app -- neither BGM on battle entry nor SFX on unit select, move, attack, or turn end. All audio calls fail silently because every method in `BattleAudioCoordinator` wraps calls in try/catch with only `debugPrint` output.

**Root Cause:** Asset paths in `_BattleAudioAssets` include the `assets/` prefix (e.g. `'assets/audio/sfx/click.mp3'`), but the `audioplayers` `AssetSource` constructor **automatically prepends `assets/`**, resulting in the engine resolving `assets/assets/audio/sfx/click.mp3` which does not exist.

**Evidence:** The working fifty_demo app uses paths WITHOUT the `assets/` prefix (e.g. `'audio/bgm/clockwork_grove.mp3'`), confirming the convention.

**Why does it matter?**

Audio is a core pillar of the tactical grid game experience. Without BGM and SFX, the game feels lifeless and fails its goal as a showcase of the fifty_audio_engine package.

---

## Goal

**What should happen after this brief is completed?**

1. BGM plays immediately on entering the battle screen
2. SFX plays on unit select, move, attack, capture, and turn end
3. Mute toggle works correctly
4. No silent failures in debug console

---

## Context & Inputs

### Affected Modules
- [x] Other: `apps/tactical_grid/lib/features/battle/services/`

### Layers Touched
- [x] Service (data layer)

### API Changes
- [x] No API changes

### Dependencies
- [x] Existing service: `fifty_audio_engine` (BGM channel, SFX channel)
- [x] Existing package: `audioplayers` v6 (AssetSource auto-prepends `assets/`)

### Related Files
- `apps/tactical_grid/lib/features/battle/services/audio_coordinator.dart` (lines 25-51)

### Reference
- Working pattern: `apps/fifty_demo/lib/features/audio_demo/controllers/audio_demo_view_model.dart` (lines 14-17)

---

## Constraints

### Architecture Rules
- Only modify path string constants in `_BattleAudioAssets`
- No changes to audio coordinator methods or engine integration

### Out of Scope
- Audio engine internals
- New SFX or BGM assets
- Volume balancing

---

## Tasks

### Pending
- [ ] Strip `assets/` prefix from all 6 path constants in `_BattleAudioAssets`
- [ ] Verify BGM plays on battle entry (manual test)
- [ ] Verify all 5 SFX groups trigger correctly (manual test)
- [ ] Run `flutter analyze` and `flutter test`

---

## Acceptance Criteria

1. [ ] BGM track path: `'audio/bgm/battle_theme.mp3'` (no `assets/` prefix)
2. [ ] All 5 SFX paths use `'audio/sfx/...'` format (no `assets/` prefix)
3. [ ] BGM plays when entering battle screen
4. [ ] Select SFX plays when tapping a friendly unit
5. [ ] Move SFX plays when moving a unit
6. [ ] Attack SFX plays when attacking an enemy
7. [ ] Capture SFX plays when defeating an enemy
8. [ ] Turn end SFX plays when ending turn
9. [ ] `flutter analyze` passes (zero errors/warnings)
10. [ ] `flutter test` passes (55/55 tests green)

---

## Test Plan

### Manual Test Cases

#### Test Case 1: BGM on Battle Entry
**Steps:**
1. Launch app, navigate to battle screen
2. Listen for background music

**Expected Result:** Battle theme BGM plays immediately

#### Test Case 2: SFX on Unit Interactions
**Steps:**
1. Tap a friendly unit (select SFX)
2. Move the unit (move SFX)
3. Attack an adjacent enemy (attack SFX)
4. Defeat an enemy (capture SFX)
5. End turn (turn end SFX)

**Expected Result:** Each action produces its corresponding sound effect

---

## Delivery

### Code Changes
- [ ] Modified: `audio_coordinator.dart` (6 string constants)

---

## Notes

The fix is a 6-line string change. The bug was introduced during initial asset path definition when the `assets/` prefix was included, not realizing that `audioplayers` `AssetSource` auto-prepends it.

---

**Created:** 2026-02-05
**Last Updated:** 2026-02-05
**Brief Owner:** Igris AI
