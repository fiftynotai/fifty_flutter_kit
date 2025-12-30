# Implementation Plan: BR-016

**Complexity:** L (Large)
**Estimated Duration:** 4-6 hours
**Risk Level:** Medium

## Summary

Rebrand the erune_map_engine package (v0.3.1) from ARKADA Studio to fifty_map_engine for the Fifty ecosystem. This involves renaming all classes to follow FiftyXxx pattern, updating package/import references, and adapting all 6 platform-specific native plugins.

## Source Package Analysis

### Dart Files (17 total)

| Source File | Lines | Key Classes |
|-------------|-------|-------------|
| `lib/erune_map_engine.dart` | 9 | Barrel export |
| `lib/core/controller/controller.dart` | 258 | `MapEngineController` |
| `lib/core/map_builder.dart` | 484 | `MapBuilderGame` |
| `lib/core/view/widget.dart` | 67 | `GameMapWidget` |
| `lib/core/components/base/model.dart` | 368 | `MapEntityModel`, `MapEntityEventModel`, `MapEntityType`, `BlockSize`, `MapEntityTapCallback` |
| `lib/core/components/base/component.dart` | 256 | `BaseEntityComponent`, `StaticMapEntityComponent`, `MovableMapEntityComponent` |
| `lib/core/components/base/extension.dart` | 180 | `MapEntityModelExtension`, `EventTypeExtension`, `EventAlignmentExtension` |
| `lib/core/components/base/spawner.dart` | 86 | `MapEntitySpawner` |
| `lib/core/components/base/priority.dart` | 40 | `RenderPriority` |
| `lib/core/components/room_component.dart` | 110 | `RoomComponent` |
| `lib/core/components/event_component.dart` | 128 | `EventComponent` |
| `lib/core/components/text_component.dart` | 97 | `OverlayTextComponent` |
| `lib/core/config/map_config.dart` | 16 | `MapConfig` |
| `lib/core/services/asset_loader_service.dart` | 59 | `AssetLoaderService` |
| `lib/core/services/map_loader_service.dart` | 60 | `MapLoaderService` |
| `lib/core/utils/logger.dart` | 65 | `EruneMapEngineLogger` |
| `lib/core/utils/utils.dart` | 136 | `Utils` |

### Platform-Specific Files

| Platform | Files | Key Changes |
|----------|-------|-------------|
| Android | 2 | Package: `com.arkada.erune_map_engine` -> `com.fifty.map_engine`, Class: `EruneMapEnginePlugin` -> `FiftyMapEnginePlugin` |
| iOS | 2 | Podspec: `erune_map_engine` -> `fifty_map_engine`, Class: `EruneMapEnginePlugin` -> `FiftyMapEnginePlugin` |
| macOS | 2 | Same as iOS |
| Linux | 5 | All erune_ prefixes -> fifty_, class: `EruneMapEnginePlugin` -> `FiftyMapEnginePlugin` |
| Windows | 6 | Namespace: `erune_map_engine` -> `fifty_map_engine`, class: `EruneMapEnginePlugin` -> `FiftyMapEnginePlugin` |
| Web | 1 | New file: `fifty_map_engine_web.dart` |

## Class Rename Mapping

### Core Classes

| Original | Rebranded | File |
|----------|-----------|------|
| `MapEngineController` | `FiftyMapController` | map_engine.dart |
| `MapBuilderGame` | `FiftyMapBuilder` | map_builder.dart |
| `GameMapWidget` | `FiftyMapWidget` | map_widget.dart |
| `MapEntityModel` | `FiftyMapEntity` | map_entity_model.dart |
| `MapEntityEventModel` | `FiftyMapEvent` | map_entity_model.dart |
| `MapEntityTapCallback` | `FiftyMapTapCallback` | map_entity_model.dart |
| `MapEntityType` | `FiftyEntityType` | map_entity_model.dart |
| `BlockSize` | `FiftyBlockSize` | map_entity_model.dart |
| `EventType` | `FiftyEventType` | map_entity_model.dart |
| `EventAlignment` | `FiftyEventAlignment` | map_entity_model.dart |

### Component Classes

| Original | Rebranded | File |
|----------|-----------|------|
| `BaseEntityComponent` | `FiftyBaseComponent` | base_component.dart |
| `StaticMapEntityComponent` | `FiftyStaticComponent` | base_component.dart |
| `MovableMapEntityComponent` | `FiftyMovableComponent` | base_component.dart |
| `RoomComponent` | `FiftyRoomComponent` | room_component.dart |
| `EventComponent` | `FiftyEventComponent` | event_component.dart |
| `OverlayTextComponent` | `FiftyTextComponent` | text_component.dart |
| `MapEntitySpawner` | `FiftyEntitySpawner` | spawner.dart |
| `RenderPriority` | `FiftyRenderPriority` | priority.dart |

### Service/Utility Classes

| Original | Rebranded | File |
|----------|-----------|------|
| `MapConfig` | `FiftyMapConfig` | map_config.dart |
| `AssetLoaderService` | `FiftyAssetLoader` | asset_loader_service.dart |
| `MapLoaderService` | `FiftyMapLoader` | map_loader_service.dart |
| `EruneMapEngineLogger` | `FiftyMapLogger` | logger.dart |
| `Utils` | `FiftyMapUtils` | utils.dart |

### Extensions

| Original | Rebranded | File |
|----------|-----------|------|
| `MapEntityModelExtension` | `FiftyMapEntityExtension` | extensions.dart |
| `EventTypeExtension` | `FiftyEventTypeExtension` | extensions.dart |
| `EventAlignmentExtension` | `FiftyEventAlignmentExtension` | extensions.dart |

## Implementation Phases

### Phase 1: Project Setup (30 min)
- Create package directory structure
- Create pubspec.yaml with Fifty ecosystem metadata
- Create analysis_options.yaml and LICENSE

### Phase 2: Core Dart Files (2 hours)
- Create data models with FiftyXxx naming
- Create components with renamed classes
- Create map classes (controller, builder, widget)
- Create services and utilities
- Create barrel export

### Phase 3: Platform Plugins (1.5 hours)
- Android: Kotlin plugin with com.fifty.map_engine
- iOS: Swift plugin with FiftyMapEnginePlugin
- macOS: Swift plugin
- Linux: C++ plugin
- Windows: C++ plugin
- Web: Dart web implementation

### Phase 4: Documentation (1 hour)
- Comprehensive README.md with API reference
- CHANGELOG.md for v0.1.0

### Phase 5: Testing (30 min)
- Unit tests for models and services
- flutter analyze (zero warnings)
- flutter test (all pass)

## Verification Checklist

- [ ] `flutter pub get` succeeds
- [ ] `flutter analyze` shows zero issues
- [ ] `flutter test` passes all tests
- [ ] No references to "erune" or "arkada" remain
- [ ] All files use `FiftyXxx` naming pattern
- [ ] README is comprehensive
- [ ] CHANGELOG documents v0.1.0
- [ ] All 6 platform plugins compile

---

**Plan Status:** Ready for approval
**Created:** 2025-12-30
