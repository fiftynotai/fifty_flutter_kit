# BR-067: Map Engine FDL Demo Implementation

**Type:** Feature / Demo
**Priority:** P2 - Medium
**Status:** Done
**Effort:** M - Medium
**Module:** apps/fifty_demo + packages/fifty_map_engine
**Created:** 2026-02-03

---

## Problem

The map engine example uses old, inconsistent assets that don't follow the Fifty Design Language (FDL). New FDL-compliant assets have been generated and organized, but the demo needs to be wired up.

---

## Goal

Create a complete map engine demo in fifty_demo using the new FDL assets, showcasing:
- Room rendering with 6 distinct rooms
- Character movement (hero)
- Creature placement (stone sentinel)
- Furniture/props (brazier, chest, pedestal)
- Event markers (interact, quest)

---

## Context & Inputs

### New FDL Assets (Ready)

All assets follow FDL color palette:
- Burgundy #88292f (primary)
- Slate Grey #335c67 (secondary)
- Hunter Green #4b644a (nature)
- Cream #fefee3 (light)
- Deep Dark #1a0d0e (shadows)
- Powder Blush #ffc9b9 (warmth)

**Asset Location:** `apps/fifty_demo/assets/images/`

```
images/
├── characters/
│   └── hero.png              # Player character (burgundy cloak, slate armor)
├── creatures/
│   └── stone_sentinel.png    # Enemy (slate golem with runes)
├── events/
│   ├── event_interact.png    # Exclamation marker (cream/burgundy)
│   └── event_quest.png       # Diamond marker (burgundy/cream)
├── furniture/
│   ├── brazier.png           # Fire bowl (slate grey, powder blush flame)
│   ├── chest.png             # Treasure chest (dark wood, burgundy trim)
│   ├── door.png              # Door (old asset, may need replacement)
│   └── pedestal.png          # Marble pedestal (cream)
└── rooms/
    ├── room_cellar.png       # 2048x2048px
    ├── room_garden.png       # 2048x2048px
    ├── room_hall.png         # 2048x2048px
    ├── room_sanctuary.png    # 2048x2048px
    ├── room_study.png        # 2048x2048px
    └── room_throne.png       # 2048x2048px
```

### Map Engine Architecture

**Package:** `packages/fifty_map_engine`

**Key Classes:**
- `FiftyMapBuilder` - Flame game widget that renders the map
- `FiftyMapEntity` - Data model for entities (rooms, characters, furniture, etc.)
- `FiftyEntityType` - Enum: room, character, monster, furniture, door, event
- `FiftyBlockSize` - Size in tile units (not pixels)
- `FiftyMapConfig.blockSize` - 64 pixels per tile

**Entity JSON Structure:**
```json
{
  "id": "unique_id",
  "type": "room",
  "asset": "rooms/room_hall.png",
  "grid_position": {"x": 0, "y": 0},
  "size": {"width": 8, "height": 8},
  "quarter_turns": 0,
  "components": []
}
```

**Room sizes for 2048px assets at 64px/tile:**
- 2048 / 64 = 32 tiles, but typically rendered at 8x8 (scaled down)

### Files to Create/Modify

1. **pubspec.yaml** - Register new asset paths
2. **Map JSON file** - `assets/maps/fdl_demo_map.json`
3. **Demo page** - `lib/features/map_demo/views/map_demo_page.dart` (if not exists)
4. **Demo routes** - Wire up navigation to map demo

---

## Demo Concept: "The Six Chambers"

Simple interconnected layout:

```
┌─────────────┐     ┌─────────────┐
│   THRONE    │─────│    HALL     │
│   (boss)    │     │   (entry)   │
└─────────────┘     └──────┬──────┘
                           │
┌─────────────┐     ┌──────┴──────┐
│   GARDEN    │─────│    STUDY    │
│  (nature)   │     │  (library)  │
└─────────────┘     └──────┬──────┘
                           │
┌─────────────┐     ┌──────┴──────┐
│  SANCTUARY  │─────│   CELLAR    │
│   (peace)   │     │  (storage)  │
└─────────────┘     └─────────────┘
```

**Entity Placement:**
- Hero starts in Hall
- Stone Sentinels in Throne room and Cellar
- Braziers in Hall and Throne (lighting)
- Chests in Cellar and Study
- Pedestals in Sanctuary and Garden
- Event markers on chests and room transitions

---

## Implementation Steps

### Step 1: Update pubspec.yaml
```yaml
flutter:
  assets:
    - assets/images/rooms/
    - assets/images/characters/
    - assets/images/creatures/
    - assets/images/furniture/
    - assets/images/events/
    - assets/maps/
```

### Step 2: Create Demo Map JSON
Create `assets/maps/fdl_demo_map.json` with:
- 6 rooms positioned on grid
- Hero character in starting room
- Creatures in appropriate rooms
- Furniture scattered across rooms
- Event markers on interactive objects

### Step 3: Create/Update Demo Page
- Load map JSON
- Initialize FiftyMapBuilder
- Handle entity interactions (optional)

### Step 4: Test & Refine
- Verify all assets load
- Check room connections make visual sense
- Ensure hero can move between rooms

---

## Constraints

- Must use FDL color palette (already done in assets)
- All rooms are 2048x2048px, render as 8x8 tiles
- Map engine uses bottom-left origin (y=0 at bottom)
- Entity positions are in tile units, not pixels

---

## Acceptance Criteria

1. [x] pubspec.yaml updated with new asset paths
2. [x] Demo map JSON created with 6 rooms
3. [x] Hero character placed and movable
4. [x] At least 2 creatures placed
5. [x] Furniture placed in multiple rooms
6. [x] Event markers on interactive objects
7. [x] Demo page loads and renders map
8. [x] All FDL assets display correctly
9. [x] No console errors about missing assets

---

## Test Plan

### Manual Testing
1. Navigate to map demo in fifty_demo app
2. Verify all 6 rooms render
3. Verify hero character visible
4. Move hero between rooms (if movement enabled)
5. Verify creatures, furniture, events display
6. Check FDL colors match design system

---

## Assets That Failed Generation (Optional Future)

These were attempted but AI couldn't generate proper top-down view:
- Door (using old asset for now)
- Banner (vertical wall decoration)
- Shadow Wisp (ethereal creature)

Can revisit with different prompts or manual creation later.

---

## Reference Files

| File | Purpose |
|------|---------|
| `packages/fifty_map_engine/example/assets/maps/example.json` | Reference map structure |
| `packages/fifty_map_engine/lib/src/models/` | Entity models |
| `design_system/fifty_design_system.md` | FDL color reference |

---

## Delivery

- [x] pubspec.yaml updated
- [x] Demo map JSON created
- [x] Demo page functional
- [x] All assets rendering
- [x] Brief status → Done

---
