# Architect Planning Checklist: Speech Engine Builder Implementation

**Purpose:** Quick reference for planning the builder pattern implementation across 3 widgets

**Status:** Ready for ARCHITECT review
**Complexity:** Medium (10-15 code changes per widget)
**Estimate:** 2-3 days full implementation + testing

---

## Phase 1: Review & Decision (You Are Here)

### Questions for ARCHITECT

- [ ] Do you agree with the separate-builders approach for SpeechControlsPanel?
  - Alternative: single composite builder (less flexible)
  - Our recommendation: separate builders (more flexible)

- [ ] Should context classes be:
  - [ ] Inline in each widget file (simpler, all together)
  - [ ] Separate files per context (cleaner, more modular)
  - [ ] Single shared file with all 3 contexts (most organized)

- [ ] Should we use:
  - [ ] `typedef` for builder signatures (recommended)
  - [ ] Inline `Function` types in constructor

- [ ] Should example app be updated?
  - [ ] Yes, show builder pattern usage (recommended)
  - [ ] No, keep example as-is

### Implementation Decisions

- [ ] **SpeechTtsControls:** Add `builder` parameter
  - [ ] Parameter name: `builder` ✓ (confirmed)
  - [ ] Type: `Widget Function(BuildContext, SpeechTtsControlsContext)?`
  - [ ] Default: `null`

- [ ] **SpeechSttControls:** Add `builder` parameter
  - [ ] Parameter name: `builder` ✓ (confirmed)
  - [ ] Type: `Widget Function(BuildContext, SpeechSttControlsContext)?`
  - [ ] Default: `null`
  - [ ] Note: _PulsingDot stays private ✓ (confirmed)

- [ ] **SpeechControlsPanel:** Add separate builders
  - [ ] Parameter names: `ttsBuilder`, `sttBuilder` ✓ (confirmed)
  - [ ] Types: `Widget Function(...)?`
  - [ ] Defaults: `null`

---

## Phase 2: Context Classes Design

### SpeechTtsControlsContext Fields

**Copy-paste ready:**
```dart
/// Context passed to SpeechTtsControls builder.
class SpeechTtsControlsContext {
  const SpeechTtsControlsContext({
    required this.enabled,
    required this.isSpeaking,
    required this.rate,
    required this.pitch,
    required this.volume,
    required this.onEnabledChanged,
    required this.onRateChanged,
    required this.onPitchChanged,
    required this.onVolumeChanged,
    required this.compact,
    required this.showCard,
  });

  final bool enabled;
  final bool isSpeaking;
  final double rate;
  final double pitch;
  final double volume;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<double>? onRateChanged;
  final ValueChanged<double>? onPitchChanged;
  final ValueChanged<double>? onVolumeChanged;
  final bool compact;
  final bool showCard;
}
```

**Location decision:**
- [ ] Inline in `speech_tts_controls.dart`
- [ ] New file: `speech_tts_controls_context.dart`
- [ ] Shared: `contexts.dart` (contains all 3)

---

### SpeechSttControlsContext Fields

**Copy-paste ready:**
```dart
/// Context passed to SpeechSttControls builder.
class SpeechSttControlsContext {
  const SpeechSttControlsContext({
    required this.enabled,
    required this.isListening,
    required this.isAvailable,
    required this.recognizedText,
    required this.errorMessage,
    required this.hintText,
    required this.onEnabledChanged,
    required this.onListenPressed,
    required this.onClear,
    required this.compact,
    required this.showCard,
  });

  final bool enabled;
  final bool isListening;
  final bool isAvailable;
  final String recognizedText;
  final String? errorMessage;
  final String hintText;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onListenPressed;
  final VoidCallback? onClear;
  final bool compact;
  final bool showCard;
}
```

**Location decision:**
- [ ] Inline in `speech_stt_controls.dart`
- [ ] New file: `speech_stt_controls_context.dart`
- [ ] Shared: `contexts.dart`

---

## Phase 3: Implementation Planning

### File 1: speech_tts_controls.dart

**Changes checklist:**

1. **Constructor:**
   - [ ] Add parameter: `this.builder,`
   - [ ] Add field: `final Widget Function(BuildContext, SpeechTtsControlsContext)? builder;`
   - [ ] Update doc comment

2. **Build method:**
   - [ ] Create context object (lines after 104)
   - [ ] Add null check: `if (builder != null) return builder!(context, ctx);`
   - [ ] Keep existing default UI code

3. **Context class (SpeechTtsControlsContext):**
   - [ ] Add class definition (copy from above)
   - [ ] Add doc comments

**Lines of code:**
- [ ] ~50 lines added (context class + logic)
- [ ] 0 lines removed
- [ ] Backward compatible ✓

---

### File 2: speech_stt_controls.dart

**Changes checklist:**

1. **Constructor:**
   - [ ] Add parameter: `this.builder,`
   - [ ] Add field: `final Widget Function(BuildContext, SpeechSttControlsContext)? builder;`
   - [ ] Update doc comment

2. **Build method:**
   - [ ] Create context object (lines after 100)
   - [ ] Add null check: `if (builder != null) return builder!(context, ctx);`
   - [ ] Keep existing default UI code
   - [ ] **Keep _PulsingDot private and internal**

3. **Context class (SpeechSttControlsContext):**
   - [ ] Add class definition (copy from above)
   - [ ] Add doc comments

**Lines of code:**
- [ ] ~60 lines added (context class + logic)
- [ ] 0 lines removed
- [ ] Backward compatible ✓

**Important:**
- [ ] _PulsingDot (lines 228-279) stays UNCHANGED
- [ ] _MicrophoneSection, _SttHeader, etc. stay INTERNAL
- [ ] Builder receives `isListening` boolean, NOT the AnimationController

---

### File 3: speech_controls_panel.dart

**Changes checklist:**

1. **Constructor:**
   - [ ] Add parameter: `this.ttsBuilder,`
   - [ ] Add parameter: `this.sttBuilder,`
   - [ ] Add fields for both
   - [ ] Update doc comment

2. **Build method (lines 154-225):**
   - [ ] Update TTS section (lines 182-195):
     ```dart
     if (showTts)
       ttsBuilder != null
           ? ttsBuilder!(context)
           : SpeechTtsControls(
               enabled: ttsEnabled,
               // ... all params ...
               showCard: false,
             )
     ```
   - [ ] Update STT section (lines 208-221):
     ```dart
     if (showStt)
       sttBuilder != null
           ? sttBuilder!(context)
           : SpeechSttControls(
               enabled: sttEnabled,
               // ... all params ...
               showCard: false,
             )
     ```

**Lines of code:**
- [ ] ~20 lines modified (conditional logic)
- [ ] 0 lines removed
- [ ] Backward compatible ✓

---

## Phase 4: Barrel Export Updates

### File: src/widgets/widgets.dart

**Current (lines 1-30):**
```dart
export 'speech_tts_controls.dart';
export 'speech_stt_controls.dart';
export 'speech_controls_panel.dart';
```

**Changes:**
- [ ] No changes needed IF contexts are inline
- [ ] OR add new exports IF separate context files:
  ```dart
  export 'speech_tts_controls_context.dart';
  export 'speech_stt_controls_context.dart';
  ```

---

## Phase 5: Testing Strategy

### Unit Tests to Add

**For SpeechTtsControls:**
- [ ] Test builder is called with correct context
- [ ] Test null builder uses default UI
- [ ] Test context fields match constructor params
- [ ] Test callbacks flow through context

**For SpeechSttControls:**
- [ ] Test builder is called with correct context
- [ ] Test null builder uses default UI
- [ ] Test _PulsingDot still works (default path)
- [ ] Test context.isListening affects builder state
- [ ] Test callbacks work with custom builder

**For SpeechControlsPanel:**
- [ ] Test ttsBuilder is called (if provided)
- [ ] Test sttBuilder is called (if provided)
- [ ] Test null builders use defaults
- [ ] Test mixed usage (custom TTS + default STT)
- [ ] Test title/divider logic preserved

### Widget Tests

- [ ] Render with builder function
- [ ] Render without builder (default)
- [ ] State changes propagate to context
- [ ] Callbacks fire correctly

---

## Phase 6: Documentation

### Widget Doc Comments (Update)

**SpeechTtsControls:**
- [ ] Add builder parameter documentation
- [ ] Add example with builder function
- [ ] Link to context class

**SpeechSttControls:**
- [ ] Add builder parameter documentation
- [ ] Add example with builder function
- [ ] Note about _PulsingDot (internal)
- [ ] Link to context class

**SpeechControlsPanel:**
- [ ] Add ttsBuilder documentation
- [ ] Add sttBuilder documentation
- [ ] Add example with separate builders
- [ ] Add example with mixed builders

### Code Examples to Add

**Example 1: Custom TTS Header**
```dart
SpeechTtsControls(
  enabled: _ttsEnabled,
  // ... other params ...
  builder: (context, state) => Column(
    children: [
      // Custom header
      Row(
        children: [
          Icon(state.isSpeaking ? Icons.pause : Icons.play),
          Text('TTS'),
          Switch(value: state.enabled, onChanged: state.onEnabledChanged),
        ],
      ),
      // Sliders...
    ],
  ),
)
```

**Example 2: Custom STT with Animation**
```dart
SpeechSttControls(
  enabled: _sttEnabled,
  // ... other params ...
  builder: (context, state) => ScaleTransition(
    scale: AlwaysStoppedAnimation(state.isListening ? 1.1 : 1.0),
    child: Column(
      children: [
        // Mic button
        // Results...
      ],
    ),
  ),
)
```

**Example 3: Panel with Mixed Builders**
```dart
SpeechControlsPanel(
  // ... all params ...
  ttsBuilder: (context) => _CustomTtsPanel(),
  sttBuilder: null, // Use default
)
```

---

## Phase 7: Example App Updates (Optional)

### Current Workaround (tts_panel.dart, stt_panel.dart)

**Decision:**
- [ ] Leave as-is (no changes to example)
- [ ] Update example to use builders (demonstrate feature)
- [ ] Add new example file showing builder usage

**If updating example:**
- [ ] Simplify `TtsPanel` to use `SpeechTtsControls` with builder
- [ ] Simplify `SttPanel` to use `SpeechSttControls` with builder
- [ ] Show language selector in builder context

---

## Quality Checklist

### Code Quality
- [ ] Zero lint errors (`flutter analyze`)
- [ ] Formatted with `dart format`
- [ ] No unused imports
- [ ] All public APIs documented
- [ ] All parameters have doc comments

### Backward Compatibility
- [ ] All existing code compiles unchanged
- [ ] Builder param has default `null` ✓
- [ ] No breaking changes to API ✓
- [ ] Existing tests pass without modification ✓

### Testing
- [ ] All new code tested
- [ ] Edge cases covered
- [ ] Integration tests pass

### Documentation
- [ ] Doc comments on all public APIs
- [ ] Context classes documented
- [ ] Builder examples provided
- [ ] README updated (if needed)

---

## Rollout Plan

### Stage 1: Implementation (Days 1-2)
- [ ] Implement SpeechTtsControls
- [ ] Implement SpeechSttControls
- [ ] Implement SpeechControlsPanel
- [ ] Add context classes
- [ ] Update barrel exports

### Stage 2: Testing (Day 2-3)
- [ ] Write unit tests
- [ ] Write widget tests
- [ ] Update example app (optional)
- [ ] Manual testing
- [ ] Lint & format checks

### Stage 3: Verification (Day 3)
- [ ] All tests pass
- [ ] No lint errors
- [ ] Backward compatibility verified
- [ ] Example app works (if updated)
- [ ] Documentation complete

### Stage 4: Commit & PR
- [ ] Create commit with conventional message: `feat(speech-engine): add builder pattern to TTS/STT/Panel widgets`
- [ ] Create PR with summary
- [ ] Link to research document
- [ ] Code review

---

## Risk Mitigation

| Risk | Mitigation |
|------|-----------|
| Builder signature breaks future | Lock in context class structure, use typedef |
| Performance impact | Builder is zero-overhead function reference |
| Backward compat break | Builder param is optional, null defaults to original |
| Internal components exposed | Document which are internal (_PulsingDot, etc.) |
| Example app breaks | Test example app thoroughly |

---

## Sign-Off Checklist

**ARCHITECT** reviews and confirms:
- [ ] Research document is complete and accurate
- [ ] Context classes are well-defined
- [ ] Implementation approach is sound
- [ ] Testing strategy is adequate
- [ ] Documentation plan is clear
- [ ] Risk assessment is acceptable

**Then proceed to FORGER for implementation**

---

## Quick Reference Commands

### Before Starting Implementation
```bash
# Verify current state
flutter analyze packages/fifty_speech_engine
flutter test packages/fifty_speech_engine

# Check test coverage
flutter test packages/fifty_speech_engine --coverage
```

### During Implementation
```bash
# Run tests frequently
flutter test packages/fifty_speech_engine -v

# Check formatting
dart format packages/fifty_speech_engine/lib

# Run analyzer
flutter analyze packages/fifty_speech_engine
```

### After Implementation
```bash
# Full verification
flutter analyze packages/fifty_speech_engine
flutter test packages/fifty_speech_engine -v
flutter test packages/fifty_speech_engine/example

# Check for breaking changes
git diff HEAD~1 packages/fifty_speech_engine/lib
```

---

**End of Planning Checklist**

**Next action:** ARCHITECT to confirm decisions above, then delegate to FORGER for implementation.
