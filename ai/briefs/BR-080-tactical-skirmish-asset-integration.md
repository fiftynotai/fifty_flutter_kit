# BR-080: Tactical Skirmish Sandbox - Asset Integration

## Metadata
- **Type:** Feature
- **Priority:** P2-Medium
- **Effort:** M
- **Status:** Done
- **Created:** 2026-02-13
- **Depends On:** BR-079 (Done)
- **Related:** BR-078 (example app), BR-071 (tactical grid game)

---

## Summary

Replace colored rectangles with actual tile images and character sprites in the tactical skirmish sandbox example. The ecosystem already has suitable assets in `apps/tactical_grid/assets/` (12 unit sprites, 6 board tiles) and `packages/fifty_map_engine/example/assets/` (characters, monsters, rooms, furniture).

---

## Current State

The tactical skirmish sandbox (`packages/fifty_map_engine/example/lib/main.dart`) renders:
- **Units:** 64x64 colored rectangles (blue/red team colors) with white text labels
- **Tiles:** Flat color fills via `TileType.color` (green grass, dark green forest, blue water, grey wall)
- **Entities use:** Transparent 1x1 placeholder sprite (`_createTransparentSprite()`)

---

## Available Assets (Scan Results)

### Tactical Grid App (`apps/tactical_grid/assets/`)

**Unit Sprites (12):**
| Asset | Suggested Mapping |
|-------|-------------------|
| `images/units/player_commander.png` | Blue Warrior (leader) |
| `images/units/player_archer.png` | Blue Archer |
| `images/units/player_mage.png` | Blue Mage |
| `images/units/player_knight.png` | (spare - Blue alt) |
| `images/units/player_shield.png` | (spare - Blue alt) |
| `images/units/player_scout.png` | (spare - Blue alt) |
| `images/units/enemy_commander.png` | Red Warrior (leader) |
| `images/units/enemy_archer.png` | Red Archer |
| `images/units/enemy_mage.png` | Red Mage |
| `images/units/enemy_knight.png` | (spare - Red alt) |
| `images/units/enemy_shield.png` | (spare - Red alt) |
| `images/units/enemy_scout.png` | (spare - Red alt) |

**Board Tiles (6):**
| Asset | Suggested Mapping |
|-------|-------------------|
| `images/board/tile_light.png` | Grass terrain |
| `images/board/tile_dark.png` | Forest terrain |
| `images/board/tile_obstacle.png` | Wall terrain |
| `images/board/tile_trap.png` | Water terrain (alt) |
| `images/board/tile_objective.png` | (spare - special tile) |
| `images/board/tile_powerup.png` | (spare - special tile) |

### Example App (`packages/fifty_map_engine/example/assets/`)

**Characters:** `adventurer.png`, `ember.png`
**Monsters:** `m-1.png` through `m-4.png` (4 sprites)
**Rooms:** `large_room.jpg`, `purple_room.png`, `medium_room.png`, `small_room.png`, `stairs.png`, `corridor_room.jpg`
**Furniture:** `skull.png`, `token.png`, `locked_door.png`, `locker.png`, `door.png`, `rock_door.png`, `table.png`, `box.png`, `square.png`
**Events:** `npc.png`, `master_of_shadow.png`, `basic.png`

### Fifty Demo App (`apps/fifty_demo/assets/`)

**Characters:** `hero.png`
**Rooms:** `room_hall.png`, `room_garden.png`, `room_cellar.png`, `room_throne.png`, `room_sanctuary.png`, `room_study.png`
**Creatures:** `stone_sentinel.png`
**Furniture:** `chest.png`, `brazier.png`, `pedestal.png`, `door.png`

---

## Scope

### Phase 1: Copy Assets to Example App
- Copy selected assets from `apps/tactical_grid/assets/` to `packages/fifty_map_engine/example/assets/`
- Organize: `images/units/` (6 sprites), `images/tiles/` (4 terrain tiles)
- Update `pubspec.yaml` asset declarations

### Phase 2: Tile Image Integration
- Replace flat color fills with tile sprite images for all 4 terrain types
- Map: grass -> tile_light, forest -> tile_dark, wall -> tile_obstacle, water -> tile_trap (or generate a water tile)
- Use engine's `TileType` sprite support or render tile images as background

### Phase 3: Unit Sprite Integration
- Replace transparent placeholder sprites with actual character images
- Load sprites from assets on entity creation
- Map 6 units to 6 sprites (3 player, 3 enemy per class: warrior/archer/mage)
- Remove `_createTransparentSprite()` hack
- Ensure sprites render at correct 64x64 block size

### Phase 4: Visual Polish
- Add team color tint/border to distinguish teams if sprites lack color coding
- Ensure selected unit visual feedback still works with sprites
- Verify highlight overlays render correctly on top of tile images
- Test on simulator

---

## Acceptance Criteria

- [ ] Tile grid renders with image textures instead of flat colors
- [ ] All 6 units display character sprites instead of colored rectangles
- [ ] Blue team units use player_* sprites, red team uses enemy_* sprites
- [ ] Unit class matches sprite (warrior->commander, archer->archer, mage->mage)
- [ ] Movement/attack highlights overlay correctly on tile images
- [ ] Selection visual feedback works with sprites
- [ ] No regression in gameplay mechanics (movement, combat, turns)
- [ ] 122+ tests still passing

---

## Technical Notes

- Engine `FiftyMapEntity` already supports `SpriteComponent` via Flame - need to load actual sprites instead of transparent placeholder
- `TileType` in engine may need tile image path support, or tiles can be rendered as background `SpriteComponent` per cell
- Block size is 64px (`FiftyMapConfig.blockSize`) - sprites should match or be scaled
- Current transparent sprite hack: `_createTransparentSprite()` in main.dart line ~220
