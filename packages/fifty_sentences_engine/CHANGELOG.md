# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-12-30

### Added

- **SentenceEngine** - Core processor for in-game sentence execution
  - Queue-based sentence processing
  - Status tracking (idle, processing, paused, cancelled, completed)
  - Status change callbacks and streams
  - Pause/resume/cancel flow control
  - User input blocking with `pauseUntilUserContinues()`

- **SentenceInterpreter** - Instruction parsing and handler delegation
  - Support for `read`, `write`, `ask`, `wait`, `navigate` instructions
  - Instruction combining (e.g., `read + write`)
  - Phase-based navigation control
  - Fallback `onUnhandled` for custom instructions

- **SentenceQueue** - Optimized queue for sentence management
  - Push to front/back operations
  - Order-based sorting with lazy evaluation
  - Efficient batch operations

- **SafeSentenceWriter** - Deduplication for idempotent rendering
  - Prevents duplicate sentence display
  - Manual reset for intentional repetition

- **BaseSentenceModel** - Abstract interface for custom sentence models
  - Order, text, instruction, waitForUserInput
  - Phase and choices for interactive content

- **Multi-platform support**
  - Android (Kotlin)
  - iOS (Swift)
  - macOS (Swift)
  - Linux (C++)
  - Windows (C++)
  - Web (Dart)

### Changed

- Rebranded from `erune_sentences_engine` to `fifty_sentences_engine`
- Removed GetX dependency - now uses plain Dart callbacks
- Package namespace changed to `com.fifty.sentences_engine`
- Updated documentation for Fifty ecosystem integration

### Migration Notes

If migrating from `erune_sentences_engine`:

1. Update package import to `fifty_sentences_engine`
2. Replace `GetxController` usage with callback parameters
3. Use `onSentencesChanged` callback instead of `RxList`
4. Use `onStatusChange` callback instead of `Rx<ProcessingStatus>`

```dart
// Before (GetX)
final engine = Get.put(SentenceEngine());
Obx(() => Text(engine.sentences.length.toString()));

// After (Callbacks)
final engine = SentenceEngine(
  onSentencesChanged: (sentences) => setState(() {}),
);
Text(engine.sentences.length.toString());
```
