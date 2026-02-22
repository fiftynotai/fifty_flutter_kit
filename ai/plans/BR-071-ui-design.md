# BR-071 TACTICAL GRID - UI Design Specification

**Generated:** 2026-02-04
**Design System:** Fifty Design Language (FDL) v2
**Style:** Modern Sophisticated

---

## Color Palette

| Element | Color | Token | Hex |
|---------|-------|-------|-----|
| Player Units | Burgundy | `FiftyColors.burgundy` | #88292F |
| Enemy Units | Slate Grey | `FiftyColors.slateGrey` | #335C67 |
| Board Dark | Dark Burgundy | `FiftyColors.darkBurgundy` | #1A0D0E |
| Board Light | Slate Grey 20% | `FiftyColors.slateGrey.withOpacity(0.2)` | #335C67 @ 20% |
| Selection | Cream | `FiftyColors.cream` | #FEFEE3 |
| Valid Moves | Hunter Green | `FiftyColors.hunterGreen` | #4B644A |
| Attack Range | Burgundy 50% | `FiftyColors.burgundy.withOpacity(0.5)` | #88292F @ 50% |
| UI Accents | Powder Blush | `FiftyColors.powderBlush` | #FFC9B9 |

---

## Screen 1: Main Menu

```
┌─────────────────────────────────────┐
│                                     │
│         ████████████████████        │
│         █ TACTICAL GRID █           │
│         ████████████████████        │
│         [A Fifty Showcase]          │
│                                     │
│         ┌─────────────────┐         │
│         │      PLAY       │         │  FiftyButton (primary, large)
│         └─────────────────┘         │
│         ┌─────────────────┐         │
│         │    SETTINGS     │         │  FiftyButton (outline, medium)
│         └─────────────────┘         │
│                                     │
│   [🔊]                    [v1.0.0]  │
└─────────────────────────────────────┘
```

### Components
- Title: fontSize 32, extraBold, cream
- Subtitle: bodyMedium, slateGrey, uppercase
- Play: `FiftyButton(variant: primary, size: large)`
- Settings: `FiftyButton(variant: outline, size: medium)`
- Audio: `FiftyIconButton`

---

## Screen 2: Battle Screen

```
┌─────────────────────────────────────────────────────────────────────────┐
│ TURN 3 │ 🔴 PLAYER 1 │ ▓▓▓▓▓▓▓▓░░░░ 45s │              [⚙] [🔊] [≡]  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│      A   B   C   D   E   F   G   H                                      │
│    ┌───┬───┬───┬───┬───┬───┬───┬───┐                                    │
│  8 │   │   │ E │   │   │ E │   │   │                                    │
│  7 │   │ E │   │   │   │   │ E │   │                                    │
│  6 │   │   │ ░ │ ░ │   │   │   │   │  ░ = Valid moves (hunterGreen)    │
│  5 │   │   │   │ ★ │ ★ │   │   │   │  ★ = Objectives                   │
│  4 │   │   │   │ ★ │ ★ │   │   │   │                                    │
│  3 │   │   │ ░ │   │ ░ │   │   │   │                                    │
│  2 │   │[P]│   │   │   │   │ P │   │  [P] = Selected (cream glow)      │
│  1 │   │   │ P │   │   │ P │   │   │                                    │
│    └───┴───┴───┴───┴───┴───┴───┴───┘                                    │
│                                                                         │
├─────────────────────────────────────────────────────────────────────────┤
│ ┌──────┐  KNIGHT           HP: ███░░ 3/5    ATK: 3    MOVE: L-shape    │
│ │[ICON]│                                                                │
│ └──────┘  [ ATTACK ]  [ ABILITY ]  [ WAIT ]            [ END TURN ]    │
└─────────────────────────────────────────────────────────────────────────┘
```

### Top Bar
| Element | Component |
|---------|-----------|
| Turn Counter | `FiftyBadge.tech(label: "TURN 3")` |
| Player Indicator | `FiftyBadge(variant: primary, showGlow: true)` |
| Turn Timer | `FiftyProgressBar(height: 6)` |
| Icons | `FiftyIconButton` |

### Game Board
- Uses `FiftyMapWidget` from fifty_map_engine
- Tile size: 64px (FiftyMapConfig.blockSize)
- Board size: 8x8 = 512px
- Dark tiles: darkBurgundy
- Light tiles: slateGrey @ 20%
- Selection: 2px cream border + glow
- Valid moves: hunterGreen @ 40%, pulsing

### Unit Info Panel
| Element | Component |
|---------|-----------|
| Container | `FiftyCard(padding: 16)` |
| Unit Icon | `FiftyAvatar(size: 56)` |
| Unit Name | titleMedium, bold, cream |
| HP Bar | `FiftyProgressBar(height: 8)` |
| Attack Button | `FiftyButton(variant: primary, size: small)` |
| Ability Button | `FiftyButton(variant: secondary, size: small)` |
| Wait Button | `FiftyButton(variant: ghost, size: small)` |
| End Turn | `FiftyButton(variant: outline, size: medium)` |

---

## Screen 3: Victory/Defeat

```
┌─────────────────────────────────────┐
│                                     │
│         ╔═══════════════════╗       │
│         ║     VICTORY       ║       │  hunterGreen (win)
│         ╚═══════════════════╝       │  burgundy (lose)
│                                     │
│         Commander Captured!         │
│                                     │
│    ┌─────────────────────────┐      │
│    │  Turns Played: 12       │      │  FiftyCard
│    │  Units Lost: 2          │      │
│    │  Units Captured: 4      │      │
│    └─────────────────────────┘      │
│                                     │
│         [ PLAY AGAIN ]              │  FiftyButton (primary)
│         [ MAIN MENU  ]              │  FiftyButton (outline)
└─────────────────────────────────────┘
```

---

## Unit Visual States

| State | Visual | Duration |
|-------|--------|----------|
| Idle | Normal size | - |
| Selected | Scale 1.1 + cream glow | 150ms |
| Actionable | Pulse 1.0 → 1.05 | 1500ms cycle |
| Moved | 80% opacity | - |
| Damaged | Flash red + shake | 150ms |
| Defeated | Scale → 0 + fade | 300ms |

---

## Animation Timing

| Animation | Duration | Curve |
|-----------|----------|-------|
| Button hover | 150ms | standard |
| Unit selection | 150ms | standard |
| Unit movement | 300ms | enter |
| Turn transition | 300ms | standard |
| Valid moves pulse | 1500ms | ease-in-out |

---

## Typography

| Element | Size | Weight |
|---------|------|--------|
| Screen Title | 32px | extraBold |
| Section Header | 24px | extraBold |
| Unit Name | 18px | bold |
| Body Text | 14px | regular |
| Button Label | 14px | bold |
| Badge | 10px | semiBold |

---

## Spacing

| Context | Value | Token |
|---------|-------|-------|
| Screen padding | 16px | `FiftySpacing.lg` |
| Card padding | 16px | `FiftySpacing.lg` |
| Element gaps | 12px | `FiftySpacing.md` |
| Section gaps | 24px | `FiftySpacing.xxl` |
| Top bar height | 56px | - |
| Bottom panel height | 120-140px | - |
