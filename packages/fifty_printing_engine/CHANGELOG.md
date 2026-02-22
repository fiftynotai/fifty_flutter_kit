# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2026-02-22

### Fixed

- Synced CHANGELOG.md with published version history (pub.dev compliance)

## [1.0.1] - 2026-02-22

### Added

- Pubspec `screenshots` field for pub.dev sidebar gallery

## [1.0.0] - 2026-01-12

Initial release of fifty_printing_engine to Fifty Flutter Kit.

### Added
- **Fifty Flutter Kit Integration** - Package now part of Fifty Flutter Kit with consistent branding
- **FDL-Compliant Example App** - Complete example app demonstrating all features with Fifty Design Language
  - FDL v2 aesthetic with FiftyTheme.dark()
  - FiftyCard, FiftyButton, and FDL tokens throughout
  - Professional empty states and loading indicators
- **Comprehensive Documentation** - Full README with:
  - Complete API reference
  - Usage examples for all printing strategies
  - Platform setup guides (Android/iOS)
  - Kitchen/receipt printing workflow example

### Changed
- **Package Rebranded** - Migrated from `printing_engine` to `fifty_printing_engine`
- **Updated Imports** - Use `package:fifty_printing_engine/fifty_printing_engine.dart`
- **Repository** - Now hosted in fifty_flutter_kit monorepo

### Fixed
- **Empty State UI** - Removed duplicate "Add Printer" button in empty state

### Migration Guide

If upgrading from `printing_engine`:

1. Update pubspec.yaml:
   ```yaml
   dependencies:
     fifty_printing_engine: ^1.0.0
   ```

2. Update imports:
   ```dart
   import 'package:fifty_printing_engine/fifty_printing_engine.dart';
   ```

No API breaking changes - all class names remain the same.

---

## [0.1.0] - 2025-11-07

### Added
- Initial release of printing_engine package
- `PrintingEngine` singleton class for orchestrating multi-printer operations
- `PrintTicket` class extending `escpos.Ticket` for familiar ticket creation API
- `PrinterDevice` abstract base class for printer implementations
- `BluetoothPrinterDevice` implementation for Bluetooth thermal printers
- `WiFiPrinterDevice` implementation for network ESC/POS printers
- Three routing strategies:
  - `PrintToAllStrategy` - Print to all registered printers
  - `RoleBasedRoutingStrategy` - Route based on printer roles
  - `SelectPerPrintStrategy` - User selects printers before each print
- `PrintResult` and `PrinterResult` for comprehensive result tracking
- Status monitoring via `statusStream` with `PrinterStatusEvent`
- Health monitoring with periodic and manual checks
- Comprehensive documentation and examples
