# BR-046: FiftyRadioCard Component

**Type:** Feature
**Priority:** P2-Medium
**Effort:** S-Small (< 1d)
**Status:** Done
**Created:** 2026-01-27

---

## Problem

The FDL v2 design system includes card-style radio selection for things like theme mode selection (Light/Dark). Our current `FiftyRadio` only supports the standard circular radio button style.

---

## Goal

Create `FiftyRadioCard` widget for card-style radio selection with:
- Icon centered in card
- Label below icon
- Border highlight when selected
- Works as part of a radio group

---

## Design Reference

**File:** `design_system/v2/fifty_ui_kit_components_3/screen.png`

```
┌─────────────┐  ┌─────────────┐
│     ☀️      │  │     🌙      │  ← Selected (bordered)
│   Light     │  │    Dark     │
└─────────────┘  └─────────────┘
```

**States:**
- **Unselected:** Subtle border, muted icon
- **Selected:** Primary/powder-blush border, ring effect
- **Hover:** Scale icon slightly

---

## Implementation

### API Design

```dart
class FiftyRadioCard<T> extends StatelessWidget {
  const FiftyRadioCard({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.icon,
    required this.label,
    this.enabled = true,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final IconData icon;
  final String label;
  final bool enabled;
}
```

### Usage

```dart
Row(
  children: [
    Expanded(
      child: FiftyRadioCard<ThemeMode>(
        value: ThemeMode.light,
        groupValue: _themeMode,
        onChanged: (v) => setState(() => _themeMode = v),
        icon: Icons.light_mode,
        label: 'Light',
      ),
    ),
    SizedBox(width: FiftySpacing.md),
    Expanded(
      child: FiftyRadioCard<ThemeMode>(
        value: ThemeMode.dark,
        groupValue: _themeMode,
        onChanged: (v) => setState(() => _themeMode = v),
        icon: Icons.dark_mode,
        label: 'Dark',
      ),
    ),
  ],
)
```

---

## Related Files

**Create:**
- `packages/fifty_ui/lib/src/inputs/fifty_radio_card.dart`
- `packages/fifty_ui/test/inputs/fifty_radio_card_test.dart`

**Modify:**
- `packages/fifty_ui/lib/fifty_ui.dart` (export)
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/inputs_section.dart`

**Reference:**
- `design_system/v2/fifty_ui_kit_components_3/screen.png`
- `design_system/v2/fifty_ui_kit_components_3/code.html`

---

## Acceptance Criteria

1. [x] FiftyRadioCard renders with icon and label
2. [x] Selected state shows primary border with ring effect
3. [x] Unselected state shows subtle border
4. [x] Icon scales on hover
5. [x] Generic type support (works with enums)
6. [x] Disabled state support
7. [x] Dark/light mode support
8. [x] Tests pass (12/12)
9. [x] Demo showcases theme mode selection

---

**Created:** 2026-01-27
**Design Source:** fifty_ui_kit_components_3
