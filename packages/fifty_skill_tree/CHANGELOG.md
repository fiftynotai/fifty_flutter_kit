# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-01-19

### Added

#### Core Models
- `SkillNode<T>` - Generic skill node model with support for:
  - Multi-level skills with variable costs per level
  - Custom data attachment via generic type parameter
  - Prerequisites and tier-based organization
  - Skill types (passive, active, ultimate, keystone)
  - Icon support (IconData or URL)
- `SkillTree<T>` - Tree container with:
  - Node storage and retrieval
  - Point management (add, remove, set)
  - Unlock logic with prerequisite validation
  - Progress export/import for save games
  - Full tree serialization to JSON
- `SkillConnection` - Connection model with:
  - Normal, required, and exclusive connection types
  - Visual styling options (solid, dashed, dotted)
- `UnlockResult<T>` - Result object for unlock operations with detailed failure reasons

#### Layouts
- `VerticalTreeLayout` - Traditional top-to-bottom skill tree
- `HorizontalTreeLayout` - Left-to-right skill tree
- `RadialTreeLayout` - Circular layout with configurable angles
- `GridLayout` - Grid-based positioning with row/column configuration
- `CustomLayout` - User-defined positioning via callback

#### Animations
- `UnlockAnimation` - Scale and glow effect on skill unlock
- `PulseAnimation` - Pulsing border for available skills
- `GlowAnimation` - Soft glow effect for highlighted nodes
- `ShakeAnimation` - Shake effect for failed unlock attempts
- `PathHighlightAnimation` - Connection path highlighting on hover

#### Theming
- `SkillTreeTheme` - Comprehensive theming with:
  - State-based node colors (locked, available, unlocked, maxed)
  - Type-based node colors (passive, active, ultimate, keystone)
  - Connection colors and widths
  - Text styles for names, levels, costs, and tooltips
- Theme presets:
  - `dark()` - Dark theme (default)
  - `light()` - Light theme
  - `rpg()` - Fantasy RPG gold/purple palette
  - `scifi()` - Futuristic cyan/blue palette
  - `minimal()` - Clean monochrome design
  - `nature()` - Earth tones and greens

#### Serialization
- Progress export/import for save game integration
- Full tree serialization for sharing/backup
- JSON-based format for easy integration

#### Widgets
- `SkillTreeView<T>` - Main interactive widget with:
  - Pan and pinch-to-zoom support
  - Mouse wheel zoom on desktop
  - Customizable node and connection rendering
  - Tap and long-press callbacks
- `SkillNodeWidget<T>` - Default node rendering with state visuals
- `SkillTooltip` - Hover/long-press tooltip display
- `SkillTreeController<T>` - State management with:
  - Unlock operations
  - View control (zoom, pan, focus)
  - Selection and hover tracking
  - ChangeNotifier integration

#### Painters
- `ConnectionPainter` - Base connection rendering
- `BezierPainter` - Curved bezier connections
- `LinePainter` - Straight line connections
- `DashedPainter` - Dashed line style
- `EnergyFlowPainter` - Animated energy flow effect

### Testing
- 170 unit and widget tests
- Model tests (SkillNode, SkillTree, SkillConnection)
- Layout algorithm tests
- Controller tests
- Widget tests with interaction verification

### Documentation
- Comprehensive README with examples
- API documentation comments
- Example application with 4 demo screens
