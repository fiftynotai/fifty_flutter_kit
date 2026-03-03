# Implementation Plan: FR-002

**Complexity:** S (Small)
**Estimated Duration:** 2-3 hours
**Risk Level:** Low

## Summary

Add optional builder callbacks to the 3 speech engine widgets (`SpeechTtsControls`, `SpeechSttControls`, `SpeechControlsPanel`) so consumers can replace the default visual content while keeping card wrapping and state flow intact. Uses data classes for builder params (not positional), following the pattern from FR-001.

---

## Key Design Decisions

### Decision 1: Data class vs. positional params

**Answer: Data classes.** TTS has 9 relevant values, STT has 10. Positional params in a typedef make for an unusable API. Two immutable data classes:

- `SpeechTtsState` -- groups all TTS state + callbacks
- `SpeechSttState` -- groups all STT state + callbacks

Both are `@immutable` with `const` constructor, `==`/`hashCode`, and `toString()`.

### Decision 2: What does SpeechControlsPanel's builder replace?

**Answer: Separate `ttsBuilder` and `sttBuilder` params** (not a single `panelBuilder`). Reasons:

1. The panel is a composition of TTS + STT. Consumers may want to customize one but not the other.
2. A single `panelBuilder` receiving 22+ fields is unusable -- it would need its own data class that duplicates both TTS and STT data classes.
3. The panel already delegates to `SpeechTtsControls` and `SpeechSttControls` -- it can just forward the builders.
4. The panel's own structural elements (title, divider, card wrap) stay panel-owned.

### Decision 3: What stays widget-owned vs. what the builder replaces?

**Answer:**
- **Widget-owned (always):** `showCard` logic (FiftyCard wrapping), padding
- **Builder replaces:** The `content` Column (header + sliders for TTS; header + mic + error + text for STT)
- **Panel-owned (always):** FiftyCard wrapping, title row, divider between TTS/STT sections

This mirrors the FR-001 pattern: the outer container/card is preserved, the builder replaces the inner content.

---

## Data Classes

### SpeechTtsState

```dart
@immutable
class SpeechTtsState {
  const SpeechTtsState({
    required this.enabled,
    required this.onEnabledChanged,
    required this.rate,
    required this.pitch,
    required this.volume,
    required this.isSpeaking,
    required this.compact,
    this.onRateChanged,
    this.onPitchChanged,
    this.onVolumeChanged,
  });

  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final double rate;
  final ValueChanged<double>? onRateChanged;
  final double pitch;
  final ValueChanged<double>? onPitchChanged;
  final double volume;
  final ValueChanged<double>? onVolumeChanged;
  final bool isSpeaking;
  final bool compact;
}
```

Note: Callbacks are included in the data class so the builder has everything it needs in one object. `==`/`hashCode` compare value fields only (not callbacks), matching the FR-001 AchievementSummaryData pattern.

### SpeechSttState

```dart
@immutable
class SpeechSttState {
  const SpeechSttState({
    required this.enabled,
    required this.onEnabledChanged,
    required this.isListening,
    required this.onListenPressed,
    required this.recognizedText,
    required this.isAvailable,
    required this.compact,
    this.errorMessage,
    this.onClear,
    this.hintText,
  });

  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final bool isListening;
  final VoidCallback onListenPressed;
  final String recognizedText;
  final bool isAvailable;
  final String? errorMessage;
  final VoidCallback? onClear;
  final bool compact;
  final String? hintText;
}
```

---

## Typedefs

```dart
/// Builder for custom TTS controls content.
typedef SpeechTtsContentBuilder = Widget Function(SpeechTtsState state);

/// Builder for custom STT controls content.
typedef SpeechSttContentBuilder = Widget Function(SpeechSttState state);
```

Single-param typedefs. Clean, extensible, IDE-discoverable.

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_speech_engine/lib/src/widgets/speech_tts_state.dart` | CREATE | `SpeechTtsState` immutable data class |
| `packages/fifty_speech_engine/lib/src/widgets/speech_stt_state.dart` | CREATE | `SpeechSttState` immutable data class |
| `packages/fifty_speech_engine/lib/src/widgets/speech_tts_controls.dart` | MODIFY | Add `contentBuilder` param + typedef, build method delegates |
| `packages/fifty_speech_engine/lib/src/widgets/speech_stt_controls.dart` | MODIFY | Add `contentBuilder` param + typedef, build method delegates |
| `packages/fifty_speech_engine/lib/src/widgets/speech_controls_panel.dart` | MODIFY | Add `ttsBuilder` + `sttBuilder` params, forward to child widgets |
| `packages/fifty_speech_engine/lib/src/widgets/widgets.dart` | MODIFY | Export new data class files |
| `packages/fifty_speech_engine/test/widgets/speech_tts_controls_test.dart` | CREATE | Builder tests for TTS widget |
| `packages/fifty_speech_engine/test/widgets/speech_stt_controls_test.dart` | CREATE | Builder tests for STT widget |
| `packages/fifty_speech_engine/test/widgets/speech_controls_panel_test.dart` | CREATE | Builder tests for panel widget |

---

## Implementation Steps

### Phase 1: Data Classes (2 new files)

**File:** `packages/fifty_speech_engine/lib/src/widgets/speech_tts_state.dart`

1. Create `SpeechTtsState` class with all TTS constructor params as fields
2. `@immutable` annotation, `const` constructor
3. `==` and `hashCode` compare value fields only: `enabled`, `rate`, `pitch`, `volume`, `isSpeaking`, `compact`
4. Skip callbacks in equality (same pattern as FR-001's `AchievementSummaryData`)
5. `toString()` with key values

**File:** `packages/fifty_speech_engine/lib/src/widgets/speech_stt_state.dart`

1. Create `SpeechSttState` class with all STT constructor params as fields
2. `@immutable` annotation, `const` constructor
3. `==` and `hashCode` compare value fields only: `enabled`, `isListening`, `recognizedText`, `isAvailable`, `compact`, `errorMessage`, `hintText`
4. `toString()` with key values

### Phase 2: SpeechTtsControls Builder (modify existing)

**File:** `packages/fifty_speech_engine/lib/src/widgets/speech_tts_controls.dart`

1. Add import for `speech_tts_state.dart`
2. Add `SpeechTtsContentBuilder` typedef at file top (before class), with doc comment
3. Add `this.contentBuilder` optional param to constructor
4. Add `final SpeechTtsContentBuilder? contentBuilder;` field with doc comment
5. In `build()`: after building `content`, check `contentBuilder != null`
   - If builder provided: `final customContent = contentBuilder!(SpeechTtsState(...))` using all current fields
   - Card wrapping logic applies to `customContent` the same way (if `!showCard` return customContent, else wrap in FiftyCard)
   - The `content` variable becomes the default path (no change to existing code)

**Build method structure:**
```dart
Widget build(BuildContext context) {
  // Builder path
  if (contentBuilder != null) {
    final customContent = contentBuilder!(SpeechTtsState(
      enabled: enabled,
      onEnabledChanged: onEnabledChanged,
      rate: rate,
      onRateChanged: onRateChanged,
      pitch: pitch,
      onPitchChanged: onPitchChanged,
      volume: volume,
      onVolumeChanged: onVolumeChanged,
      isSpeaking: isSpeaking,
      compact: compact,
    ));
    if (!showCard) return customContent;
    return FiftyCard(
      padding: EdgeInsets.all(compact ? FiftySpacing.md : FiftySpacing.lg),
      scanlineOnHover: false,
      child: customContent,
    );
  }

  // Default path (existing code unchanged)
  final colorScheme = Theme.of(context).colorScheme;
  ...
}
```

### Phase 3: SpeechSttControls Builder (modify existing)

**File:** `packages/fifty_speech_engine/lib/src/widgets/speech_stt_controls.dart`

1. Add import for `speech_stt_state.dart`
2. Add `SpeechSttContentBuilder` typedef at file top (before class), with doc comment
3. Add `this.contentBuilder` optional param to constructor
4. Add `final SpeechSttContentBuilder? contentBuilder;` field with doc comment
5. In `build()`: same early-return pattern as TTS
   - If builder provided: construct `SpeechSttState(...)` from all fields, call builder
   - Card wrapping applies identically

### Phase 4: SpeechControlsPanel Forwarding (modify existing)

**File:** `packages/fifty_speech_engine/lib/src/widgets/speech_controls_panel.dart`

1. Add `this.ttsBuilder` and `this.sttBuilder` optional params to constructor
2. Add field declarations with doc comments
3. Forward `ttsBuilder` to `SpeechTtsControls(contentBuilder: ttsBuilder)` in build
4. Forward `sttBuilder` to `SpeechSttControls(contentBuilder: sttBuilder)` in build
5. No changes to panel's own structure (title, divider, FiftyCard wrap all preserved)

Types for the panel params:
```dart
final SpeechTtsContentBuilder? ttsBuilder;
final SpeechSttContentBuilder? sttBuilder;
```

### Phase 5: Barrel Export Update

**File:** `packages/fifty_speech_engine/lib/src/widgets/widgets.dart`

1. Add `export 'speech_tts_state.dart';`
2. Add `export 'speech_stt_state.dart';`

### Phase 6: Widget Tests

**File:** `packages/fifty_speech_engine/test/widgets/speech_tts_controls_test.dart`

Test groups:
1. `contentBuilder` group:
   - Renders builder widget when contentBuilder is provided
   - Renders default content when contentBuilder is null
   - Builder receives correct SpeechTtsState values
   - showCard wrapping preserved with contentBuilder
   - showCard=false works with contentBuilder

**File:** `packages/fifty_speech_engine/test/widgets/speech_stt_controls_test.dart`

Test groups:
1. `contentBuilder` group:
   - Renders builder widget when contentBuilder is provided
   - Renders default content when contentBuilder is null
   - Builder receives correct SpeechSttState values
   - showCard wrapping preserved with contentBuilder
   - showCard=false works with contentBuilder

**File:** `packages/fifty_speech_engine/test/widgets/speech_controls_panel_test.dart`

Test groups:
1. `ttsBuilder` group:
   - ttsBuilder replaces TTS section content
   - Null ttsBuilder renders default TTS controls
2. `sttBuilder` group:
   - sttBuilder replaces STT section content
   - Null sttBuilder renders default STT controls
3. `both builders` group:
   - Both builders work simultaneously
   - Panel structure (title, divider, card) preserved with builders

**Test helper pattern:**
- Use `MaterialApp(home: Scaffold(body: ...))` wrapping
- For FiftyCard/FiftySwitch/FiftySlider to render, the test needs a `ThemeData` with colorScheme. Use `Theme(data: ThemeData.dark(), ...)` or the FDL theme if available.
- Callbacks: use captured variables to verify builder receives correct values
- These are StatelessWidget tests -- no controller mocking needed, no ChangeNotifier, just pass props

**Estimated test count:** ~18-20 tests across 3 files

### Phase 7: Data Class Unit Tests

**File:** `packages/fifty_speech_engine/test/widgets/speech_tts_state_test.dart`

1. Constructor creates with all fields
2. Equality: same values are equal
3. Equality: different value fields are not equal
4. Equality: different callbacks but same values are equal
5. hashCode consistency
6. toString contains key values

**File:** `packages/fifty_speech_engine/test/widgets/speech_stt_state_test.dart`

Same pattern as TTS state tests.

**Estimated test count:** ~12 tests across 2 files

### Phase 8: Verify Existing Tests

1. Run `flutter test` in `packages/fifty_speech_engine/`
2. Verify the method_channel test still passes
3. Run `flutter analyze` -- zero issues

---

## Testing Strategy

- **Unit tests:** Data class equality, hashCode, toString (12 tests)
- **Widget tests:** Builder rendering, value forwarding, card wrapping, defaults (18-20 tests)
- **Regression:** Existing method_channel test must pass unchanged
- **Analyzer:** Zero issues on `flutter analyze`
- **Total new tests:** ~30-32

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| FiftyCard/FiftySwitch/FiftySlider need theme context in tests | Medium | Low | Wrap with `MaterialApp` + `ThemeData.dark()` -- these FDL widgets resolve from colorScheme |
| _PulsingDot (StatefulWidget with animation) may cause pumpAndSettle issues | Medium | Low | Use `pump()` with fixed duration instead of `pumpAndSettle()` for STT tests with listening=true |
| Data class callbacks not in equality could confuse consumers | Low | Low | Document clearly: "Equality compares value fields only, not callbacks" (same as FR-001) |
| Panel test complexity with nested widget tree | Low | Low | Test panel builders via marker text in builder output, verify with `find.text()` |

---

## Backward Compatibility

- All new params are optional with null defaults
- No constructor param order changes (new params added at end)
- No changes to existing build output when builders are null
- Barrel export additions only (no removals)
- Data classes are purely additive API surface

---

## File Count Summary

| Category | Count |
|----------|-------|
| New source files | 2 (data classes) |
| Modified source files | 4 (3 widgets + barrel) |
| New test files | 5 (3 widget tests + 2 data class tests) |
| Total files affected | 11 |
