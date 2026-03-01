# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-03-01

### BREAKING CHANGES

- `const` keyword removed from `FiftySpacing.*` usages (values are now getters)

### Changed

- Widgets resolve colors from `colorScheme` instead of direct `FiftyColors.*`
- Updated dependency constraints: `fifty_tokens: ^2.0.0`

## [0.1.2] - 2026-02-22

### Fixed

- Synced CHANGELOG.md with published version history (pub.dev compliance)

## [0.1.1] - 2026-02-22

### Added

- Pubspec `screenshots` field for pub.dev sidebar gallery

## [0.1.0] - 2025-12-27

### Added
- Initial release of fifty_speech_engine
- Rebranded from erune_speech_engine to Fifty Flutter Kit
- **FiftySpeechEngine** - Unified TTS and STT interface
  - Locale-aware configuration
  - Combined initialization for both engines
  - Convenience methods for common operations
- **TtsManager** - Text-to-Speech handler
  - Flutter TTS integration
  - Language and voice configuration
  - Speech completion callbacks
  - Dynamic language switching
- **SttManager** - Speech-to-Text handler
  - Speech recognition with queue support
  - Partial and final result handling
  - Continuous listening mode (dictation)
  - Error callback handling
- **SpeechResultModel** - Speech result container
  - Text and final flag properties
  - Factory constructors for convenience
- Platform support:
  - Android (with RECORD_AUDIO permission)
  - iOS (with microphone usage description)
  - macOS (with audio-input entitlement)
  - Linux (TTS full, STT limited)
  - Web (browser-dependent)
- Comprehensive README documentation
- MIT License

### Example App
- Complete demo application showcasing package capabilities
- **Architecture:** MVVM + Actions pattern (Kalvad)
  - `SpeechDemoActions` - User interaction handlers
  - `SpeechDemoViewModel` - State management
  - `SpeechService` - Engine wrapper with notifications
- **Features:**
  - TTS panel with text input and speak/stop controls
  - STT panel with continuous/single-phrase modes
  - Language selection (9 languages)
  - Real-time transcription display
  - Status indicators
- **Styling:** FDL integration (fifty_ui, fifty_theme, fifty_tokens)
- **Dependencies:**
  - get_it for dependency injection
  - provider for state management

### Changed
- Package name: erune_speech_engine -> fifty_speech_engine
- Class naming: SpeechEngine -> FiftySpeechEngine
- Android package: com.example.erune_speech_engine -> com.fifty.speech_engine
- Method channel: erune_speech_engine -> fifty_speech_engine
- Fixed typo: speach_result_model.dart -> speech_result_model.dart

### Technical Details
- Flutter SDK: >=3.3.0
- Dart SDK: ^3.6.0
- Dependencies:
  - speech_to_text: ^7.1.0
  - flutter_tts: ^4.2.3
  - plugin_platform_interface: ^2.0.2

---

Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
