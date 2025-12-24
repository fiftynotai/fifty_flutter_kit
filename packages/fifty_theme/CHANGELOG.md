# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-12-25

### Added

- Initial release of fifty_theme package
- `FiftyTheme` class with `dark()` and `light()` static methods
- `FiftyColorScheme` class mapping tokens to Material ColorScheme
- `FiftyTextTheme` class with complete text style definitions
- `FiftyComponentThemes` class with 25+ component theme configurations:
  - Button themes (elevated, outlined, text)
  - Card and surface themes
  - Input decoration theme
  - AppBar and navigation themes
  - Dialog and bottom sheet themes
  - Selection controls (checkbox, radio, switch)
  - Progress indicators and sliders
  - And more...
- `FiftyThemeExtension` for custom Fifty properties:
  - Igris Green (AI terminal color)
  - Focus glow effects
  - Motion durations (instant, fast, compiling, systemLoad)
  - Animation curves (standard, enter, exit)
  - Semantic colors (success, warning)
- Material 3 support enabled by default
- Compact visual density for tight layouts
- Zero elevation throughout (no drop shadows)
- Full dartdoc documentation on all public APIs

### Design Principles Implemented

- Dark mode as primary theme
- Crimson glow for focus states instead of shadows
- Border outlines for depth perception
- Monument Extended for headlines (Hype)
- JetBrains Mono for body and code (Logic)
