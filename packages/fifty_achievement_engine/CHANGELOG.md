# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3] - 2026-02-22

### Fixed

- Synced CHANGELOG.md with published version history (pub.dev compliance)

## [0.1.2] - 2026-02-22

### Added

- Pubspec `screenshots` field for pub.dev sidebar gallery

## [0.1.1]

### Fixed

- **AchievementPopup**: Added `Material(type: MaterialType.transparency)` wrapper to fix yellow underline text issue when displayed via Flutter's `Overlay`. Text widgets outside a `Material` ancestor exhibit default decoration (yellow underlines in debug mode). This fix ensures proper text rendering in overlay contexts.

### Changed

- **Example pages**: Converted `basic_achievements`, `rpg_achievements`, and `fitness_achievements` example pages from `Column` with `Expanded(AchievementList)` to `SingleChildScrollView` wrapping the entire content. The `AchievementList` now uses `shrinkWrap: true` and `NeverScrollableScrollPhysics()`. This allows full-page scrolling as a single unit rather than only the achievement list being scrollable.

## [0.1.0]

Initial release of the fifty_achievement_engine package.

### Added

#### Models
- `Achievement<T>` - Generic achievement model with custom data support
- `AchievementRarity` - 5 rarity tiers (common, uncommon, rare, epic, legendary)
- `AchievementState` - 4 states (locked, available, unlocked, claimed)
- `AchievementProgress` - Detailed progress tracking data

#### Conditions
- `EventCondition` - Single event occurrence trigger
- `CountCondition` - Cumulative event count requirement
- `ThresholdCondition` - Stat threshold with comparison operators
- `CompositeCondition` - AND/OR combination of conditions
- `TimeCondition` - Time-based challenges with optional event requirement
- `SequenceCondition` - Ordered event sequences (strict or loose)
- `AchievementContext` - Context data for condition evaluation

#### Controllers
- `AchievementController<T>` - Main controller with:
  - Event and stat tracking
  - Progress calculation
  - Unlock detection with callbacks
  - Prerequisite chain support
  - Filtering and querying
  - Session management

#### Serialization
- `AchievementSerializer` - Serialize/deserialize achievements
- `AchievementPack<T>` - Achievement pack container
- `ProgressData` - Serializable progress snapshot
- JSON export/import for save games

#### Widgets (FDL-Compliant)
- `AchievementCard<T>` - Single achievement display with progress
- `AchievementList<T>` - Scrollable list with filtering
- `AchievementPopup<T>` - Animated unlock notification
- `AchievementProgressBar` - Progress bar widget
- `AchievementSummary<T>` - Points and completion overview

### Notes

- All widgets consume FDL tokens directly (no theme classes)
- Widgets support optional color override parameters
- Full JSON serialization support for conditions and progress
- Generic type support for custom achievement data
