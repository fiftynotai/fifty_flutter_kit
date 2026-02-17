# BR-103 Implementation Plan: Printing Engine Example — FDL Migration

**Complexity:** M (Medium)
**Files affected:** 11 (2 examples unchanged)
**Phases:** 4 (Dependencies, Widgets, Screens, Verification)

---

## Migration Order (Sequential)

1. `pubspec.yaml` — add fifty_tokens, fifty_theme, fifty_ui dependencies
2. `main.dart` — swap ThemeData to FiftyTheme.light()/dark()
3. `print_result_widget.dart` — FiftyCard, FiftyStatCard, FiftySectionHeader, FiftyBadge; eliminate Colors.green/orange
4. `printer_list_item.dart` — FiftyCard, FiftyStatusIndicator, FiftyButton; eliminate Colors.green/orange
5. `bluetooth_scan_sheet.dart` — FiftyLoadingIndicator, FiftyListTile, FiftyButton, FiftyIconButton
6. `add_printer_dialog.dart` — FiftyDialog, FiftyTextField, FiftyDropdown, FiftySegmentedControl; REMOVE Form widget, add manual validation
7. `printer_selection_dialog.dart` — FiftyDialog, FiftyCheckbox, FiftyBadge, FiftyButton; eliminate Colors.green/orange
8. `home_screen.dart` — FiftyCard, FiftySectionHeader, FiftyListTile, FiftyDivider
9. `printer_management_screen.dart` — FiftyDialog, FiftyButton, FiftyIconButton; snackbar colors
10. `test_print_screen.dart` — FiftyCard, FiftySegmentedControl, FiftySectionHeader; snackbar colors
11. `ticket_builder_screen.dart` — FiftyCard, FiftyTextField, FiftySegmentedControl, FiftyButton

**No changes:** kitchen_ticket_example.dart, receipt_ticket_example.dart (pure data generation)

---

## Semantic Color Mapping

| Hardcoded | Replace With |
|-----------|-------------|
| `Colors.deepPurple` | Remove entirely (FiftyTheme handles seed) |
| `Colors.green` (success) | `Theme.of(context).extension<FiftyThemeExtension>()!.success` |
| `Colors.orange` (warning/partial) | `Theme.of(context).extension<FiftyThemeExtension>()!.warning` |
| `Colors.red` / `colorScheme.error` | Keep `colorScheme.error` (already theme-aware) |

---

## Form Validation Strategy (add_printer_dialog.dart — CRITICAL)

1. Remove `Form` widget and `_formKey`
2. Add individual error state: `String? _nameError, _addressError, _portError, _copiesError;`
3. Create `bool _validate()` that sets errors via setState
4. Pass errors to `FiftyTextField(errorText: _nameError)`
5. Clear on change: `onChanged: (_) => setState(() => _nameError = null)`
6. Call `_validate()` in submit instead of `_formKey.currentState!.validate()`

---

## Key Decisions

- **NavigationBar**: Keep Material NavigationBar (FiftyTheme already styles it)
- **FloatingActionButton**: Keep FAB (FiftyTheme already styles it via floatingActionButtonTheme)
- **FilterChip**: Keep FilterChip (no FDL equivalent, FiftyTheme styles chipTheme)
- **CircleAvatar**: Keep (not a Card/Button/Dialog pattern)
- **BottomSheet shell**: Keep showModalBottomSheet (FiftyTheme styles bottomSheetTheme)
- **Scanline**: Set `scanlineOnHover: false` on utility cards that should feel static

---

## PrinterStatus → FiftyStatusState Mapping

```
PrinterStatus.connected        → FiftyStatusState.ready
PrinterStatus.printing         → FiftyStatusState.loading
PrinterStatus.connecting       → FiftyStatusState.loading
PrinterStatus.error            → FiftyStatusState.error
PrinterStatus.healthCheckFailed → FiftyStatusState.error
PrinterStatus.disconnected     → FiftyStatusState.offline
```

---

## Promotion Assessment

No widgets warrant promotion to fifty_ui. All patterns covered by existing components.
