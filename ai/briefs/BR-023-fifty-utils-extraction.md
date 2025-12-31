# BR-023: Extract fifty_utils Package

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

Utility functions in `fifty_arch` (DateTime extensions, responsive utilities, color extensions, API response state) are useful across all Flutter projects but require importing the entire fifty_arch package to use them.

**Why does it matter?**

- DateTime formatting/parsing is needed everywhere
- Responsive breakpoint utilities are broadly useful
- Color hex conversion is a common need
- ApiResponse<T> is a framework-agnostic state container
- These utilities have zero internal dependencies

---

## Goal

**What should happen after this brief is completed?**

A standalone `fifty_utils` package exists that provides:
- DateTime extensions (formatting, parsing, relative time)
- Duration extensions (human-readable formatting)
- Responsive utilities (breakpoints, screen size helpers)
- Color extensions (hex conversion)
- ApiResponse<T> state container (idle/loading/success/error)
- Comprehensive tests and documentation

---

## Context & Inputs

### Source Files (from fifty_arch)

```
lib/src/utils/
├── date_time_extensions.dart
└── responsive_utils.dart

lib/src/extensions/
└── color_extension.dart

lib/src/core/presentation/
└── api_response.dart
```

### External Dependencies
- `intl` (for DateFormat in date_time_extensions)

### Internal Dependencies
- None (pure Dart/Flutter utilities)

---

## Tasks

### Pending
- [ ] Create `packages/fifty_utils/` package structure
- [ ] Copy utility files from fifty_arch
- [ ] Update imports and package references
- [ ] Create barrel export file (`lib/fifty_utils.dart`)
- [ ] Write README with usage examples for each utility
- [ ] Write CHANGELOG
- [ ] Add unit tests for DateTime extensions
- [ ] Add unit tests for Duration extensions
- [ ] Add unit tests for responsive utilities
- [ ] Add unit tests for color extensions
- [ ] Add unit tests for ApiResponse
- [ ] Run `dart analyze` and fix issues
- [ ] Run tests and ensure all pass
- [ ] Update fifty_arch to depend on fifty_utils
- [ ] Remove extracted code from fifty_arch

### In Progress
_(None)_

### Completed
_(None)_

---

## Acceptance Criteria

1. [ ] `packages/fifty_utils/` exists as standalone package
2. [ ] Package exports DateTime/Duration extensions
3. [ ] Package exports ResponsiveUtils
4. [ ] Package exports ColorExtension
5. [ ] Package exports ApiResponse<T>
6. [ ] `dart analyze` passes (zero issues)
7. [ ] `dart test` passes (all tests green)
8. [ ] README documents all public APIs with examples
9. [ ] fifty_arch updated to use fifty_utils as dependency
10. [ ] No duplicate code between packages

---

## Delivery

### New Package Structure
```
packages/fifty_utils/
├── lib/
│   ├── fifty_utils.dart          (barrel export)
│   └── src/
│       ├── extensions/
│       │   ├── date_time_extensions.dart
│       │   ├── duration_extensions.dart
│       │   └── color_extensions.dart
│       ├── responsive/
│       │   └── responsive_utils.dart
│       └── state/
│           └── api_response.dart
├── test/
├── pubspec.yaml
├── README.md
├── CHANGELOG.md
└── LICENSE
```

---

## Notes

Pure utilities with minimal dependencies. ApiResponse<T> is particularly valuable as a framework-agnostic async state container.

---

**Created:** 2025-12-31
**Brief Owner:** Igris AI
