# TS-003: Visual Verification of Custom Palette Configuration

**Type:** Testing
**Priority:** P1-High
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** In Progress
**Created:** 2026-03-02
**Completed:**

---

## Goal

Configure the Baltic Blue palette on the fifty_demo app and visually confirm that all UI components (buttons, cards, text, backgrounds, surfaces) pick up the custom colors. This validates the fifty_tokens v3.0.0 configuration pipeline end-to-end through real rendered UI — not unit tests.

---

## Custom Palette: Baltic Blue

| Name | Hex | Role |
|------|-----|------|
| Baltic Blue | `#586994` | primary |
| Lavender Grey | `#7d869c` | secondary |
| Cool Steel | `#a2abab` | surface / accent |
| Ash Grey | `#b4c4ae` | success |
| Cream | `#e5e8b6` | background |

---

## Implementation

### What to do

1. In fifty_demo's `main.dart` (or app config), call `FiftyTokens.configure()` with a custom preset using the Baltic Blue palette colors
2. Map the 5 palette colors to the `FiftyColorConfig` semantic roles (primary, secondary, surface, success, background, etc.)
3. Derive hover/dark variants from the base palette (darken for hover, darken further for dark backgrounds)
4. Run the app on simulator
5. Navigate through demo pages — every component should render with Baltic Blue tones instead of the default burgundy

### What NOT to do

- No unit tests — this is visual/manual verification
- No theme switcher UI — just hard-configure the palette and look at it
- No new pages or widgets — use existing fifty_demo screens

---

## Acceptance Criteria

1. [ ] fifty_demo launches with Baltic Blue palette applied
2. [ ] Buttons show Baltic Blue (`#586994`) as primary color
3. [ ] Cards and surfaces show Cool Steel (`#a2abab`)
4. [ ] Background shows Cream (`#e5e8b6`) in light mode
5. [ ] Text contrast is readable against the new palette
6. [ ] Dark mode derives sensible dark variants
7. [ ] After visual confirmation, revert the config change (leave fifty_demo on default FDL v2)

---

## Palette Mapping

```dart
FiftyTokens.configure(
  FiftyPreset.fdlV2.copyWith(
    colors: FiftyColorConfig(
      primary: Color(0xFF586994),        // Baltic Blue
      primaryHover: Color(0xFF47567A),   // darkened Baltic Blue
      secondary: Color(0xFF7d869c),      // Lavender Grey
      secondaryHover: Color(0xFF656D80), // darkened Lavender Grey
      success: Color(0xFFb4c4ae),        // Ash Grey
      accent: Color(0xFFa2abab),         // Cool Steel
      background: Color(0xFFe5e8b6),     // Cream
      backgroundDark: Color(0xFF1A1D2B), // dark variant
      surface: Color(0xFFD5D8A8),        // slightly darker Cream
      surfaceDark: Color(0xFF2A2D3B),    // dark variant
      warning: Color(0xFFF7A100),        // keep FDL default
      error: Color(0xFF88292F),          // keep FDL default
      onPrimary: Color(0xFFe5e8b6),     // Cream on Baltic Blue
      onBackground: Color(0xFF1A1D2B),  // dark text on Cream
      borderOpacity: 0.05,
      focusOpacity: 0.5,
    ),
  ),
);
```

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Add FiftyTokens.configure() call to fifty_demo main.dart
**Last Updated:** 2026-03-02
**Blockers:** None

---

**Created:** 2026-03-02
**Last Updated:** 2026-03-02
**Brief Owner:** Fifty.ai
