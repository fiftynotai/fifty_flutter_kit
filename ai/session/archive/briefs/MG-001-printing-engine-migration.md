# MG-001: Migrate and Rebrand printing_engine to Fifty Ecosystem

**Type:** Migration
**Priority:** P2-Medium
**Effort:** M-Medium (4-6 hours)
**Status:** Done
**Created:** 2026-01-11
**Assignee:** -

---

## Problem

The `printing_engine` package exists in a separate project (`opaala_admin_app_v3/packages/`) and needs to be migrated into the Fifty Ecosystem with proper rebranding to maintain consistency with other Fifty packages.

---

## Goal

Migrate and rebrand `printing_engine` to `fifty_printing_engine` as part of the Fifty Ecosystem packages, following all ecosystem conventions for naming, structure, and documentation.

---

## Context & Inputs

### Source Package
- **Location:** `/Users/m.elamin/StudioProjects/opaala_admin_app_v3/packages/printing_engine`
- **Name:** `printing_engine`
- **Version:** 1.0.0
- **Description:** Production-grade Flutter package for multi-printer ESC/POS printing

### Package Features
- Multi-printer management (Bluetooth & WiFi)
- Flexible routing strategies (print to all, role-based, select per print)
- Real-time status monitoring via streams
- Health checks (periodic and manual)
- Per-printer result tracking
- Configuration persistence (export/import)

### Package Structure (40 files)
```
printing_engine/
├── lib/
│   ├── printing_engine.dart              # Main export
│   └── src/
│       ├── core/
│       │   ├── printing_engine.dart      # Main orchestrator
│       │   ├── print_ticket.dart         # Ticket wrapper
│       │   ├── printer_device.dart       # Abstract device
│       │   └── printing_strategy.dart    # Strategy interface
│       ├── devices/
│       │   ├── bluetooth_printer_device.dart
│       │   └── wifi_printer_device.dart
│       ├── models/
│       │   ├── print_result.dart
│       │   ├── printer_result.dart
│       │   ├── printer_status.dart
│       │   ├── printer_status_event.dart
│       │   ├── printer_type.dart
│       │   ├── printer_role.dart
│       │   ├── printing_mode.dart
│       │   ├── discovered_printer.dart
│       │   ├── paper_size.dart
│       │   └── exceptions.dart
│       ├── strategies/
│       │   ├── print_to_all_strategy.dart
│       │   ├── role_based_routing_strategy.dart
│       │   └── select_per_print_strategy.dart
│       └── utils/
│           ├── printer_configuration_serializer.dart
│           └── printer_discovery_utils.dart
├── example/                              # Demo app
├── test/                                 # Unit tests
├── README.md
├── CHANGELOG.md
└── pubspec.yaml
```

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  escpos: any
  print_bluetooth_thermal: ^1.1.6
  permission_handler: ^12.0.1
```

### Target Location
`/Users/m.elamin/StudioProjects/fifty_flutter_kit/packages/fifty_printing_engine`

### Existing Fifty Packages (naming reference)
- fifty_audio_engine
- fifty_speech_engine
- fifty_narrative_engine
- fifty_map_engine
- fifty_tokens
- fifty_theme
- fifty_ui
- fifty_cache
- fifty_storage
- fifty_utils
- fifty_connectivity

---

## Constraints

1. **Preserve all functionality** - No behavior changes, pure migration/rebrand
2. **Follow Fifty conventions** - Package naming, pubspec structure, documentation style
3. **Maintain tests** - All existing tests must pass after migration
4. **Update example app** - Rebrand example to use new package name
5. **No breaking API changes** - External API should remain the same (class names unchanged)

---

## Acceptance Criteria

- [ ] Package copied to `packages/fifty_printing_engine/`
- [ ] `pubspec.yaml` updated with Fifty branding:
  - name: `fifty_printing_engine`
  - homepage: `https://github.com/fiftynotai/fifty_flutter_kit`
  - repository: `https://github.com/fiftynotai/fifty_flutter_kit/tree/main/packages/fifty_printing_engine`
- [ ] Main library file renamed to `fifty_printing_engine.dart`
- [ ] All internal imports updated (`package:printing_engine/` → `package:fifty_printing_engine/`)
- [ ] README.md updated with Fifty branding and ecosystem context
- [ ] CHANGELOG.md updated with migration note
- [ ] Example app updated with new imports
- [ ] All tests pass (`flutter test`)
- [ ] Static analysis passes (`flutter analyze`)
- [ ] Package can be imported and used

---

## Test Plan

### Automated
1. Run `flutter analyze` in package directory - zero issues
2. Run `flutter test` in package directory - all tests pass
3. Run `flutter analyze` in example directory - zero issues

### Manual
1. Add package as dependency in fifty_demo
2. Import and verify intellisense works
3. Verify example app builds and runs

---

## Implementation Approach

### Phase 1: Copy Package
1. Copy entire `printing_engine/` directory to `packages/fifty_printing_engine/`
2. Remove `.dart_tool/`, `build/`, `.idea/`, `.flutter-plugins*` artifacts

### Phase 2: Update pubspec.yaml
```yaml
name: fifty_printing_engine
description: "Fifty ecosystem printing engine - multi-printer ESC/POS printing with Bluetooth and WiFi support"
version: 1.0.0
homepage: https://github.com/fiftynotai/fifty_flutter_kit
repository: https://github.com/fiftynotai/fifty_flutter_kit/tree/main/packages/fifty_printing_engine

environment:
  sdk: ^3.6.0
  flutter: '>=3.10.0'

dependencies:
  flutter:
    sdk: flutter
  escpos: any
  print_bluetooth_thermal: ^1.1.6
  permission_handler: ^12.0.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  mockito: ^5.4.0
  build_runner: ^2.4.0
```

### Phase 3: Rename Library File
- Rename `lib/printing_engine.dart` → `lib/fifty_printing_engine.dart`
- Update library directive: `library fifty_printing_engine;`

### Phase 4: Update All Imports
Replace across all files:
- `package:printing_engine/` → `package:fifty_printing_engine/`
- `printing_engine.dart` → `fifty_printing_engine.dart`

Files to update:
- `lib/fifty_printing_engine.dart`
- All files in `lib/src/`
- All files in `test/`
- All files in `example/lib/`
- `example/pubspec.yaml`

### Phase 5: Update Documentation
1. Update `README.md`:
   - Title: "# Fifty Printing Engine"
   - Add Fifty ecosystem badge/mention
   - Update import examples to `package:fifty_printing_engine/`
   - Add "Part of the Fifty Ecosystem" section

2. Update `CHANGELOG.md`:
   - Add entry for v1.0.0 migration to Fifty Ecosystem

### Phase 6: Clean and Verify
1. Run `flutter clean` in package and example
2. Run `flutter pub get`
3. Run `flutter analyze`
4. Run `flutter test`

---

## Delivery

- [ ] Branch: `implement/MG-001-printing-engine`
- [ ] All files migrated and rebranded
- [ ] Tests passing
- [ ] Commit with conventional format
- [ ] Update CURRENT_SESSION.md

---

## Notes

- Class names (PrintingEngine, PrintTicket, etc.) remain unchanged - only package name changes
- Consider future integration with fifty_demo for printing demos
- May need to update fifty_demo pubspec to include this package

---

## Related

- Source: `opaala_admin_app_v3/packages/printing_engine`
- Reference: `packages/fifty_audio_engine` (naming convention example)
- Docs: `ai/context/coding_guidelines.md`
