# TD-001: Refactor fifty_skill_tree to Consume FDL

**Type:** Technical Debt
**Priority:** P1-High
**Effort:** M-Medium (3-5 days)
**Status:** In Progress
**Created:** 2026-01-20
**Assignee:** -

---

## Problem

The `fifty_skill_tree` package was implemented with a **self-contained theming system** instead of consuming from the FDL (Fifty Design Language) foundation packages. This creates:

1. **Coupling:** Theme changes in FDL don't automatically propagate to skill_tree
2. **Inconsistency:** Different color/spacing values than the rest of the ecosystem
3. **Maintenance Burden:** Two systems to update when design changes
4. **Bad Precedent:** Future engine packages might copy this anti-pattern

**Current Anti-Pattern:**
```dart
// packages/fifty_skill_tree/lib/src/themes/
├── skill_tree_theme.dart    ← 20+ custom color definitions
└── theme_presets.dart       ← RPG, SciFi, Minimal, Nature presets
```

```dart
// WRONG - isolated theme system
class SkillTreeTheme {
  final Color lockedNodeColor;
  final Color unlockedNodeColor;
  final Color connectionColor;
  // ... custom properties
}

SkillTreeThemePresets.rpg()  // hardcoded colors
```

---

## Goal

Refactor `fifty_skill_tree` to properly consume FDL tokens and components:

1. **Remove** self-contained theme system
2. **Consume** colors, spacing, typography from `fifty_tokens`
3. **Use** components from `fifty_ui` where applicable
4. **Accept** optional overrides via constructor parameters (not a separate theme class)
5. **Establish** the correct pattern for all future engine packages

**Target Pattern:**
```dart
// CORRECT - consume from FDL
class SkillNodeWidget extends StatelessWidget {
  final Color? nodeColor;  // optional override

  Widget build(BuildContext context) {
    return Container(
      color: nodeColor ?? FiftyColors.surface,      // FDL default
      padding: FiftySpacing.insets.md,              // FDL spacing
      decoration: BoxDecoration(
        border: Border.all(color: FiftyColors.border),
        borderRadius: FiftyRadii.standardRadius,
      ),
      child: Text(
        node.name,
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          color: FiftyColors.textPrimary,
        ),
      ),
    );
  }
}
```

---

## Scope

### Files to Modify

**Remove/Refactor:**
- `lib/src/themes/skill_tree_theme.dart` - Remove or simplify to optional overrides
- `lib/src/themes/theme_presets.dart` - Remove entirely

**Update to use FDL:**
- `lib/src/widgets/skill_node_widget.dart`
- `lib/src/widgets/skill_tree_view.dart`
- `lib/src/widgets/skill_tooltip.dart`
- `lib/src/widgets/skill_tree_controller.dart` (remove theme property)
- `lib/src/painters/*.dart` (use FDL colors)
- `lib/src/animations/*.dart` (use FDL colors)

**Update Example App:**
- `example/lib/examples/*.dart` - Remove theme preset usage

**Update Tests:**
- Remove theme-related tests
- Update widget tests to not require theme

### Dependencies

**Add to pubspec.yaml:**
```yaml
dependencies:
  fifty_tokens: ^0.2.0
  fifty_ui: ^0.5.0
```

---

## Acceptance Criteria

- [ ] `SkillTreeTheme` class removed or converted to simple override container
- [ ] `SkillTreeThemePresets` removed entirely
- [ ] All widgets use `FiftyColors` for colors
- [ ] All widgets use `FiftySpacing` for padding/margins
- [ ] All widgets use `FiftyTypography` for text styles
- [ ] All widgets use `FiftyRadii` for border radius
- [ ] `SkillTreeController` no longer requires theme parameter
- [ ] Optional color/style overrides available via widget constructors
- [ ] Example app updated to work without theme presets
- [ ] All tests passing
- [ ] Documentation updated

---

## Migration Guide

### Before (Current API)
```dart
final controller = SkillTreeController<void>(
  tree: tree,
  theme: SkillTreeTheme.dark(),  // or SkillTreeThemePresets.rpg()
);

SkillTreeView<void>(
  controller: controller,
  // theme embedded in controller
)
```

### After (New API)
```dart
final controller = SkillTreeController<void>(
  tree: tree,
  // no theme required - uses FDL automatically
);

SkillTreeView<void>(
  controller: controller,
  // Optional overrides if needed:
  nodeColor: FiftyColors.crimsonPulse,  // override specific colors
  connectionColor: FiftyColors.border,
)
```

---

## Test Plan

**Unit Tests:**
- Widget renders with FDL colors by default
- Optional color overrides work correctly
- No regressions in functionality

**Visual Tests:**
- Example app looks consistent with FDL aesthetic
- All node states visually correct
- Animations use correct colors

**Integration Tests:**
- Package works without any theme configuration
- Package integrates with FiftyTheme context

---

## Breaking Changes

This is a **breaking change** for existing users:

| Before | After |
|--------|-------|
| `SkillTreeTheme.dark()` | Remove - uses FDL |
| `SkillTreeTheme.light()` | Remove - uses FDL |
| `SkillTreeThemePresets.rpg()` | Remove entirely |
| `controller.setTheme()` | Remove method |
| `theme` parameter | Optional override parameters |

**Version Bump:** 0.1.0 → 0.2.0 (minor with breaking changes)

---

## Why This Matters

This refactor establishes the **correct pattern** for all future engine packages:

- `fifty_achievement_engine` - will consume FDL
- `fifty_inventory_engine` - will consume FDL
- `fifty_dialogue_engine` - will consume FDL
- `fifty_forms` - will consume FDL

Fix this now before scaling the anti-pattern across the ecosystem.

---

## Workflow State

**Phase:** REVIEWING
**Active Agent:** reviewer
**Retry Count:** 0

### Agent Log
- `2026-01-20 16:00` - Starting PLANNER agent for refactoring plan
- `2026-01-20 16:05` - PLANNER complete - 8-phase plan created
- `2026-01-20 16:06` - Plan APPROVED by Monarch (revised: keep setTheme)
- `2026-01-20 16:07` - Starting CODER agent for implementation
- `2026-01-20 16:15` - CODER complete - 11 modified, 1 deleted
- `2026-01-20 16:16` - TESTER complete - 188 tests passed
- `2026-01-20 16:16` - Starting REVIEWER agent

---
