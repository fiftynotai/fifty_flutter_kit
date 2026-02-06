# BR-073: Tactical Grid Achievement System Integration

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-05

---

## Problem

**What's broken or missing?**

The tactical_grid game has no achievement system despite `fifty_achievement_engine` (BR-028) being a fully implemented package in the ecosystem. There is no progress tracking, no unlock notifications, no reward feedback for milestones like first kill, winning a game, or completing challenges.

**Why does it matter?**

Achievements are a critical engagement mechanic for tactics games. They provide:
- Replayability and long-term goals beyond individual matches
- Sense of progression and accomplishment
- A showcase of `fifty_achievement_engine` integration (primary goal of tactical_grid as ecosystem demo)

---

## Goal

**What should happen after this brief is completed?**

1. Tactical Grid has a defined set of achievements covering combat, strategy, and completion milestones
2. Achievements unlock automatically during gameplay via event/stat tracking
3. Popup notifications appear when achievements are unlocked
4. An achievement screen is accessible from the main menu showing progress
5. Achievement state persists between sessions (optional, can be Phase 2)

---

## Context & Inputs

### Affected Modules
- [x] Other: `apps/tactical_grid/lib/features/battle/` (event tracking)
- [x] Other: `apps/tactical_grid/lib/features/achievements/` (new feature module)
- [x] Other: `apps/tactical_grid/lib/core/` (bindings, routes)

### Layers Touched
- [x] View (UI widgets -- achievement screen, unlock popup overlay)
- [x] Actions (UX orchestration -- trigger tracking after game events)
- [x] ViewModel (business logic -- AchievementController wrapper)
- [x] Service (data layer -- AchievementController from engine)
- [x] Model (domain objects -- achievement definitions)

### API Changes
- [x] No API changes

### Dependencies
- [x] Existing package: `fifty_achievement_engine` (conditions, controller, widgets)
- [x] Existing package: `fifty_audio_engine` (SFX on unlock)
- [x] Existing package: `fifty_ui` (FDL-styled achievement UI)
- [x] Existing package: `fifty_tokens` (styling)

### Related Files
- `packages/fifty_achievement_engine/lib/fifty_achievement_engine.dart` (engine API)
- `apps/tactical_grid/lib/features/battle/actions/battle_actions.dart` (event hook points)
- `apps/tactical_grid/lib/features/battle/controllers/battle_view_model.dart` (state source)
- `apps/tactical_grid/lib/core/routes/route_manager.dart` (new route)
- `apps/tactical_grid/lib/core/bindings/initial_bindings.dart` (controller registration)
- `apps/tactical_grid/pubspec.yaml` (add dependency)

### Reference Implementation
- `packages/fifty_achievement_engine/example/` (usage patterns)
- `packages/fifty_achievement_engine/lib/src/controllers/achievement_controller.dart` (API)

---

## Proposed Solution

### Achievement Definitions

| ID | Name | Description | Condition | Rarity | Points |
|----|------|-------------|-----------|--------|--------|
| `first_blood` | First Blood | Defeat your first enemy unit | `EventCondition('unit_defeated')` | Common | 10 |
| `commander_slayer` | Commander Slayer | Capture an enemy Commander | `EventCondition('commander_captured')` | Rare | 25 |
| `flawless_victory` | Flawless Victory | Win without losing any units | `EventCondition('flawless_win')` | Epic | 50 |
| `tactician` | Tactician | Win 5 games | `CountCondition('game_won', target: 5)` | Rare | 30 |
| `veteran` | Veteran | Win 10 games | `CountCondition('game_won', target: 10)` | Epic | 50 |
| `blitz` | Blitz | Win a game in under 10 turns | `EventCondition('blitz_win')` | Rare | 30 |
| `patient_general` | Patient General | Win a game lasting 20+ turns | `EventCondition('long_win')` | Uncommon | 15 |
| `knight_master` | Knight Master | Defeat 10 enemies with Knights | `CountCondition('knight_kill', target: 10)` | Rare | 25 |
| `shield_wall` | Shield Wall | Block 20 attacks with Shields | `CountCondition('shield_block', target: 20)` | Rare | 25 |
| `total_war` | Total War | Defeat 50 enemy units total | `CountCondition('unit_defeated', target: 50)` | Legendary | 100 |

### Architecture

```
battle_actions.dart                    achievements/
├── onAttackUnit() ─── trackEvent ──► ├── achievement_definitions.dart
├── onEndTurn()    ─── trackEvent ──► ├── achievement_view_model.dart
├── onStartGame()  ─── trackEvent ──► ├── achievement_actions.dart
│                                     ├── achievement_bindings.dart
│                                     └── views/
menu_page.dart                            ├── achievement_page.dart
├── ACHIEVEMENTS button ──────────────►   └── widgets/
                                              └── achievement_unlock_overlay.dart
```

### Event Tracking Points in BattleActions

| Method | Events to Track |
|--------|----------------|
| `onAttackUnit` (success + target defeated) | `'unit_defeated'`, `'commander_captured'` (if commander), `'knight_kill'` (if attacker is knight) |
| `onEndTurn` | increment turn counter |
| Game over (victory) | `'game_won'`, `'flawless_win'` (if no units lost), `'blitz_win'` (if turns < 10), `'long_win'` (if turns >= 20) |

### New Files

```
lib/features/achievements/
├── achievement_definitions.dart      -- List<Achievement> with all 10 definitions
├── achievement_view_model.dart       -- GetxController wrapping AchievementController
├── achievement_actions.dart          -- trackBattleEvent(), showUnlockPopup()
├── achievement_bindings.dart         -- GetX bindings
└── views/
    ├── achievement_page.dart         -- Full achievement list screen
    └── widgets/
        └── achievement_unlock_overlay.dart  -- Popup overlay on unlock
```

---

## Constraints

### Architecture Rules
- Follow MVVM + Actions pattern (View -> Actions -> ViewModel -> Service)
- Achievement tracking calls go through Actions layer, not directly from widgets
- AchievementController lives as a GetxController (app-wide singleton via InitialBindings)
- Achievement definitions are pure data (no logic in the definition file)

### Technical Constraints
- Must use `fifty_achievement_engine` API (no custom achievement logic)
- Unlock popup must not block gameplay (overlay, not dialog)
- Achievement screen accessible from menu, not during battle

### Out of Scope
- Persistent storage across app restarts (Phase 2)
- Online leaderboards
- Achievement sharing
- Custom achievement icons (use rarity-based defaults)

---

## Tasks

### Pending
- [ ] Add `fifty_achievement_engine` dependency to pubspec.yaml
- [ ] Create achievement_definitions.dart with 10 achievements
- [ ] Create achievement_view_model.dart wrapping AchievementController
- [ ] Create achievement_actions.dart with tracking methods
- [ ] Create achievement_bindings.dart
- [ ] Register AchievementViewModel in initial_bindings.dart (app-wide)
- [ ] Hook event tracking into BattleActions (attack, turn end, game over)
- [ ] Create achievement_page.dart using AchievementList widget
- [ ] Create achievement_unlock_overlay.dart using AchievementPopup
- [ ] Add ACHIEVEMENTS button to menu_page.dart
- [ ] Add achievement route to route_manager.dart
- [ ] Play unlock SFX via BattleAudioCoordinator on achievement unlock
- [ ] Run `flutter analyze` and `flutter test`

---

## Acceptance Criteria

1. [ ] 10 achievements defined with correct conditions
2. [ ] Defeating an enemy unit triggers `'unit_defeated'` event
3. [ ] Winning a game triggers `'game_won'` event with context events
4. [ ] Achievement popup appears on first unlock during gameplay
5. [ ] Achievement screen shows all 10 achievements with progress
6. [ ] Achievement screen accessible from main menu
7. [ ] Unlock SFX plays when achievement is earned
8. [ ] `flutter analyze` passes (zero errors/warnings)
9. [ ] `flutter test` passes (all existing + new tests green)
10. [ ] New unit tests for achievement definitions and tracking logic

---

## Test Plan

### Automated Tests
- [ ] Unit test: Achievement definitions are valid (unique IDs, valid conditions)
- [ ] Unit test: AchievementViewModel tracks events correctly
- [ ] Unit test: Flawless victory logic (no units lost detection)
- [ ] Unit test: Blitz win detection (turn count < 10)
- [ ] Widget test: Achievement page renders achievement list

### Manual Test Cases

#### Test Case 1: First Blood Achievement
**Steps:**
1. Start new game
2. Move a unit adjacent to an enemy
3. Attack and defeat the enemy

**Expected Result:** "First Blood" achievement popup appears

#### Test Case 2: Victory Achievements
**Steps:**
1. Win a game without losing units in under 10 turns

**Expected Result:** Multiple achievements unlock: "First Blood", "Commander Slayer", "Flawless Victory", "Blitz" (if applicable)

#### Test Case 3: Achievement Screen
**Steps:**
1. From main menu, tap ACHIEVEMENTS
2. View achievement list

**Expected Result:** All 10 achievements visible with locked/unlocked state and progress bars

---

## Delivery

### Code Changes
- [ ] New: `lib/features/achievements/` (6 files)
- [ ] Modified: `battle_actions.dart` (add event tracking calls)
- [ ] Modified: `menu_page.dart` (add ACHIEVEMENTS button)
- [ ] Modified: `route_manager.dart` (add achievement route)
- [ ] Modified: `initial_bindings.dart` (register achievement controller)
- [ ] Modified: `pubspec.yaml` (add dependency)

---

## Notes

The `fifty_achievement_engine` package is fully built (BR-028, Status: Done) with:
- `AchievementController<T>` for tracking
- `EventCondition`, `CountCondition`, `ThresholdCondition` etc.
- `AchievementList`, `AchievementPopup`, `AchievementSummary` widgets
- JSON serialization for persistence

This brief focuses on **integration** -- wiring the existing engine into tactical_grid's game loop. No engine modifications needed.

---

**Created:** 2026-02-05
**Last Updated:** 2026-02-05
**Brief Owner:** Igris AI
