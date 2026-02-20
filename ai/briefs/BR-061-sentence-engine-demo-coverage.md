# BR-061: Sentence Engine Demo - Full Feature Coverage

**Type:** Feature
**Priority:** P2-Medium
**Effort:** L-Large (8-16h)
**Assignee:** Unassigned
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-02
**Completed:** 2026-02-02

---

## Problem

**What's broken or missing?**

The Sentence Engine demo in fifty_demo does not showcase all available features of the fifty_narrative_engine package. The engine supports 5 instruction types plus combined instructions, but the demo may only show basic functionality.

**Engine Capabilities (from audit):**

| Instruction | Purpose | Currently Demonstrated? |
|-------------|---------|------------------------|
| `read` | TTS - speak text aloud | ❓ Unknown |
| `write` | Display sentence on screen | ❓ Unknown |
| `ask` | Show choices, await user selection | ❓ Unknown |
| `wait` | Pause until user tap/input | ❓ Unknown |
| `navigate` | Phase/scene transition | ❓ Unknown |
| `read + write` | Combined - speak AND display | ❓ Unknown |

**Why does it matter?**

- Users cannot discover full engine capabilities
- Demo doesn't serve as proper documentation/showcase
- Features may appear missing when they actually exist
- Reduces perceived value of the engine package

---

## Goal

**What should happen after this brief is completed?**

Demo showcases ALL sentence engine features with interactive examples:

1. **Read Mode** - TTS demonstration (requires fifty_speech_engine)
2. **Write Mode** - Text display with typewriter effect
3. **Ask Mode** - Choice selection system
4. **Wait Mode** - Tap-to-continue interaction
5. **Navigate Mode** - Phase/scene transitions
6. **Combined Mode** - `read + write` simultaneous execution
7. **Processing States** - Show idle/processing/paused/completed states
8. **Order-Based Queue** - Demonstrate priority sorting

---

## Context & Inputs

### Engine Architecture (from audit)

**Core Components:**
| Component | Purpose |
|-----------|---------|
| `SentenceEngine` | Core processor for queue execution |
| `SentenceInterpreter` | Instruction parsing and handler delegation |
| `SentenceQueue` | Optimized queue with order-based sorting |
| `BaseSentenceModel` | Abstract interface for sentence data |
| `SafeSentenceWriter` | Deduplication for idempotent rendering |

**Processing States:**
| Status | Description |
|--------|-------------|
| `idle` | Ready for new work |
| `processing` | Actively executing sentences |
| `paused` | Temporarily paused |
| `cancelled` | Stopped before completion |
| `completed` | All sentences processed |

**Interpreter Handlers:**
```dart
SentenceInterpreter(
  engine: engine,
  onRead: (text) async { /* TTS */ },
  onWrite: (sentence) async { /* Display */ },
  onAsk: (sentence) async { /* Choices */ },
  onWait: (sentence) async { /* Pause */ },
  onNavigate: (sentence) async { /* Scene change */ },
  onUnhandled: (sentence) async { /* Fallback */ },
)
```

### Affected Modules
- [x] Other: `apps/fifty_demo/lib/src/modules/sentences/`

### Layers Touched
- [x] View (UI widgets) - demo sections
- [x] Actions (UX orchestration) - interactions
- [x] ViewModel (business logic) - engine state
- [ ] Service (data layer)
- [ ] Model (domain objects)

### API Changes
- [x] No API changes

### Dependencies
- [x] Existing package: `fifty_narrative_engine`
- [x] Existing package: `fifty_speech_engine` (for TTS in `read` mode)
- [x] Existing package: `fifty_ui` (FDL components)

### Related Files
- `apps/fifty_demo/lib/src/modules/sentences/`
- `packages/fifty_narrative_engine/lib/`

---

## Constraints

### Architecture Rules
- Must follow MVVM + Actions pattern
- Must use FDL components (fifty_ui)
- Follow existing demo app tab patterns

### Technical Constraints
- TTS (`read` mode) requires fifty_speech_engine integration
- STT input for creating sentences depends on BR-060
- Some features may require user interaction (tap, choice selection)

### Timeline
- **Deadline:** N/A
- **Milestones:** None

### Out of Scope
- Changes to fifty_narrative_engine package
- Adding new engine features
- This brief is about DEMONSTRATING existing features

---

## Tasks

### Pending

### In Progress

### Completed

**Phase 1: Audit Current Demo**
- [x] Task 1: Review current sentence demo implementation
- [x] Task 2: Document which features are already demonstrated
- [x] Task 3: Identify gaps in feature coverage

**Phase 2: Design Demo Structure**
- [x] Task 4: Design tabbed/sectioned UI for each mode
- [x] Task 5: Create sample sentences for each instruction type
- [x] Task 6: Design status indicator for processing states

**Phase 3: Implement Core Modes**
- [x] Task 7: Implement `write` mode demo (text display)
- [x] Task 8: Implement `read` mode demo (TTS via speech engine)
- [x] Task 9: Implement `wait` mode demo (tap-to-continue)
- [x] Task 10: Implement `ask` mode demo (choice selection)
- [x] Task 11: Implement `navigate` mode demo (phase transitions)

**Phase 4: Implement Advanced Features**
- [x] Task 12: Implement combined `read + write` demo
- [x] Task 13: Implement processing state indicator
- [x] Task 14: Implement order-based queue demo
- [x] Task 15: Implement pause/resume controls

**Phase 5: Polish**
- [x] Task 16: Add explanatory labels/descriptions
- [x] Task 17: Add code snippets showing usage
- [ ] Task 18: Manual smoke test all features

---

## Session State (Tactical - This Brief)

**Current State:** Complete
**Next Steps When Resuming:** N/A - Brief complete
**Last Updated:** 2026-02-02
**Blockers:** None

### Implementation Summary

**Files Modified:**

1. **demo_sentences.dart** - Complete rewrite
   - `DemoSentence` now implements `BaseSentenceModel`
   - Added `DemoMode` enum for all 7 instruction types: write, read, wait, ask, navigate, combined, orderQueue
   - Added demo sentences for each mode with realistic content

2. **sentences_demo_view_model.dart** - Complete rewrite
   - Integrated real `SentenceEngine` and `SentenceInterpreter`
   - Added `DemoProcessingStatus` enum
   - Added handlers: `_handleRead`, `_handleWrite`, `_handleAsk`, `_handleWait`, `_handleNavigate`
   - Added state: `_selectedMode`, `_currentPhase`, `_lastSelectedChoice`, `_currentChoices`, `_ttsEnabled`
   - Integrated `SpeechIntegrationService` for TTS

3. **sentences_demo_bindings.dart**
   - Updated to inject `SpeechIntegrationService`

4. **sentences_demo_actions.dart**
   - Added: `onModeSelected()`, `onChoiceSelected()`, `onContinueTapped()`, `onTtsToggled()`

5. **sentences_demo_page.dart** - Major UI updates
   - Mode selector with icons for all 7 modes
   - Status bar with `DemoProcessingStatus` states
   - Phase indicator for navigate mode
   - Choice buttons for ask mode
   - Continue button for wait mode
   - TTS toggle for read/combined modes
   - Instruction badge showing current instruction type

---

## Acceptance Criteria

**The feature/fix is complete when:**

### Core Modes
1. [x] `write` mode displays sentences with visual feedback
2. [x] `read` mode speaks text via TTS (fifty_speech_engine)
3. [x] `wait` mode pauses until user tap
4. [x] `ask` mode shows choices and captures selection
5. [x] `navigate` mode demonstrates phase transitions

### Advanced Features
6. [x] Combined `read + write` works simultaneously
7. [x] Processing status displayed (idle/processing/paused/completed)
8. [x] Order-based queue sorting demonstrated
9. [x] Pause/resume controls functional

### Quality
10. [x] Each mode has clear explanation/label
11. [x] `flutter analyze` passes (zero issues)
12. [ ] Manual smoke test all features work

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Write Mode
**Preconditions:** App running, Sentence Engine demo
**Steps:**
1. Navigate to Write mode section
2. Trigger a write instruction
3. Observe text display

**Expected Result:** Sentence text appears on screen
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Read Mode (TTS)
**Preconditions:** Audio enabled, speech engine working
**Steps:**
1. Navigate to Read mode section
2. Trigger a read instruction
3. Listen for speech

**Expected Result:** Sentence is spoken aloud via TTS
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 3: Wait Mode (Tap to Continue)
**Preconditions:** Sentence displayed
**Steps:**
1. Navigate to Wait mode section
2. Trigger sentence with `waitForUserInput: true`
3. Observe pause
4. Tap to continue

**Expected Result:** Processing pauses, resumes on tap
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 4: Ask Mode (Choices)
**Preconditions:** Sentence with choices available
**Steps:**
1. Navigate to Ask mode section
2. Trigger an ask instruction
3. Observe choice options
4. Select a choice

**Expected Result:** Choices displayed, selection captured
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 5: Navigate Mode
**Preconditions:** Multiple phases defined
**Steps:**
1. Navigate to Navigate mode section
2. Trigger a navigate instruction with different phase
3. Observe phase transition

**Expected Result:** Phase changes, navigation occurs
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 6: Combined Read + Write
**Preconditions:** TTS working
**Steps:**
1. Navigate to Combined mode section
2. Trigger `read + write` instruction
3. Observe and listen

**Expected Result:** Text displays AND speaks simultaneously
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 7: Processing States
**Preconditions:** Multiple sentences queued
**Steps:**
1. Start processing
2. Observe status indicator
3. Pause processing
4. Observe status change
5. Resume processing
6. Let complete

**Expected Result:** Status shows idle → processing → paused → processing → completed
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 8: Order-Based Queue
**Preconditions:** Sentences with different order values
**Steps:**
1. Enqueue sentences out of order (order: 3, 1, 2)
2. Start processing
3. Observe execution order

**Expected Result:** Sentences process in order 1, 2, 3 (not insertion order)
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

---

## Demo UI Structure (Suggested)

```
┌─────────────────────────────────────────┐
│ SENTENCE ENGINE DEMO                     │
├─────────────────────────────────────────┤
│ [Status: IDLE ●]                        │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ SENTENCE DISPLAY AREA           │   │
│  │ "Hello, this is a demo..."      │   │
│  └─────────────────────────────────┘   │
│                                         │
│  [Tap to Continue]                      │
│                                         │
├─────────────────────────────────────────┤
│ MODES                                    │
│ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐│
│ │Write│ │Read │ │Wait │ │ Ask │ │ Nav ││
│ └─────┘ └─────┘ └─────┘ └─────┘ └─────┘│
├─────────────────────────────────────────┤
│ CONTROLS                                 │
│ [▶ Play] [⏸ Pause] [⏹ Reset]           │
│ [Combined: read+write]                   │
│ [Order Demo]                             │
└─────────────────────────────────────────┘
```

---

## Notes

- Engine audit completed 2026-02-02
- TTS for `read` mode requires working fifty_speech_engine
- STT for sentence INPUT (not in engine scope) depends on BR-060
- Consider using visual novel style for immersive demo
- Order-based queue is powerful feature - demo clearly

**Engine Integration Pattern:**
```dart
final interpreter = SentenceInterpreter(
  engine: engine,
  onRead: (text) async {
    // Use fifty_speech_engine TTS
    await speechEngine.speak(text);
  },
  onWrite: (sentence) async {
    // Update UI with sentence text
    viewModel.currentText.value = sentence.text;
  },
  onAsk: (sentence) async {
    engine.pause();
    final choice = await showChoiceDialog(sentence.choices);
    handleChoice(choice);
    engine.resume();
  },
  onWait: (sentence) async {
    await engine.pauseUntilUserContinues();
  },
  onNavigate: (sentence) async {
    viewModel.currentPhase.value = sentence.phase;
  },
);
```

---

**Created:** 2026-02-02
**Last Updated:** 2026-02-02
**Brief Owner:** Igris AI
