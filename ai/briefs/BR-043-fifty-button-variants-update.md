# BR-043: FiftyButton Variants Update

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Status:** In Progress
**Created:** 2026-01-27

---

## Problem

The current `FiftyButton` component in fifty_ui doesn't match the FDL v2 design specification from `design_system/v2/fifty_ui_kit_components_1/`.

**Current variants:**
- `primary` - Burgundy filled (correct)
- `secondary` - Burgundy outline (naming mismatch - this is "outline" in design)
- `ghost` - Text only (correct)
- `danger` - Error styling (correct)

**Design spec shows:**
- **Primary** - Burgundy filled with optional trailing icon (arrow)
- **Secondary** - Slate-grey filled with leading icon
- **Outline** - Burgundy border, transparent background
- **Ghost** - Text only, no border

---

## Goal

Update `FiftyButton` to match FDL v2 design specification:

1. Add new `tertiary` variant for slate-grey filled buttons
2. Rename current `secondary` to `outline` (with deprecation)
3. Add `secondary` variant for slate-grey filled style
4. Add trailing icon support (`trailingIcon` parameter)
5. Update fifty_demo buttons showcase to demonstrate all variants

---

## Design Reference

**File:** `design_system/v2/fifty_ui_kit_components_1/screen.png`

```
┌─────────────────────────────────────┐
│  Get Started               →        │  ← Primary (burgundy filled + trailing arrow)
├─────────────────────────────────────┤
│  ↓  Download Kit                    │  ← Secondary (slate-grey filled + leading icon)
├─────────────────────────────────────┤
│  Log In          │  Skip for now    │  ← Outline / Ghost
└─────────────────────────────────────┘
```

**Colors from design:**
- Primary: `#88292f` (burgundy)
- Secondary fill: `#335c67` (slate-grey)
- Outline border: `#88292f` (burgundy)

---

## Implementation

### 1. Update FiftyButtonVariant enum

```dart
enum FiftyButtonVariant {
  /// Primary button with solid burgundy background.
  primary,

  /// Secondary button with solid slate-grey background.
  secondary,

  /// Outline button with burgundy border.
  outline,

  /// Ghost button with no background or border.
  ghost,

  /// Danger button for destructive actions.
  danger,
}
```

### 2. Add trailing icon support

```dart
class FiftyButton extends StatefulWidget {
  const FiftyButton({
    // ... existing params
    this.icon,           // Leading icon (existing)
    this.trailingIcon,   // NEW: Trailing icon
  });

  final IconData? icon;
  final IconData? trailingIcon;
}
```

### 3. Update color logic for secondary variant

```dart
Color _getBackgroundColor(ColorScheme colorScheme) {
  switch (widget.variant) {
    case FiftyButtonVariant.primary:
      return colorScheme.primary;
    case FiftyButtonVariant.secondary:
      return FiftyColors.slateGrey;  // NEW: slate-grey filled
    case FiftyButtonVariant.outline:
    case FiftyButtonVariant.ghost:
      return Colors.transparent;
    case FiftyButtonVariant.danger:
      return colorScheme.error;
  }
}
```

---

## Related Files

**Modify:**
- `packages/fifty_ui/lib/src/buttons/fifty_button.dart`
- `packages/fifty_ui/test/buttons/fifty_button_test.dart`
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/buttons_section.dart`

**Reference:**
- `design_system/v2/fifty_ui_kit_components_1/screen.png`
- `design_system/v2/fifty_ui_kit_components_1/code.html`

---

## Acceptance Criteria

1. [ ] `FiftyButtonVariant.secondary` renders slate-grey filled button
2. [ ] `FiftyButtonVariant.outline` renders burgundy outline button
3. [ ] `trailingIcon` parameter displays icon on right side of label
4. [ ] All existing tests pass
5. [ ] New tests added for secondary and outline variants
6. [ ] fifty_demo buttons section shows all 5 variants
7. [ ] `flutter analyze` passes with no errors

---

## Migration Notes

**Breaking Change:** `secondary` variant behavior changes from outline to filled.

**Migration path:**
- Existing `secondary` usage should change to `outline`
- New `secondary` for slate-grey filled buttons

Consider adding deprecation warning for one release cycle.

---

**Created:** 2026-01-27
**Design Source:** fifty_ui_kit_components_1
