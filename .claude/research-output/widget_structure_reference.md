# Fifty Speech Engine: Widget Structure Reference

Quick visual reference for the three widgets needing builder patterns.

---

## Widget #1: SpeechTtsControls

### Current Signature
```dart
SpeechTtsControls({
  required bool enabled,
  required ValueChanged<bool> onEnabledChanged,
  double rate = 1.0,
  ValueChanged<double>? onRateChanged,
  double pitch = 1.0,
  ValueChanged<double>? onPitchChanged,
  double volume = 1.0,
  ValueChanged<double>? onVolumeChanged,
  bool isSpeaking = false,
  bool compact = false,
  bool showCard = true,
})
```

### After Builder Implementation
```dart
SpeechTtsControls({
  // ... existing params above ...
  Widget Function(BuildContext, SpeechTtsControlsContext)? builder,  // NEW
})
```

### Visual Hierarchy
```
┌─────────────────────────────────────┐
│        FiftyCard (if showCard)      │
├─────────────────────────────────────┤
│  ┌─ _TtsHeader ─────────────────┐   │
│  │ [icon] TEXT-TO-SPEECH [dot]  │   │
│  │                        [toggle]  │
│  └───────────────────────────────┘   │
│                                      │
│  ────────────────────────────────   │
│                                      │
│  [slider icon] RATE    [slider]  1.0x
│                                      │
│  [slider icon] PITCH   [slider]  1.0x
│                                      │
│  [slider icon] VOLUME  [slider]  100%
└─────────────────────────────────────┘
```

### What Builder Replaces
- Entire Column layout (lines 109-171)
- Custom header (_TtsHeader component)
- Slider rows (_SliderRow components)
- Spacing/dividers

### What Builder CANNOT Replace
- The `builder` parameter itself
- The FiftyCard wrapper (controlled by `showCard` param)
- State management (props remain as constructor params)

### Builder Signature
```dart
typedef SpeechTtsControlsBuilder = Widget Function(
  BuildContext context,
  SpeechTtsControlsContext state,
);
```

### Context Provided
```dart
class SpeechTtsControlsContext {
  bool enabled;                           // Required
  bool isSpeaking;                        // For animated icon
  double rate, pitch, volume;             // Slider values
  ValueChanged<bool> onEnabledChanged;    // Toggle callback
  ValueChanged<double>? onRateChanged;    // Rate change (null = hide slider)
  ValueChanged<double>? onPitchChanged;   // Pitch change (null = hide slider)
  ValueChanged<double>? onVolumeChanged;  // Volume change (null = hide slider)
  bool compact;                           // For sizing
  bool showCard;                          // For styling
}
```

---

## Widget #2: SpeechSttControls

### Current Signature
```dart
SpeechSttControls({
  required bool enabled,
  required ValueChanged<bool> onEnabledChanged,
  required bool isListening,
  required VoidCallback onListenPressed,
  String recognizedText = '',
  bool isAvailable = true,
  String? errorMessage,
  VoidCallback? onClear,
  bool compact = false,
  bool showCard = true,
  String? hintText,
})
```

### After Builder Implementation
```dart
SpeechSttControls({
  // ... existing params above ...
  Widget Function(BuildContext, SpeechSttControlsContext)? builder,  // NEW
})
```

### Visual Hierarchy
```
┌──────────────────────────────────────┐
│        FiftyCard (if showCard)       │
├──────────────────────────────────────┤
│  ┌─ _SttHeader ────────────────────┐ │
│  │ [icon] SPEECH-TO-TEXT [dot]    │ │
│  │                          [toggle] │
│  └────────────────────────────────┘  │
│                                      │
│  ────────────────────────────────    │
│                                      │
│  ┌─ IF (enabled) ─────────────────┐  │
│  │ ┌─ _MicrophoneSection ──────┐   │  │
│  │ │ [🎤] LISTENING...         │   │  │
│  │ │                           │   │  │
│  │ └─ GestureDetector on tap ─┘   │  │
│  │                                 │  │
│  │ ┌─ _ErrorDisplay (if error) ──┐ │  │
│  │ │ [!] Error message...         │ │  │
│  │ └────────────────────────────┘  │  │
│  │                                  │  │
│  │ ┌─ _RecognizedTextDisplay ────┐ │  │
│  │ │ RECOGNIZED:                  │ │  │
│  │ │ "the recognized text" [clear]│ │  │
│  │ └────────────────────────────┘  │  │
│  └────────────────────────────────┘  │
│                                       │
│  ┌─ IF (!isAvailable) ─────────────┐  │
│  │ [ℹ] Speech recognition not...   │  │
│  └────────────────────────────────┘  │
└──────────────────────────────────────┘
```

### What Builder Replaces
- Entire Column layout (lines 103-155)
- Custom header (_SttHeader)
- Microphone button section (_MicrophoneSection)
- Error display (_ErrorDisplay)
- Text display (_RecognizedTextDisplay)
- Unavailable message (_NotAvailableMessage)
- Spacing/dividers/conditionals

### What Builder CANNOT Replace
- The `builder` parameter itself
- FiftyCard wrapper (controlled by `showCard`)
- State management
- **_PulsingDot animation** (internal StatefulWidget, stays private)

### Critical: _PulsingDot is Internal

The `_PulsingDot` widget (lines 228-279) is a StatefulWidget that handles the listening pulsing animation independently. It is NOT exposed to the builder.

**If builder needs pulsing animation:** Builder receives `isListening` boolean and can implement its own custom animation, or use `_PulsingDot` by importing it (not recommended — keep internal).

### Builder Signature
```dart
typedef SpeechSttControlsBuilder = Widget Function(
  BuildContext context,
  SpeechSttControlsContext state,
);
```

### Context Provided
```dart
class SpeechSttControlsContext {
  bool enabled;                           // Required
  bool isListening;                       // For animated states (NOT _PulsingDot itself)
  bool isAvailable;                       // For toggle disabled state
  String recognizedText;                  // For display (empty = not shown)
  String? errorMessage;                   // For error display (null = not shown)
  String hintText;                        // For mic button hint
  ValueChanged<bool> onEnabledChanged;    // Toggle callback
  VoidCallback onListenPressed;           // Mic button tap
  VoidCallback? onClear;                  // Clear button (null = hide)
  bool compact;                           // For sizing
  bool showCard;                          // For styling
}
```

---

## Widget #3: SpeechControlsPanel

### Current Signature
```dart
SpeechControlsPanel({
  // TTS params (9)
  required bool ttsEnabled,
  required ValueChanged<bool> onTtsEnabledChanged,
  double rate = 1.0,
  ValueChanged<double>? onRateChanged,
  double pitch = 1.0,
  ValueChanged<double>? onPitchChanged,
  double volume = 1.0,
  ValueChanged<double>? onVolumeChanged,
  bool isSpeaking = false,

  // STT params (9)
  required bool sttEnabled,
  required ValueChanged<bool> onSttEnabledChanged,
  required bool isListening,
  required VoidCallback onListenPressed,
  String recognizedText = '',
  bool isSttAvailable = true,
  String? sttErrorMessage,
  VoidCallback? onClearRecognizedText,
  String? sttHintText,

  // Panel options (4)
  bool showTts = true,
  bool showStt = true,
  bool compact = false,
  String? title,
})
```

### After Builder Implementation
```dart
SpeechControlsPanel({
  // ... existing 21 params above ...
  Widget Function(BuildContext, SpeechTtsControlsContext)? ttsBuilder,    // NEW
  Widget Function(BuildContext, SpeechSttControlsContext)? sttBuilder,    // NEW
})
```

### Visual Hierarchy
```
┌────────────────────────────────────┐
│          FiftyCard                 │
├────────────────────────────────────┤
│  IF (title)                        │
│  TITLE                             │
│  ────────────────────────────────  │
│                                    │
│  IF (showTts)                      │
│  ┌─ SpeechTtsControls ──────────┐  │
│  │ [TTS header + sliders]       │  │
│  │ (showCard: false)            │  │
│  └──────────────────────────────┘  │
│                                    │
│  IF (showTts && showStt)           │
│  ────────────────────────────────  │
│                                    │
│  IF (showStt)                      │
│  ┌─ SpeechSttControls ──────────┐  │
│  │ [STT header + mic + text]    │  │
│  │ (showCard: false)            │  │
│  └──────────────────────────────┘  │
└────────────────────────────────────┘
```

### What Builder Replaces
- Title rendering (lines 165-179)
- Dividers and spacing between sections
- Conditional rendering logic for showTts/showStt
- But **NOT** the child widgets themselves

### Builder Pattern for Panel

**Recommendation: Separate builders for each child**

Instead of single composite builder, use two independent builders:
- `ttsBuilder` — Optional builder for TTS section
- `sttBuilder` — Optional builder for STT section

**Why separate:**
1. Allows mixing default + custom (e.g., custom TTS, default STT)
2. Each builder is simple (no complex composition logic)
3. More flexible for different use cases

### Builder Signatures
```dart
typedef SpeechTtsControlsBuilder = Widget Function(
  BuildContext context,
  SpeechTtsControlsContext state,
);

typedef SpeechSttControlsBuilder = Widget Function(
  BuildContext context,
  SpeechSttControlsContext state,
);
```

### Build Logic
```dart
if (showTts)
  ttsBuilder != null
      ? ttsBuilder!(context)  // Use custom
      : SpeechTtsControls(    // Use default
          enabled: ttsEnabled,
          onEnabledChanged: onTtsEnabledChanged,
          // ... all TTS params ...
          showCard: false,  // Already in panel card
        )
```

---

## Parameter Comparison

### Required vs Optional

| Widget | Required | Optional |
|--------|----------|----------|
| **SpeechTtsControls** | `enabled`, `onEnabledChanged` | 9 others (including new `builder`) |
| **SpeechSttControls** | `enabled`, `onEnabledChanged`, `isListening`, `onListenPressed` | 7 others (including new `builder`) |
| **SpeechControlsPanel** | `ttsEnabled`, `onTtsEnabledChanged`, `sttEnabled`, `onSttEnabledChanged`, `isListening`, `onListenPressed` | 15 others (including new `ttsBuilder`, `sttBuilder`) |

---

## State Flow

### SpeechTtsControls State

```
Input Parameters
    ↓
    ├─ enabled: bool
    ├─ isSpeaking: bool
    ├─ rate, pitch, volume: double
    └─ callbacks: ValueChanged<double>?
        ↓
    Aggregated into Context
        ↓
    Passed to builder (if provided)
        ↓
    Builder returns Widget
        ↓
    OR default layout if builder=null
```

### SpeechSttControls State

```
Input Parameters
    ↓
    ├─ enabled: bool
    ├─ isListening: bool
    ├─ recognizedText: String
    ├─ errorMessage: String?
    └─ callbacks: VoidCallback?
        ↓
    Aggregated into Context
        ↓
    Passed to builder (if provided)
        ↓
    Builder returns Widget
        ↓
    OR default layout if builder=null
        ↓
    Note: _PulsingDot animation stays internal
```

### SpeechControlsPanel State

```
All 21 Input Parameters
    ↓
    IF ttsBuilder provided:
    ├─ Create TtsContext from TTS params
    └─ Call ttsBuilder!(context, ttsContext)

    IF sttBuilder provided:
    ├─ Create SttContext from STT params
    └─ Call sttBuilder!(context, sttContext)

    IF builders null:
    └─ Use default SpeechTtsControls + SpeechSttControls
        ↓
    Return final Widget
```

---

## File Locations (Quick Reference)

```
packages/fifty_speech_engine/
├── lib/
│   ├── fifty_speech_engine.dart                 (main export)
│   ├── src/
│   │   └── widgets/
│   │       ├── widgets.dart                     (barrel export)
│   │       ├── speech_tts_controls.dart         (← modify)
│   │       ├── speech_stt_controls.dart         (← modify)
│   │       └── speech_controls_panel.dart       (← modify)
│   ├── tts/
│   │   └── tts_manager.dart
│   └── stt/
│       └── stt_manager.dart
│
├── example/
│   └── lib/
│       └── features/speech_demo/
│           └── view/widgets/
│               ├── tts_panel.dart               (CURRENT workaround)
│               └── stt_panel.dart               (CURRENT workaround)
```

---

## Summary Table

| Aspect | TtsControls | SttControls | Panel |
|--------|-------------|-------------|-------|
| **Type** | StatelessWidget | StatelessWidget + internal `_PulsingDot` | StatelessWidget |
| **Constructor Params** | 11 | 11 | 21 (9 TTS + 9 STT + 3 panel) |
| **Builder Params to Add** | 1 (`builder`) | 1 (`builder`) | 2 (`ttsBuilder`, `sttBuilder`) |
| **Context Class Size** | 11 fields | 11 fields | Use child contexts |
| **Internal Stateful Widgets** | None | `_PulsingDot` (stays private) | None |
| **Lines in Default Layout** | ~62 | ~53 | ~71 |
| **Helper Components** | `_TtsHeader`, `_SliderRow` | `_SttHeader`, `_MicrophoneSection`, `_ErrorDisplay`, `_RecognizedTextDisplay`, `_NotAvailableMessage` | None (delegates to children) |

---

## Key Takeaways for Implementation

✅ **Straightforward for TtsControls**
- Simple layout builder
- No complex animations
- No internal stateful widgets

✅ **Slightly complex for SttControls**
- Has internal `_PulsingDot` StatefulWidget
- Builder receives `isListening` boolean, not the animation controller
- Keeps animation internal, doesn't expose it

✅ **Composite for Panel**
- Two separate builders (not one composite)
- Each builder is simple (just replaces child widget)
- Allows flexible mixing of default + custom

✅ **Backward Compatible Across All Three**
- Builder parameter is optional
- All existing code works unchanged
- No breaking changes

---

**This reference is designed to be printed or used side-by-side with the detailed research document.**
