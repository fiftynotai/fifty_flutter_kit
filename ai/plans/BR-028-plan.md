# Implementation Plan: BR-028 - Fifty Achievement Engine

**Brief:** Fifty Achievement Engine Package
**Complexity:** M (Medium)
**Estimated Duration:** 1-2 weeks
**Risk Level:** Low
**Created:** 2026-01-20
**Agent:** planner (ARCHITECT)

---

## Summary

Create `fifty_achievement_engine` - a Flutter package providing achievement/trophy systems with condition-based unlocks, progress tracking, and FDL-compliant UI widgets. Follows the established `fifty_skill_tree` patterns without introducing a separate theme system (FDL consumption only).

---

## CRITICAL: FDL Compliance Notes

Per `coding_guidelines.md` Engine Package Architecture rules:

**REMOVED from brief's proposed structure:**
- `themes/achievement_theme.dart` - ANTI-PATTERN
- `themes/theme_presets.dart` - ANTI-PATTERN

**CORRECT approach:**
- Widgets consume `FiftyColors`, `FiftySpacing`, `FiftyTypography`, `FiftyRadii` directly
- Optional override parameters on individual widgets (not a theme object)
- State-based styling via semantic color getters

---

## Files to Create

| File | Purpose |
|------|---------|
| `packages/fifty_achievement_engine/pubspec.yaml` | Package manifest |
| `packages/fifty_achievement_engine/lib/fifty_achievement_engine.dart` | Barrel export |
| `packages/fifty_achievement_engine/lib/src/models/achievement.dart` | Core model |
| `packages/fifty_achievement_engine/lib/src/models/achievement_rarity.dart` | Rarity enum |
| `packages/fifty_achievement_engine/lib/src/models/achievement_state.dart` | State enum |
| `packages/fifty_achievement_engine/lib/src/models/achievement_progress.dart` | Progress data |
| `packages/fifty_achievement_engine/lib/src/models/models.dart` | Barrel |
| `packages/fifty_achievement_engine/lib/src/conditions/achievement_condition.dart` | Base condition |
| `packages/fifty_achievement_engine/lib/src/conditions/achievement_context.dart` | Context data |
| `packages/fifty_achievement_engine/lib/src/conditions/event_condition.dart` | Event trigger |
| `packages/fifty_achievement_engine/lib/src/conditions/count_condition.dart` | Count-based |
| `packages/fifty_achievement_engine/lib/src/conditions/threshold_condition.dart` | Threshold |
| `packages/fifty_achievement_engine/lib/src/conditions/composite_condition.dart` | AND/OR |
| `packages/fifty_achievement_engine/lib/src/conditions/time_condition.dart` | Time-based |
| `packages/fifty_achievement_engine/lib/src/conditions/sequence_condition.dart` | Sequence |
| `packages/fifty_achievement_engine/lib/src/conditions/conditions.dart` | Barrel |
| `packages/fifty_achievement_engine/lib/src/controllers/achievement_controller.dart` | Main controller |
| `packages/fifty_achievement_engine/lib/src/controllers/controllers.dart` | Barrel |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_card.dart` | Card widget |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_list.dart` | List widget |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_popup.dart` | Toast popup |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_progress.dart` | Progress bar |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_summary.dart` | Summary widget |
| `packages/fifty_achievement_engine/lib/src/widgets/widgets.dart` | Barrel |
| `packages/fifty_achievement_engine/lib/src/serialization/progress_data.dart` | Progress data |
| `packages/fifty_achievement_engine/lib/src/serialization/achievement_serializer.dart` | Serializer |
| `packages/fifty_achievement_engine/lib/src/serialization/serialization.dart` | Barrel |
| `packages/fifty_achievement_engine/README.md` | Documentation |
| `packages/fifty_achievement_engine/CHANGELOG.md` | v0.1.0 |
| `packages/fifty_achievement_engine/example/pubspec.yaml` | Example manifest |
| `packages/fifty_achievement_engine/example/lib/main.dart` | Example entry |
| Various test files | Unit/widget tests |

**Total Files:** ~45 files

---

## Implementation Phases

### Phase 1: Foundation (Models)

1. Create package scaffold (`pubspec.yaml`)
2. Create `AchievementRarity` enum (common, uncommon, rare, epic, legendary)
3. Create `AchievementState` enum (locked, available, unlocked, claimed)
4. Create `Achievement<T>` model (generic, immutable, JSON serializable)
5. Create `AchievementProgress` model

**Dependencies:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  fifty_tokens:
    path: ../fifty_tokens
  fifty_ui:
    path: ../fifty_ui
  fifty_theme:
    path: ../fifty_theme
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mocktail: ^1.0.0
```

---

### Phase 2: Conditions System

1. Create base `AchievementCondition` abstract class
2. Create `AchievementContext` data container
3. Implement 6 condition types:
   - `EventCondition` - One-time event triggers
   - `CountCondition` - Cumulative count (kill 50 enemies)
   - `ThresholdCondition` - Stat-based (reach level 10)
   - `CompositeCondition` - AND/OR combinations
   - `TimeCondition` - Time-based challenges
   - `SequenceCondition` - Ordered event sequences

**Key Pattern:**
```dart
abstract class AchievementCondition {
  bool evaluate(AchievementContext context);
  double getProgress(AchievementContext context);
  String get type;
  Map<String, dynamic> toJson();
  factory AchievementCondition.fromJson(Map<String, dynamic> json);
}
```

---

### Phase 3: Controller

Create `AchievementController<T>` extending `ChangeNotifier`:

**API:**
```dart
// Event tracking
void trackEvent(String event, {int count = 1});
void clearEvent(String event);

// Stat tracking
void updateStat(String stat, num value);
void incrementStat(String stat, num delta);

// Progress
double getProgress(String achievementId);
bool isUnlocked(String achievementId);

// State
List<Achievement<T>> get achievements;
List<Achievement<T>> get unlockedAchievements;
int get totalPoints;
int get earnedPoints;

// Callbacks
ValueChanged<Achievement<T>>? onUnlock;

// Serialization
Map<String, dynamic> exportProgress();
void importProgress(Map<String, dynamic> data);
```

---

### Phase 4: Serialization

1. Create `ProgressData` model
2. Create `AchievementSerializer` with type registry

---

### Phase 5: UI Widgets (FDL COMPLIANT)

**CRITICAL: NO THEME CLASS**

All widgets consume FDL directly with optional overrides:

```dart
class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final double progress;
  final VoidCallback? onTap;

  // Optional overrides (NOT a theme object)
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? FiftyColors.surfaceDark,
      padding: const EdgeInsets.all(FiftySpacing.md),
      decoration: BoxDecoration(
        borderRadius: FiftyRadii.xxlRadius,
        border: Border.all(color: borderColor ?? FiftyColors.borderDark),
      ),
      // ...
    );
  }

  // State-based colors via semantic getter
  Color get _rarityColor => switch (achievement.rarity) {
    AchievementRarity.common => FiftyColors.slateGrey,
    AchievementRarity.uncommon => FiftyColors.hunterGreen,
    AchievementRarity.rare => FiftyColors.burgundy,
    AchievementRarity.epic => const Color(0xFF9B59B6),
    AchievementRarity.legendary => const Color(0xFFE67E22),
  };
}
```

**Widgets:**
- `AchievementCard` - Single achievement display
- `AchievementList` - Scrollable list with filtering
- `AchievementPopup` - Toast notification on unlock
- `AchievementProgress` - Progress bar widget
- `AchievementSummary` - Points/completion overview

---

### Phase 6: Barrel Exports

Main library export file.

---

### Phase 7: Example App

Three demo scenarios:
- Basic achievements
- RPG achievements
- Fitness achievements

---

### Phase 8: Documentation

- README.md with usage examples
- CHANGELOG.md with v0.1.0 entry
- API doc comments

---

### Phase 9: Testing

| Component | Test Count | Coverage |
|-----------|------------|----------|
| Models | 30+ | 90% |
| Conditions | 60+ | 90% |
| Controller | 40+ | 85% |
| Serialization | 15+ | 90% |
| Widgets | 20+ | 70% |
| **Total** | **150+** | |

---

## Dependencies Graph

```
Phase 1 (Models) → Phase 2 (Conditions) → Phase 3 (Controller)
                                                ↓
Phase 4 (Serialization) ← ─────────────────────┘
         ↓
Phase 5 (Widgets) → Phase 6 (Barrel) → Phase 7 (Example) → Phase 8 (Docs)
         ↓
Phase 9 (Testing) ← runs parallel after Phase 4
```

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| FDL violation (theme class) | Low | High | Strict code review, checklist |
| Condition serialization complexity | Medium | Medium | Type registry pattern |
| Performance with many achievements | Low | Medium | Lazy loading in list |

---

## File Count Summary

| Category | Files |
|----------|-------|
| Models | 5 |
| Conditions | 8 |
| Controllers | 2 |
| Serialization | 3 |
| Widgets | 6 |
| Config/Export | 3 |
| Example | 5 |
| Tests | 13+ |
| **Total** | **~45 files** |

---

**Plan Status:** Awaiting approval
