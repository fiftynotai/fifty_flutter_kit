# BR-027: Fifty Demo - Use FiftyAudioEngine Package

**Type:** Bug Fix
**Priority:** P1-High
**Effort:** M-Medium (4-8h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2026-01-05
**Completed:** _(pending)_

---

## Problem

**What's broken or missing?**

The `apps/fifty_demo/` application declares `fifty_audio_engine` as a dependency but does NOT actually use it. Instead, `AudioIntegrationService` reimplements audio functionality from scratch using `audioplayers` directly.

**Evidence:**

```dart
// apps/fifty_demo/lib/shared/services/audio_integration_service.dart
import 'package:audioplayers/audioplayers.dart';  // Direct import - WRONG

class AudioIntegrationService extends ChangeNotifier {
  AudioPlayer? _bgmPlayer;   // Reimplemented - WRONG
  AudioPlayer? _sfxPlayer;   // Reimplemented - WRONG
  AudioPlayer? _voicePlayer; // Reimplemented - WRONG
}
```

**Should be:**
```dart
import 'package:fifty_audio_engine/fifty_audio_engine.dart';

class AudioIntegrationService extends ChangeNotifier {
  final FiftyAudioEngine _engine = FiftyAudioEngine.instance;
}
```

**Why does it matter?**

1. **Defeats purpose of ecosystem** - Demo should showcase actual packages
2. **Missing features** - FiftyAudioEngine has ducking, fade presets, volume persistence
3. **Code duplication** - 200+ lines reimplementing existing functionality
4. **Bad example** - Developers copying demo will use wrong pattern

---

## Goal

**What should happen after this brief is completed?**

`AudioIntegrationService` wraps `FiftyAudioEngine.instance` instead of reimplementing audio. All audio playback uses the fifty_audio_engine package APIs.

---

## Context & Inputs

### Current Implementation (Wrong)

```
AudioIntegrationService
├── _bgmPlayer: AudioPlayer (direct)
├── _sfxPlayer: AudioPlayer (direct)
├── _voicePlayer: AudioPlayer (direct)
├── playBgm() → UrlSource manually
├── playSfx() → UrlSource manually
└── playVoice() → UrlSource manually
```

### Expected Implementation (Correct)

```
AudioIntegrationService
├── FiftyAudioEngine.instance
├── playBgm() → engine.bgm.playNext() / engine.bgm.loadAndPlay()
├── playSfx() → engine.sfx.playGroup()
└── playVoice() → engine.voice.playVoice()
```

### FiftyAudioEngine API Reference

```dart
// Initialize
await FiftyAudioEngine.instance.initialize(['assets/bgm/theme.mp3']);

// BGM
FiftyAudioEngine.instance.bgm.playNext();
FiftyAudioEngine.instance.bgm.stop();
FiftyAudioEngine.instance.bgm.setVolume(0.8);
FiftyAudioEngine.instance.bgm.mute();

// SFX
FiftyAudioEngine.instance.sfx.playGroup('click');
FiftyAudioEngine.instance.sfx.registerGroup('click', ['assets/sfx/click.mp3']);

// Voice
FiftyAudioEngine.instance.voice.playVoice('https://...');
FiftyAudioEngine.instance.voice.stop();

// Global
FiftyAudioEngine.instance.muteAll();
FiftyAudioEngine.instance.fadeAllOut();
```

### Files to Modify

| File | Change |
|------|--------|
| `lib/shared/services/audio_integration_service.dart` | Rewrite to wrap FiftyAudioEngine |
| `lib/features/map_demo/service/map_audio_coordinator.dart` | Update to use new API |
| `lib/main.dart` | Initialize FiftyAudioEngine properly |

---

## Constraints

### Must Preserve
- Same public API for `AudioIntegrationService` (to avoid breaking changes)
- Same functionality: playBgm, playSfx, playVoice, stop, mute
- Volume and mute state getters

### Technical Requirements
- Use `FiftyAudioEngine.instance` singleton
- Initialize engine in `main.dart`
- Use engine's built-in volume persistence

---

## Tasks

### Pending
- [ ] Task 1: Update `audio_integration_service.dart` to wrap FiftyAudioEngine
- [ ] Task 2: Remove direct `audioplayers` import (use engine's abstraction)
- [ ] Task 3: Update `main.dart` to call `FiftyAudioEngine.instance.initialize()`
- [ ] Task 4: Update `map_audio_coordinator.dart` to use new service API
- [ ] Task 5: Test audio playback (BGM, SFX)
- [ ] Task 6: Run analyzer and ensure zero issues

### In Progress
_(None)_

### Completed
_(None)_

---

## Acceptance Criteria

1. [ ] `audio_integration_service.dart` imports `fifty_audio_engine`
2. [ ] No direct `AudioPlayer` instantiation in demo app
3. [ ] BGM plays via `engine.bgm.*` methods
4. [ ] SFX plays via `engine.sfx.*` methods
5. [ ] Voice plays via `engine.voice.*` methods
6. [ ] Volume ducking works during voice playback
7. [ ] `flutter analyze` passes

---

## Test Plan

### Manual Tests
- [ ] Start app, verify BGM channel works
- [ ] Tap entities on map, verify SFX (when enabled)
- [ ] Test mute/unmute functionality
- [ ] Test volume controls

### Automated Tests
- [ ] Unit test for AudioIntegrationService initialization

---

## Workflow State

**Phase:** BUILDING
**Active Agent:** coder
**Retry Count:** 0

### Agent Log
- 2026-01-05 - Starting HUNT with multi-agent workflow
- 2026-01-05 - PLANNER complete: Plan saved to ai/plans/BR-027-plan.md
- 2026-01-05 - Invoking coder agent...

---

**Created:** 2026-01-05
**Last Updated:** 2026-01-05
**Brief Owner:** Igris AI