# AC-004: fifty_ui — Theme Alignment Audit + Fixes

**Type:** Architecture Cleanup
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** In Progress
**Created:** 2026-02-28
**Parent:** AC-001 (Theme Customization System)
**Blocked By:** AC-003 (fifty_theme parameterization)

---

## Architecture Issue

**What's the problem?**

- [x] Logical inconsistency (some widgets fall back to `FiftyColors.*` / `FiftyTokens.*` directly instead of reading from theme)

**Where is it?**

4 widgets in `packages/fifty_ui/lib/src/` reference `FiftyColors` or `FiftyTokens` as fallback instead of reading exclusively from `Theme.of(context)`:

| Widget | Direct Token Reference | Should Be |
|--------|----------------------|-----------|
| FiftyButton | `FiftyShadows.primary` for shadow | `fifty.shadowPrimary` from extension |
| FiftyBadge | `FiftyColors.*` in `_getAccentColor` fallback | `colorScheme.*` equivalents |
| KineticEffect | `fifty.fast` from extension (correct) | Already correct |
| GlowContainer | `fifty.shadowGlow` from extension (correct) | Already correct |

---

## Current State

The audit found that **most fifty_ui widgets are already well-designed:**

- 7 widgets use pure `Theme.of(context)` — no changes needed
- 4 widgets accept optional parameter overrides — good pattern, keep it
- 4 widgets have minor direct token references — fix these

The widget architecture is fundamentally correct. This brief is about closing the last few gaps so that a consumer's custom theme propagates 100% through all widgets with zero leakage.

---

## Goal

After this brief:

- Every fifty_ui widget reads ALL visual properties from `Theme.of(context)` or `FiftyThemeExtension`
- Zero direct `FiftyColors.*` references in widget build methods (only in fallback when extension is missing)
- Fallback pattern standardized: try extension → try colorScheme → FDL constant (last resort)
- Widgets that accept optional color parameters keep that API (it's a good pattern)

---

## Cleanup Steps

### 1. Standardize Fallback Pattern

All widgets should follow this hierarchy:

```dart
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final fifty = theme.extension<FiftyThemeExtension>();

  // Pattern: extension → colorScheme → FDL default (last resort)
  final accentColor = fifty?.accent ?? colorScheme.primary;
  final successColor = fifty?.success ?? colorScheme.tertiary;
}
```

### 2. Fix FiftyButton Shadow

```dart
// BEFORE:
shadows: [FiftyShadows.primary] // Direct token reference

// AFTER:
shadows: fifty?.shadowPrimary != null ? [fifty!.shadowPrimary] : FiftyShadows.sm
```

### 3. Fix FiftyBadge Accent Color Fallback

```dart
// BEFORE (in _getAccentColor):
case FiftyBadgeVariant.success:
  return fifty?.success ?? FiftyColors.hunterGreen; // Direct token

// AFTER:
case FiftyBadgeVariant.success:
  return fifty?.success ?? colorScheme.tertiary; // ColorScheme fallback
```

### 4. Audit All 40+ Widgets

Full sweep of every widget file — verify no direct FiftyColors/FiftyTokens usage in build methods escaped the initial audit. The first audit covered 17 widgets; this task covers the remaining ~23.

### 5. Verify Parameter Override Pattern

Widgets that accept optional color parameters should document the override:

```dart
/// Background color for the card.
///
/// If null, falls back to [ColorScheme.surfaceContainerHighest].
final Color? backgroundColor;
```

---

## Tasks

### Pending
- [ ] Task 1: Audit remaining ~23 widgets not covered in initial audit
- [ ] Task 2: Fix FiftyButton — shadow reference from extension, not direct token
- [ ] Task 3: Fix FiftyBadge — `_getAccentColor` fallback to colorScheme, not FiftyColors
- [ ] Task 4: Fix any other direct token references found in full audit
- [ ] Task 5: Standardize fallback pattern documentation in widget doc comments
- [ ] Task 6: Write widget tests — custom theme colors propagate to all widgets
- [ ] Task 7: Write widget test — widget with no FiftyThemeExtension still renders (graceful fallback)
- [ ] Task 8: Run `flutter analyze` — zero issues

### In Progress

### Completed

---

## Workflow State

**Phase:** COMMITTING
**Active Agent:** none
**Retry Count:** 0

### Current Work
All agents complete. Committing changes.

### Next Steps
Commit and close brief.

### Agent Log
| Time | Agent | Action | Result |
|------|-------|--------|--------|
| 2026-02-28 | architect | Create implementation plan | SUCCESS — 38 widgets audited, 10 need fixes |
| 2026-02-28 | forger | Implement widget fixes | SUCCESS — 14 files modified, 2 test files created |
| 2026-02-28 | sentinel | Run test suite | PASS — 0 new analyzer issues, 205/205 theme tests pass, 0 direct token refs remaining |
| 2026-02-28 | warden | Code review | APPROVE — 0 critical/major, 5 minor (all acceptable) |
| 2026-02-28 | /document | Documentation | Skipped — internal refactoring, no API changes |

---

## Session State (Tactical - This Brief)

**Current State:** In Progress — INIT phase
**Next Steps When Resuming:** Continue with current phase
**Last Updated:** 2026-02-28
**Blockers:** None (AC-003 Done)

---

## Acceptance Criteria

1. [ ] Zero direct `FiftyColors.*` references in widget build methods
2. [ ] All widgets render correctly with a non-FDL custom theme
3. [ ] All widgets render correctly with FDL default theme (backward compat)
4. [ ] Widgets gracefully handle missing `FiftyThemeExtension` (fallback to colorScheme)
5. [ ] All existing widget tests pass
6. [ ] New widget tests verify custom theme propagation
7. [ ] `flutter analyze` passes (zero issues)

---

## Affected Areas

### Files to Modify
- `packages/fifty_ui/lib/src/buttons/fifty_button.dart` — shadow fix
- `packages/fifty_ui/lib/src/display/fifty_badge.dart` — accent fallback fix
- Potentially 3-5 other files found during full audit

**Total files affected:** ~5-8
**Estimated changes:** ~50-100 lines

---

## References

**Parent Brief:** AC-001
**Depends On:** AC-003 (fifty_theme parameterization)
**Can Parallel With:** AC-005 (engine packages)

---

**Created:** 2026-02-28
**Last Updated:** 2026-02-28
**Brief Owner:** Fifty.ai
