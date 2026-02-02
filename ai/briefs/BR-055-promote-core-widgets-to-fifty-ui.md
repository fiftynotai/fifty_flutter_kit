# BR-055: Promote Core Widgets to fifty_ui

**Type:** Feature
**Priority:** P1-High
**Effort:** M (Medium)
**Status:** Done

---

## Summary

Promote `StatusIndicator` and `SectionHeader` from fifty_demo to fifty_ui package as reusable FDL components. These are high-value, generic widgets used throughout the demo app that follow design system patterns.

---

## Motivation

- Both widgets are generic UI patterns with no business logic dependencies
- They follow FDL conventions (FiftyTypography, FiftySpacing, theme-aware colors)
- High reuse potential across any app using fifty_ui
- Reduces code duplication when building new apps

---

## Scope

### In Scope

1. **FiftyStatusIndicator** (from `StatusIndicator`)
   - Source: `apps/fifty_demo/lib/shared/widgets/status_indicator.dart`
   - Destination: `packages/fifty_ui/lib/src/display/fifty_status_indicator.dart`
   - Features:
     - Status states: ready, loading, error, offline, idle
     - Colored dot indicator with label
     - Theme-aware colors via FiftyThemeExtension
     - Size variants (small, medium, large)

2. **FiftySectionHeader** (from `SectionHeader`)
   - Source: `apps/fifty_demo/lib/shared/widgets/section_header.dart`
   - Destination: `packages/fifty_ui/lib/src/display/fifty_section_header.dart`
   - Features:
     - Title with optional subtitle
     - Leading dot indicator (configurable)
     - Optional trailing widget
     - Optional divider
     - Size variants

3. **Update fifty_demo** to use new fifty_ui components

### Out of Scope

- SectionNavPill (evaluate vs FiftyChip separately)
- Utility widgets (_ControlButton, _InfoRow, _TypingCursor) - separate brief
- Engine-specific widgets (speech/audio controls) - separate brief

---

## Technical Details

### FiftyStatusIndicator API

```dart
enum FiftyStatusState { ready, loading, error, offline, idle }
enum FiftyStatusSize { small, medium, large }

class FiftyStatusIndicator extends StatelessWidget {
  const FiftyStatusIndicator({
    required this.label,
    required this.state,
    this.size = FiftyStatusSize.medium,
    this.showDot = true,
    this.showStatusLabel = true,
    this.customColor,
    super.key,
  });

  final String label;
  final FiftyStatusState state;
  final FiftyStatusSize size;
  final bool showDot;
  final bool showStatusLabel;
  final Color? customColor;
}
```

### FiftySectionHeader API

```dart
enum FiftySectionHeaderSize { small, medium, large }

class FiftySectionHeader extends StatelessWidget {
  const FiftySectionHeader({
    required this.title,
    this.subtitle,
    this.trailing,
    this.leading,
    this.showDivider = true,
    this.showDot = true,
    this.size = FiftySectionHeaderSize.medium,
    this.onTap,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final bool showDivider;
  final bool showDot;
  final FiftySectionHeaderSize size;
  final VoidCallback? onTap;
}
```

---

## Acceptance Criteria

- [x] `FiftyStatusIndicator` created in fifty_ui with all status states
- [x] `FiftySectionHeader` created in fifty_ui with all options
- [x] Both components exported from `fifty_ui.dart` barrel
- [x] Both components documented with dartdoc comments
- [x] fifty_demo updated to import from fifty_ui instead of local
- [x] Original shared widgets removed from fifty_demo
- [x] All existing usages in fifty_demo work correctly
- [ ] Example usage added to fifty_ui example app (if exists)

---

## Files Created

- `packages/fifty_ui/lib/src/display/fifty_status_indicator.dart`
- `packages/fifty_ui/lib/src/display/fifty_section_header.dart`

## Files Modified

- `packages/fifty_ui/lib/fifty_ui.dart` (added exports)
- `apps/fifty_demo/lib/shared/widgets/widgets.dart` (removed exports)
- All files in fifty_demo that import these widgets (updated imports)

---

## Dependencies

- fifty_tokens (spacing, typography)
- fifty_theme (FiftyThemeExtension for semantic colors)

---

## Documentation Summary

### FiftyStatusIndicator

Comprehensive dartdoc documentation includes:
- Feature list (5 semantic states, 3 size variants, theme-aware colors)
- "Why" section explaining rationale
- 4 usage examples covering basic, without status label, large with custom color, and without dot scenarios
- All properties documented with descriptions

### FiftySectionHeader

Comprehensive dartdoc documentation includes:
- Feature list (3 sizes, subtitle, leading/trailing, divider, dot, tap handler)
- "Why" section explaining rationale
- 6 usage examples covering basic, with subtitle, with trailing, large without divider, with leading icon, and tappable scenarios
- All properties documented with descriptions including behavior notes (e.g., dot auto-hides when leading provided)

---

## Notes

- Maintain backward compatibility with existing usage patterns
- Consider adding unit tests for the new components
- Follow existing fifty_ui component patterns (see FiftyButton, FiftyCard)
