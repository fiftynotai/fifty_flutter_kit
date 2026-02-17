# BR-094: Remove Direct audioplayers Dependency from tactical_grid

**Type:** Refactor
**Priority:** P3-Low
**Effort:** S-Small (< 2 hours)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-17

---

## Problem

**What's wrong?**

`apps/tactical_grid/pubspec.yaml` lists `audioplayers: ^6.0.0` as a direct dependency, but the app should only rely on `fifty_audio_engine` for all audio functionality. The `fifty_audio_engine` package already depends on `audioplayers: ^6.4.0` internally — `tactical_grid` should never import `audioplayers` directly.

**Why does it matter?**

- Violates the ecosystem layering rule: apps consume engine packages, not their transitive dependencies
- Version drift risk: tactical_grid pins `^6.0.0` while fifty_audio_engine pins `^6.4.0`
- Leaky abstraction: if fifty_audio_engine ever migrated away from audioplayers (e.g. to just_audio), tactical_grid would also need manual changes

---

## Goal

**What should happen after this brief is completed?**

1. `tactical_grid` has zero direct imports of `package:audioplayers`
2. `tactical_grid/pubspec.yaml` does not list `audioplayers` as a dependency
3. `fifty_audio_engine` properly re-exports the `AssetSource` type (or eliminates the need for consumers to reference it)

---

## Context & Inputs

### Investigation Results

**2 files** in `tactical_grid/lib/` directly import `audioplayers`:

| File | Import Line | Usage |
|------|------------|-------|
| `lib/main.dart:7` | `import 'package:audioplayers/audioplayers.dart'` | `AssetSource.new` passed to `changeSource()` — 3 calls (bgm, sfx, voice) |
| `lib/features/battle/services/audio_coordinator.dart:18` | `import 'package:audioplayers/audioplayers.dart'` | `AssetSource.new` passed to `changeSource()` — 1 call (voice) |

The only type used is **`AssetSource`** (specifically its constructor tear-off `AssetSource.new`).

**`fifty_audio_engine`** already depends on `audioplayers: ^6.4.0` and uses `AssetSource` internally in `base_audio_channel.dart`, but does NOT re-export it in its barrel file.

**No test files** in `tactical_grid/test/` reference audioplayers.

### Affected Files

| File | Change |
|------|--------|
| `packages/fifty_audio_engine/lib/fifty_audio_engine.dart` | Add re-export: `export 'package:audioplayers/audioplayers.dart' show AssetSource, Source;` |
| `apps/tactical_grid/pubspec.yaml` | Remove `audioplayers: ^6.0.0` |
| `apps/tactical_grid/lib/main.dart` | Remove `import 'package:audioplayers/audioplayers.dart';` |
| `apps/tactical_grid/lib/features/battle/services/audio_coordinator.dart` | Remove `import 'package:audioplayers/audioplayers.dart';` |

---

## Constraints

- `AssetSource` must remain accessible to consumers via `fifty_audio_engine` import
- No behavioral changes — audio must work identically
- All existing tests must pass
- Other apps in the ecosystem that may also directly depend on `audioplayers` should be checked (but out of scope for this brief — can be a follow-up)

---

## Tasks

### Pending
- [ ] Task 1: Add `AssetSource` re-export to `fifty_audio_engine` barrel file
- [ ] Task 2: Remove `audioplayers` import from `tactical_grid/lib/main.dart`
- [ ] Task 3: Remove `audioplayers` import from `tactical_grid/lib/features/battle/services/audio_coordinator.dart`
- [ ] Task 4: Remove `audioplayers: ^6.0.0` from `tactical_grid/pubspec.yaml`
- [ ] Task 5: Run `flutter pub get` in tactical_grid
- [ ] Task 6: Run analyzer — 0 errors
- [ ] Task 7: Run tactical_grid tests — all passing
- [ ] Task 8: Smoke test on iOS simulator — verify audio plays correctly

### In Progress

### Completed

---

## Acceptance Criteria

1. [ ] Zero direct `audioplayers` imports in `apps/tactical_grid/lib/`
2. [ ] `audioplayers` not listed in `apps/tactical_grid/pubspec.yaml` dependencies
3. [ ] `AssetSource` accessible via `import 'package:fifty_audio_engine/fifty_audio_engine.dart'`
4. [ ] Audio works identically (BGM, SFX, voice all play correctly)
5. [ ] All tests passing
6. [ ] Analyzer clean (0 errors)

---

## Test Plan

### Automated Tests
- [ ] Run `flutter test` in `apps/tactical_grid/` — all passing
- [ ] Run `flutter analyze` in `apps/tactical_grid/` — 0 issues

### Manual Test Cases

#### Test Case 1: Audio Still Works
1. Launch tactical_grid on iOS simulator
2. Verify menu BGM plays on menu screen
3. Start a VS AI game
4. Verify battle BGM, SFX (footsteps, sword, etc.), voice announcements all play
5. End game — verify victory/defeat audio plays

---

## Delivery

### Code Changes
- [ ] Modified: `packages/fifty_audio_engine/lib/fifty_audio_engine.dart` (add re-export)
- [ ] Modified: `apps/tactical_grid/pubspec.yaml` (remove audioplayers)
- [ ] Modified: `apps/tactical_grid/lib/main.dart` (remove import)
- [ ] Modified: `apps/tactical_grid/lib/features/battle/services/audio_coordinator.dart` (remove import)

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** Igris AI
