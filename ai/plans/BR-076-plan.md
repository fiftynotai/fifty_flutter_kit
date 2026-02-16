# BR-076 Migration Plan: Tactical Grid -> fifty_map_engine v2

**Revised:** 2026-02-16 (Pure Engine Approach)
**Previous Plan:** N/A (original plan was pre-BR-077, now obsolete)
**Effort:** L (3-5 days) -> revised to **M (2-3 days)**
**Reason for Downgrade:** Engine v2 ships tiles, overlays, decorators, animation queue, pathfinding, floating text, and input blocking natively. The example app (tactical skirmish sandbox) already demonstrates every pattern needed. This is now a "follow the reference" migration.

---

## Strategy: Pure Engine Approach

The engine v2 example app (`packages/fifty_map_engine/example/lib/main.dart`) is a 1400-line tactical skirmish sandbox that demonstrates:
- 10x8 tile grid with terrain types (grass, forest, water, wall)
- 8 unit entities with team borders, HP bars, selection rings, status icons
- Tap-to-select, move with path highlights, attack with animations
- Animation queue: move -> attack -> damage popup -> defeat
- A* pathfinding, BFS movement range
- Input blocking during animations
- Camera pan/zoom/center

The tactical_grid app needs the **exact same patterns** on an 8x8 board with 12 units. The migration is: replace Flutter widgets with engine API calls, following the example as the reference implementation.

---

## What Changes vs What Stays

### STAYS UNCHANGED (zero modifications)

| Layer | Files | Reason |
|-------|-------|--------|
| Game Logic | `GameLogicService`, `BattleViewModel` (core logic methods) | Pure state, no rendering |
| Models | `Unit`, `BoardState`, `GameState`, `GridPosition` (tactical_grid's own) | Pure data |
| AI | `AIService` | Pure logic |
| Audio | All audio services + voice announcer | No board dependency |
| Timer | `TurnTimerService` | Pure logic |
| UI Chrome | `TurnIndicator`, `UnitInfoPanel`, `GameOverOverlay` | Above/below board |
| Page | `BattlePage` structure (Column layout) | Swaps one child widget |

### REPLACED (rendering/input layer)

| Current (Flutter widgets) | Engine v2 Replacement |
|---------------------------|----------------------|
| `BoardWidget` (GridView.builder, 64 tiles) | `FiftyMapWidget` with `TileGrid(8, 8)` |
| `_BoardTile` checkerboard colors | `TileType` with asset textures (grass/forest/water/wall) |
| Move/attack/ability color overlays | `controller.highlightTiles()` + `HighlightStyle` |
| `GestureDetector` per tile | `onTileTap: (pos) => ...` callback |
| `UnitSpriteWidget` (circular PNG + HP bar + team glow) | Engine entities + decorators (HP bar, team border, selection ring) |
| `AnimatedBoardOverlay` + `AnimatedUnitSprite` | Engine `AnimationQueue` + `move()` + `attack()` + `die()` |
| `DamagePopup` widget | `controller.showFloatingText()` |
| Manual `LayoutBuilder` sizing | Engine viewport management |
| No camera controls | Engine pan/zoom/center (free) |

### REFACTORED (bridge layer)

| Component | Change |
|-----------|--------|
| `BattleActions` | Replace widget animation calls with engine controller calls |
| `AnimationService` | Simplify: delegate to engine's `AnimationQueue` instead of managing `Completer`s and `RxList<AnimationEvent>` |
| `BattleViewModel` | Add engine sync: when `gameState` changes, push updates to engine controller |

---

## Coordinate System Mapping

Both systems use `GridPosition(x, y)` with identical semantics:
- `x` = column (0-based, left-to-right)
- `y` = row (0-based, top-to-bottom)

The tactical_grid `GridPosition` (from `models/position.dart`) and engine `GridPosition` (from `fifty_map_engine`) are structurally identical. However, `FiftyMapEntity.gridPosition` uses Flame's `Vector2` internally.

**Conversion pattern (from example app):**
```dart
// tactical_grid GridPosition -> engine GridPosition
final enginePos = map_engine.GridPosition(unit.position.x, unit.position.y);

// engine GridPosition -> tactical_grid GridPosition
final gamePos = GridPosition(enginePos.x, enginePos.y);

// For FiftyMapEntity creation
gridPosition: Vector2(unit.position.x.toDouble(), unit.position.y.toDouble()),
```

**Decision:** Keep tactical_grid's own `GridPosition` for game logic (it has movement pattern helpers like `getKnightMovePositions`, `getOrthogonalPositions`). Use the engine's `GridPosition` only at the bridge layer. Import with alias: `import 'package:fifty_map_engine/fifty_map_engine.dart' as map_engine;`

---

## Phases

### Phase 1: Bridge Layer + Tile Grid (Foundation)

**Goal:** Replace `GridView.builder` with engine's tile grid. Board renders tiles but no units yet.

**Files to create:**
- `lib/features/battle/views/widgets/engine_board_widget.dart` -- New board widget wrapping `FiftyMapWidget`

**Files to modify:**
- `lib/features/battle/views/battle_page.dart` -- Swap `BoardWidget()` for `EngineBoardWidget()`

**Implementation:**

1. Create `EngineBoardWidget` (StatefulWidget):
   - Initialize `FiftyMapController`
   - Build `TileGrid(width: 8, height: 8)` with 4 tile types:
     - Use existing tile textures from `assets/images/board/` (dark_tile, light_tile, objective_tile, powerup_tile, obstacle_tile, trap_tile)
     - Register all tile and unit assets via `FiftyAssetLoader.registerAssets()`
   - Create checkerboard pattern using `grid.setTile()` (alternating two tile types)
   - Special tiles: objective center, powerup corners, obstacle positions, trap positions
   - Render `FiftyMapWidget(grid: grid, controller: controller, ...)`
   - Wire `onTileTap` to `BattleActions.onTileTapped(context, GridPosition(pos.x, pos.y))`

2. Tile type mapping:
   ```
   Current checkerboard    -> TileType(id: 'dark', asset: 'board/tile_dark.png')
                           -> TileType(id: 'light', asset: 'board/tile_light.png')
   Objective tile          -> TileType(id: 'objective', asset: 'board/tile_objective.png')
   Powerup tile            -> TileType(id: 'powerup', asset: 'board/tile_powerup.png')
   Obstacle tile           -> TileType(id: 'obstacle', walkable: false, ...)
   Trap tile               -> TileType(id: 'trap', ...)
   ```

**Verification:** Board renders 8x8 tiles with textures. Tapping tiles logs to console. No units visible yet.

---

### Phase 2: Entity Spawning + Decorators (Units on Board)

**Goal:** Units appear on the board as engine entities with team borders, HP bars, and status icons.

**Files to modify:**
- `lib/features/battle/views/widgets/engine_board_widget.dart` -- Add entity creation and decorator logic

**Implementation:**

1. Convert `Unit` list to `FiftyMapEntity` list:
   ```dart
   FiftyMapEntity _unitToEntity(Unit unit) {
     return FiftyMapEntity(
       id: unit.id,
       type: 'character',  // all units are movable characters
       asset: unit.assetPath.replaceFirst('assets/images/', ''),
       gridPosition: Vector2(unit.position.x.toDouble(), unit.position.y.toDouble()),
       blockSize: const FiftyBlockSize(width: 1, height: 1),
     );
   }
   ```

2. Pass entities to `FiftyMapWidget(initialEntities: entities, ...)`

3. Post-frame decorator application (following example pattern):
   ```dart
   WidgetsBinding.instance.addPostFrameCallback((_) {
     for (final unit in gameState.board.allUnits) {
       // Team border (blue for player, red for enemy)
       controller.setTeamColor(unit.id, unit.isPlayer ? playerColor : enemyColor);
       // HP bar
       controller.updateHP(unit.id, unit.hpRatio);
       // Status icon for unit type initial
       controller.addStatusIcon(unit.id, unit.type.name[0].toUpperCase());
     }
   });
   ```

4. Selection decorator:
   ```dart
   controller.setSelected(unit.id, selected: true, color: selectionColor);
   controller.setSelection(enginePos);  // yellow tile highlight
   ```

**Verification:** 12 units visible on board with team-colored borders, HP bars, and type labels.

---

### Phase 3: Highlights + Selection (Input Layer)

**Goal:** Tapping a unit shows movement range (green), attack range (red), and ability targets (purple). Tapping empty tiles deselects.

**Files to modify:**
- `lib/features/battle/views/widgets/engine_board_widget.dart` -- Wire highlights
- `lib/features/battle/actions/battle_actions.dart` -- Replace overlay calls with engine highlight calls

**Implementation:**

1. Observe `gameState` changes to sync highlights:
   ```dart
   // When validMoves changes
   controller.clearHighlights(group: 'validMoves');
   controller.highlightTiles(
     gameState.validMoves.map((p) => map_engine.GridPosition(p.x, p.y)).toList(),
     HighlightStyle.validMove,  // green
   );

   // When attackTargets changes
   controller.clearHighlights(group: 'attackRange');
   final attackPositions = gameState.attackTargets.map((u) =>
     map_engine.GridPosition(u.position.x, u.position.y)).toList();
   controller.highlightTiles(attackPositions, HighlightStyle.attackRange);  // red

   // When abilityTargets changes
   controller.clearHighlights(group: 'abilityTarget');
   controller.highlightTiles(
     gameState.abilityTargets.map((p) => map_engine.GridPosition(p.x, p.y)).toList(),
     HighlightStyle.abilityTarget,  // purple
   );
   ```

2. Selection flow in `onTileTap`:
   ```dart
   onTileTap: (pos) {
     if (controller.isAnimating || controller.inputManager.isBlocked) return;
     actions.onTileTapped(context, GridPosition(pos.x, pos.y));
   }
   ```

3. Update `BattleActions` to use controller instead of overlay colors:
   - `_selectUnit()` -> add `controller.setSelected()` + `controller.setSelection()`
   - `_deselectUnit()` -> add `controller.setSelected(selected: false)` + `controller.clearHighlights()`

**Verification:** Tap unit -> green move tiles, red attack tiles appear. Tap empty -> clears. Tap enemy -> red border around attackable.

---

### Phase 4: Movement Animation (Engine Animation Queue)

**Goal:** Moving a unit uses the engine's animation queue with A* pathfinding.

**Files to modify:**
- `lib/features/battle/actions/battle_actions.dart` -- Replace `AnimationService.playMoveAnimation()` with engine move
- `lib/features/battle/services/animation_service.dart` -- Simplify to delegate to engine

**Implementation:**

1. Movement in `BattleActions._handleMoveWithAnimation()`:
   ```dart
   // Old: await animService.playMoveAnimation(unit.id, from, to);
   // New: Use engine animation queue with path
   final path = controller.findPath(
     map_engine.GridPosition(from.x, from.y),
     map_engine.GridPosition(to.x, to.y),
     grid: tileGrid,
     blocked: occupiedPositions,
   );

   if (path != null && path.length > 1) {
     for (int i = 1; i < path.length; i++) {
       final isLast = i == path.length - 1;
       controller.queueAnimation(AnimationEntry(
         execute: () async {
           controller.move(entity, path[i].x.toDouble(), path[i].y.toDouble());
           await Future.delayed(const Duration(milliseconds: 200));
         },
         onComplete: isLast ? () => _onMoveComplete(unit, to) : null,
       ));
     }
   }
   ```

2. Input blocking is automatic -- engine blocks during animation queue.

3. Update unit's game-logic position AFTER animation completes in `_onMoveComplete()`.

**Verification:** Tap unit, tap valid move tile -> unit slides along A* path step by step, then game state updates.

---

### Phase 5: Combat Animations (Attack + Damage + Defeat)

**Goal:** Attack sequence uses engine's attack(), showFloatingText(), and die() instead of Flutter overlay widgets.

**Files to modify:**
- `lib/features/battle/actions/battle_actions.dart` -- Replace attack animation sequence

**Implementation:**

1. Attack sequence in `BattleActions.onAttackUnit()`:
   ```dart
   // Step 1: Attack lunge animation
   final attackerComp = controller.getComponentById(attacker.id) as FiftyMovableComponent;
   controller.queueAnimation(AnimationEntry.timed(
     action: () => attackerComp.attack(),
     duration: const Duration(milliseconds: 400),
   ));

   // Step 2: Damage popup
   controller.queueAnimation(AnimationEntry.timed(
     action: () {
       controller.showFloatingText(
         map_engine.GridPosition(target.position.x, target.position.y),
         '-${result.damageDealt}',
         color: FiftyColors.powderBlush,
       );
       // Update HP bar
       controller.updateHP(target.id, target.hpRatio);
     },
     duration: const Duration(milliseconds: 800),
   ));

   // Step 3: Defeat (if killed)
   if (target.isDead) {
     final targetComp = controller.getComponentById(target.id) as FiftyMovableComponent;
     controller.queueAnimation(AnimationEntry.timed(
       action: () => targetComp.die(),
       duration: const Duration(milliseconds: 500),
       onComplete: () {
         controller.removeEntity(targetEntity);
         controller.removeDecorators(target.id);
       },
     ));
   }
   ```

2. Flash effect: The engine doesn't have a built-in flash. Options:
   - **Option A:** Skip flash (barely visible at 150ms, low priority)
   - **Option B:** Swap sprite to white version briefly via `swapSprite()` then swap back
   - **Recommendation:** Option A (skip). The attack lunge + damage popup is sufficient feedback.

3. Audio triggers remain in the same places in `BattleActions` -- they don't depend on the rendering system.

**Verification:** Attack -> lunge animation -> "-N" damage popup rises and fades -> if killed, unit fades out and is removed.

---

### Phase 6: Game Restart + AI Turn Sync

**Goal:** Game restart properly resets the engine. AI turns sync visual updates.

**Files to modify:**
- `lib/features/battle/views/widgets/engine_board_widget.dart` -- Handle restart
- `lib/features/battle/actions/battle_actions.dart` -- AI turn visual sync

**Implementation:**

1. Game restart:
   ```dart
   void _restartGame() {
     controller.clearHighlights();
     controller.cancelAnimations();
     controller.clear();  // Remove all entities

     viewModel.startNewGame();  // Reset game state

     // Re-create entities from fresh game state
     final newEntities = _buildEntities(viewModel.gameState.value);
     controller.addEntities(newEntities);

     // Re-apply decorators after frame
     WidgetsBinding.instance.addPostFrameCallback((_) => _applyDecorators());
   }
   ```

2. AI turn sync -- AI moves units via `BattleViewModel`, which updates `gameState`. The engine board widget observes state changes and:
   - Queues move animations for AI unit movements
   - Queues attack animations for AI attacks
   - Updates HP bars after AI attacks
   - All with the "ENEMY THINKING..." delay from current implementation

3. End of turn: when turn switches, clear highlights, deselect, re-enable input.

**Verification:** Full game with AI opponent plays correctly. Restart resets board cleanly.

---

### Phase 7: Camera + Polish

**Goal:** Add camera controls, remove old files, final polish.

**Files to modify:**
- `lib/features/battle/views/widgets/engine_board_widget.dart` -- Camera setup

**Files to DELETE:**
- `lib/features/battle/views/widgets/board_widget.dart` (old GridView.builder)
- `lib/features/battle/views/widgets/unit_sprite_widget.dart` (old unit rendering)
- `lib/features/battle/views/widgets/animated_board_overlay.dart` (old animation overlay)
- `lib/features/battle/views/widgets/animated_unit_sprite.dart` (old animation widget)
- `lib/features/battle/views/widgets/damage_popup.dart` (old damage popup)

**Implementation:**

1. Camera setup:
   ```dart
   // Initial camera position
   WidgetsBinding.instance.addPostFrameCallback((_) {
     controller.centerMap();
     // Optional: slight zoom out for full board visibility
   });
   ```

2. Camera is built-in: pan (drag), zoom (pinch), center (programmatic). No code needed beyond initial setup.

3. Clean up imports in `battle_page.dart` and `battle_actions.dart`.

4. Remove `animated_board_overlay.dart` dependency from `AnimationService` if any remain.

---

### Phase 8: Testing + Verification

**Goal:** All tests pass, manual QA confirms feature parity.

**Automated:**
- Run `flutter analyze` in `apps/tactical_grid/` -- zero issues
- Run `flutter test` in `apps/tactical_grid/` -- all 278+ tests pass
- Run `flutter test` in `packages/fifty_map_engine/` -- all 122 tests pass

**Manual QA:**
- [ ] Board renders 8x8 with correct tile textures
- [ ] All 12 units visible with sprites, team borders, HP bars
- [ ] Tap unit -> highlights valid moves (green) and attack range (red)
- [ ] Tap valid move -> unit slides along path
- [ ] Tap enemy -> attack lunge, damage popup, HP bar updates
- [ ] Kill unit -> fade out + remove
- [ ] Ability targeting works (Fireball, Shoot, Rally)
- [ ] AI opponent plays correctly with visual delays
- [ ] Turn timer fires and auto-skips
- [ ] All audio plays at correct moments
- [ ] Game over overlay displays correctly
- [ ] Restart resets board cleanly
- [ ] Camera pan/zoom works (bonus feature)

---

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| GridPosition import conflicts (two packages export same name) | High | Use import alias: `as map_engine` |
| Animation timing differs from current Flutter animations | Medium | Match durations exactly (300ms move, 400ms attack, 800ms damage, 500ms defeat) |
| Engine tile size (64px) doesn't match current tile sizing | Low | Engine handles viewport scaling automatically |
| AI turn visual sync race conditions | Medium | Use animation queue completion callbacks (same pattern as example app) |
| Existing tests break due to widget tree changes | Low | Game logic tests are model-only, no widget dependencies |

---

## File Inventory

### New Files (1)
- `lib/features/battle/views/widgets/engine_board_widget.dart`

### Modified Files (3)
- `lib/features/battle/views/battle_page.dart` (swap widget reference)
- `lib/features/battle/actions/battle_actions.dart` (engine controller calls)
- `lib/features/battle/services/animation_service.dart` (simplify to engine delegation)

### Deleted Files (5)
- `lib/features/battle/views/widgets/board_widget.dart`
- `lib/features/battle/views/widgets/unit_sprite_widget.dart`
- `lib/features/battle/views/widgets/animated_board_overlay.dart`
- `lib/features/battle/views/widgets/animated_unit_sprite.dart`
- `lib/features/battle/views/widgets/damage_popup.dart`

### Unchanged Files (everything else)
All game logic, models, services, AI, audio, timer, UI chrome remain untouched.

---

## Reference Implementation

The engine example app serves as the complete reference:
`packages/fifty_map_engine/example/lib/main.dart`

Key patterns to follow:
1. **Asset registration** (lines 30-50): `FiftyAssetLoader.registerAssets([...])`
2. **Grid setup** (lines 100-130): `TileGrid(width, height)` + `grid.fill()` + `grid.setTile()`
3. **Entity creation** (lines 140-180): `FiftyMapEntity(id, type, asset, gridPosition, blockSize)`
4. **Widget construction** (lines 200-210): `FiftyMapWidget(grid, controller, initialEntities, onTileTap)`
5. **Decorator application** (lines 220-250): post-frame `setTeamColor`, `updateHP`, `addStatusIcon`
6. **Selection flow** (lines 300-350): `setSelected` + `setSelection` + `highlightTiles` + `clearHighlights`
7. **Movement** (lines 400-430): `findPath` + `queueAnimation` + `move`
8. **Attack sequence** (lines 450-510): `attack()` + `showFloatingText()` + `updateHP()` + `die()`
9. **Game reset** (lines 550-580): `clearHighlights` + `cancelAnimations` + `clear` + `addEntities`

Every pattern in the tactical grid migration has a working example in this file.

---

**Estimated Effort:** M (2-3 days)
**Complexity Downgrade Justification:** Every capability needed already exists in the engine. The example app demonstrates every pattern. No new engine features needed. No API gaps to fill. This is integration work, not engineering work.
