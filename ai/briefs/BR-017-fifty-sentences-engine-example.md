# BR-017: Fifty Sentences Engine Example App

**Type:** Feature
**Priority:** P1-High
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2025-12-30
**Completed:** _(pending)_

---

## Problem

**What's broken or missing?**

The fifty_sentences_engine package (BR-015) needs a comprehensive example app demonstrating dialogue/sentence processing capabilities with FDL styling.

**Why does it matter?**

A high-quality example app serves as:
- Living documentation for developers
- Testing ground for the package
- Showcase of FDL design principles
- Template for dialogue-driven applications

---

## Goal

**What should happen after this brief is completed?**

A complete example app at `packages/fifty_sentences_engine/example/` with:
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
- fifty_sentences_engine (local)
- fifty_theme
- fifty_ui
- fifty_tokens
- get_it
- provider

---

## Acceptance Criteria

1. [ ] Example app runs on iOS/Android
2. [ ] Sentence queue displayed with FDL styling
3. [ ] Demo buttons for each instruction type
4. [ ] Status indicator shows processing state
5. [ ] MVVM + Actions architecture
6. [ ] `flutter analyze` passes

---

**Created:** 2025-12-30
**Brief Owner:** Igris AI
