# BR-017: Fifty Narrative Engine Example App

**Type:** Feature
**Priority:** P1-High
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-12-30
**Completed:** 2025-12-30

---

## Problem

**What's broken or missing?**

The fifty_narrative_engine package (BR-015) needs a comprehensive example app demonstrating dialogue/sentence processing capabilities with FDL styling.

**Why does it matter?**

A high-quality example app serves as:
- Living documentation for developers
- Testing ground for the package
- Showcase of FDL design principles
- Template for dialogue-driven applications

---

## Goal

**What should happen after this brief is completed?**

A complete example app at `packages/fifty_narrative_engine/example/` with:
- FDL-styled UI using fifty_theme + fifty_ui
- Sentence queue visualization
- Instruction demo (read, write, ask, wait, navigate)
- Interactive dialogue simulation
- MVVM + Actions architecture

---

## Context & Inputs

### Architecture
Follow MVVM + Actions pattern:
```
example/lib/
├── main.dart
├── app/
│   └── sentences_demo_app.dart
├── core/
│   └── di/
│       └── service_locator.dart
├── features/
│   └── sentences_demo/
│       ├── actions/
│       ├── viewmodel/
│       ├── service/
│       └── view/
│           └── widgets/
└── shared/
```

### Dependencies
- fifty_narrative_engine (local)
- fifty_theme
- fifty_ui
- fifty_tokens
- get_it
- provider

---

## Acceptance Criteria

1. [x] Example app runs on iOS/Android
2. [x] Sentence queue displayed with FDL styling
3. [x] Demo buttons for each instruction type
4. [x] Status indicator shows processing state
5. [x] MVVM + Actions architecture
6. [x] `flutter analyze` passes

---

## Workflow State

**Phase:** COMPLETE
**Active Agent:** none
**Retry Count:** 0

### Agent Log
- 2025-12-30: coder - Example app created (MVVM + Actions)
- 2025-12-30: coder - Demo story feature added (19 sentences)
- 2025-12-30: documenter - Example README updated
- 2025-12-30: releaser - Released with v0.1.0

---

**Created:** 2025-12-30
**Brief Owner:** Igris AI
