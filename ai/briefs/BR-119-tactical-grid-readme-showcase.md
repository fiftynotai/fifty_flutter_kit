# BR-119: Add Tactical Grid App to Root README

**Type:** Feature
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-25

---

## Problem

**What's broken or missing?**

The `apps/tactical_grid/` app is a fully-featured tactical skirmish game (10K+ lines) that showcases multiple ecosystem packages working together — yet it is completely absent from the root README:

1. **Not in the Showcase grid** — No screenshot despite being the most visually impressive app in the ecosystem
2. **Not in the Apps table** — Only `fifty_demo` is listed; `tactical_grid` and `sneaker_drops` are missing
3. **Not mentioned anywhere** — Zero visibility for the most complex example of the ecosystem in action

**Why does it matter?**

- The tactical grid app demonstrates `fifty_world_engine`, `fifty_audio_engine`, `fifty_achievement_engine`, `fifty_tokens`, `fifty_theme`, and `fifty_ui` working together in a real app
- It's the strongest proof that the ecosystem works for non-trivial applications
- Developers evaluating the kit for game development would benefit from seeing this showcase
- `sneaker_drops` is also missing from the apps table

---

## Goal

**What should happen after this brief is completed?**

1. Tactical grid app has a screenshot in the README Showcase grid
2. All apps in `apps/` are listed in the Apps table
3. Tactical grid has screenshots captured in `apps/tactical_grid/screenshots/`

---

## Context & Inputs

### Affected Modules
- [x] Other: Root `README.md`
- [x] Other: `apps/tactical_grid/`

### Current Apps Table (README line ~180)
```markdown
| App | Description |
|-----|-------------|
| [fifty_demo](apps/fifty_demo/) | Interactive demo showcasing all packages |
```

### Missing Apps
| App | Path | Description |
|-----|------|-------------|
| `tactical_grid` | `apps/tactical_grid/` | Tactical skirmish game — world engine, audio, achievements |
| `sneaker_drops` | `apps/sneaker_drops/` | Sneaker marketplace — UI components, forms, theming |

### Current Showcase Grid (README lines 26-39)
8 screenshots in a 2x4 grid. One slot could be swapped or grid expanded to include tactical grid.

### Screenshots Needed
- `apps/tactical_grid/screenshots/` directory needs to be created
- Need at least 1 representative screenshot (battle view with grid, units, overlays)
- Ideally: `battle_dark.png` and/or `battle_light.png`

### Related Files
- `README.md` — Add to showcase grid + apps table
- `apps/tactical_grid/screenshots/` — Create directory, capture screenshots

---

## Constraints

### Architecture Rules
- Follow existing README showcase grid format (180px width, center-aligned, `<sub>` caption)
- Follow existing apps table markdown format
- Keep README line count reasonable (~250-320 lines)

### Technical Constraints
- Screenshots must be captured from the actual running app
- Screenshots should show the battle grid with units, terrain, and overlays for maximum visual impact
- If adding to showcase grid without removing an existing screenshot, may need to adjust grid layout (2x4 → 3x3 or add a row)

### Out of Scope
- Modifying the tactical_grid or sneaker_drops app code
- Updating docs/ARCHITECTURE.md or docs/QUICK_START.md
- Adding tactical_grid to the packages table (it's an app, not a package)

---

## Tasks

### Pending
- [ ] Task 1: Capture tactical_grid screenshots (battle view, dark mode)
- [ ] Task 2: Create `apps/tactical_grid/screenshots/` directory
- [ ] Task 3: Add tactical_grid screenshot to README Showcase grid
- [ ] Task 4: Add tactical_grid and sneaker_drops to README Apps table
- [ ] Task 5: Verify all links resolve correctly

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] `apps/tactical_grid/screenshots/` exists with at least 1 screenshot
2. [ ] Tactical grid screenshot appears in the README Showcase grid
3. [ ] Apps table lists all 3 apps: fifty_demo, tactical_grid, sneaker_drops
4. [ ] All relative links in README resolve correctly
5. [ ] README renders correctly on GitHub (no broken images)

---

## Test Plan

### Manual Test Cases

#### Test Case 1: README Rendering
**Steps:**
1. Push to GitHub
2. View README on repository page
3. Verify showcase screenshots all render (including new tactical grid)
4. Verify apps table links work
5. Click tactical_grid link — verify it navigates to the app directory

**Expected Result:** All images render, all links work

---

## Delivery

### Code Changes
- [ ] New: `apps/tactical_grid/screenshots/battle_dark.png` (captured)
- [ ] Modified: `README.md` (showcase grid + apps table)

### Documentation Updates
- [ ] README: Showcase grid updated with tactical_grid screenshot
- [ ] README: Apps table lists all apps in `apps/` directory

---

## Notes

- Screenshot capture requires running the tactical_grid app on a simulator/device
- The battle view with the grid, colored terrain, units with HP bars, and tile overlays is the most visually impressive screenshot to use
- Consider whether to expand the showcase grid (add row) or replace one of the existing 8 screenshots
- `sneaker_drops` should also get a description in the apps table even if no screenshot is added to the showcase grid

---

**Created:** 2026-02-25
**Last Updated:** 2026-02-25
**Brief Owner:** Igris AI
