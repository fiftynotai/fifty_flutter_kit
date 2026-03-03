# Fifty Speech Engine Widget Builder Pattern Research

## Executive Summary

Three stateless widgets in the `fifty_speech_engine` package need builder pattern implementations to allow custom UI composition while preserving internal state management and callbacks. This document provides complete architectural analysis for the implementation phase.

**Status:** Ready for ARCHITECT to plan builder implementation
**Complexity:** Medium (10-15 changes per widget)
**Risk:** Low (builder is additive, doesn't break existing API)

---

## Overview: What Gets Built

| Widget | Type | Lines | Complexity | Builder Type |
|--------|------|-------|-----------|--------------|
| `SpeechTtsControls` | StatelessWidget | 183 | Medium | Layout builder with state access |
| `SpeechSttControls` | StatelessWidget (contains internal `_PulsingDot` StatefulWidget) | 514 | Medium-High | Layout builder with animation exposure |
| `SpeechControlsPanel` | StatelessWidget | 226 | Medium | Composite builder (TTS + STT) |

---

## Widget #1: SpeechTtsControls

**File:** `/Users/m.elamin/StudioProjects/fifty_eco_system/packages/fifty_speech_engine/lib/src/widgets/speech_tts_controls.dart`

### Current Constructor

```dart
const SpeechTtsControls({
  required this.enabled,
  required this.onEnabledChanged,
  this.rate = 1.0,
  this.onRateChanged,
  this.pitch = 1.0,
  this.onPitchChanged,
  this.volume = 1.0,
  this.onVolumeChanged,
  this.isSpeaking = false,
  this.compact = false,
  this.showCard = true,
  super.key,
});
```

### Current Parameters Explained

| Parameter | Type | Default | Purpose |
|-----------|------|---------|---------|
| `enabled` | bool | N/A | Whether TTS is turned on (required) |
| `onEnabledChanged` | ValueChanged<bool> | N/A | Callback when toggle changes (required) |
| `rate` | double | 1.0 | Current speech rate (0.5-2.0) |
| `onRateChanged` | ValueChanged<double>? | null | Rate slider callback (if null, slider hidden) |
| `pitch` | double | 1.0 | Current pitch (0.5-2.0) |
| `onPitchChanged` | ValueChanged<double>? | null | Pitch slider callback (if null, slider hidden) |
| `volume` | double | 1.0 | Current volume (0.0-1.0) |
| `onVolumeChanged` | ValueChanged<double>? | null | Volume slider callback (if null, slider hidden) |
| `isSpeaking` | bool | false | Whether TTS is currently speaking (animates icon) |
| `compact` | bool | false | Use compact layout (smaller spacing) |
| `showCard` | bool | true | Wrap in FiftyCard when true |

### Default Build() Output (Lines 104-181)

```
┌─ FiftyCard (if showCard=true)
│  └─ Column
│     ├─ _TtsHeader
│     │  ├─ Icon (voice_over_off or record_voice_over)
│     │  ├─ Text "TEXT-TO-SPEECH"
│     │  ├─ Pulsing dot (if isSpeaking)
│     │  └─ FiftySwitch (enabled toggle)
│     │
│     ├─ SizedBox (spacing)
│     ├─ Divider
│     ├─ SizedBox (spacing)
│     │
│     ├─ _SliderRow (if onRateChanged != null)
│     │  ├─ Icon (Icons.speed)
│     │  ├─ Label "RATE"
│     │  ├─ FiftySlider (0.5-2.0)
│     │  └─ Value "1.0x"
│     │
│     ├─ _SliderRow (if onPitchChanged != null)
│     │  ├─ Icon (Icons.tune)
│     │  ├─ Label "PITCH"
│     │  ├─ FiftySlider (0.5-2.0)
│     │  └─ Value "1.0x"
│     │
│     └─ _SliderRow (if onVolumeChanged != null)
│        ├─ Icon (Icons.volume_up)
│        ├─ Label "VOLUME"
│        ├─ FiftySlider (0.0-1.0)
│        └─ Value "100%"
```

### Builder Context (Data Passed to Builder)

```dart
/// Context object passed to builder function
class SpeechTtsControlsContext {
  final bool enabled;                         // Is TTS on?
  final bool isSpeaking;                      // Is currently speaking? (for animations)
  final double rate;                          // Current rate value (0.5-2.0)
  final double pitch;                         // Current pitch value (0.5-2.0)
  final double volume;                        // Current volume value (0.0-1.0)
  final ValueChanged<bool> onEnabledChanged;  // Toggle callback
  final ValueChanged<double>? onRateChanged;  // Rate slider callback (null = hide slider)
  final ValueChanged<double>? onPitchChanged; // Pitch slider callback (null = hide slider)
  final ValueChanged<double>? onVolumeChanged;// Volume slider callback (null = hide slider)
  final bool compact;                         // Compact layout?
  final bool showCard;                        // Wrap in FiftyCard?
}
```

### Implementation Location

**Constructor change:**
```dart
const SpeechTtsControls({
  // ... existing params ...
  this.builder,  // NEW: Optional builder for custom UI
  super.key,
});

/// Optional builder for custom TTS UI layout.
/// If provided, overrides default build() output.
/// If null, uses default layout.
final Widget Function(BuildContext, SpeechTtsControlsContext)? builder;
```

**Build method change:**
```dart
@override
Widget build(BuildContext context) {
  final ctx = SpeechTtsControlsContext(
    enabled: enabled,
    isSpeaking: isSpeaking,
    rate: rate,
    pitch: pitch,
    volume: volume,
    onEnabledChanged: onEnabledChanged,
    onRateChanged: onRateChanged,
    onPitchChanged: onPitchChanged,
    onVolumeChanged: onVolumeChanged,
    compact: compact,
    showCard: showCard,
  );

  if (builder != null) {
    return builder!(context, ctx);
  }

  // ... existing default layout code ...
}
```

### Helper Components (Internal)

These are NOT exposed to builder, kept internal:

- **`_TtsHeader`** (lines 185-246) — Renders icon + label + pulsing dot + toggle switch
- **`_SliderRow`** (lines 249-306) — Renders icon + label + slider + value display

**Builder implementation note:** The builder replaces the entire Column layout but does NOT need to reimplement _TtsHeader or _SliderRow. It can call these helpers directly from within the builder function if needed, OR build custom alternatives.

---

## Widget #2: SpeechSttControls

**File:** `/Users/m.elamin/StudioProjects/fifty_eco_system/packages/fifty_speech_engine/lib/src/widgets/speech_stt_controls.dart`

### Current Constructor

```dart
const SpeechSttControls({
  required this.enabled,
  required this.onEnabledChanged,
  required this.isListening,
  required this.onListenPressed,
  this.recognizedText = '',
  this.isAvailable = true,
  this.errorMessage,
  this.onClear,
  this.compact = false,
  this.showCard = true,
  this.hintText,
  super.key,
});
```

### Current Parameters Explained

| Parameter | Type | Default | Purpose |
|-----------|------|---------|---------|
| `enabled` | bool | N/A | Whether STT is turned on (required) |
| `onEnabledChanged` | ValueChanged<bool> | N/A | Callback when toggle changes (required) |
| `isListening` | bool | N/A | Whether actively listening (required) |
| `onListenPressed` | VoidCallback | N/A | Callback when mic button pressed (required) |
| `recognizedText` | String | '' | Recognized speech text |
| `isAvailable` | bool | true | Whether device supports STT |
| `errorMessage` | String? | null | Error message to display |
| `onClear` | VoidCallback? | null | Callback for clear button (if null, button hidden) |
| `compact` | bool | false | Compact layout |
| `showCard` | bool | true | Wrap in FiftyCard |
| `hintText` | String? | null | Hint text for mic button (defaults to 'TAP TO SPEAK') |

### Default Build() Output (Lines 100-164)

```
┌─ FiftyCard (if showCard=true)
│  └─ Column
│     ├─ _SttHeader
│     │  ├─ Icon (mic or mic_none)
│     │  ├─ Text "SPEECH-TO-TEXT"
│     │  ├─ _PulsingDot (if isListening) ★ STATEFUL WIDGET ★
│     │  └─ FiftySwitch (enabled toggle, disabled if !isAvailable)
│     │
│     ├─ IF (enabled)
│     │  ├─ SizedBox (spacing)
│     │  ├─ Divider
│     │  ├─ SizedBox (spacing)
│     │  │
│     │  ├─ _MicrophoneSection
│     │  │  ├─ AnimatedContainer (circular button)
│     │  │  │  ├─ Icon (mic or mic_none)
│     │  │  │  └─ Border/shadow (changes when listening)
│     │  │  │
│     │  │  └─ Status column
│     │  │     └─ Text: "LISTENING..." or hintText
│     │  │
│     │  ├─ _ErrorDisplay (if errorMessage is non-empty)
│     │  │  ├─ Icon (error_outline)
│     │  │  └─ Error text
│     │  │
│     │  └─ _RecognizedTextDisplay (if recognizedText.isNotEmpty)
│     │     ├─ "RECOGNIZED:" label
│     │     ├─ Quoted text display
│     │     └─ Clear button (if onClear != null)
│     │
│     └─ IF (!isAvailable)
│        └─ _NotAvailableMessage
│           ├─ Icon (info_outline)
│           └─ "Speech recognition not available..." text
```

### Builder Context (Data Passed to Builder)

```dart
/// Context object passed to builder function
class SpeechSttControlsContext {
  final bool enabled;                         // Is STT on?
  final bool isListening;                     // Currently listening? (for animations)
  final bool isAvailable;                     // Device supports STT?
  final String recognizedText;                // Recognized speech (empty = not shown)
  final String? errorMessage;                 // Error to display (null/empty = not shown)
  final String hintText;                      // Hint text for mic button ("TAP TO SPEAK")
  final ValueChanged<bool> onEnabledChanged;  // Toggle callback (disabled if !isAvailable)
  final VoidCallback onListenPressed;         // Mic button callback
  final VoidCallback? onClear;                // Clear button callback (null = button hidden)
  final bool compact;                         // Compact layout?
  final bool showCard;                        // Wrap in FiftyCard?

  // HELPER: Exposed animation/pulsing state
  // The _PulsingDot internal widget handles its own animation.
  // Builder can use isListening boolean to recreate custom pulsing if needed.
}
```

### Implementation Location

**Constructor change:**
```dart
const SpeechSttControls({
  // ... existing params ...
  this.builder,  // NEW: Optional builder for custom UI
  super.key,
});

/// Optional builder for custom STT UI layout.
/// If provided, overrides default build() output.
/// Builder receives full state context including isListening, recognizedText, etc.
final Widget Function(BuildContext, SpeechSttControlsContext)? builder;
```

**Build method change:**
```dart
@override
Widget build(BuildContext context) {
  final ctx = SpeechSttControlsContext(
    enabled: enabled,
    isListening: isListening,
    isAvailable: isAvailable,
    recognizedText: recognizedText,
    errorMessage: errorMessage,
    hintText: hintText ?? 'TAP TO SPEAK',
    onEnabledChanged: onEnabledChanged,
    onListenPressed: isAvailable ? onListenPressed : null,
    onClear: onClear,
    compact: compact,
    showCard: showCard,
  );

  if (builder != null) {
    return builder!(context, ctx);
  }

  // ... existing default layout code ...
}
```

### Helper Components (Internal)

These are kept internal, NOT exposed to builder:

- **`_SttHeader`** (lines 168-225) — Icon + label + pulsing dot + toggle
- **`_PulsingDot`** (lines 228-279) — **STATEFUL WIDGET** with 1000ms pulsing alpha animation using AnimationController
- **`_MicrophoneSection`** (lines 282-358) — Circular animated button + status text
- **`_RecognizedTextDisplay`** (lines 361-425) — Text box with clear button
- **`_ErrorDisplay`** (lines 428-471) — Error container
- **`_NotAvailableMessage`** (lines 474-513) — Unavailable info container

**Critical insight:** `_PulsingDot` is stateful and should NOT be exposed to the builder. Instead, the builder receives `isListening` boolean and can implement its own pulsing animation (or use a fixed indicator). The internal _PulsingDot continues to exist and is only used if builder is null (default path).

---

## Widget #3: SpeechControlsPanel

**File:** `/Users/m.elamin/StudioProjects/fifty_eco_system/packages/fifty_speech_engine/lib/src/widgets/speech_controls_panel.dart`

### Current Constructor

```dart
const SpeechControlsPanel({
  // TTS props
  required this.ttsEnabled,
  required this.onTtsEnabledChanged,
  this.rate = 1.0,
  this.onRateChanged,
  this.pitch = 1.0,
  this.onPitchChanged,
  this.volume = 1.0,
  this.onVolumeChanged,
  this.isSpeaking = false,

  // STT props
  required this.sttEnabled,
  required this.onSttEnabledChanged,
  required this.isListening,
  required this.onListenPressed,
  this.recognizedText = '',
  this.isSttAvailable = true,
  this.sttErrorMessage,
  this.onClearRecognizedText,
  this.sttHintText,

  // Panel options
  this.showTts = true,
  this.showStt = true,
  this.compact = false,
  this.title,
  super.key,
});
```

### Current Parameters Explained

**TTS Section (9 parameters):**
- All parameters match SpeechTtsControls API

**STT Section (10 parameters):**
- All parameters match SpeechSttControls API (with `stt` prefix)

**Panel Options (4 parameters):**

| Parameter | Type | Default | Purpose |
|-----------|------|---------|---------|
| `showTts` | bool | true | Show TTS controls section |
| `showStt` | bool | true | Show STT controls section |
| `compact` | bool | false | Compact layout |
| `title` | String? | null | Optional panel header |

### Default Build() Output (Lines 154-225)

```
┌─ FiftyCard
│  └─ Column
│     ├─ IF (title != null)
│     │  ├─ Title text (uppercase)
│     │  ├─ Divider
│     │  └─ SizedBox (spacing)
│     │
│     ├─ IF (showTts)
│     │  └─ SpeechTtsControls (showCard=false)
│     │
│     ├─ IF (showTts && showStt)
│     │  ├─ SizedBox (spacing)
│     │  ├─ Divider
│     │  └─ SizedBox (spacing)
│     │
│     └─ IF (showStt)
│        └─ SpeechSttControls (showCard=false)
```

### Builder Context (Data Passed to Builder)

For a composite panel widget, consider two patterns:

**Pattern A: Single composite builder**
```dart
/// Context for full panel (TTS + STT combined)
class SpeechControlsPanelContext {
  // All TTS state
  final bool ttsEnabled;
  final bool isSpeaking;
  final double rate, pitch, volume;
  final ValueChanged<bool> onTtsEnabledChanged;
  final ValueChanged<double>? onRateChanged;
  final ValueChanged<double>? onPitchChanged;
  final ValueChanged<double>? onVolumeChanged;

  // All STT state
  final bool sttEnabled;
  final bool isListening;
  final String recognizedText;
  final String? sttErrorMessage;
  final bool isSttAvailable;
  final ValueChanged<bool> onSttEnabledChanged;
  final VoidCallback onListenPressed;
  final VoidCallback? onClearRecognizedText;
  final String? sttHintText;

  // Panel options
  final bool showTts;
  final bool showStt;
  final bool compact;
  final String? title;

  // HELPER: References to child widget builders
  // Allows builder to use default SpeechTtsControls/SpeechSttControls
  // without replicating all their logic
  final Widget Function(BuildContext) defaultTtsBuilder;
  final Widget Function(BuildContext) defaultSttBuilder;
}
```

**Pattern B: Separate builders for TTS and STT**
```dart
// Add to constructor:
this.ttsBuilder,  // Optional: Widget Function(BuildContext, SpeechTtsControlsContext)?
this.sttBuilder,  // Optional: Widget Function(BuildContext, SpeechSttControlsContext)?
```

**Recommendation:** Use **Pattern B** (separate builders) because:
1. Each child widget has its own builder (more flexible)
2. Doesn't duplicate SpeechTtsControls/SpeechSttControls builder logic
3. Allows mixing default + custom (e.g., custom TTS with default STT)

### Implementation Location

**Constructor change:**
```dart
const SpeechControlsPanel({
  // ... existing params ...
  this.ttsBuilder,   // NEW: Optional custom TTS UI
  this.sttBuilder,   // NEW: Optional custom STT UI
  super.key,
});

/// Optional builder for custom TTS section.
/// If null, uses SpeechTtsControls with default UI.
final Widget Function(BuildContext, SpeechTtsControlsContext)? ttsBuilder;

/// Optional builder for custom STT section.
/// If null, uses SpeechSttControls with default UI.
final Widget Function(BuildContext, SpeechSttControlsContext)? sttBuilder;
```

**Build method change:**
```dart
@override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return FiftyCard(
    padding: EdgeInsets.all(compact ? FiftySpacing.md : FiftySpacing.lg),
    scanlineOnHover: false,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Optional title
        if (title != null) ...[
          Text(title!.toUpperCase(), /* ... */),
          SizedBox(height: compact ? FiftySpacing.sm : FiftySpacing.md),
          Container(height: 1, color: colorScheme.outline),
          SizedBox(height: compact ? FiftySpacing.sm : FiftySpacing.md),
        ],

        // TTS controls
        if (showTts)
          ttsBuilder != null
              ? ttsBuilder!(context)
              : SpeechTtsControls(
                  enabled: ttsEnabled,
                  onEnabledChanged: onTtsEnabledChanged,
                  rate: rate,
                  onRateChanged: onRateChanged,
                  pitch: pitch,
                  onPitchChanged: onPitchChanged,
                  volume: volume,
                  onVolumeChanged: onVolumeChanged,
                  isSpeaking: isSpeaking,
                  compact: compact,
                  showCard: false,
                ),

        // Divider between TTS and STT
        if (showTts && showStt) ...[
          SizedBox(height: compact ? FiftySpacing.md : FiftySpacing.lg),
          Container(height: 1, color: colorScheme.outline),
          SizedBox(height: compact ? FiftySpacing.md : FiftySpacing.lg),
        ],

        // STT controls
        if (showStt)
          sttBuilder != null
              ? sttBuilder!(context)
              : SpeechSttControls(
                  enabled: sttEnabled,
                  onEnabledChanged: onSttEnabledChanged,
                  isListening: isListening,
                  onListenPressed: onListenPressed,
                  recognizedText: recognizedText,
                  isAvailable: isSttAvailable,
                  errorMessage: sttErrorMessage,
                  onClear: onClearRecognizedText,
                  compact: compact,
                  showCard: false,
                  hintText: sttHintText,
                ),
      ],
    ),
  );
}
```

---

## Usage Examples: What Builders Enable

### Example 1: SpeechTtsControls with Custom Header

```dart
SpeechTtsControls(
  enabled: _ttsEnabled,
  onEnabledChanged: (v) => setState(() => _ttsEnabled = v),
  rate: _rate,
  onRateChanged: (v) => setState(() => _rate = v),
  pitch: _pitch,
  onPitchChanged: (v) => setState(() => _pitch = v),
  volume: _volume,
  onVolumeChanged: (v) => setState(() => _volume = v),
  isSpeaking: _isSpeaking,
  builder: (context, state) => Column(
    children: [
      // Custom header with app-specific styling
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.cyan]),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(state.isSpeaking ? Icons.pause : Icons.play_arrow),
            SizedBox(width: 12),
            Text('VOICE OUTPUT'),
            Spacer(),
            Switch(value: state.enabled, onChanged: state.onEnabledChanged),
          ],
        ),
      ),

      // Default sliders (reuse existing logic)
      if (state.onRateChanged != null) _RateSlider(state),
      if (state.onPitchChanged != null) _PitchSlider(state),
      if (state.onVolumeChanged != null) _VolumeSlider(state),
    ],
  ),
)
```

### Example 2: SpeechControlsPanel with Mixed Custom/Default

```dart
SpeechControlsPanel(
  ttsEnabled: _ttsEnabled,
  onTtsEnabledChanged: (v) => setState(() => _ttsEnabled = v),
  // ... other TTS params ...
  sttEnabled: _sttEnabled,
  onSttEnabledChanged: (v) => setState(() => _sttEnabled = v),
  // ... other STT params ...

  // Use custom TTS UI from app design system
  ttsBuilder: (context) => _CustomTtsPanel(
    enabled: _ttsEnabled,
    onEnabledChanged: (v) => setState(() => _ttsEnabled = v),
    isSpeaking: _isSpeaking,
    // Custom TTS panel with app-specific layout
  ),

  // Keep default STT UI
  sttBuilder: null,  // Uses SpeechSttControls default
)
```

### Example 3: SpeechSttControls with Animation Wrapper

```dart
SpeechSttControls(
  enabled: _sttEnabled,
  onEnabledChanged: (v) => setState(() => _sttEnabled = v),
  isListening: _isListening,
  onListenPressed: _toggleListening,
  recognizedText: _recognizedText,
  onClear: _clearText,
  builder: (context, state) => AnimatedScale(
    scale: state.isListening ? 1.05 : 1.0,
    duration: Duration(milliseconds: 200),
    child: Column(
      children: [
        // Custom listening animation
        if (state.isListening)
          ..._buildAnimatedWaveform(state),

        // Standard mic button and results
        _MicButton(state),
        if (state.recognizedText.isNotEmpty)
          _ResultsBox(state),
      ],
    ),
  ),
)
```

---

## Implementation Scope & Files to Modify

### Files to Change

| File | Changes | Complexity |
|------|---------|-----------|
| `speech_tts_controls.dart` | Add builder param + context class + build logic | Low |
| `speech_stt_controls.dart` | Add builder param + context class + build logic | Low |
| `speech_controls_panel.dart` | Add 2 builder params + composite logic | Medium |

### New Types to Add

**Option A: Inline in each widget file**
```dart
// In speech_tts_controls.dart
typedef SpeechTtsControlsBuilder = Widget Function(
  BuildContext context,
  SpeechTtsControlsContext state,
);

class SpeechTtsControlsContext {
  // ... fields ...
}
```

**Option B: Separate file (recommended)**
```dart
// New file: speech_tts_controls_context.dart
export 'speech_tts_controls_context.dart';
```

### Backward Compatibility

✅ **Fully backward compatible:**
- New `builder` parameters are optional (default null)
- When null, existing default UI is used
- All existing code continues to work unchanged
- Existing tests pass without modification

---

## Context Classes Structure

### SpeechTtsControlsContext

```dart
/// Context passed to SpeechTtsControls builder function.
///
/// Provides access to all state, callbacks, and configuration
/// needed to build a custom TTS UI.
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

  /// Whether TTS is currently enabled.
  final bool enabled;

  /// Whether TTS is actively speaking.
  final bool isSpeaking;

  /// Current speech rate (0.5 - 2.0).
  final double rate;

  /// Current pitch (0.5 - 2.0).
  final double pitch;

  /// Current volume (0.0 - 1.0).
  final double volume;

  /// Callback when TTS enabled state changes.
  final ValueChanged<bool> onEnabledChanged;

  /// Callback when rate changes (null = rate control hidden).
  final ValueChanged<double>? onRateChanged;

  /// Callback when pitch changes (null = pitch control hidden).
  final ValueChanged<double>? onPitchChanged;

  /// Callback when volume changes (null = volume control hidden).
  final ValueChanged<double>? onVolumeChanged;

  /// Whether to use compact layout.
  final bool compact;

  /// Whether to wrap in FiftyCard.
  final bool showCard;
}
```

### SpeechSttControlsContext

```dart
/// Context passed to SpeechSttControls builder function.
///
/// Provides access to all state, callbacks, and configuration
/// needed to build a custom STT UI.
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

  /// Whether STT is currently enabled.
  final bool enabled;

  /// Whether STT is actively listening.
  final bool isListening;

  /// Whether STT is available on this device.
  final bool isAvailable;

  /// Currently recognized text (empty = not yet recognized).
  final String recognizedText;

  /// Error message (if any).
  final String? errorMessage;

  /// Hint text for microphone button.
  final String hintText;

  /// Callback when STT enabled state changes.
  final ValueChanged<bool> onEnabledChanged;

  /// Callback when microphone button is pressed.
  final VoidCallback onListenPressed;

  /// Callback when clear button is pressed (null = button hidden).
  final VoidCallback? onClear;

  /// Whether to use compact layout.
  final bool compact;

  /// Whether to wrap in FiftyCard.
  final bool showCard;
}
```

---

## Testing Considerations

### Unit Tests
- Verify builders are called with correct context
- Verify null builder uses default UI
- Verify callbacks flow correctly

### Widget Tests
- Default UI renders correctly
- Custom builder UI renders instead of default
- State changes (enabled, isSpeaking, etc.) propagate to context
- Callbacks work correctly with custom builder

### Example App Integration
- Update example app's `TtsPanel` and `SttPanel` to optionally use builders
- Show before/after: without builder (current) vs with builder (new pattern)

---

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|-----------|
| Builder signature breaks in future | Low | Lock context class structure in docs |
| Performance impact | Very Low | Builder is just function reference, no overhead |
| Backward compatibility break | None | Additive change, null defaults to original behavior |
| Internal components exposed | Medium | Clearly document _SttHeader, _SliderRow are internal only |

---

## Next Steps for ARCHITECT

1. **Plan builder implementation strategy**
   - Decide: separate context files vs inline?
   - Decide: typedef for builders or inline types?

2. **Define builder signatures**
   - Review context classes above
   - Confirm which fields are essential

3. **Plan code structure**
   - Where do context classes live?
   - How to organize builder logic in build() method?

4. **Plan testing strategy**
   - What tests to add?
   - Update example app?

5. **Plan documentation**
   - Update widget docs with builder examples
   - Add usage section to README

---

## Appendix: File Locations

| File | Full Path | Lines |
|------|-----------|-------|
| SpeechTtsControls | `/packages/fifty_speech_engine/lib/src/widgets/speech_tts_controls.dart` | 307 |
| SpeechSttControls | `/packages/fifty_speech_engine/lib/src/widgets/speech_stt_controls.dart` | 514 |
| SpeechControlsPanel | `/packages/fifty_speech_engine/lib/src/widgets/speech_controls_panel.dart` | 227 |
| Barrel export | `/packages/fifty_speech_engine/lib/src/widgets/widgets.dart` | 30 |
| Package export | `/packages/fifty_speech_engine/lib/fifty_speech_engine.dart` | 114 |
| Example app (TTS) | `/packages/fifty_speech_engine/example/lib/features/speech_demo/view/widgets/tts_panel.dart` | 216 |
| Example app (STT) | `/packages/fifty_speech_engine/example/lib/features/speech_demo/view/widgets/stt_panel.dart` | 150+ |

---

## Summary

**Three widgets ready for builder implementation:**

1. **SpeechTtsControls** — Layout builder for custom TTS UI while preserving callbacks
2. **SpeechSttControls** — Layout builder for custom STT UI while preserving animation state
3. **SpeechControlsPanel** — Composite builder pattern for mixed custom/default child builders

**Implementation complexity:** Low-Medium
**Backward compatibility:** Fully preserved
**Example app improvement:** High (eliminates custom panel boilerplate)

**Ready for ARCHITECT to plan detailed implementation.**
