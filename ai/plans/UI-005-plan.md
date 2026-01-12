# Implementation Plan: UI-005

**Complexity:** M (Medium)
**Estimated Duration:** 4-6 hours
**Risk Level:** Low
**Created:** 2026-01-12

## Summary

Update the `fifty_printing_engine` example app (10 files) to use Fifty Design Language (FDL) components, tokens, and theming. Kinetic Brutalism aesthetic - dark theme, crimson accents, terminal-style typography.

## Files to Modify

| File | Action |
|------|--------|
| `example/pubspec.yaml` | Add FDL dependencies |
| `example/lib/main.dart` | FiftyTheme.dark(), NavigationBar styling |
| `example/lib/screens/home_screen.dart` | FiftyCard, FDL colors/spacing |
| `example/lib/screens/printer_management_screen.dart` | FiftyButton, FDL dialogs |
| `example/lib/screens/test_print_screen.dart` | FiftyCard, FiftyButton |
| `example/lib/screens/ticket_builder_screen.dart` | FiftyCard, FiftyButton, FDL inputs |
| `example/lib/widgets/printer_list_item.dart` | FiftyCard, status colors |
| `example/lib/widgets/add_printer_dialog.dart` | FiftyCard dialog, FiftyButton |
| `example/lib/widgets/printer_selection_dialog.dart` | FiftyCard dialog, FiftyButton |
| `example/lib/widgets/bluetooth_scan_sheet.dart` | FDL bottom sheet, FiftyButton |
| `example/lib/widgets/print_result_widget.dart` | FiftyCard, FDL status colors |

**NOT modified:** kitchen_ticket_example.dart, receipt_ticket_example.dart (pure printing logic)

## Color Mapping

| Flutter | FDL |
|---------|-----|
| Background | `FiftyColors.voidBlack` |
| Cards | `FiftyColors.gunmetal` |
| Primary accent | `FiftyColors.crimsonPulse` |
| Secondary text | `FiftyColors.hyperChrome` |
| Success | `FiftyColors.success` / `FiftyColors.igrisGreen` |
| Error | `FiftyColors.error` |
| Warning | `FiftyColors.warning` |

## Spacing Mapping

| Size | Token |
|------|-------|
| 4px | `FiftySpacing.xs` |
| 8px | `FiftySpacing.sm` |
| 12px | `FiftySpacing.md` |
| 16px | `FiftySpacing.lg` |
| 24px | `FiftySpacing.xl` |
| 32px | `FiftySpacing.xxl` |

## Phases

1. Dependencies - Add fifty_tokens, fifty_theme, fifty_ui
2. Theme Setup - FiftyTheme.dark() in main.dart
3. Screens - Update 4 screens with FDL
4. Widgets - Update 5 widgets with FDL
5. Verification - flutter analyze, build test
