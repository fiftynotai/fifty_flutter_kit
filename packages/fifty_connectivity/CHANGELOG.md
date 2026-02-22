# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.3] - 2026-02-22

### Changed

- Upgraded `connectivity_plus` to ^7.0.0 for pub.dev dependency score compliance

## [0.1.2] - 2026-02-22

### Fixed

- Synced CHANGELOG.md with published version history (pub.dev compliance)

## [0.1.1] - 2026-02-22

### Added

- Pubspec `screenshots` field for pub.dev sidebar gallery

## [0.1.0] - 2025-12-31

### Added

- Initial release extracted from `fifty_arch` package
- `ConnectivityConfig` - Centralized configuration for labels, navigation, and splash settings
- `ReachabilityService` - DNS lookup and HTTP health check probing
- `ConnectionViewModel` - GetX controller for reactive connection state
- `ConnectionActions` - UX orchestration singleton (decoupled from ActionPresenter)
- `ConnectionOverlay` - Overlay widget showing connection status
- `ConnectionHandler` - Switcher widget for connection-based UI
- `ConnectivityCheckerSplash` - Configurable splash screen with connectivity check
- `ConnectionBindings` - GetX bindings with customization options
- Comprehensive documentation and usage examples

### Changed

- Decoupled from `ActionPresenter` - no longer requires fifty_arch for actions
- Decoupled from `RouteManager` - uses configurable `navigateOff` callback
- Decoupled from `AssetsManager` - uses configurable `logoBuilder`
- All hardcoded labels now configurable via `ConnectivityConfig`

### Ecosystem

- Depends on: `fifty_tokens`, `fifty_ui`, `fifty_utils`
- Independent of: `fifty_arch` (fully decoupled)
