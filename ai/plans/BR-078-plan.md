# BR-078 Implementation Plan: Tactical Skirmish Sandbox

**Brief:** BR-078
**Complexity:** M (Medium)
**Auto-approved:** Yes (S/M complexity)
**Phases:** 12

## Critical Finding: Asset Requirement

Engine crashes if no assets registered (`FiftyAssetLoader.loadAll()`) or if entity asset is empty (`FiftyBaseComponent.onLoad()`). Resolution: Option B - 2-line engine guard.

## Phases

### Phase 0: Engine Guard (2-line fix)
- Guard `map_builder.dart` line ~155: skip `loadAll` if no assets registered
- Guard `component.dart` line ~69: try/catch sprite loading for empty asset

### Phase 1: Cleanup Old Example
- Delete 8 old example files
- Update pubspec.yaml (remove provider, get_it, FDL deps)

### Phase 2-3: Game Data + State Model
- 4 terrain TileTypes with color fallback
- UnitData class, 6 unit configurations
- GameState class (turn tracking, selection, HP)

### Phase 4-5: Widget + Entity Creation
- main(), TacticalSkirmishApp, TacticalSkirmishPage (StatefulWidget)
- FiftyMapEntity for each unit, decorator setup post-spawn

### Phase 6-9: Game Logic
- Tile tap handler (main game loop)
- Selection + range visualization (BFS movement, attack range)
- Movement via A* pathfinding + animation queue
- Attack with damage popup + HP bar + death handling

### Phase 10-11: Turn Management + Win Condition
- Team switching, state reset
- Victory overlay + restart

### Phase 12: Verification
- 19/21 feature audit
- flutter analyze + flutter test

## Files

| File | Action |
|------|--------|
| `example/lib/app/map_demo_app.dart` | DELETE |
| `example/lib/core/di/service_locator.dart` | DELETE |
| `example/lib/features/**/*.dart` (6 files) | DELETE |
| `example/lib/main.dart` | REPLACE |
| `example/pubspec.yaml` | MODIFY |
| `lib/src/view/map_builder.dart` | MODIFY (guard) |
| `lib/src/components/base/component.dart` | MODIFY (guard) |
