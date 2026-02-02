# BR-057: Promote Utility Widgets to fifty_ui

**Type:** Feature
**Priority:** P3-Low
**Effort:** M (Medium)
**Status:** Done

---

## Summary

Promote utility widgets from fifty_demo to fifty_ui: `SectionNavPill`, `_SettingRow`, `_ControlButton`, `_InfoRow`, and `_TypingCursor`. These are lower-priority but useful generic components.

---

## Motivation

- Consolidate duplicate widgets (3 instances of `_ControlButton`, 2 of `_TypingCursor`)
- Provide common UI patterns for settings screens, toolbars, info panels
- Complete the FDL component library with common patterns

---

## Scope

### In Scope

1. **FiftySettingsRow** (from `_SettingRow`)
   - Source: `apps/fifty_demo/lib/features/dialogue_demo/views/widgets/tts_controls.dart`
   - Destination: `packages/fifty_ui/lib/src/display/fifty_settings_row.dart`
   - Features:
     - Icon + label + toggle layout
     - Uses FiftySwitch internally
     - Optional subtitle and trailing text

2. **FiftyNavPill** (from `SectionNavPill`)
   - Source: `apps/fifty_demo/lib/shared/widgets/section_nav_pill.dart`
   - Destination: `packages/fifty_ui/lib/src/controls/fifty_nav_pill.dart`
   - Features:
     - Icon + label pill
     - Active/inactive states
     - Horizontal scrollable list support
   - **Note:** Evaluated - FiftyNavPill kept separate from FiftyChip (different use cases)

3. **FiftyLabeledIconButton** (from `_ControlButton`)
   - Source: `apps/fifty_demo/lib/features/map_demo/views/widgets/map_controls.dart`
   - Destination: `packages/fifty_ui/lib/src/buttons/fifty_labeled_icon_button.dart`
   - Features:
     - Circular icon with label below
     - Size variants (small, medium, large)
     - Style variants (filled, outlined, ghost)
     - Disabled/selected states

4. **FiftyInfoRow** (from `_InfoRow`)
   - Source: `apps/fifty_demo/lib/features/map_demo/views/widgets/entity_info_panel.dart`
   - Destination: `packages/fifty_ui/lib/src/display/fifty_info_row.dart`
   - Features:
     - Key-value row display
     - Optional icon
     - Value color customization
     - Custom label/value styles
   - **Note:** Evaluated - FiftyInfoRow kept separate from FiftyDataSlate (lightweight vs panel)

5. **FiftyCursor** (from `_TypingCursor`)
   - Source: `apps/fifty_demo/lib/features/dialogue_demo/views/widgets/dialogue_display.dart`
   - Destination: `packages/fifty_ui/lib/src/utils/fifty_cursor.dart`
   - Features:
     - Blinking cursor animation
     - Customizable color and size
     - Adjustable blink speed

### Out of Scope

- StatusIndicator, SectionHeader (covered in BR-055)
- Speech/Audio controls (covered in BR-056)

---

## Technical Details

### FiftySettingsRow API

```dart
class FiftySettingsRow extends StatelessWidget {
  const FiftySettingsRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trailingText,
    this.enabled = true,
    this.switchSize = FiftySwitchSize.medium,
    super.key,
  });

  final String label;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final String? trailingText;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final FiftySwitchSize switchSize;
}
```

### FiftyNavPill API

```dart
class FiftyNavPillItem {
  const FiftyNavPillItem({
    required this.id,
    required this.label,
    this.icon,
  });

  final String id;
  final String label;
  final IconData? icon;
}

class FiftyNavPill extends StatelessWidget {
  const FiftyNavPill({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.icon,
    this.activeColor,
    super.key,
  });

  final String label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback onTap;
  final Color? activeColor;
}

class FiftyNavPillBar extends StatelessWidget {
  const FiftyNavPillBar({
    required this.items,
    required this.selectedId,
    required this.onSelected,
    this.activeColor,
    this.spacing = FiftySpacing.sm,
    this.padding,
    super.key,
  });

  final List<FiftyNavPillItem> items;
  final String selectedId;
  final ValueChanged<String> onSelected;
  final Color? activeColor;
  final double spacing;
  final EdgeInsets? padding;
}
```

### FiftyLabeledIconButton API

```dart
enum FiftyLabeledIconButtonSize { small, medium, large }
enum FiftyLabeledIconButtonStyle { filled, outlined, ghost }

class FiftyLabeledIconButton extends StatelessWidget {
  const FiftyLabeledIconButton({
    required this.icon,
    required this.onPressed,
    this.label,
    this.size = FiftyLabeledIconButtonSize.medium,
    this.style = FiftyLabeledIconButtonStyle.filled,
    this.isSelected = false,
    this.color,
    this.enabled = true,
    super.key,
  });

  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final FiftyLabeledIconButtonSize size;
  final FiftyLabeledIconButtonStyle style;
  final bool isSelected;
  final Color? color;
  final bool enabled;
}
```

### FiftyInfoRow API

```dart
class FiftyInfoRow extends StatelessWidget {
  const FiftyInfoRow({
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
    this.onTap,
    this.labelStyle,
    this.valueStyle,
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;
  final VoidCallback? onTap;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
}
```

### FiftyCursor API

```dart
class FiftyCursor extends StatefulWidget {
  const FiftyCursor({
    this.color,
    this.width = 2,
    this.height = 20,
    this.blinkDuration = const Duration(milliseconds: 500),
    super.key,
  });

  final Color? color;
  final double width;
  final double height;
  final Duration blinkDuration;
}
```

---

## Acceptance Criteria

- [x] All 5 widgets created in fifty_ui
- [x] Exported from `fifty_ui.dart` barrel
- [x] Documented with dartdoc comments
- [x] Duplicate widgets consolidated in fifty_demo
- [x] fifty_demo updated to use new components
- [x] FiftyNavPill evaluated against FiftyChip for overlap
- [x] FiftyInfoRow evaluated against FiftyDataSlate for overlap

---

## Files Created

- `packages/fifty_ui/lib/src/display/fifty_settings_row.dart`
- `packages/fifty_ui/lib/src/display/fifty_info_row.dart`
- `packages/fifty_ui/lib/src/controls/fifty_nav_pill.dart`
- `packages/fifty_ui/lib/src/buttons/fifty_labeled_icon_button.dart`
- `packages/fifty_ui/lib/src/utils/fifty_cursor.dart`

## Files Modified

- `packages/fifty_ui/lib/fifty_ui.dart` (added exports)
- `packages/fifty_ui/lib/src/display/display.dart` (added to barrel)
- `packages/fifty_ui/lib/src/controls/controls.dart` (added to barrel)
- `packages/fifty_ui/lib/src/buttons/buttons.dart` (added to barrel)
- Multiple fifty_demo files (updated imports, removed duplicates)

---

## Files Removed (after migration)

- `apps/fifty_demo/lib/shared/widgets/section_nav_pill.dart`
- Duplicate `_ControlButton` in 3 files
- Duplicate `_TypingCursor` in 2 files

---

## Dependencies

- fifty_tokens (spacing, typography)
- fifty_theme (theme-aware colors)
- BR-055 completed first (established patterns)

---

## Evaluation Notes

### FiftyNavPill vs FiftyChip
- FiftyChip: Tag/label display, not selectable in group
- FiftyNavPill: Navigation selection, group selection support
- **Decision:** Keep separate - different use cases

### FiftyInfoRow vs FiftyDataSlate
- FiftyDataSlate: Multiple key-value pairs in a panel
- FiftyInfoRow: Single key-value row, more lightweight
- **Decision:** Keep separate - FiftyInfoRow for simple rows, FiftyDataSlate for panels

---

## Implementation Notes

All widgets follow FDL v2 design patterns:
- Theme-aware colors via `Theme.of(context).colorScheme`
- Consistent spacing using `FiftySpacing` tokens
- Typography using `FiftyTypography` constants
- Border radii using `FiftyRadii` constants
- Comprehensive dartdoc with usage examples

---

## Completion Date

2026-02-02
