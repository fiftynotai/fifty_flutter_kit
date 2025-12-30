# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-12-30

### Added

- Initial release of fifty_map_engine
- Rebranded from erune_map_engine v0.3.1

### Core Components

- `FiftyMapController` - UI-friendly facade for map manipulation
- `FiftyMapBuilder` - FlameGame implementation with pan/zoom gestures
- `FiftyMapWidget` - Flutter widget embedding the map

### Entity System

- `FiftyMapEntity` - Data model for map entities
- `FiftyMapEvent` - Event marker model
- `FiftyBlockSize` - Tile-based size wrapper
- `FiftyEntityType` - Entity type enumeration
- `FiftyEventType` - Event type enumeration
- `FiftyEventAlignment` - Event alignment enumeration

### Component Classes

- `FiftyBaseComponent` - Abstract base for all entity components
- `FiftyStaticComponent` - Static entities (furniture, doors)
- `FiftyMovableComponent` - Movable entities (characters, monsters)
- `FiftyRoomComponent` - Room containers with children
- `FiftyEventComponent` - Event markers and overlays
- `FiftyTextComponent` - Text overlays
- `FiftyEntitySpawner` - Factory for spawning components

### Services

- `FiftyAssetLoader` - Asset registration and bulk loading
- `FiftyMapLoader` - JSON loading and serialization
- `FiftyMapLogger` - Centralized logging

### Utilities

- `FiftyMapUtils` - Position and rotation calculations
- `FiftyMapConfig` - Grid configuration constants
- `FiftyRenderPriority` - Render layer priorities

### Extensions

- `FiftyMapEntityExtension` - Entity cloning and type checks
- `FiftyEventTypeExtension` - Event type parsing
- `FiftyEventAlignmentExtension` - Alignment parsing

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
