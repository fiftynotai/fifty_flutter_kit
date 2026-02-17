# TD-008: Printing Engine Example — FDL Token Polish

**Type:** Technical Debt
**Priority:** P3-Low
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2026-02-17

---

## What is the Technical Debt?

**Current situation:**

BR-103 successfully migrated the printing_engine example to FDL components and eliminated all hardcoded colors. However, the migration used raw numeric literals for spacing, border radii, and some font sizes instead of FDL design tokens.

**Why is it technical debt?**

The FDL token packages (`fifty_tokens`) are declared as dependencies but not fully utilized. Raw spacing/radii values are correct numerically (they match the FDL 4px grid), but using tokens improves maintainability, self-documentation, and consistency. Additionally, a `_mapStatus` helper is duplicated across two files.

**Examples:**
```dart
// Current (raw values)
const SizedBox(height: 8)
padding: const EdgeInsets.all(16)
BorderRadius.circular(12)

// Target (FDL tokens)
SizedBox(height: FiftySpacing.sm)
padding: EdgeInsets.all(FiftySpacing.lg)
FiftyRadii.lgRadius
```

---

## Why It Matters

**Consequences of not fixing:**

- [x] **Maintainability:** If FDL spacing scale changes, raw values won't update automatically
- [x] **Readability:** Raw numbers lack semantic meaning (`16` vs `FiftySpacing.lg`)
- [ ] **Performance:** No impact
- [ ] **Security:** No impact
- [ ] **Scalability:** Minor — sets bad precedent for other example apps
- [x] **Developer Experience:** Example apps should demonstrate best practices for consumers

**Impact:** Low

---

## Cleanup Steps

1. [ ] Replace ~79 raw spacing values with `FiftySpacing` tokens across 9 files
2. [ ] Replace 5 `BorderRadius.circular(12)` with `FiftyRadii.lgRadius`
3. [ ] Replace `Radius.circular(20)` in bluetooth_scan_sheet.dart with nearest FDL token
4. [ ] Extract duplicated `_mapStatus(PrinterStatus)` from printer_list_item.dart and printer_selection_dialog.dart into a shared utility
5. [ ] Replace ~15 raw `fontSize` values with `Theme.of(context).textTheme` references where semantically appropriate
6. [ ] Add `const` to FiftySectionHeader instances where applicable
7. [ ] Run `dart analyze` — zero errors, zero warnings

---

## Tasks

### Pending
- [ ] Task 1: Replace raw spacing values → FiftySpacing tokens (~79 occurrences across 9 files)
- [ ] Task 2: Replace raw BorderRadius → FiftyRadii tokens (5 occurrences + 1 Radius.circular)
- [ ] Task 3: Extract `_mapStatus` to shared `printer_status_utils.dart`
- [ ] Task 4: Replace raw font sizes → textTheme references (~15 occurrences)
- [ ] Task 5: Add `const` to applicable FiftySectionHeader calls
- [ ] Task 6: Analyzer verification — 0 errors, 0 warnings

### In Progress
_(none)_

### Completed
_(none)_

---

## Session State (Tactical - This Brief)

**Current State:** Coder deployed
**Next Steps When Resuming:** Check coder results
**Last Updated:** 2026-02-17
**Blockers:** None

---

## Benefits of Fixing

- Fully FDL-compliant example app (best practice showcase)
- Self-documenting spacing/radii values with semantic token names
- DRY: single `_mapStatus` utility instead of duplicated method
- Consistent text styling via theme textStyles

**Return on Investment:** Medium (low effort, improves example quality)

---

## Affected Areas

### Files
- `packages/fifty_printing_engine/example/lib/screens/home_screen.dart` — spacing + font sizes
- `packages/fifty_printing_engine/example/lib/screens/printer_management_screen.dart` — spacing
- `packages/fifty_printing_engine/example/lib/screens/test_print_screen.dart` — spacing + radii
- `packages/fifty_printing_engine/example/lib/screens/ticket_builder_screen.dart` — spacing + radii
- `packages/fifty_printing_engine/example/lib/widgets/print_result_widget.dart` — spacing
- `packages/fifty_printing_engine/example/lib/widgets/printer_list_item.dart` — spacing + font sizes + _mapStatus extraction
- `packages/fifty_printing_engine/example/lib/widgets/bluetooth_scan_sheet.dart` — spacing + radii
- `packages/fifty_printing_engine/example/lib/widgets/add_printer_dialog.dart` — spacing + radii
- `packages/fifty_printing_engine/example/lib/widgets/printer_selection_dialog.dart` — spacing + _mapStatus extraction

### New File
- `packages/fifty_printing_engine/example/lib/utils/printer_status_utils.dart` — shared _mapStatus

### Count
**Total files affected:** 10 (9 existing + 1 new utility)
**Total lines to change:** ~100 (mostly 1:1 replacements)

---

## Testing

### Regression Testing
- [ ] Existing tests still pass (53/53 printing engine tests)
- [ ] No functionality changes
- [ ] Only code quality improvements
- [ ] Visual output unchanged (token values match raw values)

### Verification
1. `grep -rn "SizedBox(height:" packages/fifty_printing_engine/example/lib/` — should show FiftySpacing tokens, not raw numbers
2. `grep -rn "BorderRadius.circular" packages/fifty_printing_engine/example/lib/` — should be zero
3. `grep -rn "_mapStatus" packages/fifty_printing_engine/example/lib/` — should point to single utility file
4. `dart analyze` — 0 errors, 0 warnings

---

## Acceptance Criteria

1. [ ] Zero raw spacing values — all use `FiftySpacing.*` tokens
2. [ ] Zero raw `BorderRadius.circular()` — all use `FiftyRadii.*` tokens
3. [ ] Single `_mapStatus` utility (no duplication)
4. [ ] Raw font sizes replaced with textTheme references where appropriate
5. [ ] `dart analyze` passes (zero issues)
6. [ ] All existing tests pass (53/53)
7. [ ] No functionality changes (refactoring only)
8. [ ] Visual output unchanged

---

## References

**Coding Guidelines:**
- `ai/context/coding_guidelines.md` — FDL Compliance section (lines 580-670)
- FiftySpacing scale: xs(4), sm(8), md(12), lg(16), xl(20), xxl(24), xxxl(32)
- FiftyRadii scale: sm(4), md(8), lg(12), xl(16), xxl(24), xxxl(32)

**Related Briefs:**
- BR-103: Printing Engine Example FDL Migration (parent — this is the follow-up polish)

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** Igris AI
