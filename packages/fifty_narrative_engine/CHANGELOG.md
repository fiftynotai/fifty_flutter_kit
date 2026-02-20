# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2026-02-20

### Changed

- Renamed package from `fifty_sentences_engine` to `fifty_narrative_engine`
- All class names, file names, and references updated to use "narrative" terminology

## [0.1.0] - 2025-12-30

### Added

- **NarrativeEngine** - Core processor for in-game sentence execution
  - Queue-based sentence processing with `ListQueue`
  - Status tracking (idle, processing, paused, cancelled, completed)
  - Status change callbacks and streams for reactive updates
  - Pause/resume/cancel flow control
  - User input blocking with `pauseUntilUserContinues()`
  - Processed sentence management with change notifications

- **NarrativeInterpreter** - Instruction parsing and handler delegation
  - Support for `read`, `write`, `ask`, `wait`, `navigate` instructions
  - Instruction combining (e.g., `read + write`)
  - Phase-based navigation control with state tracking
  - Fallback `onUnhandled` for custom instructions
  - Decoupled architecture for TTS, UI, and navigation concerns

- **NarrativeQueue** - Optimized queue for sentence management
  - Push to front/back operations (`pushFront`, `pushBack`)
  - Order-based sorting with lazy evaluation (`pushOrdered`)
  - Efficient batch operations (`pushBackAll`, `pushOrderedAll`)
  - In-place operations for low memory churn
  - Utility methods: `peek`, `pop`, `toList`, `contains`, `remove`

- **SafeNarrativeWriter** - Deduplication for idempotent rendering
  - Prevents duplicate sentence display based on text and instruction
  - Manual reset for intentional repetition after phase changes
  - Protective wrapper for turn-based loop scenarios

- **BaseNarrativeModel** - Abstract interface for custom sentence models
  - `order` - Optional ordering for queue sorting
  - `text` - Sentence content
  - `instruction` - Processing directive
  - `waitForUserInput` - Pause flag for user interaction
  - `phase` - Navigation phase identifier
  - `choices` - List for interactive content

- **Example Application**
  - MVVM + Actions architecture demonstration
  - FDL styling with fifty_tokens, fifty_theme, fifty_ui
  - 19-sentence interactive demo story
  - Dialogue display with sentence history
  - Queue visualization panel
  - Instruction type buttons (WRITE, READ, ASK, WAIT)
  - Flow control buttons (PROCESS, PAUSE, RESUME, CANCEL)

- **Multi-platform support**
  - Android (Kotlin)
  - iOS (Swift)
  - macOS (Swift)
  - Linux (C++)
  - Windows (C++)
  - Web (Dart)

- **Documentation**
  - Comprehensive README with API reference
  - Quick start guide with code examples
  - Usage patterns for common scenarios
  - Fifty Flutter Kit integration examples

### Changed

- Rebranded from `erune_narrative_engine` to `fifty_narrative_engine`
- Removed GetX dependency - now uses plain Dart callbacks
- Package namespace changed to `com.fifty.narrative_engine`
- Updated documentation for Fifty Flutter Kit integration

### Migration Notes

If migrating from `erune_narrative_engine`:

1. Update package import to `fifty_narrative_engine`
2. Replace `GetxController` usage with callback parameters
3. Use `onSentencesChanged` callback instead of `RxList`
4. Use `onStatusChange` callback instead of `Rx<ProcessingStatus>`

```dart
// Before (GetX)
final engine = Get.put(NarrativeEngine());
Obx(() => Text(engine.sentences.length.toString()));

// After (Callbacks)
final engine = NarrativeEngine(
  onSentencesChanged: (sentences) => setState(() {}),
);
Text(engine.sentences.length.toString());
```
