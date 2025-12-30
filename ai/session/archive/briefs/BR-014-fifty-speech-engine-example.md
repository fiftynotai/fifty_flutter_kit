# BR-014: Fifty Speech Engine Example App

**Type:** Feature
**Priority:** P1-High
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-12-27
**Completed:** 2025-12-27

---

## Problem

**What's broken or missing?**

The fifty_speech_engine package (BR-013) needs a comprehensive example app demonstrating TTS and STT capabilities. Following the pattern established by fifty_audio_engine, the example should showcase all features in an interactive, FDL-styled interface.

**Why does it matter?**

A high-quality example app serves as:
- Living documentation for developers
- Testing ground for the package
- Showcase of FDL design principles
- Template for speech-enabled applications

---

## Goal

**What should happen after this brief is completed?**

A complete example app at `packages/fifty_speech_engine/example/` with:
- FDL-styled UI using fifty_theme + fifty_ui
- TTS demo: Text input → spoken output
- STT demo: Voice input → text display
- Language selection
- Status indicators (speaking/listening)
- MVVM + Actions architecture

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_speech_engine/example/` (new app)

### Layers Touched
- [x] View (FDL-styled UI widgets)
- [x] Actions (user interaction handlers)
- [x] ViewModel (speech state management)
- [x] Service (FiftySpeechEngine wrapper)
- [x] Model (speech results)

### Dependencies
- [x] Existing package: `fifty_speech_engine` (from BR-013)
- [x] Existing package: `fifty_theme` (FDL theming)
- [x] Existing package: `fifty_ui` (FDL components)
- [x] Existing package: `fifty_tokens` (design tokens)

### Related Files
```
packages/fifty_speech_engine/example/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   └── speech_demo_app.dart
│   ├── core/
│   │   └── di/
│   │       └── service_locator.dart
│   ├── features/
│   │   └── speech_demo/
│   │       ├── actions/
│   │       │   └── speech_demo_actions.dart
│   │       ├── viewmodel/
│   │       │   └── speech_demo_viewmodel.dart
│   │       ├── service/
│   │       │   └── speech_service.dart
│   │       └── view/
│   │           ├── speech_demo_page.dart
│   │           └── widgets/
│   │               ├── tts_panel.dart
│   │               ├── stt_panel.dart
│   │               └── status_indicator.dart
│   └── shared/
│       └── widgets/
│           └── demo_scaffold.dart
├── pubspec.yaml
└── README.md
```

---

## Constraints

### Architecture Rules
- Follow MVVM + Actions pattern (like fifty_audio_engine example)
- Use FDL design tokens and components
- Use dependency injection via service locator
- No business logic in Views

### Technical Constraints
- Must work on Android, iOS (microphone permissions)
- Web support optional (browser STT limitations)
- Dark theme primary (FDL)

### Out of Scope
- Advanced NLP processing
- Custom voice models
- Streaming API integrations

---

## Tasks

### Pending
- [ ] Task 1: Create example app scaffold (flutter create)
- [ ] Task 2: Set up pubspec.yaml with dependencies
- [ ] Task 3: Implement service locator (DI)
- [ ] Task 4: Create SpeechService wrapper
- [ ] Task 5: Create SpeechDemoViewModel
- [ ] Task 6: Create SpeechDemoActions
- [ ] Task 7: Build TTS panel (text input, speak button, stop button)
- [ ] Task 8: Build STT panel (listen button, result display, status)
- [ ] Task 9: Build status indicator (speaking/listening states)
- [ ] Task 10: Add language selector dropdown
- [ ] Task 11: Style with FDL (crimson glows, voidBlack, etc.)
- [ ] Task 12: Write example README.md
- [ ] Task 13: Run flutter analyze (zero warnings)
- [ ] Task 14: Manual test on Android/iOS

### In Progress
_(Tasks currently being worked on)_

### Completed
_(Finished tasks)_

---

## Session State (Tactical - This Brief)

**Current State:** Brief registered, awaiting BR-013 completion
**Next Steps When Resuming:** Complete BR-013 first, then start Task 1
**Last Updated:** 2025-12-27 00:00
**Blockers:** Depends on BR-013 (fifty_speech_engine package)

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Example app runs on Android/iOS
2. [ ] TTS demo: User can type text and hear it spoken
3. [ ] STT demo: User can speak and see transcription
4. [ ] Language can be switched (en-US, etc.)
5. [ ] Status indicators show speaking/listening states
6. [ ] UI follows FDL styling (dark theme, crimson accents)
7. [ ] MVVM + Actions architecture implemented
8. [ ] `flutter analyze` passes (zero issues)
9. [ ] README.md documents how to run and use

---

## Test Plan

### Manual Test Cases

#### Test Case 1: TTS Flow
**Preconditions:** App running, permissions granted
**Steps:**
1. Enter text "Hello Fifty"
2. Tap Speak button
3. Observe status indicator

**Expected Result:** Device speaks text, indicator shows "Speaking"
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: STT Flow
**Preconditions:** App running, microphone permission granted
**Steps:**
1. Tap Listen button
2. Speak "Test message"
3. Observe result display

**Expected Result:** Spoken text appears in display
**Status:** [ ] Pass / [ ] Fail

#### Test Case 3: Language Switch
**Preconditions:** App running
**Steps:**
1. Select different language from dropdown
2. Perform TTS/STT operations

**Expected Result:** Engine uses selected language
**Status:** [ ] Pass / [ ] Fail

---

## Delivery

### Code Changes
- [x] New files created: `packages/fifty_speech_engine/example/*`
- [ ] Modified files: None
- [ ] Deleted files: None

### Documentation Updates
- [x] README: Example app usage guide

---

## Workflow State

**Phase:** INIT
**Active Agent:** none
**Retry Count:** 0

### Agent Log
_(Timestamped subagent invocations)_

---

**Created:** 2025-12-27
**Last Updated:** 2025-12-27
**Brief Owner:** Igris AI
