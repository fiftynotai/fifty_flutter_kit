# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

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
- Type scale following minor third ratio 1.25 (8 sizes: 48→12px)
- Letter spacing tokens (heading -1%, body +0.25%)
- Line height multipliers (display, heading, body, code)

**Spacing Tokens (13):**
- 8px-based spacing scale (10 values: micro 2px → massive 48px)
- Responsive gutters (desktop: 24px, tablet: 16px, mobile: 12px)

**Radii Tokens (10):**
- Border radius values (xs 4px → full 999px)
- BorderRadius convenience objects (xsRadius → fullRadius)

**Motion Tokens (8):**
- Animation durations (fast 120ms → overlay 280ms)
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
- ✅ 76 design tokens implemented
- ✅ 59 passing tests (100% coverage)
- ✅ Zero analyzer warnings
- ✅ Zero external dependencies
- ✅ 100% FDL specification fidelity

[0.1.0]: https://github.com/fiftynotai/fifty_tokens/releases/tag/v0.1.0
