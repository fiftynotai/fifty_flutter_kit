# Fifty Speech Engine

A unified speech interface for Flutter games and applications. Provides both Text-to-Speech (TTS) and Speech-to-Text (STT) capabilities.

---

## Overview

Fifty Speech Engine combines TTS and STT into a single, easy-to-use interface:

| Feature | Description | Use Case |
|---------|-------------|----------|
| **TTS** | Text-to-Speech synthesis | Game narration, accessibility |
| **STT** | Speech-to-Text recognition | Voice commands, dictation |

Key features:
- Unified API for both TTS and STT
- Locale-aware configuration
- Continuous listening mode for dictation
- Result queueing to prevent overlap
- Callback-based result handling

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_speech_engine:
    git:
      url: https://github.com/fiftynotai/fifty_eco_system.git
      path: packages/fifty_speech_engine
```

**Dependencies:**
- `speech_to_text: ^7.1.0`
- `flutter_tts: ^4.2.3`

---

## Quick Start

```dart
import 'package:fifty_speech_engine/fifty_speech_engine.dart';

// 1. Create engine with locale
final engine = FiftySpeechEngine(
  locale: Locale('en', 'US'),
  onSttResult: (text) async => print('Heard: $text'),
  onSttError: (error) => print('Error: $error'),
);

// 2. Initialize
await engine.initialize();

// 3. Speak text
await engine.speak('Hello! How can I help you?');

// 4. Listen for voice input
await engine.startListening(continuous: true);

// 5. Stop listening when done
await engine.stopListening();

// 6. Clean up
engine.dispose();
```

---

## Architecture

```
FiftySpeechEngine
    |
    +-- tts: TtsManager
    |       Text-to-Speech synthesis via flutter_tts
    |
    +-- stt: SttManager
            Speech-to-Text recognition via speech_to_text
```

### Core Components

| Component | Description |
|-----------|-------------|
| `FiftySpeechEngine` | Unified interface combining TTS and STT |
| `TtsManager` | Text-to-Speech handler with voice configuration |
| `SttManager` | Speech-to-Text handler with queue support |
| `SpeechResultModel` | Result container for recognized speech |

---

## API Reference

### FiftySpeechEngine

Main unified controller.

```dart
/// Create with locale and optional callbacks
FiftySpeechEngine({
  required Locale locale,
  Future Function(String text)? onSttResult,
  void Function(String error)? onSttError,
})

/// Initialize both TTS and STT engines
Future<void> initialize()

/// Text-to-Speech
Future<void> speak(String text)
Future<void> stopSpeaking()
bool get isSpeaking

/// Speech-to-Text
Future<void> startListening({bool continuous = false})
Future<void> stopListening()
Future<void> cancelListening()
bool get isListening

/// Access individual managers
TtsManager get tts
SttManager get stt

/// Clean up resources
void dispose()
```

---

### TtsManager

Text-to-Speech handler.

```dart
/// Initialize with language and optional voice
Future<void> initialize({
  String language = 'en-US',
  String? voiceId,
})

/// Speak text aloud
Future<void> speak(String text)

/// Stop current speech
Future<void> stop()

/// Change language at runtime
Future<void> changeLanguage(String language, {String? voiceId})

/// Status
bool get isSpeaking

/// Callback when speech completes
VoidCallback? onSpeechComplete
```

**Language Examples:**
```dart
await tts.initialize(language: 'en-US');  // English (US)
await tts.initialize(language: 'fr-FR');  // French
await tts.initialize(language: 'de-DE');  // German
await tts.initialize(language: 'ja-JP');  // Japanese
```

---

### SttManager

Speech-to-Text handler with queue support.

```dart
/// Initialize the STT engine
Future<bool> initialize()

/// Start listening for speech
Future<void> startListening({
  String localeId = 'en_US',
  bool partialResults = true,
  bool listenContinuously = true,
})

/// Stop listening (returns final result)
Future<void> stopListening()

/// Cancel listening (discards results)
Future<void> cancelListening()

/// Status
bool get isListening
bool get isAvailable

/// Clear queued results
void flushQueue()

/// Callbacks
Future<void> Function(String text)? onResult
void Function(String error)? onError
```

**Listen Modes:**
- `listenContinuously: true` - Dictation mode for longer input
- `listenContinuously: false` - Confirmation mode for commands

---

### SpeechResultModel

Container for recognition results.

```dart
/// Properties
final String text      // Recognized text
final bool isFinal     // Whether result is final

/// Constructors
SpeechResultModel(text, isFinal)
SpeechResultModel.final_(text)
SpeechResultModel.partial(text)
```

---

## Advanced Usage

### Voice Commands

```dart
final engine = FiftySpeechEngine(
  locale: Locale('en', 'US'),
  onSttResult: (text) async {
    final command = text.toLowerCase();

    if (command.contains('attack')) {
      await performAttack();
    } else if (command.contains('defend')) {
      await performDefend();
    } else if (command.contains('help')) {
      await engine.speak('Available commands: attack, defend, help');
    }
  },
);

await engine.initialize();
await engine.startListening();
```

### Interactive Storytelling

```dart
// Narrate story segment
await engine.speak('You enter a dark cave. What do you do?');

// Wait for response
engine.stt.onResult = (text) async {
  if (text.contains('light') || text.contains('torch')) {
    await engine.speak('You light a torch, revealing ancient runes on the walls.');
  } else if (text.contains('back') || text.contains('leave')) {
    await engine.speak('You step back into the sunlight.');
  }
};

await engine.startListening();
```

### Accessibility Features

```dart
// Read UI elements aloud
Future<void> announceButton(String label) async {
  await engine.speak('Button: $label');
}

// Describe screen content
Future<void> describeScreen(String description) async {
  await engine.speak(description);
}
```

### Language Switching

```dart
// Switch TTS language dynamically
await engine.tts.changeLanguage('es-ES');
await engine.speak('Hola, bienvenido al juego!');

// Switch back
await engine.tts.changeLanguage('en-US');
await engine.speak('Welcome back!');
```

---

## Platform Support

| Platform | TTS | STT | Notes |
|----------|-----|-----|-------|
| Android | Yes | Yes | Requires RECORD_AUDIO permission |
| iOS | Yes | Yes | Requires microphone usage description |
| macOS | Yes | Yes | Requires audio-input entitlement |
| Linux | Yes | Limited | STT requires libspeechd |
| Web | Yes | Yes | Browser-dependent |

### Required Permissions

**Android** (`AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

**iOS** (`Info.plist`):
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Required for voice commands</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>Required for speech recognition</string>
```

**macOS** (`*.entitlements`):
```xml
<key>com.apple.security.device.audio-input</key>
<true/>
```

---

## Example App

See the [example directory](example/) for a complete demo app showcasing:

- MVVM + Actions architecture pattern
- TTS panel with text input and controls
- STT panel with continuous/single-phrase modes
- Language selection (9 languages)
- FDL styling with fifty_ui components

```bash
cd example
flutter pub get
flutter run
```

---

## Fifty Design Language Integration

This package is part of the Fifty ecosystem:

- **Consistent naming** - FiftySpeechEngine follows ecosystem patterns
- **Compatible packages** - Works with `fifty_audio_engine`, `fifty_ui`
- **Unified locale handling** - Consistent with other Fifty packages

---

## Best Practices

1. **Initialize once** - Call `initialize()` at app startup
2. **Handle errors** - Always provide `onSttError` callback
3. **Check availability** - Use `stt.isAvailable` before listening
4. **Clean up** - Call `dispose()` when done
5. **Request permissions** - Handle microphone permissions before STT

---

## Version

**Current:** 0.1.0

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of the [Fifty Design Language](https://github.com/fiftynotai/fifty_eco_system) ecosystem.
