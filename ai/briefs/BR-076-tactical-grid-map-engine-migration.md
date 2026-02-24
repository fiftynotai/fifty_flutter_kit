# BR-076: Migrate Tactical Grid to fifty_map_engine

**Type:** Refactor
**Priority:** P1-High
**Effort:** M-Medium (2-3d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Ready
**Created:** 2026-02-10
**Completed:**

---

## Problem

**What's broken or missing?**

The Tactical Grid app was built to demonstrate `fifty_map_engine` in action, but the current implementation bypasses it entirely. The board is rendered using a plain Flutter `GridView.builder` with a custom `GridPosition(x, y)` coordinate system, manual overlay stacking for animations, and no camera controls. The `fifty_map_engine` dependency is listed in `pubspec.yaml` but never imported.

A comment in `board_widget.dart` even acknowledges this: *"This is a simple Flutter grid implementation for the MVP. It can be swapped to use fifty_map_engine in a later iteration."*

That iteration is now.

**Why does it matter?**

- The entire purpose of the Tactical Grid app is to showcase `fifty_map_engine` capabilities
- Currently it demonstrates nothing about the engine - it's just vanilla Flutter widgets
- Without a real demo app, the map engine has no flagship example for developers to reference
- The GridView approach lacks camera controls (pan/zoom), efficient tile rendering, and Flame's optimized game loop

---

## Goal

**What should happen after this brief is completed?**

The Tactical Grid game board should be fully rendered through `fifty_map_engine`, using its tile system, entity management, camera controls, and animation capabilities. The game logic (turns, abilities, AI, timer) remains unchanged - only the rendering and input layer migrates.

---

## Context & Inputs

### Affected Modules
- [x] Other: `apps/tactical_grid/` - battle feature (board rendering, unit rendering, animations)

### Layers Touched
- [x] View (UI widgets) - BoardWidget, UnitSpriteWidget, AnimatedBoardOverlay replaced
- [ ] Actions (UX orchestration) - minimal changes
- [x] ViewModel (business logic) - adapter layer for map engine integration
- [ ] Service (data layer) - no changes
- [x] Model (domain objects) - GridPosition adapter to Vector2, map JSON definitions

### API Changes
- [x] No API changes

### Dependencies
- [x] Existing package: `fifty_map_engine` (already in pubspec.yaml, currently unused)

### Related Files

**Files to replace/refactor:**
- `lib/features/battle/views/widgets/board_widget.dart` - GridView.builder implementation
- `lib/features/battle/views/widgets/unit_sprite_widget.dart` - manual sprite rendering
- `lib/features/battle/views/widgets/animated_board_overlay.dart` - manual animation overlay
- `lib/features/battle/models/position.dart` - GridPosition coordinate system

**Files to create:**
- `assets/maps/battle_board.json` - map definition for fifty_map_engine
- Adapter/bridge layer between game logic and map engine

**Files unchanged (game logic preserved):**
- `lib/features/battle/models/unit.dart`
- `lib/features/battle/models/board_state.dart`
- `lib/features/battle/controllers/battle_view_model.dart` (core logic)
- `lib/features/battle/data/services/ai_service.dart`
- `lib/features/battle/data/services/turn_timer_service.dart`
- `lib/features/battle/data/services/animation_service.dart` (may need adapter)
- `lib/features/battle/data/services/audio/` (all audio untouched)

---

## Constraints

### Architecture Rules
- Game logic layer (ViewModel, Services, Models) must remain decoupled from rendering
- Use an adapter/bridge pattern to connect existing game state to map engine rendering
- All 278 existing tests must continue to pass (game logic unchanged)
- FDL compliance: map engine already consumes FDL tokens

### Technical Constraints
- Must preserve all existing gameplay: unit movement, attacks, abilities, AI turns, timer, animations, audio
- Camera controls (pan/zoom) should be added but optional (can be disabled for fixed 8x8)
- Tile textures (`assets/images/board/`) must be loaded through map engine's asset system
- Unit sprites (`assets/images/units/`) must be rendered as map entities
- Turn-based input blocking must work with Flame's tap handling
- Animation system (move, attack, damage popup, defeat) must use Flame effects or bridge to existing AnimationService

### Out of Scope
- Changing game rules, unit types, or abilities
- Changing AI behavior
- Changing audio/voice system
- Adding new gameplay features
- Larger board sizes (keep 8x8 for now, but architecture should support it)

---

## Tasks

### Pending
- [ ] Phase 1: Create EngineBoardWidget with TileGrid(8,8), tile types, asset registration, FiftyMapWidget
- [ ] Phase 2: Entity spawning - convert Unit list to FiftyMapEntity list, apply decorators (team border, HP bar, status icon)
- [ ] Phase 3: Highlights + selection - wire gameState.validMoves/attackTargets/abilityTargets to engine overlays
- [ ] Phase 4: Movement animation - replace AnimationService.playMoveAnimation with engine AnimationQueue + A* path
- [ ] Phase 5: Combat animations - attack lunge, damage popup (showFloatingText), defeat (die), HP bar updates
- [ ] Phase 6: Game restart + AI turn sync - engine clear/rebuild, AI visual delay integration
- [ ] Phase 7: Camera setup + delete old files (board_widget, unit_sprite_widget, animated_board_overlay, animated_unit_sprite, damage_popup)
- [ ] Phase 8: Testing + verification - flutter analyze, flutter test, manual QA

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** INIT — reset to Ready, no phases completed
**Active Agent:** none
**Next Steps When Resuming:** Start fresh from Phase 1 (EngineBoardWidget + TileGrid)
**Last Updated:** 2026-02-24
**Blockers:** None
**Plan:** ai/plans/BR-076-plan.md

---

## Acceptance Criteria

**The migration is complete when:**

1. [ ] `fifty_map_engine` is actively imported and used for all board rendering
2. [ ] GridView.builder is fully removed from board rendering
3. [ ] All 6 tile types render correctly through the map engine
4. [ ] All 12 unit sprites render as map entities (6 player, 6 enemy)
5. [ ] Unit selection, movement, and attack targeting work through map engine input
6. [ ] All animations (move, attack, damage popup, defeat) work correctly
7. [ ] AI opponent turns render correctly with visual delays
8. [ ] Turn timer visual bar still displays properly
9. [ ] All audio (SFX, BGM, voice) fires at correct moments (unchanged)
10. [ ] Camera controls available (pan/zoom) but board centers nicely by default
11. [ ] `flutter analyze` passes (zero issues)
12. [ ] All 278+ existing tests pass
13. [ ] Manual smoke test: full game plays correctly (local + vs AI)

---

## Test Plan

### Automated Tests
- [ ] All existing 278 tests pass without modification (game logic unchanged)
- [ ] New widget tests for map engine board rendering
- [ ] New tests for adapter layer (GridPosition <-> Vector2 conversion)

### Manual Test Cases

#### Test Case 1: Full Game Playthrough (Local 1v1)
**Preconditions:** App launched, game mode selection shown
**Steps:**
1. Select Local 1v1 mode
2. Play full game - move units, attack, use abilities
3. Capture enemy commander to win

**Expected Result:** Game plays identically to current GridView version
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: AI Opponent Match
**Preconditions:** App launched
**Steps:**
1. Select VS AI mode (Hard difficulty)
2. Play full game against AI
3. Verify AI moves display with delays and "ENEMY THINKING..." indicator

**Expected Result:** AI behavior and visual feedback identical to current
**Status:** [ ] Pass / [ ] Fail

#### Test Case 3: Camera Controls
**Preconditions:** In active game
**Steps:**
1. Pinch to zoom in/out on board
2. Pan around the board
3. Double-tap to reset view

**Expected Result:** Smooth camera controls, board stays within bounds
**Status:** [ ] Pass / [ ] Fail

### Regression Checklist
- [ ] Unit movement animations smooth
- [ ] Attack animations and damage popups display correctly
- [ ] Ability targeting (Fireball, Shoot, Rally, etc.) highlights correct tiles
- [ ] Turn timer bar renders and auto-skips on expiry
- [ ] Audio cues fire at correct moments
- [ ] Voice announcer triggers on game events

---

## Delivery

### Code Changes
- [ ] New files: Map JSON definition, adapter/bridge layer
- [ ] Modified files: BoardWidget (rewrite), BattlePage (swap widget), unit rendering
- [ ] Deleted files: Old GridView board_widget.dart (replaced), animated_board_overlay.dart (replaced)

### Documentation Updates
- [ ] Update tactical_grid README to note fifty_map_engine usage
- [ ] Add comments explaining adapter pattern between game logic and rendering

### Deployment Notes
- [ ] Requires app restart: Yes (full rebuild)
- [ ] Backend changes needed: No
- [ ] Rollback plan: Revert to GridView commit

---

## Notes

- The existing game logic is well-tested (278 tests) and completely decoupled from rendering. The migration should ONLY touch the rendering/input layer.
- The adapter pattern is key: game logic speaks `GridPosition` and `BoardState`, the adapter translates to map engine's `Vector2` and entity system.
- The `assets/maps/` directory already exists (empty with `.gitkeep`) - ready for board JSON.
- This brief transforms tactical_grid from "Flutter app with a grid" to "flagship fifty_map_engine demo."

---

**Created:** 2026-02-10
**Last Updated:** 2026-02-10
**Brief Owner:** Monarch
