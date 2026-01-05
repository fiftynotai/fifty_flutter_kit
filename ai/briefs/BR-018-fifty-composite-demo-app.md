# BR-018: Fifty Composite Demo App

**Type:** Feature
**Priority:** P2-Medium
**Effort:** L-Large (2-4d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-12-30
**Completed:** 2026-01-05

---

## Problem

**What's broken or missing?**

The Fifty ecosystem now has 7 released packages but no unified demo app that showcases all engines working together. Each package has its own isolated example app, but there's no demonstration of how they integrate into a cohesive application.

**Why does it matter?**

A composite demo app would:
- Demonstrate full ecosystem integration
- Serve as a reference architecture for developers
- Showcase FDL styling across all components
- Validate inter-package compatibility
- Provide a template for real game projects

---

## Goal

**What should happen after this brief is completed?**

A new demo app exists at `apps/fifty_demo/` that:
- Integrates all 7 Fifty packages
- Demonstrates audio, speech, sentences, and map engines together
- Uses fifty_tokens, fifty_theme, and fifty_ui for styling
- Follows MVVM + Actions architecture
- Runs on all platforms (Android, iOS, macOS, Linux, Windows, Web)

---

## Context & Inputs

### Packages to Integrate

| Package | Version | Purpose |
|---------|---------|---------|
| fifty_tokens | v0.2.0 | Design tokens (colors, typography, spacing) |
| fifty_theme | v0.1.0 | Theme system (dark/light themes) |
| fifty_ui | v0.4.0 | UI components (buttons, cards, inputs) |
| fifty_audio_engine | v0.7.0 | Audio (BGM, SFX, Voice channels) |
| fifty_speech_engine | v0.1.0 | TTS/STT capabilities |
| fifty_sentences_engine | v0.1.0 | Dialogue/sentence queue processing |
| fifty_map_engine | v0.1.0 | Interactive grid map rendering |

### Demo Scenarios

1. **Interactive Map with Audio**
   - Map rendering with FiftyMapWidget
   - BGM playing during exploration
   - SFX on entity interactions

2. **Dialogue System**
   - Sentence engine for narrative text
   - TTS reading dialogue aloud
   - STT for voice commands

3. **UI Showcase**
   - FDL-styled interface
   - All fifty_ui components
   - Dark theme with crimson accents

### Layers Touched
- [x] UI (Flutter widgets, FDL components)
- [x] ViewModel (state management)
- [x] Service (engine integrations)
- [x] Actions (user interactions)

### Dependencies
- All 7 Fifty packages (path dependencies)
- provider: ^6.1.2 (state management)
- get_it: ^8.0.0 (dependency injection)

---

## Constraints

### Architecture Rules
- Follow MVVM + Actions pattern
- Use GetIt for dependency injection
- Apply FDL styling throughout
- Maintain clean separation of concerns

### Technical Constraints
- Must run on all 6 platforms
- Zero analyzer warnings
- All engines properly initialized/disposed

### Out of Scope
- Game logic beyond demo scenarios
- Persistent data storage
- Network features
- Publishing to app stores

---

## Tasks

### Pending
- [ ] Task 1: Create app structure at apps/fifty_demo/
- [ ] Task 2: Set up pubspec.yaml with all package dependencies
- [ ] Task 3: Create DI service locator for all engines
- [ ] Task 4: Build main navigation with FDL styling
- [ ] Task 5: Create Map Demo feature (map + audio integration)
- [ ] Task 6: Create Dialogue Demo feature (sentences + speech)
- [ ] Task 7: Create UI Showcase feature (all fifty_ui components)
- [ ] Task 8: Add platform configurations
- [ ] Task 9: Write README documentation
- [ ] Task 10: Run flutter analyze and test

### In Progress
_(None)_

### Completed
_(None)_

---

## Session State (Tactical - This Brief)

**Current State:** Brief registered, awaiting implementation
**Next Steps When Resuming:** Start with Task 1 - create app structure
**Last Updated:** 2025-12-30
**Blockers:** None

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] App exists at `apps/fifty_demo/`
2. [ ] All 7 Fifty packages integrated
3. [ ] Map Demo: FiftyMapWidget + FiftyAudioEngine working together
4. [ ] Dialogue Demo: FiftySentenceEngine + FiftySpeechEngine working together
5. [ ] UI Showcase: All fifty_ui components displayed
6. [ ] FDL styling applied throughout (dark theme, crimson accents)
7. [ ] MVVM + Actions architecture followed
8. [ ] Runs on all 6 platforms
9. [ ] `flutter analyze` passes (zero issues)
10. [ ] README.md documents the demo app

---

## Test Plan

### Manual Tests
- [ ] Launch app on each platform
- [ ] Navigate between demo features
- [ ] Verify map rendering and interactions
- [ ] Verify audio plays correctly
- [ ] Verify TTS/STT functionality
- [ ] Verify dialogue system progression
- [ ] Verify UI components render correctly

### Automated Tests
- [ ] Widget tests for navigation
- [ ] Unit tests for service integrations

---

## Delivery

### Code Changes
- [x] New app created: `apps/fifty_demo/`

### Documentation Updates
- [x] README: App overview and feature documentation
- [x] Architecture: MVVM + Actions pattern explanation

---

## Workflow State

**Phase:** COMPLETE
**Active Agent:** none
**Retry Count:** 0

### Agent Log
- 2026-01-05 - Starting HUNT with multi-agent workflow
- 2026-01-05 - PLANNER complete: Plan saved to ai/plans/BR-018-plan.md
- 2026-01-05 - CODER complete: 53 Dart files created, zero analyzer issues
- 2026-01-05 - TESTER complete: PASS (analyzer clean, tests pass, build success)
- 2026-01-05 - REVIEWER complete: APPROVE (all checks passed)
- 2026-01-05 - COMMIT complete: ea1a73d (190 files, 12028 insertions)

---

**Created:** 2025-12-30
**Last Updated:** 2025-12-30
**Brief Owner:** Igris AI
