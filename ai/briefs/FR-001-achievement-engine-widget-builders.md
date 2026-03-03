# FR-001: Add builder patterns to fifty_achievement_engine widgets

**Type:** Feature Request
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Done
**Created:** 2026-03-03
**Completed:** 2026-03-03

---

## Feature Description

**What is the proposed feature?**

Add builder/customization callbacks to all 5 achievement engine widgets so consumers can swap the default UI with their own designs while keeping the achievement logic pipeline intact.

**Why is this valuable?**

The achievement engine provides a complete pipeline (conditions, progress tracking, unlock logic, persistence). The UI layer should accelerate adoption — not lock consumers into our visual design. Consumers should be able to wire their own card designs, popup animations, and summary layouts.

---

## User Value

### Who Benefits?
- [x] Developers (building with the package)

### Pain Point Solved
**Current situation:**
`AchievementList` always renders `AchievementCard` internally. Consumers can tweak colors but can't swap the card widget. Same for popup and summary.

**With this feature:**
Consumers use the full achievement pipeline with their own UI. The package becomes a logic+pipeline engine with optional default UI.

---

## Technical Approach

### Widgets to Update

| Widget | Builder to Add | Fallback |
|--------|---------------|----------|
| `AchievementList` | `itemBuilder(achievement, state)` | Default `AchievementCard` |
| `AchievementPopup` | `popupBuilder(achievement)` | Default popup layout |
| `AchievementSummary` | `summaryBuilder(stats)` | Default summary layout |
| `AchievementProgressBar` | `barBuilder(progress, label)` | Default linear bar |
| `AchievementCard` | `contentBuilder(achievement, state)` | Default card content |

### Pattern (same as fifty_skill_tree's nodeBuilder)

```dart
AchievementList<T>(
  controller: controller,
  // Optional — if null, uses default AchievementCard
  itemBuilder: (achievement, state) {
    return MyCustomAchievementTile(
      title: achievement.name,
      icon: achievement.icon,
      progress: state.progress,
    );
  },
)
```

### Constraints
- Default widgets remain unchanged (backward compatible)
- Builder is optional — null means use default
- All existing tests must pass

---

## Acceptance Criteria

1. [x] Each widget has an optional builder callback
2. [x] Null builder falls back to current default widget
3. [x] Existing API unchanged (backward compatible)
4. [x] Example app demonstrates custom builder usage
5. [x] All existing tests pass
6. [x] New tests for builder pattern (41 new tests, 50 total)

---

## Notes

Reference: fifty_skill_tree's `nodeBuilder` pattern is the gold standard.

---

**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Brief Owner:** Fifty.ai
