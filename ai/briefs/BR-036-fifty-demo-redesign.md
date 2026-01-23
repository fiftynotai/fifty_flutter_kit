# BR-036: Fifty Demo App Redesign with FDL v2

**Type:** Feature
**Priority:** P1-High
**Effort:** L-Large (3-5d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-01-23
**Completed:** 2026-01-23

---

## Problem

**What's broken or missing?**

The current `fifty_demo` app has a basic structure with 4 tabs (Home, Map, Dialogue, UI) but:
- Uses top navigation instead of bottom navigation
- Only showcases 4 packages (audio, speech, sentences, map)
- Missing demos for: printing, skill_tree, achievements, forms
- Home screen needs enhancement with ecosystem overview
- No Settings screen for theme toggle and app info

**Why does it matter?**

The demo app should showcase ALL packages in the Fifty Flutter Kit ecosystem with proper FDL v2 styling. It serves as the reference implementation for developers.

---

## Goal

**What should happen after this brief is completed?**

A fully redesigned demo app with:
- FDL v2 dark theme with bottom navigation (4 tabs)
- Home screen with ecosystem dashboard
- Packages hub showcasing all 8+ engine packages
- UI Kit showcase of all FDL v2 components
- Settings screen with theme toggle

---

## Context & Inputs

### Affected Modules
- [x] `app` - App shell redesign
- [x] `home` - Enhanced home screen
- [x] `packages` - NEW packages hub
- [x] `ui_showcase` - Rename to ui_kit
- [x] `settings` - NEW settings feature
- [x] Other: map_demo, dialogue_demo → move under packages

### Layers Touched
- [x] View (UI widgets)
- [x] Actions (UX orchestration)
- [x] ViewModel (business logic)
- [ ] Service (data layer)
- [ ] Model (domain objects)

### Dependencies
- [x] New package: fifty_printing_engine ^1.0.0
- [x] New package: fifty_skill_tree ^0.2.0
- [x] New package: fifty_achievement_engine ^0.1.1
- [x] New package: fifty_forms ^0.1.0
- [x] New package: fifty_connectivity ^0.1.0

---

## Tasks

### Pending
- [ ] Phase 4: Add printing demo
- [ ] Phase 4: Add skill_tree demo
- [ ] Phase 4: Add achievements demo
- [ ] Phase 4: Add forms demo
- [ ] Phase 5: UI Kit showcase (reorganize existing)
- [ ] Phase 6: Settings screen

### In Progress
- [x] Phase 1: App shell with bottom navigation (started: 2026-01-23)

### Completed
_(Finished tasks)_

---

## Session State (Tactical - This Brief)

**Current State:** Starting Phase 1 - App shell with bottom navigation
**Next Steps When Resuming:** Complete app shell, then Phase 2 Home screen
**Last Updated:** 2026-01-23
**Blockers:** None

---

## Acceptance Criteria

1. [ ] App launches with FDL v2 dark theme
2. [ ] Bottom navigation works across all 4 tabs (Home, Packages, UI Kit, Settings)
3. [ ] Home screen shows ecosystem status
4. [ ] All 8+ package demos are accessible from Packages hub
5. [ ] UI Kit showcases all FDL v2 components
6. [ ] Settings allows theme toggle
7. [ ] MVVM + Actions pattern consistent throughout
8. [ ] `flutter analyze` passes (zero issues)
9. [ ] Manual smoke test performed

---

## Implementation Phases

### Phase 1: App Shell + FDL v2 Theme + Bottom Navigation
- Redesign fifty_demo_app.dart with bottom nav
- 4 tabs: Home, Packages, UI Kit, Settings
- FDL v2 dark theme (burgundy-black, cream text)

### Phase 2: Home Screen
- Hero section with app title + tagline
- Ecosystem status cards
- Quick access grid to package demos
- Version info footer

### Phase 3: Packages Hub + Existing Demos
- Packages hub with grid of all packages
- Move map_demo, dialogue_demo under packages
- Add audio, speech demos

### Phase 4: Add Missing Package Demos
- printing_demo
- skill_tree_demo
- achievements_demo
- forms_demo

### Phase 5: UI Kit Showcase
- Reorganize existing ui_showcase
- Add sections: Buttons, Inputs, Controls, Cards, Display

### Phase 6: Settings Screen
- Theme toggle (Light/Dark)
- About section
- Version info
- Links to docs

---

## Design Reference

### FDL v2 Color Palette
| Role | Hex | Usage |
|------|-----|-------|
| Background | `#1A0D0E` | Dark burgundy-black canvas |
| Surface | `#2A1517` | Cards, elevated containers |
| Primary | `#88292F` | Burgundy - primary buttons |
| Success | `#4B644A` | Hunter green - toggles |
| Text Primary | `#FEFEE3` | Cream - headings, body |
| Accent | `#FFC9B9` | Powder blush - highlights |

### Typography
- Font: Manrope (all text)
- Headings: Extra-bold (800)
- Body: Regular (400) / Medium (500)

### Component Style
- Border radius: 16-24px (large), 8px (small)
- Cards: Subtle 1px borders, 16-24px padding
- Buttons: Full-width or pill-shaped, 48px height

---

**Created:** 2026-01-23
**Last Updated:** 2026-01-23
**Brief Owner:** Igris AI
