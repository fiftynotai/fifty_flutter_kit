# BR-022: Extract fifty_cache Package

**Type:** Refactor
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Completed:** 2025-12-31
**Created:** 2025-12-31

---

## Problem

**What's broken or missing?**

The HTTP caching system in `fifty_arch/lib/src/infrastructure/cache/` is a well-designed, self-contained module with clean contracts (CacheStore, CachePolicy, CacheKeyStrategy). However, it's bundled inside fifty_arch, making it unavailable to projects that don't need the full MVVM+Actions architecture.

**Why does it matter?**

- HTTP caching is broadly useful across all Flutter projects
- Zero internal dependencies - ready for extraction
- Contract-based design allows pluggable implementations
- Reduces fifty_arch complexity by modularizing infrastructure

---

## Goal

**What should happen after this brief is completed?**

A standalone `fifty_cache` package exists in the ecosystem that:
- Provides TTL-based HTTP response caching
- Supports pluggable cache stores (memory, GetStorage, custom)
- Supports configurable cache policies
- Has comprehensive tests and documentation
- Can be used independently or as a dependency of fifty_arch

---

## Context & Inputs

### Source Files (from fifty_arch)

```
lib/src/infrastructure/cache/
├── contracts/
│   ├── cache_store.dart
│   ├── cache_policy.dart
│   └── cache_key_strategy.dart
├── cache_manager.dart
├── simple_ttl_cache_policy.dart
├── default_cache_key_strategy.dart
└── get_storage_cache_store.dart
```

### External Dependencies
- `get_storage` (optional - for GetStorageCacheStore)

### Internal Dependencies
- None (fully self-contained)

---

## Tasks

### Pending
- [ ] Create `packages/fifty_cache/` package structure
- [ ] Copy cache files from fifty_arch
- [ ] Update imports and package references
- [ ] Create barrel export file (`lib/fifty_cache.dart`)
- [ ] Write README with usage examples
- [ ] Write CHANGELOG
- [ ] Add unit tests for CacheManager
- [ ] Add unit tests for cache policies
- [ ] Run `dart analyze` and fix issues
- [ ] Run tests and ensure all pass
- [ ] Update fifty_arch to depend on fifty_cache
- [ ] Remove extracted code from fifty_arch

### In Progress
_(None)_

### Completed
_(None)_

---

## Acceptance Criteria

1. [ ] `packages/fifty_cache/` exists as standalone package
2. [ ] Package exports: CacheManager, CacheStore, CachePolicy, CacheKeyStrategy
3. [ ] Package exports: SimpleTtlCachePolicy, DefaultCacheKeyStrategy, GetStorageCacheStore
4. [ ] `dart analyze` passes (zero issues)
5. [ ] `dart test` passes (all tests green)
6. [ ] README documents all public APIs with examples
7. [ ] fifty_arch updated to use fifty_cache as dependency
8. [ ] No duplicate code between packages

---

## Delivery

### New Package Structure
```
packages/fifty_cache/
├── lib/
│   ├── fifty_cache.dart          (barrel export)
│   └── src/
│       ├── contracts/
│       │   ├── cache_store.dart
│       │   ├── cache_policy.dart
│       │   └── cache_key_strategy.dart
│       ├── cache_manager.dart
│       ├── policies/
│       │   └── simple_ttl_cache_policy.dart
│       ├── strategies/
│       │   └── default_cache_key_strategy.dart
│       └── stores/
│           ├── memory_cache_store.dart
│           └── get_storage_cache_store.dart
├── test/
├── pubspec.yaml
├── README.md
├── CHANGELOG.md
└── LICENSE
```

---

## Notes

Clean extraction - no decoupling required. This is the highest priority extraction due to zero dependencies and immediate usability.

---

**Created:** 2025-12-31
**Brief Owner:** Igris AI
