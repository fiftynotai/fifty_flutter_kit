# Implementation Plan: BR-010

**Complexity:** XL (Extra Large)
**Estimated Duration:** 5-7 days
**Risk Level:** Medium

## Summary

Create `packages/fifty_ui/` - a Flutter component library that builds on `fifty_tokens` and `fifty_theme` to provide FDL-styled widgets with crimson glow focus states, zero elevation, and motion token animations. All components access theme via `FiftyThemeExtension`.

## Architecture Overview

```
fifty_tokens (v0.2.0) - Raw design values (colors, spacing, motion, radii)
       |
fifty_theme (v0.1.0) - ThemeData + FiftyThemeExtension
       |
fifty_ui (v0.1.0) - Themed components <-- THIS PACKAGE
       |
Application - Your Flutter app
```

## Files to Create

| File | Action | Description |
|------|--------|-------------|
| `packages/fifty_ui/pubspec.yaml` | CREATE | Package manifest with ecosystem deps |
| `packages/fifty_ui/lib/fifty_ui.dart` | CREATE | Barrel export file |
| `packages/fifty_ui/lib/src/utils/fifty_theme_mixin.dart` | CREATE | Theme access mixin for all components |
| `packages/fifty_ui/lib/src/utils/glow_decoration.dart` | CREATE | Shared glow decoration utilities |
| `packages/fifty_ui/lib/src/buttons/fifty_button.dart` | CREATE | Primary/secondary/ghost button |
| `packages/fifty_ui/lib/src/buttons/fifty_icon_button.dart` | CREATE | Icon-only button with glow |
| `packages/fifty_ui/lib/src/inputs/fifty_text_field.dart` | CREATE | Text input with focus glow |
| `packages/fifty_ui/lib/src/containers/fifty_card.dart` | CREATE | Container with border outline |
| `packages/fifty_ui/lib/src/display/fifty_chip.dart` | CREATE | Tag/label component |
| `packages/fifty_ui/lib/src/display/fifty_divider.dart` | CREATE | Themed dividers |
| `packages/fifty_ui/lib/src/display/fifty_data_slate.dart` | CREATE | Key-value panel (terminal style) |
| `packages/fifty_ui/lib/src/display/fifty_badge.dart` | CREATE | Status indicator with glow |
| `packages/fifty_ui/lib/src/display/fifty_avatar.dart` | CREATE | User avatar with border |
| `packages/fifty_ui/lib/src/display/fifty_progress_bar.dart` | CREATE | Linear progress with crimson fill |
| `packages/fifty_ui/lib/src/display/fifty_loading_indicator.dart` | CREATE | Pulsing crimson loader |
| `packages/fifty_ui/lib/src/feedback/fifty_snackbar.dart` | CREATE | Toast notification |
| `packages/fifty_ui/lib/src/feedback/fifty_dialog.dart` | CREATE | Modal with border glow |
| `packages/fifty_ui/lib/src/feedback/fifty_tooltip.dart` | CREATE | Hover tooltip |
| `packages/fifty_ui/test/` | CREATE | Test files for each component |
| `packages/fifty_ui/example/lib/main.dart` | CREATE | Example gallery app |
| `packages/fifty_ui/README.md` | CREATE | Documentation with examples |
| `packages/fifty_ui/CHANGELOG.md` | CREATE | Version history |
| `packages/fifty_ui/analysis_options.yaml` | CREATE | Lint rules |

## Implementation Steps

### Phase 1: Package Foundation (Day 1)

1. **Create package structure**
2. **Create pubspec.yaml** with ecosystem dependencies
3. **Create FiftyThemeMixin** (shared theme access pattern)
4. **Create GlowDecoration utility** (reusable animated glow container)

### Phase 2: Button Components (Day 2)

5. **Implement FiftyButton**
   - Variants: `primary`, `secondary`, `ghost`, `danger`
   - Props: `label`, `onPressed`, `icon`, `variant`, `size`, `loading`, `disabled`
   - Focus/hover: Crimson glow via `FiftyThemeExtension.focusGlow`

6. **Implement FiftyIconButton**
   - Icon-only circular button with glow
   - Required tooltip for accessibility

### Phase 3: Input Components (Day 2-3)

7. **Implement FiftyTextField**
   - Focus state: Crimson border glow (2px crimson + box shadow)
   - Animation: Smooth border color transition

### Phase 4: Container Components (Day 3)

8. **Implement FiftyCard**
   - No drop shadow - border outline only
   - Selected state: Crimson border + subtle glow

### Phase 5: Display Components (Day 3-4)

9. **Implement FiftyChip**
10. **Implement FiftyDivider**
11. **Implement FiftyDataSlate** (Terminal-style key-value display)
12. **Implement FiftyBadge**
13. **Implement FiftyAvatar**
14. **Implement FiftyProgressBar**
15. **Implement FiftyLoadingIndicator**

### Phase 6: Feedback Components (Day 4-5)

16. **Implement FiftySnackbar**
17. **Implement FiftyDialog**
18. **Implement FiftyTooltip**

### Phase 7: Testing (Day 5-6)

19. **Write widget tests for each component**
20. **Test theme integration**

### Phase 8: Example App & Documentation (Day 6-7)

21. **Create example gallery app**
22. **Write comprehensive README**
23. **Create CHANGELOG.md**

## Key Implementation Patterns

### Theme Access Pattern (MANDATORY)

```dart
class FiftyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    // Use fifty.focusGlow, fifty.fast, etc.
  }
}
```

### Focus Glow Pattern

```dart
AnimatedContainer(
  duration: fifty.fast, // 150ms
  curve: fifty.standardCurve,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(FiftyRadii.standard),
    boxShadow: _hasFocus ? fifty.focusGlow : [],
    border: Border.all(
      color: _hasFocus ? colorScheme.primary : FiftyColors.border,
      width: _hasFocus ? 2 : 1,
    ),
  ),
  child: child,
)
```

## Testing Strategy

| Component | Test File | Test Cases |
|-----------|-----------|------------|
| FiftyButton | `test/buttons/fifty_button_test.dart` | Renders, taps, variants, disabled, loading |
| FiftyIconButton | `test/buttons/fifty_icon_button_test.dart` | Renders, taps, tooltip, variants |
| FiftyTextField | `test/inputs/fifty_text_field_test.dart` | Input, focus glow, error state |
| FiftyCard | `test/containers/fifty_card_test.dart` | Renders, tap, selected state |
| FiftyChip | `test/display/fifty_chip_test.dart` | Renders, delete, selected |
| FiftyDivider | `test/display/fifty_divider_test.dart` | Renders, thickness |
| FiftyDataSlate | `test/display/fifty_data_slate_test.dart` | Renders, data display |
| FiftyBadge | `test/display/fifty_badge_test.dart` | Renders, variants |
| FiftyAvatar | `test/display/fifty_avatar_test.dart` | Renders, fallback |
| FiftyProgressBar | `test/display/fifty_progress_bar_test.dart` | Renders, value, animation |
| FiftyLoadingIndicator | `test/display/fifty_loading_indicator_test.dart` | Renders, animation |
| FiftySnackbar | `test/feedback/fifty_snackbar_test.dart` | Shows, dismisses |
| FiftyDialog | `test/feedback/fifty_dialog_test.dart` | Shows, actions work |
| FiftyTooltip | `test/feedback/fifty_tooltip_test.dart` | Shows on hover |

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Focus glow not animating smoothly | Medium | Medium | Use AnimatedContainer with proper curves |
| Theme extension null at runtime | Low | High | Document required ThemeData setup |
| Accessibility compliance gaps | Medium | Medium | Test with screen readers |
| Performance on list of components | Low | Medium | Use const constructors |

## Definition of Done

- [ ] All Tier 1 (P0/P1) components implemented
- [ ] All components use `FiftyThemeExtension` - no hardcoded values
- [ ] Focus states use crimson glow
- [ ] All animations use `FiftyMotion` tokens
- [ ] `dart analyze` passes with zero issues
- [ ] `flutter test` passes (all green)
- [ ] Each component has widget tests
- [ ] README with component catalog exists
- [ ] Example gallery app demonstrates all components
- [ ] CHANGELOG.md updated for v0.1.0

---

**Plan created for BR-010**
**Created:** 2025-12-25
**Agent:** ARCHITECT (planner)
