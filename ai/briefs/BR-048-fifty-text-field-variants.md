# BR-048: FiftyTextField Variants Update

**Type:** Feature
**Priority:** P3-Low
**Effort:** S-Small (< 1d)
**Status:** Done
**Created:** 2026-01-27

---

## Problem

The FDL v2 design system shows a rounded/pill-shaped search input variant. Our current `FiftyTextField` only supports the standard rectangular style with xl border radius.

---

## Goal

Add shape variants to `FiftyTextField`:
- **Standard** (current): Rectangular with xl radius
- **Rounded/Pill**: Full border radius for search inputs

---

## Design Reference

**File:** `design_system/v2/fifty_ui_kit_components_3/screen.png`

```
Standard Input:
┌────────────────────────────────┐
│ 📧  name@example.com           │
└────────────────────────────────┘

Rounded/Search Input:
╭────────────────────────────────╮
│ 🔍  Search...                  │
╰────────────────────────────────╯
```

---

## Implementation

### API Changes

```dart
enum FiftyTextFieldShape {
  /// Standard rectangular shape with xl radius.
  standard,

  /// Pill/rounded shape with full radius (for search inputs).
  rounded,
}

class FiftyTextField extends StatefulWidget {
  const FiftyTextField({
    // ... existing params
    this.shape = FiftyTextFieldShape.standard, // NEW
  });

  final FiftyTextFieldShape shape;
}
```

### Usage

```dart
// Standard (default)
FiftyTextField(
  label: 'Email',
  prefixIcon: Icons.mail,
)

// Rounded search
FiftyTextField(
  hint: 'Search...',
  prefixIcon: Icons.search,
  shape: FiftyTextFieldShape.rounded,
)
```

### Border Radius Logic

```dart
BorderRadius get _borderRadius {
  switch (widget.shape) {
    case FiftyTextFieldShape.standard:
      return FiftyRadii.xlRadius;
    case FiftyTextFieldShape.rounded:
      return BorderRadius.circular(100); // Full pill
  }
}
```

---

## Related Files

**Modify:**
- `packages/fifty_ui/lib/src/inputs/fifty_text_field.dart`
- `packages/fifty_ui/test/inputs/fifty_text_field_test.dart`
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/inputs_section.dart`

**Reference:**
- `design_system/v2/fifty_ui_kit_components_3/screen.png`
- `design_system/v2/fifty_ui_kit_components_3/code.html`

---

## Acceptance Criteria

1. [x] FiftyTextFieldShape enum added
2. [x] `shape` parameter added to FiftyTextField
3. [x] Standard shape uses xl radius (existing behavior)
4. [x] Rounded shape uses full pill radius
5. [x] Existing code continues to work (backward compatible)
6. [x] Tests updated for new shape parameter (4 new tests)
7. [x] Demo shows both variants

---

**Created:** 2026-01-27
**Design Source:** fifty_ui_kit_components_3
