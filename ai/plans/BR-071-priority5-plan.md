# BR-071 Priority 5: Voice Announcer - Implementation Plan

**Complexity:** M (Medium)
**Files affected:** 8 (2 create, 6 modify)
**Phases:** 7

## Architecture

```
BattleActions / AITurnExecutor  (orchestration layer)
        |
        v
BattleAudioCoordinator          (audio coordination - new voice methods)
        |
        v
VoiceAnnouncerService           (NEW - event-to-path mapping, skip logic)
        |
        v
FiftyAudioEngine.instance.voice  (engine - plays audio, handles BGM ducking)
```

## Phases

1. Create VoiceAnnouncerService (core service)
2. Extend BattleAudioCoordinator (voice wrapper methods)
3. Register in BattleBindings (DI)
4. Wire into BattleActions (player events)
5. Wire into AITurnExecutor (AI events)
6. Register voice asset directory (pubspec.yaml)
7. Tests (~25-30 new tests)

## Voice Asset Files (17 total)

```
audio/voice/battle_begins.mp3
audio/voice/commander_captured.mp3
audio/voice/knight_captured.mp3
audio/voice/shield_captured.mp3
audio/voice/archer_captured.mp3
audio/voice/mage_captured.mp3
audio/voice/scout_captured.mp3
audio/voice/rally.mp3
audio/voice/shoot.mp3
audio/voice/fireball.mp3
audio/voice/block.mp3
audio/voice/reveal.mp3
audio/voice/commander_in_danger.mp3
audio/voice/objective_secured.mp3
audio/voice/ten_seconds_remaining.mp3
audio/voice/victory_is_yours.mp3
audio/voice/you_have_been_defeated.mp3
```
