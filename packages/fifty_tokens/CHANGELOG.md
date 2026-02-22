# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.0.2] - 2026-02-22

### Fixed

- Synced CHANGELOG.md with published version history (pub.dev compliance)

## [1.0.1] - 2026-02-22

### Changed

- Patch release for pub.dev metadata updates

## [1.0.0] - 2026-01-15

### Changed

- Complete color palette overhaul to "Sophisticated Warm" (FDL v2)
- Primary color: Burgundy (#88292F) replaces CrimsonPulse
- New surface palette: Cream, Dark Burgundy, Powder Blush, Slate Grey
- Typography unified to Manrope font family with Material-aligned type scale
- Radii expanded to full scale (none through full, 8 values)
- Shadows redesigned as soft sophisticated system (sm/md/lg/primary/glow)

### Added

- `FiftyGradients` class with primary, progress, and surface gradient tokens
- `FiftyShadows` class with soft shadow tokens
- Complete semantic color aliases (primary, secondary, success, error, warning)
- Full radii scale with BorderRadius convenience objects

### Removed

- FDL v1 terminal-inspired tokens (voidBlack, crimsonPulse, terminalWhite, igrisGreen)
- Monument Extended and JetBrains Mono font families
- Glow-only elevation system

## [0.2.0] - 2025-12-25

### Changed

**Color System Overhaul (FDL Alignment):**
- Renamed color tokens to match FDL specification:
  - `surface0` -> `voidBlack` (#050505) - The infinite canvas
  - `crimsonCore` -> `crimsonPulse` (#960E29) - The heartbeat
  - `surface1` -> `gunmetal` (#1A1A1A) - Surfaces
  - `textPrimary` -> `terminalWhite` (#EAEAEA) - Primary text
  - NEW: `hyperChrome` (#888888) - Hardware/metadata
  - NEW: `igrisGreen` (#00FF41) - AI Agent exclusive
- Removed intermediate surface colors (surface2, surface3) per FDL "no gradual elevation" philosophy
- Removed `techCrimson` - consolidated to single crimson identity
- `border` now derived from `hyperChrome` @ 10% opacity

**Typography Font Family Changes:**
- Renamed `fontFamilyDisplay` -> `fontFamilyHeadline` (Monument Extended)
- Renamed `fontFamilyBody` -> `fontFamilyMono` (JetBrains Mono)
- Removed `fontFamilyCode` - unified under `fontFamilyMono`
- Removed `bold` weight - FDL uses `ultrabold` (800) for headlines only
- Removed `semiBold` weight - replaced by `medium` (500) for UI elements
- Updated type scale to match FDL: 64/48/32/16/12px (removed 28/24/20/14px)
- Renamed size tokens: `displayXL` -> `hero`, `h1` -> `display`, `h2`/`h3` -> `section`, `bodyLarge`/`bodyBase` -> `body`, `caption` -> `mono`

**Radii Simplification:**
- Consolidated to 3 values per FDL specification:
  - `standard` (12px) - Default for all elements
  - `smooth` (24px) - Hero cards, feature panels
  - `full` (999px) - Pills and circles
- Removed `xs` (4px), `sm` (6px), `md` (10px), `lg` (16px)
- Renamed BorderRadius objects: `standardRadius`, `smoothRadius`, `fullRadius`

**Motion Timing Updates:**
- Renamed durations to match FDL terminology:
  - `fast` (150ms, was 120ms) - Hover states
  - NEW: `instant` (0ms) - Logic changes
  - NEW: `compiling` (300ms) - Panel reveals
  - NEW: `systemLoad` (800ms) - Staggered entry
- Removed `base` (180ms), `slow` (240ms), `overlay` (280ms)
- Renamed curves: `emphasisEnter` -> `enter`, `emphasisExit` -> `exit`
- Removed `spring` curve - FDL prefers decisive motion over bouncy

**Spacing System:**
- Changed base unit from 8px to 4px per FDL specification
- Added `tight` (8px) and `standard` (12px) as primary gaps
- Retained semantic scale (xs through massive)

**Shadow Philosophy Change:**
- Renamed `FiftyElevation` tokens to reflect glow-only approach
- Removed `ambient` shadow - FDL uses no drop shadows
- Renamed shadow lists: `card` -> `focus`, `hoverCard` -> `strongFocus`
- Removed `glowOnly` - all elevation is now glow-based
- Added documentation explaining depth-without-shadows approach

### Added

- `FiftyColors.hyperChrome` - Hardware/metadata color (#888888)
- `FiftyColors.igrisGreen` - AI Agent exclusive color (#00FF41)
- `FiftyMotion.instant` - Zero-duration for logic changes
- `FiftyMotion.compiling` - 300ms for panel reveals
- `FiftyMotion.systemLoad` - 800ms for staggered entry
- `FiftySpacing.tight` - 8px primary gap
- `FiftySpacing.standard` - 12px primary gap
- Comprehensive design philosophy documentation in README
- Font requirements section with setup instructions
- "Data Slate" card example
- Focus state with crimson glow example
- Terminal text style example
- Kinetic panel reveal example

### Removed

- `FiftyColors.techCrimson` - Consolidated to single crimson
- `FiftyColors.surface2`, `surface3` - No gradual surface elevation
- `FiftyTypography.fontFamilyCode` - Unified under fontFamilyMono
- `FiftyTypography.bold`, `semiBold` - Replaced by ultrabold, medium
- `FiftyTypography.bodyLarge`, `bodySmall` - Simplified scale
- `FiftyTypography.h2`, `h3` - Consolidated to section
- `FiftyTypography.headingLetterSpacing`, `bodyLetterSpacing` - Renamed to tight, standard
- `FiftyRadii.xs`, `sm`, `md`, `lg` - Simplified to standard, smooth, full
- `FiftyMotion.base`, `slow`, `overlay` - Replaced by FDL timing
- `FiftyMotion.spring` - Removed bouncy motion
- `FiftyElevation.ambient` - No drop shadows per FDL
- `FiftyElevation.card`, `hoverCard`, `glowOnly` - Simplified to focus, strongFocus

### Quality Metrics

- 73 passing tests (up from 59)
- Zero analyzer warnings
- Zero external dependencies
- 100% FDL specification alignment

---

## [0.1.0] - 2025-11-10

### Added

**Foundation:**
- Initial release of fifty_tokens package
- Package structure following Flutter conventions
- Zero external dependencies (Flutter SDK only)
- MIT License

**Color Tokens (14):**
- Primary crimson palette (crimsonCore #960E29, techCrimson #B31337)
- Surface hierarchy (surface0-3) for dark mode depth
- Text colors (textPrimary, textSecondary, muted)
- Border and divider colors
- Semantic state colors (success, warning, error)

**Typography Tokens (21):**
- Font families (Space Grotesk, Inter, JetBrains Mono)
- Font weights (regular, medium, semiBold, bold)
- Type scale following minor third ratio 1.25 (8 sizes: 48->12px)
- Letter spacing tokens (heading -1%, body +0.25%)
- Line height multipliers (display, heading, body, code)

**Spacing Tokens (13):**
- 8px-based spacing scale (10 values: micro 2px -> massive 48px)
- Responsive gutters (desktop: 24px, tablet: 16px, mobile: 12px)

**Radii Tokens (10):**
- Border radius values (xs 4px -> full 999px)
- BorderRadius convenience objects (xsRadius -> fullRadius)

**Motion Tokens (8):**
- Animation durations (fast 120ms -> overlay 280ms)
- Easing curves with cubic bezier (emphasisEnter, emphasisExit, standard, spring)

**Elevation Tokens (10):**
- BoxShadow definitions (ambient, crimsonGlow, focusRing)
- Shadow list combinations (card, focus, hoverCard, glowOnly)

**Breakpoint Tokens (3):**
- Responsive breakpoints (mobile: 768px, desktop: 1024px)

**Testing:**
- Complete test suite with 59 passing tests
- 100% token coverage validation
- Critical value verification (crimson accuracy, type scale, 8px grid)

**Documentation:**
- Comprehensive README with usage examples
- Full API documentation (dartdoc comments)
- Design philosophy explanation
- Ecosystem integration guide

### Quality Metrics
- 76 design tokens implemented
- 59 passing tests (100% coverage)
- Zero analyzer warnings
- Zero external dependencies
- 100% FDL specification fidelity

[1.0.0]: https://github.com/fiftynotai/fifty_flutter_kit/releases/tag/fifty_tokens-v1.0.0
[0.2.0]: https://github.com/fiftynotai/fifty_flutter_kit/releases/tag/fifty_tokens-v0.2.0
[0.1.0]: https://github.com/fiftynotai/fifty_flutter_kit/releases/tag/fifty_tokens-v0.1.0
