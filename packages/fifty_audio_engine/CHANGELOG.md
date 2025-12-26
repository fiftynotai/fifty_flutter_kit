# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7.0] - 2025-12-27

### Added
- Initial release as part of the Fifty Design Language ecosystem
- Rebranded from arkada_sound_engine to fifty_audio_engine
- Integration with fifty_tokens motion system
- New `FadePreset.panel` preset using FiftyMotion.compiling (300ms)

### Changed
- Main class renamed from `SoundEngine` to `FiftyAudioEngine`
- Platform plugins rebranded to `FiftyAudioEnginePlugin`
- Storage keys prefixed with `fifty_audio_*` for namespace isolation
- Android package namespace changed to `dev.fifty.audio_engine`
- Updated documentation for Fifty ecosystem consistency

### Architecture
- FiftyAudioEngine singleton for global audio management
- BgmChannel for background music with playlist support
- SfxChannel for sound effects with pooling
- VoiceActingChannel for voice-over with BGM ducking
- AudioStorage for persistent state management

### Platform Support
- Android (API 21+)
- iOS (12.0+)
- macOS (10.11+)
- Linux
- Windows
- Web
