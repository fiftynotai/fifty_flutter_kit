# Implementation Plan: BR-011 - Fifty Audio Engine Integration

**Complexity:** L (Large)
**Estimated Duration:** 4-6 hours
**Risk Level:** Low
**Agent Override:** flutter_mvvm_arch_agent (replaces coder)

---

## Summary

Clone arkada_sound_engine v0.6.1 to `packages/fifty_audio_engine`, rebrand all "arkada" references to "fifty", integrate fifty_tokens for FiftyMotion durations, and update documentation with Fifty ecosystem branding.

---

## Files to Create/Modify

### Phase 1: Package Structure

| File | Action | Description |
|------|--------|-------------|
| `packages/fifty_audio_engine/` | CREATE | New package directory |
| `packages/fifty_audio_engine/pubspec.yaml` | CREATE | New pubspec with fifty branding |
| `packages/fifty_audio_engine/README.md` | CREATE | Rebranded documentation |
| `packages/fifty_audio_engine/CHANGELOG.md` | CREATE | Fresh changelog starting at 0.7.0 |
| `packages/fifty_audio_engine/LICENSE` | CREATE | MIT license |
| `packages/fifty_audio_engine/analysis_options.yaml` | CREATE | Flutter lints configuration |

### Phase 2: Dart Library Renames

| Source File | Target File | Key Changes |
|-------------|-------------|-------------|
| `arkada_sound_engine.dart` | `fifty_audio_engine.dart` | Export renames |
| `arkada_sound_engine_platform_interface.dart` | `fifty_audio_engine_platform_interface.dart` | `ArkadaSoundEnginePlatform` -> `FiftyAudioEnginePlatform` |
| `arkada_sound_engine_method_channel.dart` | `fifty_audio_engine_method_channel.dart` | `MethodChannelArkadaSoundEngine` -> `MethodChannelFiftyAudioEngine`, channel name `arkada_sound_engine` -> `fifty_audio_engine` |
| `arkada_sound_engine_web.dart` | `fifty_audio_engine_web.dart` | `ArkadaSoundEngineWeb` -> `FiftyAudioEngineWeb` |
| `engine/sound_engine.dart` | `engine/fifty_audio_engine.dart` | `SoundEngine` -> `FiftyAudioEngine` |

### Phase 3: Engine Core Files

| File | Action | Notes |
|------|--------|-------|
| `lib/engine/global_fade_presets.dart` | COPY + MODIFY | Update to use FiftyMotion durations |
| `lib/engine/core/base_audio_channel.dart` | COPY | No arkada references |
| `lib/engine/core/fade_preset.dart` | COPY + MODIFY | Integrate FiftyMotion constants |
| `lib/engine/core/audio_logger.dart` | COPY | No changes needed |
| `lib/engine/core/channel_lifecycle_config.dart` | COPY | No changes needed |
| `lib/engine/core/pooled_playback.dart` | COPY | No changes needed |
| `lib/engine/channels/bgm_channel.dart` | COPY + MODIFY | Update import paths |
| `lib/engine/channels/sfx_channel.dart` | COPY + MODIFY | Update import paths |
| `lib/engine/channels/voice_acting_channel.dart` | COPY + MODIFY | Update import paths |
| `lib/engine/storage/audio_storage.dart` | COPY + MODIFY | Storage keys: `arkada_*` -> `fifty_audio_*` |
| `lib/engine/storage/volume_storage.dart` | COPY + MODIFY | Storage keys update |
| `lib/engine/storage/bgm_storage.dart` | COPY + MODIFY | Storage keys update |
| `lib/engine/storage/activation_storage.dart` | COPY + MODIFY | Storage keys update |

### Phase 4: Platform Plugins

#### Android

| File | Action | Changes |
|------|--------|---------|
| `android/src/main/kotlin/.../ArkadaSoundEnginePlugin.kt` | RENAME + MODIFY | Package: `dev.fifty.audio_engine`, class: `FiftyAudioEnginePlugin`, channel: `fifty_audio_engine` |
| `android/src/main/AndroidManifest.xml` | MODIFY | Package: `dev.fifty.audio_engine` |
| `android/build.gradle` | MODIFY | Namespace: `dev.fifty.audio_engine` |
| `android/settings.gradle` | MODIFY | Project name: `fifty_audio_engine` |

#### iOS

| File | Action | Changes |
|------|--------|---------|
| `ios/Classes/ArkadaSoundEnginePlugin.swift` | RENAME | -> `FiftyAudioEnginePlugin.swift`, class: `FiftyAudioEnginePlugin` |
| `ios/arkada_sound_engine.podspec` | RENAME | -> `fifty_audio_engine.podspec` |

#### macOS

| File | Action | Changes |
|------|--------|---------|
| `macos/Classes/ArkadaSoundEnginePlugin.swift` | RENAME | -> `FiftyAudioEnginePlugin.swift` |
| `macos/arkada_sound_engine.podspec` | RENAME | -> `fifty_audio_engine.podspec` |

#### Linux

| File | Action | Changes |
|------|--------|---------|
| `linux/arkada_sound_engine_plugin.cc` | RENAME | -> `fifty_audio_engine_plugin.cc` |
| `linux/include/arkada_sound_engine/` | RENAME | -> `include/fifty_audio_engine/` |
| `linux/CMakeLists.txt` | MODIFY | PROJECT_NAME, PLUGIN_NAME |

#### Windows

| File | Action | Changes |
|------|--------|---------|
| `windows/arkada_sound_engine_plugin.cpp` | RENAME | -> `fifty_audio_engine_plugin.cpp` |
| `windows/include/arkada_sound_engine/` | RENAME | -> `include/fifty_audio_engine/` |
| `windows/CMakeLists.txt` | MODIFY | PROJECT_NAME, PLUGIN_NAME |

### Phase 5: Tests

| File | Action | Changes |
|------|--------|---------|
| `test/arkada_sound_engine_test.dart` | RENAME | -> `fifty_audio_engine_test.dart` |
| `test/arkada_sound_engine_method_channel_test.dart` | RENAME | -> `fifty_audio_engine_method_channel_test.dart` |

---

## Implementation Steps

### Phase 1: Package Clone & Structure (30 min)

1. Create package directory
2. Copy source files from arkada_sound_engine
3. Create new pubspec.yaml with fifty branding
4. Create analysis_options.yaml

### Phase 2: Core Dart Rebranding (60 min)

1. Rename main library files
2. Update all class names
3. Update import paths in channel files
4. Update storage keys (arkada_* -> fifty_audio_*)

### Phase 3: Platform Plugin Updates (90 min)

1. Android: New namespace `dev.fifty.audio_engine`, class `FiftyAudioEnginePlugin`
2. iOS: Rename to `FiftyAudioEnginePlugin.swift`
3. macOS: Same as iOS
4. Linux: Update CMakeLists.txt and all identifiers
5. Windows: Update CMakeLists.txt and all identifiers

### Phase 4: Fifty Integration (30 min)

1. Update FadePreset with FiftyMotion tokens
2. Update GlobalFadePresets
3. Ensure fifty_tokens dependency works

### Phase 5: Documentation & Testing (30 min)

1. Update README.md with Fifty branding
2. Create CHANGELOG.md
3. Run flutter analyze
4. Run flutter test

---

## Key Renames

| Original | New |
|----------|-----|
| arkada_sound_engine | fifty_audio_engine |
| ArkadaSoundEnginePlugin | FiftyAudioEnginePlugin |
| ArkadaSoundEngineWeb | FiftyAudioEngineWeb |
| SoundEngine | FiftyAudioEngine |
| com.example.arkada_sound_engine | dev.fifty.audio_engine |
| arkada_* (storage keys) | fifty_audio_* |

---

## Checklist Before Commit

- [ ] All files renamed from `arkada*` to `fifty_audio*`
- [ ] All class names updated
- [ ] `SoundEngine` -> `FiftyAudioEngine`
- [ ] Package namespace: `dev.fifty.audio_engine`
- [ ] Method channel name: `fifty_audio_engine` (all 6 platforms)
- [ ] Storage keys prefixed with `fifty_audio_`
- [ ] FiftyMotion integration in FadePreset
- [ ] pubspec.yaml has fifty_tokens dependency
- [ ] All tests pass
- [ ] Analyzer shows zero warnings
- [ ] Git grep "arkada" returns 0 results

---

**Ready for implementation by flutter_mvvm_arch_agent**
