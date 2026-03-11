# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 3.0.1

- **fix:** Derive `onSurfaceVariant` from secondary with WCAG AA contrast guarantee instead of raw secondary passthrough — fixes invisible text in dark mode when secondary is a dark color

## [3.0.0] - 2026-03-01

### BREAKING CHANGES

- Requires `fifty_tokens` ^3.0.0 with semantic color names

### Changed

- All deprecated palette color references replaced with semantic names:
  - `FiftyColors.cream` -> `FiftyColors.background`
  - `FiftyColors.darkBurgundy` -> `FiftyColors.backgroundDark`
  - `FiftyColors.surfaceLight` -> `FiftyColors.surface`
  - `FiftyColors.powderBlush` -> `FiftyColors.accent`
- README rewritten around the brand configuration pipeline story
- CHANGELOG expanded with full 3.0.0 and 2.0.0 migration context

## [2.0.0] - 2026-03-01

### BREAKING CHANGES

- `FiftyTheme.dark()` and `FiftyTheme.light()` now accept optional parameters: `colorScheme`, `primaryColor`, `secondaryColor`, `fontFamily`, `fontSource`, `extension`
- `FiftyThemeExtension.dark()` and `.light()` accept optional color overrides
- All component themes now consume `ColorScheme` parameter instead of hardcoded `FiftyColors.*`
- Removed direct `google_fonts` import (now transitive via `fifty_tokens`)

### Changed

- 191 `FiftyColors.*` references replaced with `colorScheme.*` in component themes
- 57 `GoogleFonts.manrope()` calls replaced with `FiftyFontResolver.resolve()`
- Light theme consolidated (~280 lines of duplicated code eliminated)
- Component themes use `FiftyComponentThemes.*()` static methods consistently

## [1.0.1] - 2026-02-22

### Changed

- Upgraded `google_fonts` to ^8.0.0 for pub.dev dependency score compliance

## [1.0.0] - 2026-01-15

### Changed

- Complete redesign to "Sophisticated Warm" aesthetic (FDL v2)
- Color scheme: Burgundy primary, Cream surfaces, Slate Grey secondary
- Typography: Unified Manrope font family with Material-aligned type scale
- Component themes updated for warm palette across all 25+ Material widgets
- Theme extension updated with v2 semantic colors and motion tokens

### Added

- Light mode as equal-quality alternative (no longer secondary to dark)
- Gradient-aware component styling
- Updated shadow system (soft sophisticated shadows)

## [0.1.0] - 2025-12-25

Initial release of the fifty_theme package - the theming layer for the Fifty Design Language (FDL).

### Added

- **FiftyTheme** - Main entry point with `dark()` and `light()` factory methods
- **FiftyColorScheme** - Token-to-ColorScheme mapping
- **FiftyTextTheme** - Binary type system implementation
- **FiftyComponentThemes** - 25+ pre-configured component themes
- **FiftyThemeExtension** - Custom Fifty properties (semantic colors, shadows, motion)
