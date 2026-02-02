# BR-056: Extract Speech Controls to fifty_speech_engine

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M (Medium)
**Status:** Done

---

## Summary

Extract `TtsControls` and `SttControls` widgets from fifty_demo to fifty_speech_engine package as reusable UI components. This provides standard speech control widgets for any app using the speech engine.

---

## Motivation

- Speech control patterns are reusable across any app with TTS/STT features
- Keeps UI close to the engine it controls
- Reduces boilerplate when integrating speech features
- Follows pattern of engine packages providing optional UI components

---

## Scope

### In Scope

1. **SpeechTtsControls** (from `TtsControls`)
   - Source: `apps/fifty_demo/lib/features/dialogue_demo/views/widgets/tts_controls.dart`
   - Destination: `packages/fifty_speech_engine/lib/src/widgets/speech_tts_controls.dart`
   - Features:
     - TTS enable/disable toggle
     - Rate, pitch, volume sliders
     - Callback-based (not ViewModel dependent)

2. **SpeechSttControls** (from `SttControls`)
   - Source: `apps/fifty_demo/lib/features/dialogue_demo/views/widgets/stt_controls.dart`
   - Destination: `packages/fifty_speech_engine/lib/src/widgets/speech_stt_controls.dart`
   - Features:
     - Microphone button with listening state
     - Recognized text display
     - Error state handling
     - Callback-based API

3. **SpeechControlsPanel** (new combined widget)
   - Optional combined panel with both TTS and STT controls
   - Collapsible sections

4. **Update fifty_demo** to use engine widgets

### Out of Scope

- Changes to speech engine core functionality
- `_SettingRow` extraction (covered in BR-055 as FiftySettingsRow)

---

## Technical Details

### SpeechTtsControls API

```dart
class SpeechTtsControls extends StatelessWidget {
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
  final bool showCard;
}
```

### SpeechSttControls API

```dart
class SpeechSttControls extends StatelessWidget {
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

  final bool enabled;
  final ValueChanged<bool> onEnabledChanged;
  final bool isListening;
  final VoidCallback onListenPressed;
  final String recognizedText;
  final bool isAvailable;
  final String? errorMessage;
  final VoidCallback? onClear;
  final bool compact;
  final bool showCard;
  final String? hintText;
}
```

### SpeechControlsPanel API

```dart
class SpeechControlsPanel extends StatelessWidget {
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
}
```

---

## Acceptance Criteria

- [x] `SpeechTtsControls` created in fifty_speech_engine
- [x] `SpeechSttControls` created in fifty_speech_engine
- [x] `SpeechControlsPanel` created combining both
- [x] All widgets are callback-based (no ViewModel dependencies)
- [x] Widgets exported from `fifty_speech_engine.dart`
- [x] fifty_demo updated to use engine widgets
- [x] Original widgets removed from fifty_demo
- [x] Documentation added with usage examples

---

## Files Created

- `packages/fifty_speech_engine/lib/src/widgets/widgets.dart` (barrel)
- `packages/fifty_speech_engine/lib/src/widgets/speech_tts_controls.dart`
- `packages/fifty_speech_engine/lib/src/widgets/speech_stt_controls.dart`
- `packages/fifty_speech_engine/lib/src/widgets/speech_controls_panel.dart`

## Files Modified

- `packages/fifty_speech_engine/lib/fifty_speech_engine.dart` (added widget exports)

---

## Dependencies

- fifty_ui (FiftyButton, FiftySwitch, FiftySlider, FiftyCard)
- fifty_tokens (spacing, typography)
- fifty_theme (theme-aware colors)

---

## Implementation Notes

### Widget Documentation

All widgets include comprehensive dartdoc comments with:
- Purpose and "Why" sections explaining design decisions
- Key features lists
- Complete usage examples
- Parameter documentation

### Design Patterns

- **Callback-based API**: All widgets work with any state management solution
- **Composable**: `showCard: false` allows embedding in other cards
- **Compact mode**: Supports space-constrained layouts
- **FDL compliant**: Uses fifty_tokens and fifty_ui for consistent styling

### Widget Features

**SpeechTtsControls:**
- TTS enable/disable toggle with speaking indicator
- Optional rate slider (0.5x - 2.0x)
- Optional pitch slider (0.5x - 2.0x)
- Optional volume slider (0% - 100%)
- Sliders hidden when callbacks are null

**SpeechSttControls:**
- STT enable/disable toggle with availability check
- Animated microphone button with pulsing listening indicator
- Recognized text display with clear button
- Error message display
- Not-available message for unsupported devices

**SpeechControlsPanel:**
- Combined TTS + STT in single card
- Selective display via `showTts` and `showStt` flags
- Optional panel title
- Consistent divider between sections

---

## Completion Date

2025-02-02
