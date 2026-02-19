# BR-102: Capture Example Screenshots for All Engine Packages

**Type:** Feature
**Priority:** P2-Medium
**Effort:** L-Large (3-5d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-17

---

## Problem

**What's broken or missing?**

All 7 engine packages in the Fifty Flutter Kit lack example screenshots in their READMEs. No `screenshots/` directories exist. No PNG references in any README. This makes it impossible for developers evaluating the kit to see what each engine looks like without cloning and running the code.

**Engines missing screenshots:**
1. `fifty_achievement_engine` — achievement cards, popups, progress, summary
2. `fifty_audio_engine` — BGM/SFX/voice channel controls, playlists
3. `fifty_world_engine` — tile map rendering, entities, camera
4. `fifty_sentences_engine` — dialogue display, sentence queue, instruction buttons
5. `fifty_speech_engine` — TTS/STT panels, language selection, status indicators
6. `fifty_printing_engine` — printer management, test print, ticket builder
7. `fifty_skill_tree` — skill tree rendering, node progression, interactions

**Why does it matter?**

Screenshots are the first thing developers look at when evaluating a package. Without them, the README is incomplete and the engine's value proposition is invisible.

---

## Goal

**What should happen after this brief is completed?**

- Each engine package has a `screenshots/` directory with 2-4 screenshots
- Each screenshot captures a key feature of the example app (light mode preferred, dark mode bonus)
- Each README references the screenshots with proper markdown image tags
- Screenshots are captured from iOS Simulator using mobile MCP tools

---

## Context & Inputs

### Affected Packages
- [x] `packages/fifty_achievement_engine/`
- [x] `packages/fifty_audio_engine/`
- [x] `packages/fifty_world_engine/`
- [x] `packages/fifty_sentences_engine/`
- [x] `packages/fifty_speech_engine/`
- [x] `packages/fifty_printing_engine/`
- [x] `packages/fifty_skill_tree/`

### Tools Required
- iOS Simulator (already available on macOS)
- `mobile-mcp` tools: `mobile_list_available_devices`, `mobile_launch_app`, `mobile_take_screenshot`, `mobile_save_screenshot`, `mobile_click_on_screen_at_coordinates`, `mobile_swipe_on_screen`
- `flutter build ios --simulator --debug` for each example app
- `flutter install` to deploy to simulator

---

## Constraints

### Architecture Rules
- Screenshots saved to `packages/{engine}/screenshots/` directory
- Naming convention: `{feature}_light.png` (e.g., `achievement_card_light.png`)
- README references use relative paths: `![Feature](screenshots/feature_light.png)`
- Capture at iPhone 15 Pro resolution (default simulator)

### Technical Constraints
- Each example app must be built and installed separately on the simulator
- Apps must be fully loaded before screenshots (wait for render)
- Some engines require interaction to reach interesting screens (navigate tabs, trigger features)
- Printing engine: screenshot the UI only (no hardware required for UI screenshots)
- Speech engine: screenshot TTS/STT panels (no microphone needed for UI screenshots)

### Out of Scope
- Dark mode screenshots (can be added in a follow-up)
- Video recordings / GIFs
- Modifying example app code (already reviewed in BR-095 through BR-101)

---

## Multi-Agent Workflow

**NOTE:** This brief is SEQUENTIAL — each engine uses the same simulator, so they must be processed one at a time. However, within each engine the workflow is parallelizable (build while documenting README changes).

### Per-Engine Workflow (repeat for each of 7 engines):

#### Step 1: BUILD (coder agent via Bash)
**Boundary:** Build only, no code changes.
1. `cd packages/{engine}/example`
2. `flutter build ios --simulator --debug`
3. Verify build succeeds

#### Step 2: INSTALL & LAUNCH (orchestrator via mobile MCP)
**Boundary:** Simulator interaction only.
1. List available simulators → select booted iPhone
2. Install the built app on simulator
3. Launch the app
4. Wait for app to fully render

#### Step 3: CAPTURE SCREENSHOTS (orchestrator via mobile MCP)
**Boundary:** Screenshot capture only.
1. Take screenshot of main/home screen
2. Navigate to key feature screens (tap buttons, switch tabs)
3. Take 2-4 screenshots per engine capturing distinct features
4. Save screenshots to `packages/{engine}/screenshots/`

**Screenshot targets per engine:**

| Engine | Screenshot 1 | Screenshot 2 | Screenshot 3 | Screenshot 4 |
|--------|-------------|-------------|-------------|-------------|
| achievement_engine | Achievement list | Achievement card detail | Achievement popup | Achievement summary |
| audio_engine | BGM player | SFX panel | Voice channel | Global controls |
| map_engine | Tile map overview | Entity interaction | Camera zoomed | Pathfinding demo |
| sentences_engine | Dialogue display | Sentence queue | Instruction buttons | Story flow |
| speech_engine | TTS panel | STT panel | Language selection | — |
| printing_engine | Home screen | Printer management | Test print | Ticket builder |
| skill_tree | Tree overview | Node interaction | Unlock progression | — |

#### Step 4: UPDATE README (documenter agent)
**Boundary:** README.md only.
1. Add `## Screenshots` section to README (or update existing)
2. Add markdown image references: `![Feature](screenshots/feature_light.png)`
3. Brief description under each screenshot

#### Step 5: TERMINATE APP
1. Terminate the app on simulator
2. Move to next engine

---

## Tasks

### Pending
_(None)_

### In Progress
_(None)_

### Completed
- [x] Engine 1: fifty_achievement_engine — 4 screenshots (home, basic, unlocked, RPG)
- [x] Engine 2: fifty_audio_engine — 4 screenshots (BGM, SFX, voice, global)
- [x] Engine 3: fifty_world_engine — 2 screenshots (tactical overview, unit selection)
- [x] Engine 4: fifty_sentences_engine — 3 screenshots (queue, choices, narration)
- [x] Engine 5: fifty_speech_engine — 2 screenshots (TTS panel, STT panel)
- [x] Engine 6: fifty_printing_engine — 4 screenshots (home, printers, test print, builder)
- [x] Engine 7: fifty_skill_tree — 4 screenshots (home, basic tree, node unlock, RPG tree)

---

## Session State (Tactical - This Brief)

**Current State:** Done
**Next Steps When Resuming:** N/A — all 7 engines complete
**Last Updated:** 2026-02-17
**Blockers:** None

---

## Acceptance Criteria

1. [x] Each engine has `screenshots/` directory with 2-4 screenshots
2. [x] Screenshots capture distinct features of each engine's example app
3. [x] Screenshots are clear, fully rendered (no loading spinners)
4. [x] Each README has a `## Screenshots` section with image references
5. [x] Image paths are relative (`screenshots/feature_light.png`)
6. [x] All 7 engines covered

---

## Test Plan

### Manual Verification
For each engine:
1. Open README on GitHub/locally
2. Verify screenshots render correctly
3. Verify screenshots show meaningful engine features
4. Verify image file sizes are reasonable (< 2MB each)

---

## Delivery

### Files Created
- `packages/fifty_achievement_engine/screenshots/*.png` (2-4 files)
- `packages/fifty_audio_engine/screenshots/*.png` (2-4 files)
- `packages/fifty_world_engine/screenshots/*.png` (2-4 files)
- `packages/fifty_sentences_engine/screenshots/*.png` (2-4 files)
- `packages/fifty_speech_engine/screenshots/*.png` (2-4 files)
- `packages/fifty_printing_engine/screenshots/*.png` (2-4 files)
- `packages/fifty_skill_tree/screenshots/*.png` (2-4 files)

### Files Modified
- `packages/*/README.md` — Screenshots section added (7 files)

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** Igris AI
