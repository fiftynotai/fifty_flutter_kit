# BR-056: Extract Speech Controls to fifty_speech_engine

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M (Medium)
**Status:** Ready

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
}
```

### SpeechControlsPanel API

```dart
class SpeechControlsPanel extends StatelessWidget {
  const SpeechControlsPanel({
    // TTS props
    required this.ttsEnabled,
    required this.onTtsEnabledChanged,
    // STT props
    required this.sttEnabled,
    required this.onSttEnabledChanged,
    required this.isListening,
    required this.onListenPressed,
    // ... other props
    this.showTts = true,
    this.showStt = true,
    super.key,
  });
}
```

---

## Acceptance Criteria

- [ ] `SpeechTtsControls` created in fifty_speech_engine
- [ ] `SpeechSttControls` created in fifty_speech_engine
- [ ] `SpeechControlsPanel` created combining both
- [ ] All widgets are callback-based (no ViewModel dependencies)
- [ ] Widgets exported from `fifty_speech_engine.dart`
- [ ] fifty_demo updated to use engine widgets
- [ ] Original widgets removed from fifty_demo
- [ ] Documentation added with usage examples

---

## Files to Create

- `packages/fifty_speech_engine/lib/src/widgets/widgets.dart` (barrel)
- `packages/fifty_speech_engine/lib/src/widgets/speech_tts_controls.dart`
- `packages/fifty_speech_engine/lib/src/widgets/speech_stt_controls.dart`
- `packages/fifty_speech_engine/lib/src/widgets/speech_controls_panel.dart`

## Files to Modify

- `packages/fifty_speech_engine/lib/fifty_speech_engine.dart` (add exports)
- `apps/fifty_demo/lib/features/dialogue_demo/views/widgets/` (remove/update)
- `apps/fifty_demo/lib/features/speech_demo/views/speech_demo_page.dart` (use new widgets)

---

## Dependencies

- fifty_ui (FiftyButton, FiftySwitch, FiftySlider, FiftyCard)
- fifty_tokens (spacing, typography)
- fifty_theme (theme-aware colors)

---

## Notes

- Widgets should work standalone without requiring GetX
- Consider adding a `SpeechControlsController` mixin for easy ViewModel integration
- Follow FDL design patterns for consistency
