# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 3.0.0

* **BREAKING**: Renamed package from `fifty_map_engine` to `fifty_world_engine`
* All classes renamed: `FiftyMapController` → `FiftyWorldController`, `FiftyMapWidget` → `FiftyWorldWidget`, `FiftyMapEntity` → `FiftyWorldEntity`, `MapConfig` → `WorldConfig`, `MapBuilder` → `WorldBuilder`, `MapLoaderService` → `WorldLoaderService`
* Platform plugins renamed accordingly

## [0.1.0] - 2025-12-30

### Added

- Initial release of fifty_map_engine (now fifty_world_engine)
- Rebranded from erune_map_engine v0.3.1

### Core Components

- `FiftyMapController` - UI-friendly facade for map manipulation
- `FiftyMapBuilder` - FlameGame implementation with pan/zoom gestures
- `FiftyMapWidget` - Flutter widget embedding the map

### Entity System

- `FiftyMapEntity` - Data model for map entities with JSON serialization
- `FiftyMapEvent` - Event marker model with alignment options
- `FiftyBlockSize` - Tile-based size wrapper
- `FiftyEntityType` - Entity type enumeration (room, monster, character, door, furniture, event)
- `FiftyEventType` - Event type enumeration (basic, npc, masterOfShadow)
- `FiftyEventAlignment` - Event alignment enumeration (9 positions)

### Component Classes

- `FiftyBaseComponent` - Abstract base for all entity components
- `FiftyStaticComponent` - Static entities (furniture, doors)
- `FiftyMovableComponent` - Movable entities with animation support
  - Movement: `moveTo`, `moveUp`, `moveDown`, `moveLeft`, `moveRight`
  - Effects: `attack` (bounce), `die` (fade out)
  - Sprite swap at runtime
- `FiftyRoomComponent` - Room containers with child spawning
- `FiftyEventComponent` - Event markers and overlays
- `FiftyTextComponent` - Text overlays
- `FiftyEntitySpawner` - Factory for spawning components with custom type registration

### Services

- `FiftyAssetLoader` - Asset registration and bulk loading
- `FiftyMapLoader` - JSON loading and serialization
- `FiftyMapLogger` - Centralized logging

### Utilities

- `FiftyMapUtils` - Position and rotation calculations
- `FiftyMapConfig` - Grid configuration constants (64px block size)
- `FiftyRenderPriority` - Render layer priorities (background through uiOverlay)

### Extensions

- `FiftyMapEntityExtension` - Entity cloning, position changes, type checks
- `FiftyEventTypeExtension` - Event type parsing
- `FiftyEventAlignmentExtension` - Alignment parsing

### Camera Controls

- Smooth pan with single finger drag
- Pinch-to-zoom anchored at midpoint (0.3x - 3.0x)
- Programmatic zoom in/out/reset
- Center on all entities or specific entity

### Platform Support

- Android (com.fifty.map_engine)
- iOS (FiftyMapEnginePlugin)
- macOS (FiftyMapEnginePlugin)
- Linux (fifty_map_engine_plugin)
- Windows (FiftyMapEnginePlugin)
- Web (FiftyMapEngineWeb)

### Naming Convention

All classes renamed to FiftyXxx pattern:
- MapEngineController -> FiftyMapController
- MapBuilderGame -> FiftyMapBuilder
- GameMapWidget -> FiftyMapWidget
- MapEntityModel -> FiftyMapEntity
- MapEntityEventModel -> FiftyMapEvent
- BlockSize -> FiftyBlockSize
- EventType -> FiftyEventType
- EventAlignment -> FiftyEventAlignment
- BaseEntityComponent -> FiftyBaseComponent
- StaticMapEntityComponent -> FiftyStaticComponent
- MovableMapEntityComponent -> FiftyMovableComponent
- RoomComponent -> FiftyRoomComponent
- EventComponent -> FiftyEventComponent
- OverlayTextComponent -> FiftyTextComponent
- MapEntitySpawner -> FiftyEntitySpawner
- RenderPriority -> FiftyRenderPriority
- MapConfig -> FiftyMapConfig
- AssetLoaderService -> FiftyAssetLoader
- MapLoaderService -> FiftyMapLoader
- EruneMapEngineLogger -> FiftyMapLogger
- Utils -> FiftyMapUtils
