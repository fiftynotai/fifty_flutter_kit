# BR-030: Fifty Demo - Map Widget Integration

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M-Medium (4-8h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-01-05
**Completed:** 2026-01-05

---

## Problem

**What's broken or missing?**

The Map Demo page in `apps/fifty_demo/` shows a placeholder instead of an actual map:

```dart
const FiftyCard(
  child: SizedBox(
    height: 300,
    child: Center(
      child: Text('MAP WIDGET PLACEHOLDER'),
    ),
  ),
),
```

Additionally:
- `assets/maps/` directory is empty (only `.gitkeep`)
- `assets/images/` has no map-related images (rooms, furniture, monsters)
- `FiftyMapWidget` from `fifty_map_engine` is not integrated
- Map entities are not loaded or rendered

**Why does it matter?**

1. **Incomplete demo** - Map engine is a key ecosystem package but isn't showcased
2. **No visual demonstration** - Users can't see what fifty_map_engine can do
3. **Audio-map coordination untested** - SFX on entity tap can't be tested without entities

---

## Goal

**What should happen after this brief is completed?**

The Map Demo page displays an interactive map using `FiftyMapWidget` with:
- Room backgrounds rendered
- Furniture and monster entities visible
- Entity tap triggers SFX sound
- Camera controls (zoom in/out, center) functional
- Map loads from JSON asset file

---

## Context & Inputs

### Source Assets

Copy from `packages/fifty_map_engine/example/assets/`:

**Images to copy:**
```
images/rooms/
  - small_room.png
  - medium_room.png
  - large_room.jpg
  - corridor_room.jpg

images/furniture/
  - door.png
  - box.png
  - table.png
  - token.png

images/monsters/
  - m-1.png
  - m-2.png
  - m-3.png
  - m-4.png

images/characters/
  - adventurer.png
```

**Map JSON to copy:**
```
maps/example.json
```

### Target Structure

```
apps/fifty_demo/assets/
├── images/
│   ├── rooms/
│   ├── furniture/
│   ├── monsters/
│   └── characters/
├── maps/
│   └── demo_map.json
└── audio/
    └── sfx/
```

### Integration Points

1. **MapDemoPage** - Replace placeholder with `FiftyMapWidget`
2. **MapIntegrationService** - Load map JSON and initialize controller
3. **MapAudioCoordinator** - Wire entity tap to SFX playback
4. **pubspec.yaml** - Add new asset paths

### Reference Implementation

See `packages/fifty_map_engine/example/lib/` for:
- How to create `FiftyMapController`
- How to load map from JSON
- How to register assets with `FiftyAssetLoader`
- How to handle entity taps

---

## Constraints

### Technical Requirements
- Must use `FiftyMapWidget` from `fifty_map_engine`
- Must follow MVVM+Actions pattern (GetX)
- Must work with existing audio integration
- Must pass `flutter analyze`

### Out of Scope
- Creating new map assets (use existing from example)
- Complex game logic
- Save/load map state
- Multi-map navigation

---

## Tasks

### Pending
_(None)_

### In Progress
_(None)_

### Completed
- [x] Task 1: Copy image assets from fifty_map_engine example
- [x] Task 2: Copy and adapt map JSON file
- [x] Task 3: Update pubspec.yaml with new asset paths
- [x] Task 4: Create FiftyMapController in MapIntegrationService
- [x] Task 5: Add asset registration in MapIntegrationService
- [x] Task 6: Replace placeholder with FiftyMapWidget in MapDemoPage
- [x] Task 7: Wire entity tap callback to play SFX
- [x] Task 8: Connect camera controls to map controller
- [x] Task 9: Test map rendering and interactions
- [x] Task 10: Run flutter analyze and fix issues

---

## Acceptance Criteria

1. [x] Map renders with room backgrounds visible
2. [x] Furniture and monster entities display on map
3. [x] Tapping an entity plays click SFX
4. [x] Zoom in/out buttons change map scale
5. [x] Center button resets camera position
6. [x] Map loads from JSON asset file
7. [x] `flutter analyze` passes
8. [x] No placeholder text visible on Map Demo page

---

## Test Plan

### Manual Tests
- [ ] Launch app, navigate to Map Demo tab
- [ ] Verify map renders (not placeholder)
- [ ] Tap entity, verify SFX plays
- [ ] Tap zoom in, verify map zooms
- [ ] Tap zoom out, verify map zooms out
- [ ] Tap center, verify camera resets
- [ ] Pan/drag map, verify it moves

### Automated Tests
- [ ] Widget test for MapDemoPage renders FiftyMapWidget
- [ ] Unit test for MapIntegrationService initialization

---

## Workflow State

**Phase:** COMPLETE
**Active Agent:** _(none)_
**Retry Count:** 0

### Agent Log
- [2026-01-05 PLANNING] Starting planner agent...
- [2026-01-05 PLANNING] Plan complete (7 phases, 10 files)
- [2026-01-05 BUILDING] Starting coder agent...
- [2026-01-05 BUILDING] Coder complete (5 files modified, 14 assets copied)
- [2026-01-05 TESTING] Tester PASS (all checks passed)
- [2026-01-05 REVIEWING] Reviewer verified assets present
- [2026-01-05 COMMITTING] Committed as 61d9d99

---

**Created:** 2026-01-05
**Last Updated:** 2026-01-05
**Brief Owner:** Igris AI
