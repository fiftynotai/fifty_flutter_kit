# Implementation Plan: BR-117

**Complexity:** M (Medium)
**Estimated Duration:** 3-4 hours
**Risk Level:** Low

## Summary

Replace the existing 727-line tactical skirmish sandbox example with a slim ~350-line FDL-styled tactical grid demo. The new example demonstrates grid rendering, entities with decorators, tile overlays, tap interaction, and pathfinding -- all wrapped in FiftyTheme with FDL tokens for UI chrome. No game logic, no turns, no AI, no MVVM.

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_world_engine/example/lib/main.dart` | REPLACE | New ~350-line FDL demo (single file) |
| `packages/fifty_world_engine/example/pubspec.yaml` | MODIFY | Add fifty_tokens, fifty_theme deps; bump SDK constraint |
| `packages/fifty_world_engine/README.md` | MODIFY | Update example section description |

### Files NOT Changed

| File | Reason |
|------|--------|
| `apps/tactical_grid/**` | Explicit constraint: do NOT modify |
| Example platform dirs (android/, ios/, etc.) | Keep as-is; flutter create scaffold is fine |
| Example assets (`assets/images/units/`, `assets/images/tiles/`) | Reuse existing sprites; no new assets needed |
| `analysis_options.yaml` | Current config is fine |

## Implementation Steps

### Phase 1: Update pubspec.yaml

**File:** `packages/fifty_world_engine/example/pubspec.yaml`

1. Change description to `"FDL Tactical Grid Demo - fifty_world_engine showcase"`
2. Keep SDK constraint as `^3.6.0` (compatible with both `fifty_theme` and `fifty_world_engine`)
3. Add dependencies:
   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     fifty_world_engine:
       path: ../
     fifty_tokens:
       path: ../../fifty_tokens
     fifty_theme:
       path: ../../fifty_theme
   ```
   Note: `flame` dependency is NO LONGER listed directly -- `fifty_world_engine` brings it transitively, and the example must NOT import Flame directly (acceptance criterion #8).
4. Remove the `flame: ^1.30.1` direct dependency.
5. Keep `flutter_lints: ^5.0.0` in dev_dependencies.
6. Keep existing asset declarations (`assets/images/units/`, `assets/images/tiles/`) -- the demo reuses these sprites.

### Phase 2: Replace main.dart

**File:** `packages/fifty_world_engine/example/lib/main.dart`

Single-file architecture (~350 lines). Structure:

```
// File header comment with link to apps/tactical_grid/
// Imports (flutter, fifty_world_engine, fifty_tokens, fifty_theme)

// SECTION 1: Tile Type Definitions (~15 lines)
// SECTION 2: Demo Data (~50 lines)
// SECTION 3: App Entry Point (~20 lines)
// SECTION 4: DemoPage StatefulWidget (~250 lines)
// SECTION 5: Info Panel Helper Widget (~30 lines)
```

#### Section 1: Tile Type Definitions

Four terrain types using `TileType` with color-only rendering (no asset sprites needed, since the engine falls back to `color` when `asset` is null or missing). This is actually cleaner for the demo since it avoids asset-loading complexity:

```dart
const _grass = TileType(
  id: 'grass',
  color: Color(0xFF4CAF50),  // Green
  walkable: true,
  movementCost: 1.0,
);
const _forest = TileType(
  id: 'forest',
  color: Color(0xFF2E7D32),  // Dark green
  walkable: true,
  movementCost: 2.0,
);
const _water = TileType(
  id: 'water',
  color: Color(0xFF1565C0),  // Blue
  walkable: false,
);
const _wall = TileType(
  id: 'wall',
  color: Color(0xFF5D4037),  // Brown
  walkable: false,
);
```

Actually, the existing example already has tile sprites (`tiles/tile_light.png`, `tiles/tile_dark.png`, `tiles/tile_obstacle.png`, `tiles/tile_trap.png`). Use them WITH color fallbacks:

```dart
const _grass = TileType(
  id: 'grass',
  asset: 'tiles/tile_light.png',
  color: Color(0xFF4CAF50),
  walkable: true,
  movementCost: 1.0,
);
const _forest = TileType(
  id: 'forest',
  asset: 'tiles/tile_dark.png',
  color: Color(0xFF2E7D32),
  walkable: true,
  movementCost: 2.0,
);
const _water = TileType(
  id: 'water',
  asset: 'tiles/tile_trap.png',
  color: Color(0xFF1565C0),
  walkable: false,
);
const _wall = TileType(
  id: 'wall',
  asset: 'tiles/tile_obstacle.png',
  color: Color(0xFF5D4037),
  walkable: false,
);
```

#### Section 2: Demo Data

A function `_buildGrid()` that creates a `TileGrid(width: 8, height: 8)`:
- Fill with `_grass` (base terrain)
- `fillRect` a 2x2 forest patch at (2, 1)
- `fillRect` a 2x2 forest patch at (5, 5)
- `fillRect` a 2x1 water strip at (3, 3) and (4, 3) -- a river crossing
- Scatter 3-4 wall tiles as obstacles

A function `_buildEntities()` returning `List<FiftyWorldEntity>`:
- 3 "blue team" units using existing sprites:
  - `player_commander` at (1, 2)
  - `player_archer` at (1, 4)
  - `player_mage` at (1, 6)
- 3 "red team" units:
  - `enemy_commander` at (6, 1)
  - `enemy_archer` at (6, 3)
  - `enemy_mage` at (6, 5)

Each unit is a `FiftyWorldEntity` with `type: 'character'`, `blockSize: FiftyBlockSize(1, 1)`.

A simple data class or record for unit metadata:

```dart
/// Lightweight unit data for the demo.
class _DemoUnit {
  final String id;
  final String name;
  final String team; // 'blue' | 'red'
  final String asset;
  final int moveRange;
  final GridPosition position;
  const _DemoUnit({
    required this.id,
    required this.name,
    required this.team,
    required this.asset,
    required this.moveRange,
    required this.position,
  });
}
```

List of 6 `_DemoUnit` instances (const). No HP tracking, no attack logic -- just enough data to show decorators and movement ranges.

#### Section 3: App Entry Point

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FiftyAssetLoader.registerAssets([
    'units/player_commander.png',
    'units/player_archer.png',
    'units/player_mage.png',
    'units/enemy_commander.png',
    'units/enemy_archer.png',
    'units/enemy_mage.png',
    'tiles/tile_light.png',
    'tiles/tile_dark.png',
    'tiles/tile_obstacle.png',
    'tiles/tile_trap.png',
  ]);
  runApp(const FdlTacticalGridDemo());
}
```

Root widget:
```dart
class FdlTacticalGridDemo extends StatelessWidget {
  const FdlTacticalGridDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FDL Tactical Grid Demo',
      debugShowCheckedModeBanner: false,
      theme: FiftyTheme.dark(),   // FDL dark as primary
      darkTheme: FiftyTheme.dark(),
      home: const DemoPage(),
    );
  }
}
```

Uses `FiftyTheme.dark()` as the primary theme (FDL specifies dark as primary). No theme toggle needed -- the brief says "light/dark support" so the app should be wrapped in FiftyTheme. We can use `theme: FiftyTheme.light()` and `darkTheme: FiftyTheme.dark()` with `themeMode: ThemeMode.system` to support both modes.

#### Section 4: DemoPage StatefulWidget

State fields:
- `late FiftyWorldController _controller`
- `late TileGrid _grid`
- `String? _selectedUnitId` -- which unit is selected
- `bool _decoratorsApplied`

`initState`:
1. Create `_controller = FiftyWorldController()`
2. Build grid via `_buildGrid()`
3. Schedule post-frame decorator setup (same pattern as tactical_grid)

`_setupDecorators()`:
- For each `_DemoUnit`: set team color (blue = `FiftyColors.slateGrey`, red = `FiftyColors.burgundy`), add HP bar (all at 1.0), add status icon (first letter of unit name)
- Zoom out x2, center map

`_onTileTap(GridPosition pos)`:
- Look up if a unit is at that position
- If own unit: select it, show movement range via `getMovementRange` + `highlightTiles`
- If highlighted tile and unit selected: move unit (simple path animation)
- Otherwise: deselect

`_onEntityTap(FiftyWorldEntity entity)`:
- No-op (all input through tile tap, same pattern as the real app)

`build`:
- `Scaffold` with:
  - `AppBar` using FDL tokens: title styled with `Theme.of(context).textTheme.titleMedium`, background from theme
  - Body: `Column` with:
    - `Expanded` child: `FiftyWorldWidget(grid: _grid, controller: _controller, ...)`
    - Bottom info panel: `Container` with FDL styling showing:
      - Selected unit name or "Tap a unit to select"
      - Terrain legend (4 colored dots with labels)

Key interactions demonstrated:
1. **Grid rendering** -- 8x8 with 4 terrain types (grass, forest, water, wall)
2. **Entity placement** -- 6 units with team borders, HP bars, status icons
3. **Tile selection** -- tap unit to select, yellow highlight on selected tile
4. **Movement range overlays** -- BFS range shown as green overlay tiles
5. **Pathfinding + movement** -- tap highlighted tile to move unit along A* path
6. **Camera controls** -- pan/zoom built into the engine (gesture-based)

No attack logic. No turns. No win conditions. Just demonstrate the API.

#### Section 5: Info Panel

A small bottom panel (~60px tall) styled with FDL:
- Background: `Theme.of(context).colorScheme.surface`
- Selected unit info or instruction text
- Uses `FiftySpacing.md` for padding, theme textTheme for typography
- Optional: terrain legend row with 4 small colored circles + labels

### Phase 3: Update README

**File:** `packages/fifty_world_engine/README.md`

1. Update the last paragraph of the README (line 681) that describes the example:
   - Old: "See the [example directory](example/) for a complete tactical skirmish sandbox showcasing tile grid rendering, camera controls, entity spawning with team decorators, A* pathfinding, animation queues, and tap interaction."
   - New: "See the [example directory](example/) for a concise FDL-styled tactical grid demo showcasing tile grid rendering, entity decorators (HP bars, team borders, status icons), tile overlays, A* pathfinding, and tap interaction -- all themed with the Fifty Design Language. For a full-featured tactical game, see [apps/tactical_grid/](../../apps/tactical_grid/)."

2. No other README changes required at this stage. Screenshots will be captured after implementation as a follow-up task.

## Architecture

### Single-File Design

The example is a single `main.dart` file (~350 lines). This is intentional:
- Package examples should be immediately scannable
- A developer opening the example should see everything in one file
- No need for separate model files, widgets, or routing for this scope

### What the Demo Shows

| Engine Feature | How Demonstrated |
|----------------|-----------------|
| TileGrid | 8x8 grid with 4 terrain types |
| TileType | Grass, forest (2x cost), water (unwalkable), wall (unwalkable) |
| FiftyWorldWidget | Embedded in Scaffold body |
| FiftyWorldController | Entity management, camera, highlights, decorators |
| Entity spawning | 6 units (3 blue, 3 red) via `addEntities` |
| Team borders | setTeamColor (slateGrey for blue, burgundy for red) |
| HP bars | updateHP (all at 100%) |
| Status icons | addStatusIcon (unit type initial) |
| Tile overlays | highlightTiles with HighlightStyle.validMove |
| Selection | setSelection + setSelected |
| Movement range | getMovementRange (BFS with budget) |
| Pathfinding | findPath (A* for movement animation) |
| Animation queue | queueAnimation for step-by-step movement |
| Camera | Pan/zoom built-in, programmatic zoomOut + centerMap |

### What the Demo Does NOT Show

- Attack/combat (out of scope)
- Turn management (out of scope)
- Game state / win conditions (out of scope)
- AI opponent (see `apps/tactical_grid/`)
- Audio / achievements / settings

## Grid Layout

```
  0 1 2 3 4 5 6 7
0 . . F F . . . .    F = Forest
1 . B F F . . R .    W = Wall
2 . B . . . . R .    ~ = Water
3 . . . ~ ~ . . .    . = Grass
4 . B . . . R . .    B = Blue unit
5 . . . . . F F .    R = Red unit
6 . B . . . F F .
7 . . . . . . . W
```

(Approximate layout -- exact positions from _DemoUnit list and _buildGrid)

Blue team (left side): Commander (1,1), Archer (1,4), Mage (1,6)
Red team (right side): Commander (6,1), Archer (6,3), Mage (6,5)
Forest patches: (2,0)-(3,1) and (5,5)-(6,6)
Water strip: (3,3)-(4,3)
Walls: (0,0) corner and (7,7) corner

## FDL Integration

### Theme
- App wrapped in `FiftyTheme.dark()` (primary) + `FiftyTheme.light()` via `theme`/`darkTheme`
- All UI chrome (AppBar, bottom panel, card) styled by FiftyTheme automatically

### Color Tokens Used
| Token | Usage |
|-------|-------|
| `FiftyColors.burgundy` | Red team border color |
| `FiftyColors.slateGrey` | Blue team border color |
| `FiftyColors.cream` | Available via theme for light mode text |
| `FiftyColors.darkBurgundy` | Available via theme for dark mode background |
| `FiftyColors.surfaceDark` | Bottom info panel background (via colorScheme.surface) |

### Spacing Tokens Used
| Token | Usage |
|-------|-------|
| `FiftySpacing.sm` (8px) | Icon-to-label gaps in legend |
| `FiftySpacing.md` (12px) | Info panel padding |
| `FiftySpacing.lg` (16px) | AppBar/panel internal spacing |

### Typography
- All text via `Theme.of(context).textTheme` which is already Manrope from FiftyTheme
- AppBar title: `titleMedium` (18px, bold)
- Info panel text: `bodyMedium` (14px)
- Legend labels: `bodySmall` (12px)

### No fifty_ui Dependency
The brief targets ~250-500 lines. Adding `fifty_ui` would introduce FiftyButton, FiftyCard, etc. but the example's UI chrome is minimal enough to use standard Material widgets themed by FiftyTheme. This keeps the dependency footprint small and the focus on the world engine.

## README Updates

Update the example description in `packages/fifty_world_engine/README.md`:
- Reference "FDL-styled tactical grid demo" instead of "tactical skirmish sandbox"
- Add link to `apps/tactical_grid/` for the full experience
- Screenshots: deferred to post-implementation (manual capture needed)

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Tile sprites don't match terrain intent | Low | Low | TileType has `color` fallback; sprites are already used in the old example |
| google_fonts network dependency in example | Low | Medium | fifty_theme already handles this; fonts are cached after first load |
| FiftyTheme.dark() conflicts with Flame rendering | Very Low | Medium | The real tactical_grid app already uses FDL theme without issues; FiftyWorldWidget renders in its own Flame canvas independent of Material theme |
| Example exceeds 500 line target | Low | Low | Plan targets ~350 lines; no game logic keeps it lean |
| Missing asset registration causes blank sprites | Low | Medium | Reuse exact same asset list from old example; already proven to work |

## Testing Strategy

1. **Manual: Launch** -- Run example on iOS/Android simulator, verify grid renders with all 4 terrain types
2. **Manual: FDL theming** -- Verify AppBar, bottom panel, and overall chrome use FDL colors/typography
3. **Manual: Unit decorators** -- Verify all 6 units show team borders (blue=slateGrey, red=burgundy), HP bars, status icons
4. **Manual: Tap interaction** -- Tap a unit, verify selection highlight + movement range overlay appears
5. **Manual: Movement** -- Tap a highlighted tile, verify unit moves along path
6. **Manual: Camera** -- Pinch to zoom, drag to pan
7. **Analyzer: `flutter analyze`** -- Must pass with zero issues
8. **No Flame imports** -- Grep example code for `package:flame` -- must not appear

## Notes for FORGER

- The current example is 727 lines. The new one should be ~350 lines. Do not add game logic (attack, turns, win conditions).
- Use the `_onEntityTap: (_) {}` pattern (no-op) and handle all interaction through `onTileTap`.
- For movement animation, use `queueAnimation` with step-by-step `findPath` + `move` (same pattern as old example lines 490-516, but simpler -- no turn management afterward).
- The `Vector2` import from `package:flame/components.dart` is needed for `FiftyWorldEntity.gridPosition`. Import it through the `fifty_world_engine` barrel export (it re-exports `Vector2` with a deprecation warning). Alternatively, the barrel exports it -- check if the example can use `GridPosition` instead. Looking at the entity model, `gridPosition` is `Vector2` type, so the import is needed. Use the re-export from `fifty_world_engine` barrel (deprecated but functional). The deprecation warning says to use `GridPosition` instead, but `FiftyWorldEntity.gridPosition` still requires `Vector2`. So import it from the barrel: `import 'package:fifty_world_engine/fifty_world_engine.dart';` which re-exports `Vector2`.
- Put the comment linking to `apps/tactical_grid/` in the file header doc comment.
