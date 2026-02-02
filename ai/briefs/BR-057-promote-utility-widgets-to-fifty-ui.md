# BR-057: Promote Utility Widgets to fifty_ui

**Type:** Feature
**Priority:** P3-Low
**Effort:** M (Medium)
**Status:** Ready

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
   - **Note:** Evaluate overlap with FiftyChip - may extend instead

3. **FiftyLabeledIconButton** (from `_ControlButton`)
   - Source: `apps/fifty_demo/lib/features/map_demo/views/widgets/map_controls.dart`
   - Destination: `packages/fifty_ui/lib/src/buttons/fifty_labeled_icon_button.dart`
   - Features:
     - Circular icon with label below
     - Size variants
     - Disabled/selected states

4. **FiftyInfoRow** (from `_InfoRow`)
   - Source: `apps/fifty_demo/lib/features/map_demo/views/widgets/entity_info_panel.dart`
   - Destination: `packages/fifty_ui/lib/src/display/fifty_info_row.dart`
   - Features:
     - Key-value row display
     - Optional icon
     - Value color customization
   - **Note:** Evaluate if FiftyDataSlate covers this use case

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
    this.icon,
    this.subtitle,
    this.trailingText,
    this.enabled = true,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final String? subtitle;
  final String? trailingText;
  final bool enabled;
}
```

### FiftyNavPill API

```dart
class FiftyNavPill extends StatelessWidget {
  const FiftyNavPill({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.icon,
    this.activeColor,
    this.inactiveColor,
    super.key,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? activeColor;
  final Color? inactiveColor;
}

// Helper for horizontal pill lists
class FiftyNavPillBar extends StatelessWidget {
  const FiftyNavPillBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.scrollable = true,
    super.key,
  });

  final List<FiftyNavPillItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool scrollable;
}
```

### FiftyLabeledIconButton API

```dart
enum FiftyLabeledIconButtonSize { small, medium, large }

class FiftyLabeledIconButton extends StatelessWidget {
  const FiftyLabeledIconButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.size = FiftyLabeledIconButtonSize.medium,
    this.isSelected = false,
    this.isDisabled = false,
    this.color,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final FiftyLabeledIconButtonSize size;
  final bool isSelected;
  final bool isDisabled;
  final Color? color;
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
    super.key,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;
  final VoidCallback? onTap;
}
```

### FiftyCursor API

```dart
class FiftyCursor extends StatefulWidget {
  const FiftyCursor({
    this.color,
    this.width = 2.0,
    this.height = 20.0,
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

- [ ] All 5 widgets created in fifty_ui
- [ ] Exported from `fifty_ui.dart` barrel
- [ ] Documented with dartdoc comments
- [ ] Duplicate widgets consolidated in fifty_demo
- [ ] fifty_demo updated to use new components
- [ ] FiftyNavPill evaluated against FiftyChip for overlap
- [ ] FiftyInfoRow evaluated against FiftyDataSlate for overlap

---

## Files to Create

- `packages/fifty_ui/lib/src/display/fifty_settings_row.dart`
- `packages/fifty_ui/lib/src/display/fifty_info_row.dart`
- `packages/fifty_ui/lib/src/controls/fifty_nav_pill.dart`
- `packages/fifty_ui/lib/src/buttons/fifty_labeled_icon_button.dart`
- `packages/fifty_ui/lib/src/utils/fifty_cursor.dart`

## Files to Modify

- `packages/fifty_ui/lib/fifty_ui.dart` (add exports)
- `packages/fifty_ui/lib/src/display/display.dart` (add to barrel)
- `packages/fifty_ui/lib/src/controls/controls.dart` (add to barrel)
- `packages/fifty_ui/lib/src/buttons/buttons.dart` (add to barrel)
- Multiple fifty_demo files (update imports, remove duplicates)

---

## Files to Remove (after migration)

- `apps/fifty_demo/lib/shared/widgets/section_nav_pill.dart`
- Duplicate `_ControlButton` in 3 files
- Duplicate `_TypingCursor` in 2 files

---

## Dependencies

- fifty_tokens (spacing, typography)
- fifty_theme (theme-aware colors)
- BR-055 should be completed first (establishes patterns)

---

## Evaluation Notes

### FiftyNavPill vs FiftyChip
- FiftyChip: Tag/label display, not selectable in group
- FiftyNavPill: Navigation selection, group selection support
- **Recommendation:** Keep separate - different use cases

### FiftyInfoRow vs FiftyDataSlate
- FiftyDataSlate: Multiple key-value pairs in a panel
- FiftyInfoRow: Single key-value row, more lightweight
- **Recommendation:** Keep separate - FiftyInfoRow for simple rows, FiftyDataSlate for panels

---

## Notes

- Lower priority than BR-055 and BR-056
- Can be implemented incrementally (one widget at a time)
- Consider adding storybook/catalog entries for each component
