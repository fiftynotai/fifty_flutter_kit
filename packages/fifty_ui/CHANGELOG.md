# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-12-25

### Added

#### Buttons
- `FiftyButton` - Primary action button with variants (primary, secondary, ghost, danger) and sizes (small, medium, large)
- `FiftyIconButton` - Circular icon button with required tooltip for accessibility

#### Inputs
- `FiftyTextField` - Text input with focus glow, validation support, and prefix/suffix icons

#### Containers
- `FiftyCard` - Card container with optional tap interaction and selected state

#### Display
- `FiftyChip` - Tag/label component with variants (default, success, warning, error)
- `FiftyDivider` - Themed horizontal or vertical divider
- `FiftyDataSlate` - Terminal-style key-value display panel
- `FiftyBadge` - Small status indicator with optional glow pulse animation
- `FiftyAvatar` - Circular avatar with image or fallback initials
- `FiftyProgressBar` - Linear progress indicator with crimson fill
- `FiftyLoadingIndicator` - Pulsing circular loading indicator

#### Feedback
- `FiftySnackbar` - Toast notification with variants (info, success, warning, error)
- `FiftyDialog` - Modal dialog with border glow and animated entrance
- `FiftyTooltip` - Hover-triggered tooltip wrapper

#### Utils
- `GlowContainer` - Reusable container with animated glow effect

### Features
- All components follow Fifty Design Language (FDL) specification
- Crimson glow focus states on all interactive elements
- Zero elevation design (no drop shadows)
- Motion animations using FDL timing tokens
- Dark-first design optimized for OLED displays
- Full accessibility support with semantics
- Comprehensive widget tests for all components
- Example gallery app demonstrating all components
