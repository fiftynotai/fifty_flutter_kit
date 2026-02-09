# BR-071: TACTICAL GRID - Async Strategy Board Game

**Type:** Feature / New App
**Priority:** P1 - High
**Status:** In Progress
**Effort:** L - Large
**Module:** apps/tactical_grid (new)
**Created:** 2026-02-04

---

## Problem

There is no compelling showcase app that demonstrates the full capabilities of the fifty_flutter_kit ecosystem working together. The current demos show individual packages in isolation, but don't demonstrate how they combine to create an immersive game experience.

Mobile gamers also lack a polished async tactics game that feels native to touch interfaces with proper audio feedback and a unique visual identity.

---

## Goal

Build **TACTICAL GRID** - a 1v1 turn-based strategy game that showcases:
- **fifty_map_engine**: Grid-based board, unit entities, movement animations
- **fifty_audio_engine**: BGM, SFX for moves/attacks, voice announcer
- **fifty_speech_engine**: Voice commands for moves (optional)
- **fifty_ui**: FDL-styled cards, buttons, dialogs
- **fifty_tokens**: Consistent visual design language

The game should be fun, replayable, and demonstrate premium mobile game quality.

---

## Game Overview

### Concept
Chess-like tactics game where players control unique units with special abilities on an 8x8 grid. Capture the enemy Commander or hold objectives to win.

### Core Loop
```
SELECT UNITS → PLACE ON BOARD → TAKE TURNS → MOVE/ATTACK/USE ABILITY → WIN
```

### Match Modes
1. **Local 1v1** - Pass and play on same device
2. **vs AI** - Single player against computer opponent
3. **Async Online** - Take turns when convenient (future)

---

## Unit Roster

| Unit | HP | ATK | Movement | Ability | Cooldown |
|------|-----|-----|----------|---------|----------|
| **Commander** | 5 | 2 | 1 tile (any) | Rally: +1 ATK to adjacent allies | 3 turns |
| **Knight** | 3 | 3 | L-shape | Charge: +2 damage if moved this turn | Passive |
| **Archer** | 2 | 2 | 2 tiles (orthogonal) | Shoot: Attack at range 3 | 2 turns |
| **Shield** | 4 | 1 | 1 tile (any) | Block: Take 50% damage next hit | 2 turns |
| **Mage** | 2 | 3 | 2 tiles (diagonal) | Fireball: Hit 3x3 area (1 damage) | 3 turns |
| **Scout** | 2 | 1 | 3 tiles (any) | Reveal: Show traps in 2-tile radius | 2 turns |

### Army Composition
Each player selects **6 units** (must include 1 Commander)

---

## Board Design

### Grid
- 8x8 tile grid
- Dark/light alternating tiles (FDL colors)
- Grid coordinates (A1-H8)

### Terrain Types
| Terrain | Effect | Visual |
|---------|--------|--------|
| **Normal** | No effect | Standard tile |
| **Objective** | Hold for 3 turns to win | Flag marker (event) |
| **Power-up** | Grants buff when stepped on | Star marker (event) |
| **Obstacle** | Blocks movement | Rock/pillar (furniture) |
| **Trap** | Deals 1 damage (hidden) | Revealed by Scout |

### Starting Positions
```
  A B C D E F G H
8 [Enemy placement zone - rows 7-8]
7 [                               ]
6 [                               ]
5 [        Objectives             ]
4 [        Objectives             ]
3 [                               ]
2 [                               ]
1 [Player placement zone - rows 1-2]
```

---

## Turn Structure

### Player Turn
1. **Select Unit** - Tap unit to see movement range highlighted
2. **Move** (optional) - Tap valid tile to move (animated)
3. **Action** (pick one):
   - **Attack** - If enemy adjacent, deal damage
   - **Ability** - Use unit's special (if off cooldown)
   - **Wait** - Do nothing
4. **End Turn** - Tap button or voice command "End turn"

### Turn Timer
- 60 seconds per turn (configurable)
- Visual countdown bar
- Audio warning at 10 seconds

---

## Win Conditions

| Condition | Description |
|-----------|-------------|
| **Regicide** | Capture enemy Commander |
| **Domination** | Eliminate all enemy units |
| **Objective** | Hold center objective for 3 consecutive turns |

---

## fifty_flutter_kit Integration

### fifty_map_engine

| Feature | Implementation |
|---------|----------------|
| Game board | Room entity (8x8 grid texture) |
| Units | Character/monster entities |
| Objectives | Event markers (flag icon) |
| Power-ups | Event markers (star icon) |
| Obstacles | Furniture entities |
| Movement | `FiftyMovableComponent.moveTo()` |
| Selection | `onEntityTap` callback |
| Camera | `centerOnEntity()` for action focus |
| Highlights | Overlay entities for valid moves |

### fifty_audio_engine

| Feature | Implementation |
|---------|----------------|
| Battle BGM | Playlist: calm_strategy.mp3, tense_battle.mp3, victory.mp3 |
| Move SFX | footstep.mp3, slide.mp3 |
| Attack SFX | sword_clash.mp3, arrow_hit.mp3, magic_blast.mp3 |
| Capture SFX | capture.mp3, defeat.mp3 |
| UI SFX | select.mp3, confirm.mp3, cancel.mp3 |
| Announcer | Voice channel with BGM ducking |
| Turn warning | tick.mp3 at 10s, alarm.mp3 at 5s |

### fifty_speech_engine (Optional)

| Feature | Implementation |
|---------|----------------|
| Voice commands | "Move knight to C5", "Attack", "End turn" |
| Move parsing | Extract unit + coordinate from speech |

### fifty_ui

| Component | Usage |
|-----------|-------|
| FiftyCard | Unit stat cards, game info panels |
| FiftyButton | End turn, abilities, menu |
| FiftyIconButton | Quick actions |
| FiftyProgressBar | Turn timer, HP bars |
| FiftyDialog | Match start, victory/defeat, pause |
| FiftySlider | Volume settings |

---

## Screen Flows

### 1. Main Menu
```
┌─────────────────────────────┐
│      TACTICAL GRID          │
│                             │
│    [ PLAY ]                 │
│    [ ARMY ]                 │
│    [ SETTINGS ]             │
│                             │
└─────────────────────────────┘
```

### 2. Army Builder
- Select 6 units from roster
- View unit stats
- Save army presets

### 3. Match Setup
- Select game mode (Local/AI)
- Select difficulty (Easy/Medium/Hard)
- Placement phase

### 4. Battle Screen
- Game board (center)
- Selected unit info (bottom)
- Turn indicator (top)
- End turn button
- Ability buttons

### 5. Victory/Defeat
- Match stats
- XP earned (future)
- Rematch / Main Menu

---

## Audio Design

### BGM Playlist
| Track | When |
|-------|------|
| `menu_theme.mp3` | Main menu |
| `army_builder.mp3` | Army selection |
| `battle_calm.mp3` | Early game (>50% units alive) |
| `battle_tense.mp3` | Late game (<50% units alive) |
| `victory_fanfare.mp3` | Win screen |
| `defeat_somber.mp3` | Lose screen |

### Announcer Lines
| Event | Line |
|-------|------|
| Match start | "Battle begins!" |
| Unit captured | "Knight captured!" |
| Ability used | "Fireball!" |
| Low HP | "Commander in danger!" |
| Objective held | "Objective secured!" |
| Turn warning | "Ten seconds remaining" |
| Victory | "Victory is yours!" |
| Defeat | "You have been defeated" |

---

## Visual Style

### FDL Colors
| Element | Color |
|---------|-------|
| Player units | Burgundy #88292f |
| Enemy units | Slate Grey #335c67 |
| Board dark | Deep Dark #1a0d0e |
| Board light | Slate Grey #335c67 (20% opacity) |
| Selection | Cream #fefee3 (glow) |
| Valid moves | Hunter Green #4b644a (overlay) |
| Attack range | Burgundy #88292f (overlay) |
| UI accents | Powder Blush #ffc9b9 |

### Unit Sprites
Generate FDL-styled unit sprites:
- Minimal detail, icon-like
- Clear silhouettes
- Burgundy vs Slate color coding
- 64x64 px base size

---

## Technical Architecture

### Project Structure
```
apps/tactical_grid/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── bindings/
│   │   ├── routes/
│   │   └── theme/
│   ├── features/
│   │   ├── menu/
│   │   ├── army_builder/
│   │   ├── battle/
│   │   │   ├── models/
│   │   │   │   ├── unit.dart
│   │   │   │   ├── board.dart
│   │   │   │   ├── game_state.dart
│   │   │   │   └── move.dart
│   │   │   ├── services/
│   │   │   │   ├── game_logic_service.dart
│   │   │   │   ├── ai_service.dart
│   │   │   │   └── audio_coordinator.dart
│   │   │   ├── controllers/
│   │   │   ├── actions/
│   │   │   └── views/
│   │   └── settings/
│   └── shared/
├── assets/
│   ├── audio/
│   │   ├── bgm/
│   │   ├── sfx/
│   │   └── voice/
│   ├── images/
│   │   ├── units/
│   │   ├── board/
│   │   └── ui/
│   └── maps/
│       └── battle_board.json
└── pubspec.yaml
```

### Key Classes

```dart
// Unit model
class Unit {
  final String id;
  final UnitType type;
  final int hp;
  final int maxHp;
  final int attack;
  final Position position;
  final bool isPlayer;
  final int abilityCooldown;
}

// Board state
class BoardState {
  final List<Unit> units;
  final List<Tile> tiles;
  final List<Objective> objectives;

  List<Position> getValidMoves(Unit unit);
  List<Unit> getAttackTargets(Unit unit);
}

// Game state
class GameState {
  final BoardState board;
  final bool isPlayerTurn;
  final int turnNumber;
  final int objectiveHoldCount;
  final GameResult? result;
}
```

---

## Implementation Phases

### Phase 1: Core (MVP)
**Effort: M | Duration: ~1 week**
- [ ] Project setup with fifty_flutter_kit dependencies
- [ ] Board rendering with fifty_map_engine
- [ ] Basic unit entities (Commander, Knight, Shield)
- [ ] Turn-based movement
- [ ] Simple attack (adjacent only)
- [ ] Win condition: Commander capture
- [ ] Local 2-player mode

### Phase 2: Polish
**Effort: M | Duration: ~1 week**
- [ ] All 6 unit types with abilities
- [ ] Movement animations
- [ ] Attack animations
- [ ] BGM integration
- [ ] SFX for all actions
- [ ] Turn timer
- [ ] Valid move highlighting

### Phase 3: AI & Audio
**Effort: M | Duration: ~1 week**
- [ ] Basic AI opponent
- [ ] Voice announcer
- [ ] Objective win condition
- [ ] Power-ups
- [ ] Obstacles/terrain
- [ ] Victory/defeat screens

### Phase 4: Enhancement
**Effort: S | Duration: ~3 days**
- [ ] Army builder
- [ ] Settings screen
- [ ] Voice commands (optional)
- [ ] Match replay
- [ ] Polish and testing

---

## Acceptance Criteria

### Must Have
- [ ] 8x8 grid board renders correctly
- [ ] Units can be selected and moved
- [ ] Turn alternates between players
- [ ] Combat resolves correctly
- [ ] Game ends when Commander captured
- [ ] BGM plays during match
- [ ] SFX plays for moves/attacks
- [ ] FDL visual style throughout

### Should Have
- [ ] All 6 unit types with unique abilities
- [ ] AI opponent (at least Easy mode)
- [ ] Voice announcer for key events
- [ ] Movement/attack animations
- [ ] Turn timer with audio warning

### Nice to Have
- [ ] Voice commands
- [ ] Multiple AI difficulties
- [ ] Army customization
- [ ] Match statistics

---

## Dependencies

### Packages
- fifty_map_engine: ^latest
- fifty_audio_engine: ^latest
- fifty_speech_engine: ^latest
- fifty_ui: ^latest
- fifty_tokens: ^latest
- get: ^4.x (state management)
- flame: ^1.x (via map engine)

### Assets Required
- 6 unit sprites (player variants)
- 6 unit sprites (enemy variants)
- Board texture
- Event markers (objective, power-up)
- UI elements (buttons, panels)
- BGM tracks (6)
- SFX sounds (~20)
- Voice lines (~15)

---

## Success Metrics

| Metric | Target |
|--------|--------|
| Match completion rate | >80% |
| Avg match duration | 5-10 minutes |
| Audio playing | 100% of matches |
| Crash rate | <1% |
| User rating (if published) | >4.0 |

---

## Open Questions

1. **Async multiplayer** - Include in v1 or defer?
2. **Progression system** - XP/unlocks in scope?
3. **Platform** - Android only or iOS too?
4. **Monetization** - Free or paid? Ads?

---

## References

- Chess (grid movement)
- Fire Emblem (unit abilities)
- Into the Breach (tactical positioning)
- Clash Royale (short async matches)
- Polytopia (mobile-first tactics)

---

## Notes

This game is designed as a **showcase app** for the fifty_flutter_kit ecosystem. Every feature should demonstrate a kit capability. When in doubt, prioritize showing off the packages over adding game complexity.

The FDL aesthetic should make this feel premium and unique - not another generic mobile game.

### Asset Generation Dependency

**Unit art generation is blocked on igris-ai/BR-014 (Higgsfield MCP Server).**

The existing Higgsfield MCP only supports the Soul model, which is currently offline. igris-ai/BR-014 builds a new MCP server using the official `higgsfield-client` SDK with access to all models (Nano Banana Pro, Seedream 4.5, FLUX.2, etc.). Once BR-014 is complete:
- Generate 6 player unit sprites (burgundy #88292f theme)
- Generate 6 enemy unit sprites (slate grey #335c67 theme)
- Generate board textures and UI elements
- Use Nano Banana Pro or Seedream for best quality at 64x64 icon-style sprites
