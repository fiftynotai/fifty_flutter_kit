# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-12-31

### Added

- **DateTime Extensions**
  - `isToday`, `isYesterday`, `isTomorrow` - Date comparison getters
  - `isSameDay`, `isSameMonth`, `isSameYear` - Date comparison methods
  - `startOfDay`, `endOfDay` - Day boundary getters
  - `daysBetween` - Calculate days between dates
  - `format`, `formatTime`, `formatDateTime` - Flexible date formatting
  - `timeAgo` - Human-readable relative time strings

- **Duration Extensions**
  - `format` - Format as HH:mm:ss
  - `formatCompact` - Format as compact string (e.g., "2h 5m")

- **Color Extensions**
  - `HexColor.fromHex` - Parse hex string to Color
  - `toHex` - Convert Color to hex string

- **Responsive Utils**
  - Device type detection (`isMobile`, `isTablet`, `isDesktop`, `isWideDesktop`)
  - `deviceType` - Get device type as enum
  - `valueByDevice` - Return different values per device type
  - `scaledFontSize` - Scale fonts by device
  - `padding`, `margin`, `gridColumns` - Device-appropriate values
  - `screenWidth`, `screenHeight` - Screen dimension helpers
  - `isPortrait`, `isLandscape` - Orientation helpers
  - Configurable breakpoints

- **State Containers**
  - `ApiStatus` - Lifecycle status enum (idle, loading, success, error)
  - `ApiResponse<E>` - Immutable request state container
  - `apiFetch` - Stream-based API fetch helper
  - `PaginationResponse<E>` - Pagination envelope with total rows

### Notes

- Extracted from `fifty_arch` package for standalone use
- Requires Flutter SDK >= 3.0.0 and Dart SDK >= 3.0.0
- Depends on `intl` package for date formatting
