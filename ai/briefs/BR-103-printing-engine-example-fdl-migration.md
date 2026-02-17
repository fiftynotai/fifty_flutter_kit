# BR-103: Printing Engine Example — FDL Migration & fifty_ui Adoption

**Type:** Migration
**Priority:** P2-Medium
**Effort:** M-Medium (2-3d)
**Status:** Ready
**Created:** 2026-02-17
**Requested By:** Monarch
**Supersedes:** UI-008 (vague, outdated — this brief replaces it)

---

## Problem

The fifty_printing_engine example app builds its own custom widgets (cards, dialogs, list items, bottom sheets, result displays) instead of consuming fifty_ui components. This creates:

1. **Duplicated UI code** - Custom widgets that already exist in fifty_ui
2. **Hardcoded colors** - `Colors.green`, `Colors.orange`, `Colors.deepPurple` instead of theme tokens
3. **Inconsistent UX** - Doesn't match other FDL-compliant example apps
4. **Maintenance burden** - Fixes to fifty_ui don't flow through to this app
5. **No DRY** - Every example app re-invents the same patterns

---

## Goal

Migrate the printing engine example to fully consume FDL elements:

1. Replace all custom widgets with fifty_ui equivalents
2. Eliminate every hardcoded color — use `colorScheme` and FDL tokens only
3. Keep the app fully theme-aware (light + dark)
4. Follow DRY — never create a widget that already exists in fifty_ui
5. If a custom widget is general enough, promote it to fifty_ui before using it
6. Match quality bar of the fifty_achievement_engine example app

---

## Scope

**Package:** `packages/fifty_printing_engine/example/`

**Files to migrate:**

| File | Description |
|------|-------------|
| `lib/main.dart` | App entry, theme setup |
| `lib/screens/home_screen.dart` | Home with navigation |
| `lib/screens/printer_management_screen.dart` | Printer CRUD |
| `lib/screens/test_print_screen.dart` | Print testing |
| `lib/screens/ticket_builder_screen.dart` | Ticket composition |
| `lib/widgets/printer_list_item.dart` | Custom list item |
| `lib/widgets/add_printer_dialog.dart` | Custom dialog |
| `lib/widgets/printer_selection_dialog.dart` | Multi-select dialog |
| `lib/widgets/bluetooth_scan_sheet.dart` | BT scan bottom sheet |
| `lib/widgets/print_result_widget.dart` | Result display |
| `lib/examples/kitchen_ticket_example.dart` | Kitchen ticket demo |
| `lib/examples/receipt_ticket_example.dart` | Receipt ticket demo |

---

## Component Migration Map

### Direct Replacements (delete custom widget, use fifty_ui)

| Current Custom Widget | Replace With | Notes |
|-----------------------|-------------|-------|
| `PrinterListItem` | `FiftyListTile` | Status indicator via `FiftyStatusIndicator` or `FiftyBadge` |
| `AddPrinterDialog` (AlertDialog) | `FiftyDialog` + `FiftyTextField` + `FiftyDropdown` | Form fields become FDL inputs |
| `PrinterSelectionDialog` (AlertDialog) | `FiftyDialog` + `FiftyCheckbox` | Multi-select with FDL checkboxes |
| `PrintResultWidget` metrics | `FiftyStatCard` | Success/failure/total counts |
| Custom buttons | `FiftyButton` / `FiftyIconButton` | All ElevatedButton/TextButton/IconButton → FDL |
| Custom cards | `FiftyCard` | All Card() → FiftyCard |
| Section headers | `FiftySectionHeader` | Any custom section title patterns |
| Settings rows | `FiftySettingsRow` | Toggle/dropdown settings |
| Loading indicators | `FiftyLoadingIndicator` | Any CircularProgressIndicator |

### Compose with fifty_ui (keep custom shell, use FDL internals)

| Current Custom Widget | Compose Using | Notes |
|-----------------------|--------------|-------|
| `BluetoothScanSheet` | `FiftyCard` + `FiftyListTile` + `FiftyLoadingIndicator` + `FiftyButton` | Bottom sheet shell stays, internals become FDL |
| `PrintResultWidget` detail list | `FiftyListTile` + `FiftyBadge` | Per-printer result rows |

### Promotion Candidates (evaluate for fifty_ui)

During migration, evaluate if any of these patterns are general enough to promote:

| Pattern | Candidate For | Criteria |
|---------|--------------|----------|
| Printer status badge (connected/error/printing) | `FiftyStatusBadge` variant | If 3+ example apps need status display |
| Scan/discovery bottom sheet pattern | `FiftyDiscoverySheet` | If BT/WiFi scan pattern reusable |
| Print result summary card | `FiftyResultCard` | If success/partial/failure pattern reusable |

**Rule:** Only promote if the widget is truly reusable across 2+ packages. Otherwise keep it in the example app but built from fifty_ui primitives.

---

## Hardcoded Color Audit

Replace all instances:

| Hardcoded | Replace With |
|-----------|-------------|
| `Colors.green` (connected/success) | `colorScheme.primary` or `colorScheme.tertiary` |
| `Colors.orange` (partial/warning) | `colorScheme.tertiary` or custom semantic |
| `Colors.red` (error/failed) | `colorScheme.error` |
| `Colors.deepPurple` (theme seed) | FDL theme seed from `fifty_theme` |
| `Colors.grey` (disabled) | `colorScheme.outline` or `colorScheme.surfaceContainerHighest` |
| Any `Color(0x...)` | Appropriate `colorScheme` token |

---

## Theme Awareness Requirements

- All screens must render correctly in light AND dark mode
- No color should be hardcoded — everything from `Theme.of(context).colorScheme`
- Spacing from `FiftySpacing` tokens
- Typography from `FiftyTypography` tokens
- Border radii from `FiftyRadii` tokens
- Motion/animation durations from `FiftyMotion` tokens
- Test both themes on iOS simulator before marking complete

---

## Architecture Notes

Current app uses StatefulWidget + PrintingEngine singleton. This is fine — no architecture change needed. Focus is purely on UI layer migration.

---

## Acceptance Criteria

- [ ] Zero hardcoded colors — every color from `colorScheme` or FDL tokens
- [ ] All custom widgets replaced with fifty_ui equivalents where available
- [ ] Remaining custom widgets composed from fifty_ui primitives
- [ ] `FiftyListTile` replaces `PrinterListItem`
- [ ] `FiftyDialog` replaces all `AlertDialog` usage
- [ ] `FiftyButton` replaces all `ElevatedButton`/`TextButton`
- [ ] `FiftyCard` replaces all `Card`
- [ ] `FiftyTextField` / `FiftyDropdown` replace all form inputs
- [ ] `FiftyStatCard` replaces metric displays
- [ ] `FiftyLoadingIndicator` replaces `CircularProgressIndicator`
- [ ] Light + dark mode verified on iOS simulator
- [ ] Analyzer clean (zero errors, zero warnings)
- [ ] All printing features still functional after migration
- [ ] DRY: no widget duplicates fifty_ui functionality
- [ ] Any promoted widgets added to fifty_ui with exports + documentation
- [ ] Screenshots recaptured for README

---

## Workflow State

**Phase:** Not Started
**Active Agent:** None
**Retry Count:** 0

### Agent Log
_(empty - not started)_
