# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-11

### Changed
- **Migrated to Fifty Ecosystem** - Package rebranded from `printing_engine` to `fifty_printing_engine`
- Updated package name, imports, and documentation
- No API breaking changes - all class names remain the same

### Migration Guide
If upgrading from `printing_engine`:
1. Update pubspec.yaml: `fifty_printing_engine: ^1.0.0`
2. Update imports: `package:fifty_printing_engine/fifty_printing_engine.dart`

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
