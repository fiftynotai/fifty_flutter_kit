# BR-132: Tokens Demo — Runtime Palette Switcher

**Type:** Feature
**Priority:** P1-High
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Done
**Created:** 2026-03-02
**Completed:** 2026-03-03

---

## Problem

There's no way to visually verify that `FiftyTokens.configure()` works at runtime. The current TS-003 approach hardcodes the palette in `main.dart` at startup, but users need to see that tokens can be swapped live — and so do we, to confirm the configuration pipeline works end-to-end through the theme layer.

---

## Goal

Add a Tokens demo page to fifty_demo with a button that toggles between the default FDL v2 palette and the Baltic Blue palette at runtime. Pressing the button reconfigures tokens and rebuilds the theme live — all components on every page should update to reflect the new palette.

---

## Context

### Runtime reconfiguration flow

```
Button tap
  → FiftyTokens.configure(colors: balticBlueColors)
  → Get.changeTheme(FiftyTheme.dark())  // regenerate ThemeData from new tokens
  → Entire app rebuilds with new colors
```

`FiftyTokens.configure()` is a static setter — callable at any time. The ThemeData must be regenerated because `FiftyTheme.dark()` / `.light()` read from `FiftyTokens.active` at build time. GetX provides `Get.changeTheme()` and `Get.forceAppUpdate()` for this.

### Baltic Blue Palette

| Name | Hex | Role |
|------|-----|------|
| Baltic Blue | `#586994` | primary |
| Lavender Grey | `#7d869c` | secondary |
| Cool Steel | `#a2abab` | surface / accent |
| Ash Grey | `#b4c4ae` | success |
| Cream | `#e5e8b6` | background |

---

## Implementation Plan

### 1. Revert main.dart

Remove the TS-003 `FiftyTokens.configure()` call from `main.dart` so the app starts with default FDL v2.

### 2. Create Tokens demo page

`lib/features/tokens_demo/views/tokens_demo_page.dart`

- Display current palette name (FDL v2 / Baltic Blue)
- Show color swatches for the active palette: primary, secondary, surface, success, accent, background
- "Apply Baltic Blue" button — calls `FiftyTokens.configure(colors: ...)` then triggers theme rebuild
- "Reset to FDL v2" button — calls `FiftyTokens.reset()` then triggers theme rebuild
- Show hex values next to each swatch so the user can confirm the values changed

### 3. Create bindings

`lib/features/tokens_demo/tokens_demo_bindings.dart` — standard bindings (may be minimal if no ViewModel needed).

### 4. Register in navigation

Add Tokens demo as an accessible page from the Packages hub (alongside Audio, Speech, etc.) or as a new entry in the settings page.

### 5. Theme rebuild mechanism

On button press:
```dart
// Apply Baltic Blue
FiftyTokens.configure(colors: _balticBlueColors);
Get.changeTheme(FiftyTheme.light());
Get.changeDarkTheme(FiftyTheme.dark());
Get.forceAppUpdate();

// Reset
FiftyTokens.reset();
Get.changeTheme(FiftyTheme.light());
Get.changeDarkTheme(FiftyTheme.dark());
Get.forceAppUpdate();
```

Verify `Get.changeDarkTheme()` exists in the GetX version used. If not, use `Get.forceAppUpdate()` alone — it rebuilds the entire widget tree which re-evaluates `FiftyTheme.dark()`.

---

## Acceptance Criteria

1. [ ] fifty_demo starts with default FDL v2 palette (burgundy)
2. [ ] Tokens demo page is accessible from Packages hub or navigation
3. [ ] "Apply Baltic Blue" button swaps all app colors to the Baltic Blue palette live
4. [ ] All pages (Home, UI Kit, Packages, Settings) reflect the new palette after swap
5. [ ] "Reset to FDL v2" button restores the original burgundy palette live
6. [ ] Color swatches on the Tokens page display current hex values
7. [ ] No app restart required — swap is instant

---

## Constraints

- Follow MVVM + Actions architecture if a ViewModel is needed
- Use FDL components (FiftyCard, FiftyButton) for the demo page UI
- No new packages or dependencies
- Keep it simple — this is a configuration demo, not a full theme editor

---

## Workflow State

**Phase:** COMPLETE
**Active Agent:** none
**Retry Count:** 0

### Agent Log
| Time | Agent | Action | Result |
|------|-------|--------|--------|
| 2026-03-03 | architect | Create implementation plan | SUCCESS |
| 2026-03-03 | forger | Implement changes | SUCCESS (5 created, 3 modified) |
| 2026-03-03 | sentinel | Run test suite | PASS (7/7 new, 104/104 total) |
| 2026-03-03 | warden | Code review | APPROVE (6 minor, 0 blocking) |

---

## Dependencies

- TS-003 visual test config in main.dart should be reverted as part of this brief
- Depends on `FiftyTokens.configure()` and `FiftyTokens.reset()` working correctly (confirmed by SENTINEL: 317 tests passing)

---

**Created:** 2026-03-02
**Last Updated:** 2026-03-02
**Brief Owner:** Fifty.ai
