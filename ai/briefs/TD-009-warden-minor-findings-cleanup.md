# TD-009: WARDEN Minor Findings Cleanup

## Metadata

- **Type:** Technical Debt
- **Priority:** P3
- **Status:** Done
- **Effort:** S
- **Created:** 2026-03-01
- **Source:** WARDEN review of AC-001 Theme Customization Pipeline

---

## Problem

Four minor findings flagged by WARDEN during the AC-006 review remain unfixed. All are non-blocking documentation/config issues that reduce accuracy of docs and add unnecessary dependencies.

---

## Goal

Clean up all 4 WARDEN findings from the theme customization work so docs and configs accurately reflect the current codebase state.

---

## Findings

### 1. Stale v1 token names in coding_guidelines.md (lines 596-628)

The design tokens section references FDL v1 names that no longer exist:
- Colors: `crimsonPulse`, `voidBlack`, `hyperChrome`, `igrisGreen` (v1) should be `burgundy`, `darkBurgundy`, `slateGrey`, `hunterGreen` (v2)
- Typography: `fontFamilyHeadline` (Monument Extended), `fontFamilyMono` (JetBrains Mono), `display/heading/title/body/mono` should be `fontFamily` (Manrope), `displayLarge/displayMedium/titleLarge/bodyLarge/bodyMedium/bodySmall`
- Radii: `standardRadius/smallRadius/largeRadius` should be `mdRadius/smRadius/lgRadius`

### 2. `withOpacity` deprecated in fifty_ui README (line 507)

```dart
leadingIconBackgroundColor: Colors.blue.withOpacity(0.1),
```
Should use `withValues(alpha: 0.1)` per Dart SDK 3.9.2+.

### 3. `google_fonts` redundant in fifty_theme pubspec.yaml

`fifty_theme` lists `google_fonts: ^8.0.0` as a direct dependency but has zero direct imports. It gets `google_fonts` transitively via `fifty_tokens`. The CHANGELOG even says "Removed direct google_fonts import (now transitive via fifty_tokens)". The pubspec entry should be removed.

### 4. CHANGELOG link references incomplete in fifty_tokens

Missing version links for `[2.0.0]`, `[1.0.3]`, `[1.0.2]`, `[1.0.1]` at the bottom of the CHANGELOG.

---

## Acceptance Criteria

- [ ] coding_guidelines.md design tokens section reflects current v2 token names
- [ ] fifty_ui README uses `withValues(alpha:)` instead of `withOpacity()`
- [ ] fifty_theme pubspec.yaml no longer lists `google_fonts` as direct dependency
- [ ] fifty_tokens CHANGELOG.md has complete version links at bottom

---

## Test Plan

- `flutter analyze` passes across affected packages
- No broken tests from doc/config changes
