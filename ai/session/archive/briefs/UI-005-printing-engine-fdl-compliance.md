# UI-005: Fifty Printing Engine Example - FDL Compliance

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M-Medium (4-6 hours)
**Status:** Done
**Created:** 2026-01-12
**Assignee:** -

---

## Problem

The `fifty_printing_engine` example app uses default Flutter Material Design widgets instead of the Fifty Design Language (FDL). This is inconsistent with other Fifty ecosystem examples and doesn't showcase the cohesive Fifty visual identity.

---

## Goal

Update the `fifty_printing_engine` example app to use FDL components, tokens, and theming for a consistent Fifty ecosystem experience. The app should match the visual style of `fifty_demo` and other ecosystem examples.

---

## Context & Inputs

### Current State
- **Location:** `packages/fifty_printing_engine/example/`
- **Files:** 12 Dart files (4 screens, 5 widgets, 2 examples, 1 main)
- **Current UI:** Default Flutter Material Design
- **Missing:** FDL packages (fifty_tokens, fifty_theme, fifty_ui)

### Files to Update

**Screens (4):**
- `lib/screens/home_screen.dart`
- `lib/screens/printer_management_screen.dart`
- `lib/screens/test_print_screen.dart`
- `lib/screens/ticket_builder_screen.dart`

**Widgets (5):**
- `lib/widgets/printer_list_item.dart`
- `lib/widgets/add_printer_dialog.dart`
- `lib/widgets/printer_selection_dialog.dart`
- `lib/widgets/bluetooth_scan_sheet.dart`
- `lib/widgets/print_result_widget.dart`

**Core (1):**
- `lib/main.dart` - Theme setup

### FDL Packages to Add
```yaml
dependencies:
  fifty_tokens:
    path: ../../fifty_tokens
  fifty_theme:
    path: ../../fifty_theme
  fifty_ui:
    path: ../../fifty_ui
```

### FDL Components to Use

| Flutter Widget | FDL Replacement |
|----------------|-----------------|
| `ElevatedButton` | `FiftyButton` |
| `Card` | `FiftyCard` |
| `TextField` | `FiftyTextField` |
| `AppBar` | Custom with `FiftyColors.voidBlack` |
| `ListTile` | Custom with FDL tokens |
| `Dialog` | `FiftyCard` based dialog |
| `BottomSheet` | Custom with FDL styling |
| `CircularProgressIndicator` | FDL styled loader |
| `SnackBar` | FDL styled feedback |

### FDL Tokens to Apply

**Colors:**
- `FiftyColors.voidBlack` - Background
- `FiftyColors.crimsonPulse` - Primary accent
- `FiftyColors.hyperChrome` - Secondary text
- `FiftyColors.igrisGreen` - Success/online status
- `FiftyColors.error` - Error states
- `FiftyColors.border` - Borders

**Typography:**
- `FiftyTypography.fontFamilyHeadline` - Headlines
- `FiftyTypography.fontFamilyMono` - Body/data

**Spacing:**
- `FiftySpacing.sm/md/lg/xl` - Consistent spacing

**Radii:**
- `FiftyRadii.standardRadius` - Card corners

---

## Constraints

1. **Preserve functionality** - No changes to printing logic
2. **FDL compliance** - Use Fifty tokens, not hardcoded values
3. **FDL v2** - Match Fifty aesthetic (modern sophisticated, burgundy accents, Manrope typography)
4. **Responsive** - Work on various screen sizes
5. **Accessibility** - Maintain proper contrast ratios

---

## Acceptance Criteria

- [ ] `pubspec.yaml` includes fifty_tokens, fifty_theme, fifty_ui
- [ ] `main.dart` uses `FiftyTheme` for app theming
- [ ] All buttons replaced with `FiftyButton`
- [ ] All cards replaced with `FiftyCard`
- [ ] All text inputs use FDL styling
- [ ] Colors use `FiftyColors.*` tokens (no hardcoded colors)
- [ ] Spacing uses `FiftySpacing.*` tokens
- [ ] Typography uses FDL font families
- [ ] Status indicators match Fifty style (green online, red error)
- [ ] Dialogs/sheets styled with FDL components
- [ ] `flutter analyze` passes (zero errors)
- [ ] App builds and runs correctly

---

## Test Plan

### Automated
1. Run `flutter analyze` in example directory - zero errors
2. Run `flutter build apk --debug` - successful build

### Manual
1. Launch app and verify Fifty visual identity
2. Test all screens render correctly
3. Verify printer status colors (green/yellow/red)
4. Test dialogs and bottom sheets styling
5. Verify button interactions and feedback
6. Check dark theme consistency

---

## Implementation Approach

### Phase 1: Dependencies
1. Update `example/pubspec.yaml` with FDL packages
2. Run `flutter pub get`

### Phase 2: Theme Setup
1. Update `main.dart` with `FiftyTheme`
2. Configure dark theme as default

### Phase 3: Screens
Update each screen to use FDL:
- Replace AppBar styling
- Replace buttons with FiftyButton
- Replace cards with FiftyCard
- Apply FDL colors and spacing

### Phase 4: Widgets
Update shared widgets:
- Printer list item styling
- Dialog components
- Bottom sheet styling
- Status indicators

### Phase 5: Polish
1. Verify consistency across all screens
2. Fix any visual issues
3. Run analyze and build

---

## Delivery

- [ ] Branch: `implement/UI-005-printing-fdl`
- [ ] All files updated with FDL compliance
- [ ] Build successful
- [ ] Commit with conventional format

---

## Notes

- Reference `fifty_demo` for FDL implementation patterns
- Reference `apps/fifty_demo/lib/src/` for MVVM+Actions structure if needed
- Consider using `FiftyDataSlate` for printer status display
- Consider `StatusIndicator` widget for connection status

---

## Related

- Package: `packages/fifty_printing_engine/example/`
- Reference: `apps/fifty_demo/` (FDL implementation example)
- Tokens: `packages/fifty_tokens/`
- Theme: `packages/fifty_theme/`
- UI: `packages/fifty_ui/`
- Guidelines: `ai/context/coding_guidelines.md`
