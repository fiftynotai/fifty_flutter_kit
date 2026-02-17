# BR-071 TACTICAL GRID - Phase 1 Implementation Plan

**Generated:** 2026-02-04
**Brief:** BR-071 (TACTICAL GRID)
**Phase:** 1 (MVP)
**Complexity:** L (Large)
**Est. Duration:** 5-7 hours with parallelization

---

## Summary

Build MVP foundation for TACTICAL GRID - a turn-based tactics game showcasing fifty_flutter_kit.

**Phase 1 Deliverables:**
- Project setup with fifty_flutter_kit dependencies
- 8x8 grid board rendering via fifty_map_engine
- 3 basic unit types (Commander, Knight, Shield)
- Turn-based movement
- Adjacent-only combat
- Commander capture win condition
- Local 2-player hot-seat mode

---

## Project Structure

```
apps/tactical_grid/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   └── app.dart
│   ├── core/
│   │   ├── bindings/
│   │   │   └── initial_bindings.dart
│   │   ├── routes/
│   │   │   └── route_manager.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   └── presentation/
│   │       └── actions/
│   │           └── action_presenter.dart
│   ├── features/
│   │   ├── menu/
│   │   │   ├── menu_page.dart
│   │   │   ├── menu_view_model.dart
│   │   │   ├── menu_actions.dart
│   │   │   └── menu_bindings.dart
│   │   ├── battle/
│   │   │   ├── models/
│   │   │   │   ├── unit.dart
│   │   │   │   ├── position.dart
│   │   │   │   ├── board_state.dart
│   │   │   │   ├── game_state.dart
│   │   │   │   └── move.dart
│   │   │   ├── services/
│   │   │   │   ├── game_logic_service.dart
│   │   │   │   └── audio_coordinator.dart
│   │   │   ├── controllers/
│   │   │   │   └── battle_view_model.dart
│   │   │   ├── actions/
│   │   │   │   └── battle_actions.dart
│   │   │   ├── views/
│   │   │   │   ├── battle_page.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── board_widget.dart
│   │   │   │       ├── unit_info_panel.dart
│   │   │   │       └── turn_indicator.dart
│   │   │   └── battle_bindings.dart
│   │   └── settings/
│   │       └── settings_page.dart
│   └── shared/
├── assets/
│   ├── images/
│   │   ├── units/
│   │   └── board/
│   ├── audio/
│   │   ├── bgm/
│   │   └── sfx/
│   └── maps/
│       └── battle_board.json
├── android/
├── ios/
└── pubspec.yaml
```

---

## Implementation Phases

### Phase 1: Project Foundation (S) - 1-2h
- Create project structure
- Configure pubspec.yaml with dependencies
- Create main.dart with engine initialization
- Create app.dart with GetMaterialApp + FiftyTheme

### Phase 2: Core Architecture (S) - 2-3h
- Create action_presenter.dart (copy from fifty_demo)
- Create initial_bindings.dart
- Create route_manager.dart
- Create app_theme.dart

### Phase 3: Domain Models (M) - 3-4h
- position.dart (GridPosition with adjacency utils)
- unit.dart (UnitType enum, Unit class)
- board_state.dart (BoardState with valid moves)
- game_state.dart (GamePhase, GameResult, GameState)
- move.dart (MoveType, GameMove)

### Phase 4: Game Logic Service (M) - 3-4h
- Turn management (start, switch, end)
- Movement rules (per unit type)
- Combat resolution (damage, death)
- Win condition check (Commander capture)
- Initial army setup

### Phase 5: Audio Coordinator (S) - 1-2h
- BGM playback (battle theme)
- SFX groups (ui, combat, movement)
- Volume control integration

### Phase 6: Battle ViewModel (M) - 3-4h
- Reactive state (Rx observables)
- Unit selection
- Valid moves calculation
- Turn management
- Game flow orchestration

### Phase 7: Battle Actions (S) - 1-2h
- Tile selection handling
- Unit selection handling
- End turn logic
- Victory/defeat dialogs

### Phase 8: Map Integration (M) - 3-4h
- battle_board.json (8x8 grid definition)
- board_widget.dart (FiftyMapWidget wrapper)
- Entity registration (unit types)
- Tap handling override
- Move overlay system

### Phase 9: Battle Views (M) - 3-4h
- battle_page.dart (main layout)
- turn_indicator.dart (player turn, timer)
- unit_info_panel.dart (stats, action buttons)

### Phase 10: Menu Module (S) - 1-2h
- menu_page.dart (title, play/settings buttons)
- menu_view_model.dart
- menu_actions.dart
- menu_bindings.dart

### Phase 11: Assets (S) - 1-2h
- Placeholder unit sprites (6 images)
- Board texture
- Audio placeholders

### Phase 12: Integration & Testing (S) - 2-3h
- Wire up all bindings
- Test complete game flow
- Bug fixes and polish

---

## Key Models

```dart
// position.dart
class GridPosition {
  final int x;
  final int y;
  bool isAdjacent(GridPosition other);
  double distanceTo(GridPosition other);
  List<GridPosition> getAdjacentPositions();
}

// unit.dart
enum UnitType { commander, knight, shield }

class Unit {
  final String id;
  final UnitType type;
  final bool isPlayer;
  int hp;
  int maxHp;
  int attack;
  GridPosition position;
  bool get isDead => hp <= 0;
  int get movementRange;
}

// game_state.dart
enum GamePhase { placement, playing, gameOver }
enum GameResult { none, playerWin, opponentWin }

class GameState {
  final BoardState board;
  final bool isPlayerTurn;
  final int turnNumber;
  final GamePhase phase;
  final GameResult result;
  Unit? selectedUnit;
}
```

---

## Movement Rules

| Unit | Pattern | Range |
|------|---------|-------|
| Commander | Any direction | 1 tile |
| Knight | L-shape | 2+1 or 1+2 |
| Shield | Any direction | 1 tile |

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Fifty Flutter Kit
  fifty_tokens:
    path: ../../packages/fifty_tokens
  fifty_theme:
    path: ../../packages/fifty_theme
  fifty_ui:
    path: ../../packages/fifty_ui
  fifty_audio_engine:
    path: ../../packages/fifty_audio_engine
  fifty_map_engine:
    path: ../../packages/fifty_map_engine
  # State management
  get: ^4.6.6
  loader_overlay: ^4.0.3
```

---

## Acceptance Criteria

- [ ] Project builds and runs
- [ ] 8x8 grid board renders correctly
- [ ] 3 unit types display on board
- [ ] Player can select unit and see valid moves
- [ ] Player can move unit to valid tile
- [ ] Player can attack adjacent enemy unit
- [ ] Combat resolves correctly
- [ ] Turn alternates between players
- [ ] Game ends when Commander captured
- [ ] Victory/Defeat dialog displays
- [ ] BGM plays during match
- [ ] SFX plays for moves/attacks
