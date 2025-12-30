# BR-016: Fifty Map Engine Package

**Type:** Feature
**Priority:** P1-High
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-12-30
**Completed:** 2025-12-30

---

## Problem

**What's broken or missing?**

The Fifty ecosystem lacks an interactive grid-based map engine for games. An existing implementation exists in `../erune_map_engine` (ARKADA Studio, v0.3.1) built on Flame engine, but needs to be rebranded and integrated into the Fifty ecosystem.

**Why does it matter?**

A map engine enables:
- Board games with grid-based layouts
- Strategy games with tile maps
- Dungeon crawlers and RPGs
- Interactive gestures (tap, pan, zoom)
- Dynamic entity spawning and movement

---

## Goal

**What should happen after this brief is completed?**

A new package `packages/fifty_map_engine` exists with:
- Full rebrand from erune_map_engine → fifty_map_engine
- Updated class names (FiftyMapEngine, FiftyMapController, etc.)
- FDL-aligned documentation
- All tests passing
- Ready for release as v0.1.0

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_map_engine` (new package)

### Layers Touched
- [x] Service (MapEngine, MapController, MapLoaderService)
- [x] Model (MapConfig, MapEntity, TileData)
- [x] View (GameMapWidget, MapBuilderGame)

### Dependencies
- [x] Existing package: `flame: ^1.30.1` (game engine)
- [x] Flutter SDK >=3.3.0, Dart ^3.6.0

### Related Files
Source: `../erune_map_engine/`
```
lib/
├── erune_map_engine.dart → fifty_map_engine.dart
├── core/
│   ├── map_config.dart
│   ├── map_controller.dart
│   ├── map_entity.dart
│   ├── map_entity_spawner.dart
│   ├── map_loader_service.dart
│   ├── asset_loader_service.dart
│   ├── game_map_widget.dart
│   └── map_builder_game.dart
```

---

## Constraints

### Architecture Rules
- Follow Fifty ecosystem naming conventions (FiftyXxx)
- Maintain Flame engine integration
- Include comprehensive documentation comments

### Technical Constraints
- Must support all platforms where Flame runs
- Zero analyzer warnings
- Flame ^1.30.1 compatibility

### Out of Scope
- New features beyond rebrand
- Example app (separate brief BR-017)

---

## Tasks

### Pending
- [ ] Task 1: Copy erune_map_engine to packages/fifty_map_engine
- [ ] Task 2: Update pubspec.yaml (name, description, homepage)
- [ ] Task 3: Rename all Dart files (erune → fifty)
- [ ] Task 4: Update all class names (FiftyMapEngine, FiftyMapController, etc.)
- [ ] Task 5: Update all internal imports
- [ ] Task 6: Write comprehensive README (FDL-aligned)
- [ ] Task 7: Write CHANGELOG.md
- [ ] Task 8: Run flutter analyze (zero warnings)
- [ ] Task 9: Run flutter test (all pass)

### In Progress
_(None)_

### Completed
_(None)_

---

## Session State (Tactical - This Brief)

**Current State:** Brief registered, awaiting implementation
**Next Steps When Resuming:** Start with Task 1 - copy package
**Last Updated:** 2025-12-30
**Blockers:** None

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Package exists at `packages/fifty_map_engine`
2. [ ] All files renamed from erune → fifty
3. [ ] Class names follow FiftyXxx pattern
4. [ ] Flame integration working
5. [ ] README.md comprehensive with API reference
6. [ ] CHANGELOG.md documents v0.1.0
7. [ ] `flutter analyze` passes (zero issues)
8. [ ] `flutter test` passes (all tests green)

---

## Test Plan

### Automated Tests
- [ ] Unit test: MapConfig tile calculations
- [ ] Unit test: MapController entity management
- [ ] Unit test: MapLoaderService JSON parsing

---

## Delivery

### Code Changes
- [x] New files created: `packages/fifty_map_engine/*`

### Documentation Updates
- [x] README: Full API reference with Flame integration
- [x] CHANGELOG: v0.1.0 initial release

---

## Workflow State

**Phase:** COMPLETE
**Active Agent:** none
**Retry Count:** 0

### Agent Log
- [2025-12-30 PLANNING] planner: Created implementation plan (L complexity, 5 phases, ~45 files)
- [2025-12-30 APPROVAL] Monarch approved plan
- [2025-12-30 BUILDING] coder: Implementation complete (43 files, 31 tests)
- [2025-12-30 TESTING] tester: PASS (31/31 tests, zero lint issues, no legacy refs)
- [2025-12-30 REVIEWING] reviewer: APPROVE (4.5/5, 4 minor suggestions, ready for release)
- [2025-12-30 COMMITTING] Committed b251c4f (48 files, 4424 insertions)

---

**Created:** 2025-12-30
**Last Updated:** 2025-12-30
**Brief Owner:** Igris AI
