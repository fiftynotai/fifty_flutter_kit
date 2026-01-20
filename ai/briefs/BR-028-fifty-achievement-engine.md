# BR-028: Fifty Achievement Engine Package

**Type:** Feature
**Priority:** P1-High
**Effort:** M-Medium (1-2 weeks)
**Status:** In Progress
**Created:** 2026-01-20
**Assignee:** -

---

## Problem

Games and apps need achievement/trophy systems with unlock conditions, progress tracking, notifications, and persistence. Currently developers must build this from scratch. The `fifty_skill_tree` package establishes a precedent for game-focused packages, but achievements are a natural companion feature that is missing from the ecosystem.

Common pain points:
- No standardized achievement model with conditions
- Manual progress tracking and state management
- No integration with existing Fifty ecosystem packages
- Repetitive UI widget implementation for achievement displays

---

## Goal

Create `fifty_achievement_engine` - a production-ready Flutter package providing a complete achievement system with:
- Flexible condition-based unlocks (event, count, threshold, composite)
- Progress tracking with percentage completion
- Notification callbacks for UI integration
- JSON serialization for save games
- Integration with fifty_skill_tree, fifty_audio_engine, fifty_ui
- FDL-compliant UI widgets

---

## Context & Inputs

**Target Location:** `packages/fifty_achievement_engine/`

**Ecosystem Integration:**
| Package | Integration |
|---------|-------------|
| fifty_skill_tree | Unlock achievements when skills mastered |
| fifty_audio_engine | Play sounds on achievement unlock |
| fifty_ui | Achievement card, popup components |
| fifty_storage | Persist achievement state |
| fifty_tokens | FDL styling tokens |

**Similar Package Reference:** `packages/fifty_skill_tree/` (patterns, structure)

---

## Proposed Solution

### Core Models

**Achievement<T>**
```dart
Achievement<T>({
  id: String,
  name: String,
  description: String,
  icon: String?,
  rarity: AchievementRarity,     // common, rare, epic, legendary
  points: int,                    // gamerscore/trophy points
  hidden: bool,                   // secret achievements
  category: String?,
  condition: AchievementCondition,
  data: T?,                       // generic metadata
})
```

**Condition Types:**
- `EventCondition` - One-time event triggers
- `CountCondition` - Cumulative count (kill 50 enemies)
- `ThresholdCondition` - Stat-based (reach level 10)
- `CompositeCondition` - AND/OR combinations
- `TimeCondition` - Time-based challenges
- `SequenceCondition` - Ordered event sequences

### Controller

**AchievementController**
- `trackEvent(String event, {int count})` - Track events
- `updateStat(String stat, num value)` - Update stats
- `incrementStat(String stat, num delta)` - Increment stats
- `getProgress(String id)` - Get 0.0-1.0 progress
- `isUnlocked(String id)` - Check unlock status
- `getUnlockedAchievements()` - List unlocked
- `exportProgress()` / `importProgress()` - Serialization
- `onUnlock` callback for notifications

### UI Widgets

- `AchievementCard` - Single achievement display with progress
- `AchievementList` - Scrollable list with filtering
- `AchievementPopup` - Toast notification on unlock
- `AchievementProgress` - Progress bar widget
- `AchievementSummary` - Points/completion overview

---

## Package Structure

```
fifty_achievement_engine/
├── lib/
│   ├── src/
│   │   ├── models/
│   │   │   ├── achievement.dart
│   │   │   ├── achievement_rarity.dart
│   │   │   ├── achievement_state.dart
│   │   │   └── achievement_progress.dart
│   │   ├── conditions/
│   │   │   ├── achievement_condition.dart
│   │   │   ├── event_condition.dart
│   │   │   ├── count_condition.dart
│   │   │   ├── threshold_condition.dart
│   │   │   ├── composite_condition.dart
│   │   │   ├── time_condition.dart
│   │   │   └── sequence_condition.dart
│   │   ├── controllers/
│   │   │   └── achievement_controller.dart
│   │   ├── widgets/
│   │   │   ├── achievement_card.dart
│   │   │   ├── achievement_list.dart
│   │   │   ├── achievement_popup.dart
│   │   │   ├── achievement_progress.dart
│   │   │   └── achievement_summary.dart
│   │   ├── serialization/
│   │   │   ├── achievement_serializer.dart
│   │   │   └── progress_data.dart
│   │   └── themes/
│   │       ├── achievement_theme.dart
│   │       └── theme_presets.dart
│   └── fifty_achievement_engine.dart
├── example/
│   ├── lib/
│   │   ├── main.dart
│   │   └── examples/
│   │       ├── basic_achievements.dart
│   │       ├── rpg_achievements.dart
│   │       └── fitness_achievements.dart
│   └── pubspec.yaml
├── test/
├── README.md
├── CHANGELOG.md
└── pubspec.yaml
```

---

## Acceptance Criteria

- [ ] Core models: Achievement, AchievementRarity, AchievementState
- [ ] 6 condition types: Event, Count, Threshold, Composite, Time, Sequence
- [ ] AchievementController with full API
- [ ] Progress tracking (0.0-1.0 percentage)
- [ ] JSON serialization (export/import)
- [ ] 5 UI widgets with FDL compliance
- [ ] Theme system with presets
- [ ] Example app with 3 demo scenarios
- [ ] Unit tests (150+ tests)
- [ ] Documentation (README, API docs, CHANGELOG)
- [ ] Integration examples with fifty_skill_tree and fifty_audio_engine

---

## Test Plan

**Unit Tests:**
- Achievement model creation and copyWith
- All condition types evaluate correctly
- Controller tracks events and stats
- Progress calculation accuracy
- Serialization round-trip

**Widget Tests:**
- AchievementCard renders correctly
- AchievementList filtering works
- AchievementPopup animations
- Theme application

**Integration Tests:**
- Full unlock flow with notifications
- Save/load cycle
- Multiple achievement unlocks

---

## Constraints

- Must follow FDL (Fifty Design Language) patterns
- Use ChangeNotifier pattern (framework-agnostic)
- No external dependencies beyond Flutter SDK and ecosystem packages
- Generic type support for custom metadata
- Immutable models with copyWith

---

## Delivery

- [ ] Package at `packages/fifty_achievement_engine/`
- [ ] Example app at `packages/fifty_achievement_engine/example/`
- [ ] README.md with usage examples
- [ ] CHANGELOG.md with v0.1.0 entry
- [ ] All tests passing
- [ ] Analyzer clean (no warnings)

---

## Workflow State

**Phase:** COMMITTING
**Active Agent:** none
**Retry Count:** 0

### Agent Log
- [2026-01-20 19:XX] Starting planner agent for implementation plan...
- [2026-01-20 19:XX] ARCHITECT plan complete → ai/plans/BR-028-plan.md
- [2026-01-20 19:XX] Awaiting approval (M complexity requires user review)
- [2026-01-20 19:XX] APPROVED by Monarch
- [2026-01-20 19:XX] Starting coder agent for implementation...
- [2026-01-20 19:XX] FORGER complete → 35 files created
- [2026-01-20 19:XX] Starting tester agent for validation...
- [2026-01-20 19:XX] SENTINEL report: PASS (0 errors, 2 expected warnings)
- [2026-01-20 19:XX] Starting reviewer agent for code review...
- [2026-01-20 19:XX] WARDEN verdict: APPROVE (8.5/10)
- [2026-01-20 19:XX] Proceeding to commit...

---
