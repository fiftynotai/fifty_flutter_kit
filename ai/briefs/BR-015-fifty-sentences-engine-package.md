# BR-015: Fifty Sentences Engine Package

**Type:** Feature
**Priority:** P1-High
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Ready
**Created:** 2025-12-30
**Completed:** _(pending)_

---

## Problem

**What's broken or missing?**

The Fifty ecosystem lacks a dialogue/sentence processing engine for games and interactive storytelling. An existing implementation exists in `../erune_sentences_engine` (ARKADA Studio, v0.2.0) but needs to be rebranded and integrated into the Fifty ecosystem.

**Why does it matter?**

A sentence engine enables:
- Game master dialogues and NPC conversations
- Interactive storytelling with branching paths
- Queue-based dialogue processing with TTS integration
- Instruction-based flow control (read, write, wait, ask, navigate)

---

## Goal

**What should happen after this brief is completed?**

A new package `packages/fifty_sentences_engine` exists with:
- Full rebrand from erune_sentences_engine → fifty_sentences_engine
- Updated class names (FiftySentenceEngine, FiftySentenceInterpreter, etc.)
- FDL-aligned documentation
- All tests passing
- Ready for release as v0.1.0

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_sentences_engine` (new package)

### Layers Touched
- [x] Service (SentenceEngine, SentenceInterpreter)
- [x] Model (SentenceModel, BaseSentenceModel)

### Dependencies
- [x] Existing package: `plugin_platform_interface: ^2.0.2`
- [x] Flutter SDK >=3.3.0, Dart ^3.6.0

### Related Files
Source: `../erune_sentences_engine/`
```
lib/
├── erune_sentences_engine.dart → fifty_sentences_engine.dart
├── erune_sentences_engine_platform_interface.dart
├── erune_sentences_engine_method_channel.dart
├── erune_sentences_engine_web.dart
├── engine/
│   ├── sentence_engine.dart
│   ├── sentence_interpreter.dart
│   └── safe_sentence_writer.dart
└── data/
    └── models/
        └── base_sentence_model.dart
```

---

## Constraints

### Architecture Rules
- Follow Fifty ecosystem naming conventions (FiftyXxx)
- Maintain pluggable handler architecture
- Include comprehensive documentation comments

### Technical Constraints
- Must support all platforms (Android, iOS, macOS, Linux, Web, Windows)
- Zero analyzer warnings

### Out of Scope
- New features beyond rebrand
- Example app (separate brief BR-016)

---

## Tasks

### Pending
- [ ] Task 1: Copy erune_sentences_engine to packages/fifty_sentences_engine
- [ ] Task 2: Update pubspec.yaml (name, description, homepage)
- [ ] Task 3: Rename all Dart files (erune → fifty)
- [ ] Task 4: Update all class names (FiftySentenceEngine, etc.)
- [ ] Task 5: Update plugin classes in pubspec.yaml
- [ ] Task 6: Update all internal imports
- [ ] Task 7: Write comprehensive README (FDL-aligned)
- [ ] Task 8: Write CHANGELOG.md
- [ ] Task 9: Run flutter analyze (zero warnings)
- [ ] Task 10: Run flutter test (all pass)

### In Progress
_(None)_

### Completed
_(None)_

---

## Session State (Tactical - This Brief)

**Current State:** Brief registered, awaiting implementation
**Next Steps When Resuming:** Start with Task 1 - copy package
**Last Updated:** 2025-12-30
**Blockers:** None

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Package exists at `packages/fifty_sentences_engine`
2. [ ] All files renamed from erune → fifty
3. [ ] Class names follow FiftyXxx pattern
4. [ ] README.md comprehensive with API reference
5. [ ] CHANGELOG.md documents v0.1.0
6. [ ] `flutter analyze` passes (zero issues)
7. [ ] `flutter test` passes (all tests green)

---

## Test Plan

### Automated Tests
- [ ] Unit test: SentenceEngine queue processing
- [ ] Unit test: SentenceInterpreter instruction handling
- [ ] Unit test: SafeSentenceWriter deduplication

---

## Delivery

### Code Changes
- [x] New files created: `packages/fifty_sentences_engine/*`

### Documentation Updates
- [x] README: Full API reference
- [x] CHANGELOG: v0.1.0 initial release

---

## Workflow State

**Phase:** INIT
**Active Agent:** none
**Retry Count:** 0

### Agent Log
_(Timestamped subagent invocations)_

---

**Created:** 2025-12-30
**Last Updated:** 2025-12-30
**Brief Owner:** Igris AI
