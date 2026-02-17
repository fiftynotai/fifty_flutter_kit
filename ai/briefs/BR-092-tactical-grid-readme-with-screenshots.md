# BR-092: Tactical Grid README with Screenshots

**Type:** Documentation
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-17

---

## Problem

**What's broken or missing?**

The Tactical Grid app (`apps/tactical_grid/`) has no comprehensive README. After 20+ briefs of development (BR-071 through BR-091), the app has grown into a fully featured tactical turn-based game with multiple pages, AI opponents, audio, achievements, settings, and theme support — but none of this is documented. There is no visual overview of what the app looks like or what it does.

**Why does it matter?**

Without a README, anyone opening the project (including future contributors or the Monarch returning after a break) has no quick way to understand the app's scope, features, architecture, or how to run it. Screenshots are essential for a game app — they communicate more than text alone.

---

## Goal

**What should happen after this brief is completed?**

A polished `apps/tactical_grid/README.md` exists with:
- App overview and description
- Feature list
- Screenshots of every major page/screen (light + dark mode)
- Architecture overview (how modules connect)
- How to build and run
- Tech stack / dependencies
- Credits / attribution for assets

---

## Context & Inputs

### Affected Modules
- [x] App: `apps/tactical_grid/`

### Layers Touched
- [x] Documentation only (README.md + screenshot assets)

### API Changes
- [x] No code changes

### Pages to Screenshot

| Page | Description | Modes |
|------|-------------|-------|
| Menu | Main menu with PLAY, ACHIEVEMENTS, SETTINGS buttons | Light + Dark |
| Battle | Active gameplay with grid, units, HUD bars | Dark (primary mode) |
| Achievements | Achievement cards list with rarity badges | Light + Dark |
| Settings | Audio, Gameplay, Display sections with theme toggle | Light + Dark |
| AI Turn | AI thinking/moving state during battle | Dark |
| Victory/Defeat | End-of-game state | Dark |

### Documentation to Review

Before writing the README, review these sources for accurate feature lists:
- `ai/briefs/BR-071-tactical-grid-game.md` — original game brief
- `ai/session/CURRENT_SESSION.md` — completed brief summaries
- `apps/tactical_grid/lib/` — source code for feature inventory
- `apps/tactical_grid/pubspec.yaml` — dependencies
- `apps/tactical_grid/test/` — test count for quality badge

---

## Constraints

### Architecture Rules
- README goes in `apps/tactical_grid/README.md`
- Screenshots go in `apps/tactical_grid/docs/screenshots/` directory
- Use relative paths for screenshot references in README
- Screenshots should be PNG format, taken on iOS simulator

### Content Rules
- Keep it concise but comprehensive
- Lead with a hero screenshot (battle gameplay)
- Feature list should reflect actual implemented features, not aspirational ones
- Architecture section should be high-level (not a deep dive)
- Include test count as a quality signal
- No AI-generated badges or fake shields

### Out of Scope
- Code changes to the app itself
- Generating new app icons or logos
- Publishing to any platform
- Writing API documentation (this is a standalone app)

---

## Tasks

### Pending

### In Progress

### Completed
- [x] Task 1: Review BR-071 brief and CURRENT_SESSION.md for complete feature inventory
- [x] Task 2: Review source code structure (`apps/tactical_grid/lib/`) for architecture overview
- [x] Task 3: Launch app on iOS simulator and capture screenshots of all pages in dark mode
- [x] Task 4: Switch to light mode and capture screenshots of menu, achievements, settings
- [x] Task 5: Create `apps/tactical_grid/docs/screenshots/` directory
- [x] Task 6: Save all screenshots with descriptive filenames (9 screenshots)
- [x] Task 7: Write `apps/tactical_grid/README.md` with all sections
- [x] Task 8: Verify all screenshot paths resolve correctly in the README
- [x] Task 9: Review README for accuracy and completeness

---

## Acceptance Criteria

**The brief is complete when:**

1. [ ] `apps/tactical_grid/README.md` exists with all sections
2. [ ] Screenshots captured for all major pages (minimum 6 screenshots)
3. [ ] Both light and dark mode represented in screenshots
4. [ ] Feature list matches actual implemented features
5. [ ] Architecture overview accurately reflects MVVM+Actions pattern
6. [ ] Build/run instructions are correct and tested
7. [ ] All screenshot paths in README resolve to actual files
8. [ ] README is well-formatted markdown that renders correctly on GitHub

---

## Test Plan

### Automated Tests
- [ ] No code changes — no tests needed

### Manual Test Cases

#### Test Case 1: README Renders Correctly
**Steps:**
1. Open `apps/tactical_grid/README.md` in a markdown preview
2. Verify all screenshots display
3. Verify all links work
4. Verify formatting is clean

**Expected Result:** README renders with visible screenshots and clean formatting

---

## Delivery

### Code Changes
- [ ] New files: `apps/tactical_grid/README.md`, `apps/tactical_grid/docs/screenshots/*.png`
- [ ] Modified files: None
- [ ] Deleted files: None

---

## README Structure (Suggested)

```
# Tactical Grid

> Turn-based tactical combat on a hex-free grid. A Fifty Showcase app.

[Hero screenshot - battle gameplay]

## Features
- [feature list]

## Screenshots
### Dark Mode
[grid of dark mode screenshots]
### Light Mode
[grid of light mode screenshots]

## Architecture
[high-level MVVM+Actions diagram]
[module overview]

## Tech Stack
[dependencies and packages used]

## Getting Started
[build and run instructions]

## Tests
[test count and how to run]

## Credits
[asset attribution]
```

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** Igris AI
