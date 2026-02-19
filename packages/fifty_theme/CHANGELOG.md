# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
  - Material 3 enabled by default
  - Compact visual density for information-dense interfaces
  - Zero elevation throughout (no drop shadows)
  - Complete component theme configuration

- **FiftyColorScheme** - Token-to-ColorScheme mapping
  - Dark mode: "Mecha Cockpit" aesthetic with OLED-optimized blacks
  - Light mode: Inverted palette maintaining brand identity
  - Crimson Pulse primary, Hyper Chrome secondary, Igris Green tertiary

- **FiftyTextTheme** - Binary type system implementation
  - Monument Extended for headlines (Hype) - bold, extended, impactful
  - JetBrains Mono for body text (Logic) - functional, readable, precise
  - Complete Material text scale mapping

- **FiftyComponentThemes** - 25+ pre-configured component themes
  - Button themes (elevated, outlined, text, FAB)
  - Card and surface themes (cards, dialogs, bottom sheets, drawers)
  - Input themes (text fields, checkboxes, radios, switches, sliders)
  - Navigation themes (app bar, bottom nav, navigation rail, tabs)
  - Feedback themes (snackbars, tooltips, progress indicators)
  - Menu themes (popup, dropdown)
  - List and divider themes

- **FiftyThemeExtension** - Custom Fifty properties
  - `igrisGreen` - AI terminal color (#00FF41)
  - `success` and `warning` - Semantic state colors
  - `focusGlow` and `strongFocusGlow` - Crimson glow effects
  - Motion durations: `instant` (0ms), `fast` (150ms), `compiling` (300ms), `systemLoad` (800ms)
  - Animation curves: `standardCurve`, `enterCurve`, `exitCurve`

- **Comprehensive documentation** - Full dartdoc on all public APIs

### Design Principles

- **Dark mode is PRIMARY** - Optimized for OLED, reduced eye strain
- **No drop shadows** - Depth via surface hierarchy and crimson glow
- **Border outlines** - Subtle borders replace elevation for depth
- **Compact density** - Tight spacing for bento-grid layouts
- **Zero elevation** - All components configured with elevation: 0

### Performance

- Const constructors throughout for compile-time optimization
- Efficient color scheme generation
- Minimal runtime overhead

### Dependencies

- `flutter` SDK >=3.0.0
- `fifty_tokens` ^0.2.0 (design token foundation)

### Notes

- Dark mode is the canonical FDL experience; light mode provided for accessibility
- Requires Monument Extended and JetBrains Mono fonts in project
- Path dependency on fifty_tokens during development; update to pub.dev reference for publishing
