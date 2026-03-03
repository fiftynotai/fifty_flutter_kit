# TD-013: fifty_world_engine README rewrite — document tile-based systems

**Type:** Technical Debt
**Priority:** P1-High
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Done
**Created:** 2026-03-04
**Completed:** 2026-03-04

---

## What is the Technical Debt?

**Current situation:**

The fifty_world_engine README only documents the entity/room system (FiftyWorldEntity, FiftyWorldController, FiftyEntitySpawner). The entire tile-based tactical grid layer — which is the bigger selling point — is completely undocumented:

- TileGrid / TileType / GridPosition (2D grid with walkability and movement costs)
- TileOverlay / HighlightStyle / OverlayManager (colored tile highlights with group-based batch clear)
- Pathfinder / GridGraph (A* pathfinding with diagonal support and blocked positions)
- MovementRange (BFS reachable tiles within movement budget)
- AnimationQueue / AnimationEntry (sequential animation execution with input blocking)
- InputManager / TapResolver (tap-to-grid resolution and input blocking)

**Why is it technical debt?**

The package's most powerful features are invisible to pub.dev visitors. A developer evaluating fifty_world_engine sees an entity spawner but has no idea it includes A* pathfinding, movement range calculation, tile overlays, and animation queuing — the features that make it a complete tactical game engine.

---

## Why It Matters

**Consequences of not fixing:**

- [x] **Developer Experience:** Developers can't discover pathfinding, overlays, or movement range from the README
- [x] **Adoption:** The package looks like a simple sprite renderer instead of a full tactical engine
- [x] **Maintainability:** TD-011 "Why" section is inaccurate — doesn't mention the tile-based selling points

**Impact:** High (the tile layer is the primary differentiator)

---

## Cleanup Steps

**How to pay off this debt:**

1. [ ] Rewrite "Why fifty_world_engine" bullets to include tile grid, pathfinding, overlays, and animation queue
2. [ ] Add "Tile Grid" section documenting TileGrid, TileType, GridPosition
3. [ ] Add "Tile Overlays" section documenting TileOverlay, HighlightStyle, OverlayManager
4. [ ] Add "Pathfinding" section documenting Pathfinder, GridGraph, MovementRange
5. [ ] Add "Animation Queue" section documenting AnimationQueue, AnimationEntry
6. [ ] Add "Input Management" section documenting InputManager, TapResolver
7. [ ] Update Customization section to include tile types, overlay styles, and graph configuration
8. [ ] Update Architecture diagram to show tile-based layer alongside entity layer
9. [ ] Update Quick Start or add a second Quick Start showing tile-based usage

---

## Tasks

### Pending
- [ ] Task 1: Read all tile-based source files to catalog exact APIs
- [ ] Task 2: Rewrite README with both entity and tile-based systems documented
- [ ] Task 3: Verify all code snippets compile against actual API

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Read all source files in grid/, pathfinding/, animation/, input/, components/tiles/, components/overlays/
**Last Updated:** 2026-03-04
**Blockers:** None

---

## Benefits of Fixing

**What improves after cleanup:**

- pub.dev visitors see the full tactical engine capability
- Pathfinding, overlays, and movement range become discoverable
- "Why" section accurately represents the package's value
- Developers can adopt tile-based features without reading source code

**Return on Investment:** High

---

## Affected Areas

### Files
- `packages/fifty_world_engine/README.md`

### Source Files to Reference
- `lib/src/grid/tile_grid.dart` — TileGrid
- `lib/src/grid/tile_type.dart` — TileType
- `lib/src/grid/grid_position.dart` — GridPosition
- `lib/src/grid/tile_overlay.dart` — TileOverlay, HighlightStyle
- `lib/src/grid/coordinate_adapter.dart` — CoordinateAdapter
- `lib/src/components/tiles/tile_component.dart` — TileComponent
- `lib/src/components/tiles/tile_grid_component.dart` — TileGridComponent
- `lib/src/components/overlays/overlay_manager.dart` — OverlayManager
- `lib/src/components/overlays/tile_overlay_component.dart` — TileOverlayComponent
- `lib/src/pathfinding/pathfinder.dart` — Pathfinder (A*)
- `lib/src/pathfinding/grid_graph.dart` — GridGraph
- `lib/src/pathfinding/movement_range.dart` — MovementRange
- `lib/src/animation/animation_queue.dart` — AnimationQueue, AnimationEntry
- `lib/src/input/input_manager.dart` — InputManager
- `lib/src/input/tap_resolver.dart` — TapResolver

### Count
**Total files affected:** 1 (README.md)
**Total source files to reference:** 15

---

## Testing

### Regression Testing
- [ ] No code changes — documentation only
- [ ] Verify all code snippets match actual API signatures

### Verification
**How to verify cleanup is successful:**

1. README documents both entity system AND tile-based system
2. Pathfinding, overlays, movement range, and animation queue all have dedicated sections
3. "Why" bullets accurately reflect the full package capability
4. Code snippets in README match actual source signatures

---

## Acceptance Criteria

**The debt is paid off when:**

1. [ ] "Why fifty_world_engine" includes tile grid, pathfinding, overlays, and animation queue
2. [ ] TileGrid, TileType, GridPosition documented with API tables and examples
3. [ ] TileOverlay, HighlightStyle, OverlayManager documented with usage examples
4. [ ] Pathfinder and MovementRange documented with code snippets
5. [ ] AnimationQueue documented with input-blocking pattern
6. [ ] Architecture diagram shows both entity and tile-based layers
7. [ ] All code snippets verified against source

---

## References

**Related Briefs:**
- TD-011 (README audit — the "Why" section that needs updating)
- BR-077 (fifty_map_engine v2 upgrade — context on tile system origin)

---

**Created:** 2026-03-04
**Last Updated:** 2026-03-04
**Brief Owner:** Fifty.ai
