# Implementation Plan: BR-027 - Fix Audio Integration

**Created:** 2026-01-05
**Complexity:** M (Medium)
**Estimated Duration:** 4-6 hours
**Risk Level:** Low

---

## Summary

Rewrite `AudioIntegrationService` to properly wrap `FiftyAudioEngine.instance` singleton instead of reimplementing audio with raw `audioplayers`.

---

## API Mapping

| Current API | Engine API |
|-------------|------------|
| `initialize()` | `FiftyAudioEngine.instance.initialize()` |
| `playBgm(url)` | `engine.bgm.play(url)` |
| `pauseBgm()` | `engine.bgm.pause()` |
| `resumeBgm()` | `engine.bgm.resume()` |
| `stopBgm()` | `engine.bgm.stop()` |
| `setBgmVolume(v)` | `engine.bgm.setVolume(v)` |
| `toggleBgmMute()` | `engine.bgm.mute()` / `unmute()` |
| `playSfx(url)` | `engine.sfx.play(url)` |
| `playVoice(url)` | `engine.voice.playVoice(url)` |
| `stopAll()` | `engine.stopAll()` |
| `muteAll()` | `engine.muteAll()` |

---

## Files to Modify

| File | Change |
|------|--------|
| `main.dart` | Add FiftyAudioEngine initialization |
| `audio_integration_service.dart` | REWRITE to wrap engine |
| `service_locator.dart` | Minor update (if needed) |
| `map_audio_coordinator.dart` | No changes (API preserved) |

---

## Implementation Steps

### Phase 1: Engine Initialization (main.dart)
- Import `package:fifty_audio_engine/fifty_audio_engine.dart`
- Call `await FiftyAudioEngine.instance.initialize()` before DI setup

### Phase 2: Rewrite AudioIntegrationService
- Remove `audioplayers` direct imports
- Add `fifty_audio_engine` import
- Replace AudioPlayer fields with engine accessor
- Configure channels for URL-based playback
- Delegate all methods to engine channels
- Preserve same public API

### Phase 3: Verify & Test
- Run `flutter analyze`
- Test BGM playback
- Test mute/unmute

---

## Key Transformation

```dart
// OLD (WRONG)
import 'package:audioplayers/audioplayers.dart';
AudioPlayer? _bgmPlayer;
await _bgmPlayer!.play(UrlSource(url));

// NEW (CORRECT)
import 'package:fifty_audio_engine/fifty_audio_engine.dart';
FiftyAudioEngine get _engine => FiftyAudioEngine.instance;
await _engine.bgm.play(url);
```

---

**Ready for implementation.**
