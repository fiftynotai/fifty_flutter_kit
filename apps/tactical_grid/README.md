# tactical_grid

> Turn-based tactical combat on a grid — Fifty Flutter Kit, battle-tested

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.0.0+-02569B?logo=flutter)](https://flutter.dev)
[![Tests](https://img.shields.io/badge/tests-382%20passing-success)](test/)

---

## Overview

`tactical_grid` is not just a game. It is a SHOWCASE — a live-fire demonstration of the entire Fifty Flutter Kit working in concert. Six packages. One battlefield. Every design token, every theme variant, every audio channel, every achievement unlock, every tile on the board is driven by the Fifty Design Language stack.

Deploy six distinct unit types on an 8x8 board. Outmaneuver your opponent. Capture their Commander. This is turn-based strategy built with Flutter, running on the full FDL pipeline from `fifty_tokens` to `fifty_map_engine`.

Play locally against a friend or challenge the AI across three difficulty levels. The game is real. The architecture is the point.

---

## Getting Started

```bash
# From the monorepo root
cd apps/tactical_grid

# Get dependencies
flutter pub get

# Deploy to a connected device or simulator
flutter run -d <device-id>
```

---

## Features

### Game Modes

- **Local 1v1** — Two players share one device, taking alternating turns
- **VS AI** — Play against an AI opponent with three difficulty levels:
  - **Easy** — Random valid moves, no tactical awareness
  - **Medium** — Prioritizes attacking, targets low-HP enemies, moves toward threats
  - **Hard** — Score-based evaluation considering damage, safety, abilities, and commander protection

### Unit Roster

Six combat units. Each with distinct movement patterns, stats, and special abilities.

| Unit | HP | ATK | Movement | Ability |
|------|:---:|:---:|----------|---------|
| Commander | 5 | 2 | 1 tile, any direction | **Rally:** +1 ATK to adjacent allies (3-turn cooldown) |
| Knight | 3 | 3 | L-shape (chess knight) | **Charge:** passive +2 damage if moved this turn |
| Shield | 4 | 1 | 1 tile, any direction | **Block:** 50% damage reduction on next hit (2-turn cooldown) |
| Archer | 2 | 2 | 2 tiles, orthogonal | **Shoot:** ranged attack at distance 3 (2-turn cooldown) |
| Mage | 2 | 2 | 2 tiles, diagonal | **Fireball:** 1 damage to 3x3 area (3-turn cooldown) |
| Scout | 2 | 1 | 3 tiles, any direction | **Reveal:** show traps in 2-tile radius (2-turn cooldown) |

### Win Condition

Capture (defeat) the enemy **Commander** to win the match. No point systems. No timers. One target. Total commitment.

### Board

8x8 grid with six custom tile textures (dark, light, objective, obstacle, powerup, trap), rendered using `fifty_map_engine` — a Flame-based isometric engine built for Fifty Flutter Kit.

### Audio

Full audio suite powered by `fifty_audio_engine`:

- **4 BGM tracks** — Menu theme, battle theme, victory fanfare, defeat theme
- **16 sound effects** — Sword slash, arrow shot, fireball cast, shield block, footsteps, hit, and more
- **19 voice lines** — Announcer lines for match start, unit captures, ability usage, commander warnings, victory, and defeat
- BGM ducking during voice announcements
- Per-channel volume control (BGM, SFX, Voice) with master mute

### Achievements

10 achievements tracked via `fifty_achievement_engine` across Combat, Strategy, and Mastery categories — from Common to Legendary rarity. First Blood, Commander Slayer, Flawless Victory, Tactician, Blitz. Earn them all or don't bother.

### Settings

A full settings page with persistent preferences:

- **Audio** — Master mute toggle, BGM / SFX / Voice volume sliders
- **Gameplay** — Default AI difficulty, turn timer duration, warning and critical thresholds
- **Display** — Dark / light theme toggle
- Reset to Defaults

### Turn Timer

Configurable countdown per turn (default 60 seconds). Warning at 10s, critical at 5s with audio cues. Auto-skips on timeout. Hesitation is defeat.

### Theme Support

Full light and dark mode support using `Theme.of(context).colorScheme` tokens across all pages. Dark mode is the primary environment. Light mode exists for those who insist.

---

## Screenshots

### Menu

<table>
  <tr>
    <td align="center"><strong>Dark</strong></td>
    <td align="center"><strong>Light</strong></td>
    <td align="center"><strong>Game Mode Select</strong></td>
  </tr>
  <tr>
    <td><img src="docs/screenshots/menu_dark.png" alt="Menu — Dark mode" width="250"/></td>
    <td><img src="docs/screenshots/menu_light.png" alt="Menu — Light mode" width="250"/></td>
    <td><img src="docs/screenshots/game_mode_select.png" alt="Game mode selection" width="250"/></td>
  </tr>
</table>

### Battle

<table>
  <tr>
    <td align="center"><strong>Gameplay</strong></td>
    <td align="center"><strong>Unit Selected</strong></td>
  </tr>
  <tr>
    <td><img src="docs/screenshots/battle_dark.png" alt="Battle gameplay" width="250"/></td>
    <td><img src="docs/screenshots/battle_unit_selected.png" alt="Unit selected with movement highlights" width="250"/></td>
  </tr>
</table>

### Settings

<table>
  <tr>
    <td align="center"><strong>Dark</strong></td>
    <td align="center"><strong>Light</strong></td>
  </tr>
  <tr>
    <td><img src="docs/screenshots/settings_dark.png" alt="Settings — Dark mode" width="250"/></td>
    <td><img src="docs/screenshots/settings_light.png" alt="Settings — Light mode" width="250"/></td>
  </tr>
</table>

### Achievements

<table>
  <tr>
    <td align="center"><strong>Dark</strong></td>
    <td align="center"><strong>Light</strong></td>
  </tr>
  <tr>
    <td><img src="docs/screenshots/achievements_dark.png" alt="Achievements — Dark mode" width="250"/></td>
    <td><img src="docs/screenshots/achievements_light.png" alt="Achievements — Light mode" width="250"/></td>
  </tr>
</table>

---

## Architecture

**Pattern:** MVVM + Actions (Fifty Flutter Kit architecture)

```
lib/
  features/
    battle/       # Game logic, AI, animations, audio, HUD
    settings/     # Settings MVVM module with persistence
    achievements/ # Achievement definitions and tracking
    menu/         # Main menu with game mode selection
```

- **State Management:** GetX
- **Routing:** Centralized `RouteManager` with 4 routes (menu, battle, settings, achievements)

---

## Tech Stack

### Fifty Flutter Kit Packages

| Package | Purpose |
|---------|---------|
| `fifty_tokens` | Design tokens (colors, spacing, typography) |
| `fifty_theme` | Theme system (dark/light mode) |
| `fifty_ui` | UI components (FiftyButton, FiftyCard) |
| `fifty_audio_engine` | Audio management (BGM, SFX, Voice) |
| `fifty_achievement_engine` | Achievement tracking and display |
| `fifty_map_engine` | Flame-based board rendering |

### Third-Party

| Package | Purpose |
|---------|---------|
| `get` | State management, routing, dependency injection |
| `get_storage` | Local persistence |
| `loader_overlay` | Loading overlays |

---

## Assets

- 12 unit sprites (player and enemy variants for all 6 unit types)
- 6 tile textures (dark, light, objective, obstacle, powerup, trap)
- 4 BGM tracks, 16 SFX sounds, 19 voice lines

---

## Kit Position

`tactical_grid` is the **showcase application** of Fifty Flutter Kit. Every package converges here.

```
fifty_tokens -> fifty_theme -> fifty_ui
                                  |
fifty_audio_engine -> tactical_grid <- fifty_achievement_engine
                                  |
                       fifty_map_engine
```

This is where the kit proves itself. Design tokens become themed surfaces. Themed surfaces become UI components. Audio engines drive battlefield ambiance. Achievement engines track combat milestones. The map engine renders the board. All of it, in one app, under fire.

---

## Related Packages

| Package | Description |
|---------|-------------|
| [`fifty_tokens`](../../packages/fifty_tokens) | Design tokens — the DNA of Kinetic Brutalism |
| [`fifty_theme`](../../packages/fifty_theme) | Flutter ThemeData integration |
| [`fifty_ui`](../../packages/fifty_ui) | Component library (FiftyButton, FiftyCard) |
| [`fifty_audio_engine`](../../packages/fifty_audio_engine) | Audio management (BGM, SFX, Voice) |
| [`fifty_achievement_engine`](../../packages/fifty_achievement_engine) | Achievement tracking and display |
| [`fifty_map_engine`](../../packages/fifty_map_engine) | Flame-based map and board rendering |

---

## Testing

```bash
cd apps/tactical_grid
flutter test
```

**Results:** 382 passing tests across 18 test files. Full coverage of game logic, AI behavior, unit abilities, and UI state.

---

## Credits

- **Development** — [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit) (Mohamed Elamin)
- **Sprite Generation** — [Higgsfield FLUX.2 Pro](https://higgsfield.ai)

---

## License

MIT License - see [LICENSE](../../LICENSE) file for details.

Copyright (c) 2025 Fifty Flutter Kit (Mohamed Elamin)

---

**Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit) | Showcase App**

*Deploy. Outmaneuver. Dominate.*
