# TD-006: Theme-Aware Achievement Rarity Colors

**Type:** Technical Debt
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2026-02-02
**Audit Reference:** H-002

---

## What is the Technical Debt?

**Current situation:**

Achievement rarity colors are hardcoded directly in the enum, bypassing the theme system. This is marked with a TODO comment in the code.

**Why is it technical debt?**

Colors don't adapt to light/dark mode. This violates the FDL consumption pattern where all colors should come from the theme system.

**Examples:**
```dart
// Current code in achievement_demo_view_model.dart:18-41
/// TODO(theme): Consider refactoring to use theme-aware colors.
enum AchievementRarity {
  common('Common', FiftyColors.slateGrey),
  uncommon('Uncommon', FiftyColors.hunterGreen),
  rare('Rare', FiftyColors.slateGrey),
  epic('Epic', FiftyColors.powderBlush),
  legendary('Legendary', FiftyColors.warning);

  final String label;
  final Color color;
  const AchievementRarity(this.label, this.color);
}
```

---

## Why It Matters

**Consequences of not fixing:**

- [x] **Maintainability:** Hardcoded colors diverge from theme system
- [x] **Readability:** Violates established FDL patterns
- [ ] **Performance:** N/A
- [ ] **Security:** N/A
- [x] **Scalability:** Won't adapt to future theme changes
- [x] **Developer Experience:** Sets bad example for other developers

**Impact:** Medium

---

## Cleanup Steps

**How to pay off this debt:**

1. [ ] Remove color from enum definition
2. [ ] Create `getRarityColor(BuildContext)` helper method
3. [ ] Use theme extension or ColorScheme for colors
4. [ ] Update view layer to call helper method
5. [ ] Remove TODO comment

---

## Tasks

### Pending
- [ ] Task 4: Test in both light and dark modes

### In Progress
_(None)_

### Completed
- [x] Task 1: Created AchievementRarityColors extension with getColor(BuildContext)
- [x] Task 2: Removed hardcoded colors from AchievementRarity enum
- [x] Task 3: Updated all usages in achievement_demo_page.dart to use extension
- [x] Task 5: Removed TODO comment, replaced with proper documentation

---

## Session State (Tactical - This Brief)

**Current State:** Implementation complete, pending visual verification
**Next Steps When Resuming:** Test light/dark mode appearance
**Last Updated:** 2026-02-02
**Blockers:** None

---

## Affected Areas

### Files
- `lib/features/achievement_demo/controllers/achievement_demo_view_model.dart`
- `lib/features/achievement_demo/views/achievement_demo_page.dart`

### Count
**Total files affected:** 2
**Total lines to change:** ~30

---

## Acceptance Criteria

**The debt is paid off when:**

1. [ ] No hardcoded colors in enum
2. [ ] Colors adapt to light/dark mode
3. [ ] Follows FDL consumption pattern
4. [ ] TODO comment removed
5. [ ] `flutter analyze` passes (zero issues)
6. [ ] Visual appearance correct in both themes

---

**Created:** 2026-02-02
**Last Updated:** 2026-02-02
**Brief Owner:** Igris AI
