/// Speech engine UI widgets.
///
/// This library provides ready-to-use UI components for controlling
/// text-to-speech (TTS) and speech-to-text (STT) functionality.
///
/// **Components:**
/// - [SpeechTtsControls] - TTS toggle and settings (rate, pitch, volume)
/// - [SpeechSttControls] - STT microphone button and recognized text display
/// - [SpeechControlsPanel] - Combined TTS + STT controls in a single panel
///
/// All widgets are callback-based and work independently of any state
/// management solution (GetX, Provider, Bloc, etc.).
///
/// **Example:**
/// ```dart
/// import 'package:fifty_speech_engine/fifty_speech_engine.dart';
///
/// SpeechTtsControls(
///   enabled: _ttsEnabled,
///   onEnabledChanged: (value) => setState(() => _ttsEnabled = value),
///   rate: _rate,
///   onRateChanged: (value) => setState(() => _rate = value),
/// )
/// ```
library;

export 'speech_tts_controls.dart';
export 'speech_stt_controls.dart';
export 'speech_controls_panel.dart';
