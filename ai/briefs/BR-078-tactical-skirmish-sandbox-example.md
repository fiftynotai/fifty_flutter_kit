# BR-078: Tactical Skirmish Sandbox - fifty_map_engine v2 Example App

**Type:** Feature
**Priority:** P1-High
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-10
**Completed:**

---

## Problem

**What's broken or missing?**

The `fifty_map_engine` package was upgraded to v2 (BR-077) with 21 new features: tile grid, overlays, entity decorators, instant tap, animation queue, sprite animation, A* pathfinding, and BFS movement range. The current example app (`example/lib/main.dart`) only demonstrates the legacy room/entity system - it does not showcase any v2 capabilities.

**Why does it matter?**

- No way to verify the v2 API works end-to-end in a real app context
- Developers evaluating the package see an outdated example that doesn't reflect new capabilities
- Integration bugs between v2 subsystems (grid + overlays + pathfinding + decorators + animation) remain untested in a real scenario
- 19 of 21 new features have zero example coverage

---

## Goal

**What should happen after this brief is completed?**

Replace the existing example app with a **Tactical Skirmish Sandbox** - a lightweight 2-player hot-seat tactical game that demonstrates 19/21 v2 features in ~250 lines. Players select units, see movement/attack ranges highlighted on tiles, move via A* pathfinding, attack enemies with damage popups, watch HP bars drain, and see defeated units removed.

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_map_engine/example/`

### Layers Touched
- [x] View (UI widgets)
- [x] Model (domain objects)

### API Changes
- [x] No API changes (consumer of existing v2 API)

### Dependencies
- [x] Existing service: `fifty_map_engine` v2 public API (all new grid/overlay/decorator/animation/pathfinding features)

### Related Files
- `packages/fifty_map_engine/example/lib/main.dart` - Replace entirely
- `packages/fifty_map_engine/example/pubspec.yaml` - May need asset declarations

### v2 Features to Demonstrate (19/21)

| # | Feature | How Demonstrated |
|---|---------|-----------------|
| 1 | TileGrid | 10x8 map with terrain types (grass, forest, water, wall) |
| 2 | TileType | 4 terrain types with different movement costs and walkability |
| 3 | GridPosition | All unit/tile references use GridPosition |
| 4 | CoordinateAdapter | Internal - used by engine for grid-to-pixel conversion |
| 5 | TileOverlay/Highlights | Blue highlights for movement range, red for attack range, yellow for selection |
| 6 | Instant tap (onTileTap) | Tap tile to select unit or move/attack |
| 7 | InputManager | Blocks input during animations |
| 8 | Entity decorators - HealthBar | HP bar above each unit, updates on damage |
| 9 | Entity decorators - SelectionRing | Amber ring around selected unit |
| 10 | Entity decorators - TeamBorder | Blue/red team color borders on units |
| 11 | Entity decorators - StatusIcon | Optional status indicators |
| 12 | FloatingText | Damage numbers pop up on attack |
| 13 | AnimationQueue | Sequential move then attack animations |
| 14 | SpriteAnimationConfig | Unit sprites with idle/walk/attack/die states |
| 15 | AnimatedEntityComponent | Sprite state changes during gameplay |
| 16 | A* Pathfinding | Calculate shortest path for unit movement |
| 17 | BFS Movement Range | Show reachable tiles based on movement points |
| 18 | Controller API | All interactions through FiftyMapController |
| 19 | FiftyMapWidget + grid param | Widget with tile grid rendering |

**Not demonstrated (2/21):**
- TapResolver (internal implementation detail)
- OverlayManager (internal implementation detail)

---

## Constraints

### Architecture Rules
- Single-file example (~250 lines) in `example/lib/main.dart`
- All game state managed locally (no external state management)
- Only use public API from `fifty_map_engine` barrel export
- No direct Flame imports - prove the API hides Flame completely

### Technical Constraints
- Must work on both iOS and Android simulators
- No external assets required if sprites unavailable - fall back to colored rectangles with text labels
- Hot-seat gameplay (two players on same device, alternating turns)

### Game Design
- **Map:** 10 columns x 8 rows
- **Terrain:** Grass (cost 1), Forest (cost 2, partial cover), Water (impassable), Wall (impassable)
- **Units:** 6 total - 3 blue team (left side), 3 red team (right side)
- **Unit stats:** HP, attack power, movement range (3-4 tiles), attack range (1-2 tiles)
- **Turn flow:** Select unit -> show movement range (blue) + attack range (red) -> tap tile to move/attack -> next player's turn
- **Win condition:** Eliminate all enemy units

### Out of Scope
- AI opponent (just hot-seat)
- Sound effects / music
- Save/load game state
- Unit abilities beyond basic move + attack
- Network multiplayer

---

## Tasks

### Pending
- [ ] Task 1: Design map layout (10x8 grid with terrain placement)
- [ ] Task 2: Define unit configurations (stats, positions, sprite configs)
- [ ] Task 3: Implement game state model (turns, units, HP tracking)
- [ ] Task 4: Build example app with FiftyMapWidget + TileGrid
- [ ] Task 5: Wire tile tap to unit selection + range display
- [ ] Task 6: Implement move action (A* path, animation, position update)
- [ ] Task 7: Implement attack action (damage calc, floating text, HP bar update)
- [ ] Task 8: Implement unit defeat (die animation, removal)
- [ ] Task 9: Add turn management + win condition UI
- [ ] Task 10: Verify all 19 features are exercised
- [ ] Task 11: Run flutter analyze + flutter test on package

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** COMPLETE
**Active Agent:** none
**Next Steps When Resuming:** N/A - Brief complete
**Plan:** ai/plans/BR-078-plan.md
**Last Updated:** 2026-02-10
**Blockers:** None (BR-077 complete)

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Example app launches and renders a 10x8 tile grid with 4 terrain types
2. [ ] 6 units (3 blue, 3 red) spawn at predefined positions with team borders and HP bars
3. [ ] Tapping a friendly unit selects it (selection ring visible) and shows movement range (blue) + attack range (red)
4. [ ] Tapping a highlighted blue tile moves the unit via A* path with walk animation
5. [ ] Tapping an enemy in attack range triggers attack with damage floating text and HP bar update
6. [ ] Unit at 0 HP plays die animation and is removed
7. [ ] Turns alternate between blue and red teams
8. [ ] Input is blocked during animations (InputManager integration)
9. [ ] All interactions go through FiftyMapController (no direct Flame usage)
10. [ ] 19/21 v2 features are exercised in the example
11. [ ] `flutter analyze` passes (zero issues) on the package
12. [ ] `flutter test` passes (all existing 119 tests still green)
13. [ ] No Flame imports in example code (only `fifty_map_engine` barrel)

---

## Test Plan

### Automated Tests
- [ ] Existing 119 engine tests continue to pass (regression)
- [ ] Optional: Add integration test for example app launch

### Manual Test Cases

#### Test Case 1: Unit Selection and Range Display
**Preconditions:** App launched, blue team's turn
**Steps:**
1. Tap a blue team unit
2. Observe selection ring appears
3. Observe blue-highlighted tiles (movement range) and red-highlighted tiles (attack range)
4. Tap empty space to deselect

**Expected Result:** Selection ring, movement highlights, and attack highlights appear/disappear correctly

#### Test Case 2: Movement via A* Path
**Preconditions:** Blue unit selected, movement range visible
**Steps:**
1. Tap a blue-highlighted tile
2. Observe unit walks along path to destination
3. Input blocked during movement animation

**Expected Result:** Unit moves smoothly along A* path, highlights clear after move

#### Test Case 3: Attack with Damage
**Preconditions:** Unit adjacent to enemy, attack range visible
**Steps:**
1. Tap enemy unit in red-highlighted range
2. Observe attack animation
3. Observe floating damage number
4. Observe enemy HP bar decrease

**Expected Result:** Damage popup appears, enemy HP bar updates

#### Test Case 4: Unit Defeat
**Preconditions:** Enemy unit at low HP
**Steps:**
1. Attack enemy unit to reduce HP to 0
2. Observe die animation
3. Unit removed from board

**Expected Result:** Defeated unit plays die animation and disappears

---

## Delivery

### Code Changes
- [ ] Modified files: `packages/fifty_map_engine/example/lib/main.dart` (replace)
- [ ] Modified files: `packages/fifty_map_engine/example/pubspec.yaml` (if assets needed)

### Database Migrations
- [x] N/A

### Configuration Changes
- [x] N/A

### Documentation Updates
- [ ] README: Update example section in package README to describe the Tactical Skirmish Sandbox

### Deployment Notes
- [x] N/A (example app only)

---

## Notes

- This brief was generated from Ideator output (Option 1: Tactical Skirmish Sandbox)
- Ranked highest for API coverage: 19/21 v2 features demonstrated
- Estimated ~250 lines of example code
- If sprite assets are unavailable, fall back to colored rectangles with unit-type text labels
- This example doubles as an integration test proving all v2 subsystems work together

---

**Created:** 2026-02-10
**Last Updated:** 2026-02-10
**Brief Owner:** Igris AI
