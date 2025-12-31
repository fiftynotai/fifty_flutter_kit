# BR-024: Extract fifty_storage Package

**Type:** Refactor
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-12-31

---

## Problem

**What's broken or missing?**

The storage infrastructure in `fifty_arch/lib/src/infrastructure/storage/` provides secure token storage and preferences management with clean contracts. This functionality is essential for any authenticated Flutter app but is locked inside fifty_arch.

**Why does it matter?**

- Secure token storage is required by virtually all authenticated apps
- Contract-based design (TokenStorage interface) allows testability
- Preferences storage is a common need
- Well-designed facade (AppStorageService) simplifies usage
- No internal fifty_arch dependencies

---

## Goal

**What should happen after this brief is completed?**

A standalone `fifty_storage` package exists that provides:
- TokenStorage contract for secure credential storage
- SecureTokenStorage implementation using flutter_secure_storage
- PreferencesStorage for app preferences using get_storage
- AppStorageService facade combining both
- Comprehensive tests and documentation

---

## Context & Inputs

### Source Files (from fifty_arch)

```
lib/src/infrastructure/storage/
├── contracts/
│   └── token_storage.dart
├── secure_token_storage.dart
├── preferences_storage.dart
└── app_storage_service.dart
```

### External Dependencies
- `flutter_secure_storage` (for SecureTokenStorage)
- `get_storage` (for PreferencesStorage)

### Internal Dependencies
- None (fully self-contained)

---

## Tasks

### Pending
- [ ] Create `packages/fifty_storage/` package structure
- [ ] Copy storage files from fifty_arch
- [ ] Update imports and package references
- [ ] Make container name configurable in PreferencesStorage
- [ ] Create barrel export file (`lib/fifty_storage.dart`)
- [ ] Write README with usage examples
- [ ] Write CHANGELOG
- [ ] Add unit tests for SecureTokenStorage (with mocks)
- [ ] Add unit tests for PreferencesStorage (with mocks)
- [ ] Add unit tests for AppStorageService
- [ ] Run `dart analyze` and fix issues
- [ ] Run tests and ensure all pass
- [ ] Update fifty_arch to depend on fifty_storage
- [ ] Remove extracted code from fifty_arch

### In Progress
_(None)_

### Completed
_(None)_

---

## Acceptance Criteria

1. [ ] `packages/fifty_storage/` exists as standalone package
2. [ ] Package exports: TokenStorage (contract)
3. [ ] Package exports: SecureTokenStorage
4. [ ] Package exports: PreferencesStorage
5. [ ] Package exports: AppStorageService
6. [ ] Container name is configurable (not hardcoded)
7. [ ] `dart analyze` passes (zero issues)
8. [ ] `dart test` passes (all tests green)
9. [ ] README documents all public APIs with examples
10. [ ] fifty_arch updated to use fifty_storage as dependency
11. [ ] No duplicate code between packages

---

## Delivery

### New Package Structure
```
packages/fifty_storage/
├── lib/
│   ├── fifty_storage.dart        (barrel export)
│   └── src/
│       ├── contracts/
│       │   └── token_storage.dart
│       ├── secure_token_storage.dart
│       ├── preferences_storage.dart
│       └── app_storage_service.dart
├── test/
├── pubspec.yaml
├── README.md
├── CHANGELOG.md
└── LICENSE
```

---

## Notes

Minor enhancement needed: make the GetStorage container name configurable instead of hardcoded. This allows multiple apps to use the package without conflicts.

---

**Created:** 2025-12-31
**Brief Owner:** Igris AI
