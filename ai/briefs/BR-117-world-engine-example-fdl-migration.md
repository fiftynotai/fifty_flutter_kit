# BR-117: Replace World Engine Example with FDL Tactical Grid Demo

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-25

---

## Problem

**What's broken or missing?**

The `fifty_world_engine` example app does not use the Fifty Design Language (FDL). It relies on generic styling and does not showcase how the world engine integrates with the broader design system (fifty_tokens, fifty_theme, fifty_ui). This makes the example feel disconnected from the rest of the ecosystem.

**Why does it matter?**

- The example is the first thing developers see when evaluating the package
- It should demonstrate both the engine's capabilities AND how it fits the ecosystem's design system
- A FDL-styled tactical grid demo would be a much stronger first impression
- The full `apps/tactical_grid/` app (10K+ lines) already exists but is too large for a package example

---

## Goal

**What should happen after this brief is completed?**

Replace the existing `fifty_world_engine` example app with a slim (~250 line) FDL-styled tactical grid demo that:
1. Uses FDL design tokens (colors, typography, spacing) throughout the UI chrome
2. Demonstrates the world engine's core capabilities (grid rendering, entities, overlays, tap interaction)
3. Serves as a concise, visually polished "hello world" for the engine + design system integration
4. Links to `apps/tactical_grid/` for the full experience

---

## Approach

**Do NOT move `apps/tactical_grid/` into the example folder.**

The tactical_grid app is a full application (10,459 lines, 44 files) with MVVM + Actions architecture, AI opponent, audio coordinator, achievements, and settings. Package examples must stay concise (~250-500 lines).

**Instead, create a new slim demo** that extracts the essence of the tactical grid:

1. **Keep `apps/tactical_grid/` untouched** — it remains the full showcase app
2. **Replace `packages/fifty_world_engine/example/`** with a new, stripped-down FDL tactical grid demo:
   - Grid rendering with terrain types (grass, forest, water, wall)
   - Entity placement (a few units with team borders, HP bars)
   - Tile overlays (movement range, attack range on tap)
   - Tap interaction (select unit, show ranges)
   - FDL theming (FiftyTheme.light/dark, FiftyColors, FiftyTypography, FiftySpacing)
3. **No AI, no achievements, no settings, no audio** — just engine + FDL
4. **Add a comment/link** pointing to `apps/tactical_grid/` for the full game

Think of it as the tactical grid's "hello world" — enough to show what the engine can do, styled with FDL, with a pointer to the full experience.

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_world_engine/example/`

### Layers Touched
- [x] View (UI widgets)
- [x] Model (domain objects)

### API Changes
- [x] No API changes (consumer of existing APIs)

### Dependencies
- [x] Existing service: `fifty_world_engine` public API
- [x] Existing service: `fifty_tokens` (FDL color palette, typography, spacing)
- [x] Existing service: `fifty_theme` (FiftyTheme.light/dark)

### Related Files
- `packages/fifty_world_engine/example/lib/main.dart` — Replace
- `packages/fifty_world_engine/example/lib/shared/` — Replace or remove
- `packages/fifty_world_engine/example/pubspec.yaml` — Add fifty_tokens/fifty_theme deps
- `packages/fifty_world_engine/example/screenshots/` — New screenshots after implementation

### Reference (DO NOT modify)
- `apps/tactical_grid/` — Full tactical grid app (10K lines). Reference for patterns, NOT a copy source.
- `apps/tactical_grid/lib/features/battle/views/widgets/engine_board_widget.dart` — Key reference for engine API usage (443 lines)
- `apps/tactical_grid/lib/features/battle/models/` — Reference for unit/position/board models

### Prior Art
- BR-067 (Map Engine FDL Demo) — Done. Proved FDL assets work with grid engine.
- BR-078 (Tactical Skirmish Sandbox) — Done. Proved tactical grid concept as example.

---

## Constraints

### Architecture Rules
- Example must be ~250-500 lines total (concise package example, not a full app)
- Use FDL tokens for all UI chrome (colors, typography, spacing)
- Wrap app in FiftyTheme.light()/dark() for proper theming
- Only use public API from `fifty_world_engine` barrel export
- No direct Flame imports — prove the API hides Flame completely

### Technical Constraints
- Must work on iOS and Android simulators
- FDL brand colors: Burgundy #88292f, Slate Grey #335c67, Cream #fefee3, Deep Dark #1a0d0e, Powder Blush #ffc9b9
- Keep example concise and readable — a developer should understand it in 5 minutes

### Out of Scope
- AI opponent (see `apps/tactical_grid/` for that)
- Sound effects / music integration
- Save/load game state
- Settings page
- Achievement system
- MVVM + Actions architecture (overkill for a simple example)
- Network multiplayer
- New engine features — this is a consumer of existing APIs
- Modifying `apps/tactical_grid/` in any way

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Example app launches and renders a tile grid with FDL-styled chrome
2. [ ] UI chrome uses FiftyColors, FiftyTypography, FiftySpacing tokens
3. [ ] App wrapped in FiftyTheme with light/dark support
4. [ ] Grid rendering with terrain types demonstrated
5. [ ] Entity placement with decorators (HP bars, team borders) demonstrated
6. [ ] Tile overlays (movement/attack range) demonstrated on tap
7. [ ] Total example code is ~250-500 lines (not a full app)
8. [ ] No direct Flame imports in example code
9. [ ] Comment/link to `apps/tactical_grid/` for full experience
10. [ ] `flutter analyze` passes (zero issues) on the example
11. [ ] New screenshots captured for package README
12. [ ] Package README updated to describe the new example

---

## Test Plan

### Manual Test Cases

#### Test Case 1: FDL Styling
**Preconditions:** App launched
**Steps:**
1. Verify UI chrome uses FDL brand colors (burgundy, cream, slate)
2. Verify typography matches FiftyTypography tokens
3. Toggle light/dark mode if supported

**Expected Result:** All UI elements follow FDL design language

#### Test Case 2: Engine Core Features
**Preconditions:** App launched
**Steps:**
1. Verify tile grid renders with distinct terrain types
2. Verify entities (units) display on grid with HP bars and team borders
3. Tap a unit — verify selection ring and range overlays appear
4. Tap a highlighted tile — verify unit moves or action occurs

**Expected Result:** Engine features work correctly within FDL-styled shell

---

## Delivery

### Code Changes
- [ ] Replaced: `packages/fifty_world_engine/example/lib/main.dart`
- [ ] Replaced/removed: `packages/fifty_world_engine/example/lib/shared/`
- [ ] Modified: `packages/fifty_world_engine/example/pubspec.yaml` (add FDL deps)

### Documentation Updates
- [ ] README: Update example section in package README
- [ ] Screenshots: Capture new FDL-styled screenshots

---

## Notes

- `apps/tactical_grid/` stays untouched — it's a full app, not a package example
- The example is a "hello world" for engine + FDL, the app is the full experience
- Reference `engine_board_widget.dart` (443 lines) for how the app uses the engine API — distill the essentials
- Consider reusing FDL assets from `apps/fifty_demo/assets/images/` if applicable

---

**Created:** 2026-02-25
**Last Updated:** 2026-02-25
**Brief Owner:** Igris AI
