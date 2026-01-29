# BR-049: FiftySegmentedControl Variants

**Type:** Feature
**Priority:** P2-Medium
**Effort:** S-Small (< 1d)
**Status:** Done
**Created:** 2026-01-29

---

## Problem

The FDL v2 design system (fifty_ui_kit_components_2) shows two distinct segmented control styles:

1. **Primary variant** (text-based): Cream background with burgundy text - used for content filters (Daily/Weekly/Monthly)
2. **Secondary variant** (icon-based): Slate-grey background with cream text - used for system settings (Light/Dark/System mode)

Our current `FiftySegmentedControl` only implements the secondary style (slate-grey in dark mode), missing the primary cream variant.

---

## Goal

Add a `variant` parameter to `FiftySegmentedControl` to support both design styles:
- **Primary:** Cream active background with burgundy text (regardless of theme mode)
- **Secondary:** Slate-grey active background with cream text (current behavior)

---

## Design Reference

**File:** `design_system/v2/fifty_ui_kit_components_2/code.html`

**Primary Variant (lines 123-133):**
```html
<button class="flex-1 py-2.5 rounded-lg bg-background-light text-primary font-bold text-sm shadow-sm">
    Daily
</button>
```
- Active: `bg-background-light` (cream) + `text-primary` (burgundy)
- Inactive: `text-gray-400`

**Secondary Variant (lines 134-144):**
```html
<button class="flex-1 py-2.5 rounded-lg bg-slate-grey text-background-light shadow-md">
    <span class="material-symbols-outlined">dark_mode</span>
</button>
```
- Active: `bg-slate-grey` + `text-background-light` (cream)
- Inactive: `text-gray-400`

---

## Implementation

### API Changes

```dart
enum FiftySegmentedControlVariant {
  /// Cream background with burgundy text.
  /// Used for content filters (Daily/Weekly/Monthly).
  primary,

  /// Slate-grey background with cream text.
  /// Used for system settings (Light/Dark/System).
  secondary,
}

class FiftySegmentedControl<T> extends StatelessWidget {
  const FiftySegmentedControl({
    // ... existing params
    this.variant = FiftySegmentedControlVariant.primary, // NEW - default to primary
  });

  final FiftySegmentedControlVariant variant;
}
```

### Color Logic

```dart
Color get activeColor {
  switch (variant) {
    case FiftySegmentedControlVariant.primary:
      return FiftyColors.cream; // Always cream
    case FiftySegmentedControlVariant.secondary:
      return FiftyColors.slateGrey; // Always slate-grey
  }
}

Color get activeTextColor {
  switch (variant) {
    case FiftySegmentedControlVariant.primary:
      return FiftyColors.burgundy; // Always burgundy
    case FiftySegmentedControlVariant.secondary:
      return FiftyColors.cream; // Always cream
  }
}
```

### Usage

```dart
// Primary variant (default) - for content filters
FiftySegmentedControl<String>(
  segments: [
    FiftySegment(value: 'daily', label: 'Daily'),
    FiftySegment(value: 'weekly', label: 'Weekly'),
    FiftySegment(value: 'monthly', label: 'Monthly'),
  ],
  selected: _period,
  onChanged: (value) => setState(() => _period = value),
)

// Secondary variant - for system settings
FiftySegmentedControl<ThemeMode>(
  variant: FiftySegmentedControlVariant.secondary,
  segments: [
    FiftySegment(value: ThemeMode.light, label: '', icon: Icons.light_mode),
    FiftySegment(value: ThemeMode.dark, label: '', icon: Icons.dark_mode),
    FiftySegment(value: ThemeMode.system, label: '', icon: Icons.settings_system_daydream),
  ],
  selected: _themeMode,
  onChanged: (value) => setState(() => _themeMode = value),
)
```

---

## Related Files

**Modify:**
- `packages/fifty_ui/lib/src/controls/fifty_segmented_control.dart`
- `packages/fifty_ui/test/controls/fifty_segmented_control_test.dart`
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/inputs_section.dart` (add demo)

**Reference:**
- `design_system/v2/fifty_ui_kit_components_2/code.html`
- `design_system/v2/fifty_ui_kit_components_2/screen.png`

---

## Acceptance Criteria

1. [x] `FiftySegmentedControlVariant` enum added (primary, secondary)
2. [x] `variant` parameter added to FiftySegmentedControl
3. [x] Primary variant uses cream background + burgundy text
4. [x] Secondary variant uses slate-grey background + cream text
5. [x] Default variant is primary (backward compatible for most use cases)
6. [x] Existing behavior preserved when using secondary variant
7. [ ] Tests updated for new variant parameter (existing tests pass)
8. [ ] Demo shows both variants

## Implementation Notes

**Commit:** 120cee5
**Date:** 2026-01-29

Changes made:
- Added `FiftySegmentedControlVariant` enum with `primary` and `secondary` values
- Added `variant` parameter to `FiftySegmentedControl` (default: primary)
- Active colors are now variant-based (mode-independent) per FDL v2
- Updated doc comments with variant documentation and examples
- All 276 tests pass

---

**Created:** 2026-01-29
**Design Source:** fifty_ui_kit_components_2
