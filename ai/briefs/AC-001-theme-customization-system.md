# AC-001: Fifty Flutter Kit — Theme Customization System (Master)

**Type:** Architecture Cleanup
**Priority:** P1-High
**Effort:** XL-Extra Large (>1w)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Ready
**Created:** 2026-02-28

---

## Architecture Issue

**What's the problem?**

- [x] Logical inconsistency (packages marketed as configurable toolkit but locked to one design language)
- [x] Poor separation of concerns (design values hardcoded as compile-time constants, no indirection layer)

**Where is it?**

The entire Fifty Flutter Kit foundation layer. `fifty_tokens` uses `static const` for all values (colors, typography, spacing, radii, motion, shadows, gradients, breakpoints). `fifty_theme` hardcodes `FiftyColors.*` in 100+ places across 23 component theme builders, ignoring the `ColorScheme` parameter it receives. This locks every downstream package to the burgundy/cream/Manrope design language with no consumer override mechanism.

---

## Vision

**The Fifty Flutter Kit should be a scaffold, not a cage.**

Consumers should be able to:
1. Configure tokens once at app startup via a simple API
2. Use Google Fonts OR local asset fonts — both equally supported
3. Override any color, spacing, typography, or motion value
4. Have changes cascade automatically to all fifty_* packages
5. Use the kit's architecture and components without adopting the FDL aesthetic
6. Fall back to FDL defaults for anything not explicitly overridden

**Target developer experience:**

```dart
void main() {
  // One configuration call — everything updates
  FiftyTokens.configure(
    colors: FiftyColorConfig(
      primary: Color(0xFF1E88E5),
      secondary: Color(0xFF43A047),
    ),
    typography: FiftyTypographyConfig(
      fontFamily: 'Inter',
      source: FontSource.googleFonts,  // or FontSource.asset
    ),
  );

  runApp(MaterialApp(
    theme: FiftyTheme.dark(),   // Generates theme from configured tokens
    home: MyApp(),              // All fifty_ui widgets use configured values
  ));
}
```

---

## Sub-Briefs

| Brief | Title | Scope | Effort | Dependency |
|-------|-------|-------|--------|------------|
| **AC-002** | fifty_tokens Configuration System | Token layer — configure(), getters, font source abstraction | L | None (first) |
| **AC-003** | fifty_theme Parameterization | Theme layer — use ColorScheme, accept overrides, fix 100+ hardcoded refs | L | AC-002 |
| **AC-004** | fifty_ui Theme Alignment | UI widgets — audit + fix direct token refs, ensure Theme.of cascade | M | AC-003 |
| **AC-005** | Engine Packages Theme Alignment | connectivity, achievements, skill_tree fixes | M | AC-003 |
| **AC-006** | Documentation + Migration Guide | README updates, migration guide, example apps | S | AC-004, AC-005 |

**Execution order:** AC-002 → AC-003 → (AC-004 + AC-005 in parallel) → AC-006

---

## Current State

**Audit completed 2026-02-28.** Findings:

### fifty_tokens (AC-002)
- 8 token files, ALL values `static const` with hardcoded literals
- Zero configuration mechanism, zero override API
- Font family locked to "Manrope" string constant
- No font source abstraction (Google Fonts vs asset fonts)
- Gradients duplicate color hex values instead of referencing FiftyColors

### fifty_theme (AC-003)
- `FiftyTheme.dark()` / `.light()` accept zero parameters
- `FiftyColorScheme.dark()` / `.light()` hardcode all 22 ColorScheme slots
- 23 component theme builders receive `ColorScheme` parameter but 11 IGNORE it entirely
- 100+ direct `FiftyColors.*` references across 4 files (664-line component_themes.dart is main target)
- `FiftyThemeExtension` hardcoded with no consumer configuration

### fifty_ui (AC-004)
- MOSTLY GOOD — 7/17 widgets use pure `Theme.of(context)`
- 4 widgets reference `FiftyColors/FiftyTokens` directly as fallback
- 4 widgets accept optional parameter overrides (good pattern)
- No hardcoded hex colors (only accessibility values like white check icon)

### Engine packages (AC-005)
- fifty_forms: Clean — pure Theme.of(context)
- fifty_audio_engine: Clean — safe extension fallback
- fifty_speech_engine: Clean — pure Theme.of(context)
- fifty_connectivity: 2 hardcoded `FiftyColors.*` references
- fifty_achievement_engine: Rarity colors hardcoded, but accepts parameter overrides
- fifty_skill_tree: Custom theme system (independent, has copyWith)
- fifty_printing_engine: No UI widgets
- fifty_scroll_sequence: No color styling

---

## Tracking

### Progress

| Brief | Status | Notes |
|-------|--------|-------|
| AC-002 | Ready | |
| AC-003 | Ready | Blocked by AC-002 |
| AC-004 | Ready | Blocked by AC-003 |
| AC-005 | Ready | Blocked by AC-003 |
| AC-006 | Ready | Blocked by AC-004 + AC-005 |

### Review Checklist (after all sub-briefs complete)

- [ ] Consumer can configure all token values at app startup
- [ ] Consumer can use Google Fonts (package) or local asset fonts
- [ ] Changing tokens cascades to fifty_theme automatically
- [ ] Changing theme cascades to fifty_ui widgets automatically
- [ ] Changing theme cascades to engine package widgets automatically
- [ ] FDL defaults still work with zero configuration (backward compatible)
- [ ] All 17 packages build and test green
- [ ] Example app demonstrates custom theme configuration
- [ ] Migration guide documents breaking changes (if any)
- [ ] `flutter analyze` passes across entire mono-repo
- [ ] pub.dev publish-ready (version bumps done)

---

## Session State (Tactical - This Brief)

**Current State:** Briefs registered, ready for implementation
**Next Steps When Resuming:** Start with AC-002 (fifty_tokens configuration)
**Last Updated:** 2026-02-28
**Blockers:** None

---

## Acceptance Criteria

**The architecture cleanup is complete when:**

1. [ ] All 5 sub-briefs are Done
2. [ ] Review checklist above passes
3. [ ] Zero regressions in existing functionality
4. [ ] Backward compatible — existing apps using FDL defaults unchanged
5. [ ] New consumer app can configure custom palette without forking any package
6. [ ] Font source abstraction supports both Google Fonts and local asset fonts
7. [ ] Version bumps applied to all affected packages

---

## Notes

**Philosophy:** The Fifty Flutter Kit provides the scaffold and the standard. Consumers get the architecture, the patterns, the components — and configure the visual identity to match their brand. FDL v2 remains the default, but it's the DEFAULT, not the ONLY option.

**Non-goals:**
- Runtime theme switching (that's a consumer app feature, not a token feature)
- Theme editor UI (out of scope)
- Backward-incompatible API breakage (minimize, document, version bump)

---

**Created:** 2026-02-28
**Last Updated:** 2026-02-28
**Brief Owner:** Fifty.ai
