# FR-002: Add builder patterns to fifty_speech_engine widgets

**Type:** Feature Request
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Ready
**Created:** 2026-03-03
**Completed:**

---

## Feature Description

**What is the proposed feature?**

Add builder/customization callbacks to the 3 speech engine widgets (`SpeechControlsPanel`, `SpeechTtsControls`, `SpeechSttControls`) so consumers can provide their own control UI while keeping the TTS/STT pipeline intact.

**Why is this valuable?**

The speech engine handles platform TTS/STT, voice selection, language detection, and state management. The UI layer (panels, buttons, indicators) should be swappable so consumers can match their app's design language instead of being locked into the default FDL controls.

---

## User Value

### Who Benefits?
- [x] Developers (building with the package)

### Pain Point Solved
**Current situation:**
Speech control panels have hardcoded layouts. Consumers can pass callbacks but can't customize the visual structure of controls (button placement, indicator style, panel layout).

**With this feature:**
Consumers wire the speech engine's state and callbacks into their own UI. The package becomes a speech pipeline with optional default UI.

---

## Technical Approach

### Widgets to Update

| Widget | Builder to Add | Fallback |
|--------|---------------|----------|
| `SpeechControlsPanel` | `panelBuilder(ttsState, sttState, callbacks)` | Default combined panel |
| `SpeechTtsControls` | `controlsBuilder(state, onSpeak, onStop, voices)` | Default TTS controls |
| `SpeechSttControls` | `controlsBuilder(state, onListen, onStop, transcript)` | Default STT controls |

### Pattern

```dart
SpeechTtsControls(
  controller: ttsController,
  // Optional — if null, uses default control layout
  controlsBuilder: (state, onSpeak, onStop, voices) {
    return MyCustomTtsPanel(
      isPlaying: state.isPlaying,
      onSpeak: onSpeak,
      onStop: onStop,
    );
  },
)
```

### Constraints
- Default widgets remain unchanged (backward compatible)
- Builder is optional — null means use default
- State and callbacks exposed cleanly to builder

---

## Acceptance Criteria

1. [ ] Each widget has an optional builder callback
2. [ ] Null builder falls back to current default widget
3. [ ] Existing API unchanged (backward compatible)
4. [ ] TTS/STT state and callbacks cleanly exposed to builders
5. [ ] All existing tests pass
6. [ ] New tests for builder pattern

---

## Notes

Reference: fifty_skill_tree's `nodeBuilder` pattern is the gold standard.

---

**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Brief Owner:** Fifty.ai
