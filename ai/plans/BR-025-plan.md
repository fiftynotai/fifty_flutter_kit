# Implementation Plan: BR-025

**Complexity:** M (Medium)
**Estimated Duration:** 1-2 days
**Risk Level:** Low-Medium

## Summary

Extract the connectivity module from `fifty_arch` into a standalone `fifty_connectivity` package. The module provides network monitoring with intelligent reachability probing (DNS/HTTP) via `ReachabilityService`, reactive state management via `ConnectionViewModel` (GetX), and UI widgets for connection status display. Key challenges include decoupling internal dependencies (locale keys, RouteManager, ActionPresenter, AssetsManager) by making them optional/configurable.

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_connectivity/pubspec.yaml` | CREATE | Package manifest with dependencies |
| `packages/fifty_connectivity/lib/fifty_connectivity.dart` | CREATE | Barrel export |
| `packages/fifty_connectivity/lib/src/services/reachability_service.dart` | CREATE | Copy from fifty_arch, no changes |
| `packages/fifty_connectivity/lib/src/controllers/connection_view_model.dart` | CREATE | Copy + replace fifty_arch import with fifty_utils |
| `packages/fifty_connectivity/lib/src/actions/connection_actions.dart` | CREATE | Copy + make optional with callbacks |
| `packages/fifty_connectivity/lib/src/widgets/connection_handler.dart` | CREATE | Copy + externalize locale keys |
| `packages/fifty_connectivity/lib/src/widgets/connection_overlay.dart` | CREATE | Copy + externalize locale keys |
| `packages/fifty_connectivity/lib/src/widgets/connectivity_checker_splash.dart` | CREATE | Copy + make configurable (logo, routing) |
| `packages/fifty_connectivity/lib/src/bindings/connection_bindings.dart` | CREATE | Copy, no changes |
| `packages/fifty_connectivity/lib/src/config/connectivity_config.dart` | CREATE | Configuration class for externalized settings |
| `packages/fifty_connectivity/test/reachability_service_test.dart` | CREATE | Unit tests for ReachabilityService |
| `packages/fifty_connectivity/test/connection_view_model_test.dart` | CREATE | Unit tests for ConnectionViewModel |
| `packages/fifty_connectivity/test/connection_handler_test.dart` | CREATE | Widget tests |
| `packages/fifty_connectivity/README.md` | CREATE | Documentation with usage examples |
| `packages/fifty_connectivity/CHANGELOG.md` | CREATE | Initial changelog |
| `packages/fifty_connectivity/LICENSE` | CREATE | MIT License |
| `packages/fifty_arch/pubspec.yaml` | MODIFY | Add fifty_connectivity dependency |
| `packages/fifty_arch/lib/src/modules/connections/` | DELETE | Remove extracted files |
| `packages/fifty_arch/lib/fifty_arch.dart` | MODIFY | Re-export from fifty_connectivity |

---

## Implementation Steps

### Phase 1: Package Scaffolding

**Task 1.1: Create package directory structure**
- Create `packages/fifty_connectivity/`
- Create subdirectories: `lib/`, `lib/src/`, `lib/src/services/`, `lib/src/controllers/`, `lib/src/actions/`, `lib/src/widgets/`, `lib/src/bindings/`, `lib/src/config/`, `test/`

**Task 1.2: Create pubspec.yaml**
```yaml
name: fifty_connectivity
description: Network connectivity monitoring with intelligent reachability probing (DNS/HTTP). Part of the Fifty ecosystem.
version: 0.1.0
repository: https://github.com/fiftynotai/fifty_flutter_kit/tree/main/packages/fifty_connectivity
homepage: https://fifty.dev

environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  connectivity_plus: ^6.1.0
  get: ^4.6.6
  fifty_tokens:
    path: ../fifty_tokens
  fifty_ui:
    path: ../fifty_ui
  fifty_utils:
    path: ../fifty_utils

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mocktail: ^1.0.4
```

**Task 1.3: Create LICENSE file**
- Copy MIT License from existing packages

---

### Phase 2: Core Service Extraction

**Task 2.1: Extract ReachabilityService**
- Copy from: `fifty_arch/lib/src/modules/connections/data/services/reachability_service.dart`
- Changes: None required (already standalone)

**Task 2.2: Extract ConnectionViewModel**
- Copy from: `fifty_arch/lib/src/modules/connections/controllers/connection_view_model.dart`
- Changes:
  - Replace `import '/src/utils/utils.dart'` with `import 'package:fifty_utils/fifty_utils.dart'`
  - Update relative import for ReachabilityService

**Task 2.3: Create ConnectivityConfig**
- Purpose: Externalize hardcoded values (locale keys, default assets, routes)

---

### Phase 3: Actions Extraction

**Task 3.1: Extract ConnectionActions (Decoupled)**
- Remove ActionPresenter inheritance (makes it standalone)
- Remove RouteManager.off() call - use ConnectivityConfig.navigateOff callback
- Keep singleton pattern but make it more flexible

---

### Phase 4: Widget Extraction

**Task 4.1: Extract ConnectionOverlay**
- Remove locale keys import
- Replace hardcoded strings with ConnectivityConfig lookups

**Task 4.2: Extract ConnectionHandler**
- Remove locale keys import
- Replace `tkTryAgainBtn.tr` with `ConnectivityConfig.labelTryAgain`

**Task 4.3: Extract ConnectivityCheckerSplash (Highly Configurable)**
- Remove RouteManager.authRoute - use parameter with fallback to config
- Remove AssetsManager.logoPath - use logoBuilder callback
- Make logo widget fully configurable

**Task 4.4: Extract ConnectionBindings**
- Update import paths only

---

### Phase 5: Barrel Export & Package API

Create `fifty_connectivity.dart` with exports for:
- Configuration
- Services
- Controllers
- Actions
- Widgets
- Bindings

---

### Phase 6: Documentation

**Task 6.1: Create README.md**
**Task 6.2: Create CHANGELOG.md**

---

### Phase 7: Testing

**Task 7.1: ReachabilityService tests**
**Task 7.2: ConnectionViewModel tests**
**Task 7.3: Widget tests**

---

### Phase 8: Integration with fifty_arch

**Task 8.1: Update fifty_arch pubspec.yaml**
**Task 8.2: Update fifty_arch barrel export (re-export for backwards compatibility)**
**Task 8.3: Remove extracted files from fifty_arch**
**Task 8.4: Update fifty_arch module exports**

---

### Phase 9: Verification

**Task 9.1: Run dart analyze**
**Task 9.2: Run tests**
**Task 9.3: Verify fifty_arch still works**

---

## Testing Strategy

| Test Type | Coverage Target | Files |
|-----------|-----------------|-------|
| Unit | ReachabilityService (DNS/HTTP strategies) | `reachability_service_test.dart` |
| Unit | ConnectionViewModel (state transitions, callbacks) | `connection_view_model_test.dart` |
| Widget | ConnectionHandler (state-based rendering) | `connection_handler_test.dart` |
| Widget | ConnectionOverlay (badge display) | `connection_overlay_test.dart` |
| Integration | fifty_arch backwards compatibility | Existing fifty_arch tests |

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Locale key dependencies break existing apps | Medium | Medium | Use fallback strings in ConnectivityConfig |
| RouteManager removal breaks navigation | Medium | High | Provide navigateOff callback |
| AssetsManager removal breaks splash screen | Medium | Medium | Provide logoBuilder callback |
| fifty_arch backwards compatibility breaks | Low | High | Re-export all public APIs |

---

## Summary

This plan extracts `fifty_connectivity` as a **highly configurable, standalone package** with minimal coupling to fifty_arch internals. The key architectural decisions:

1. **ConnectivityConfig** - Central configuration class replaces hardcoded locale keys, assets, and routing
2. **Callback-based navigation** - `navigateOff` callback instead of RouteManager dependency
3. **Builder pattern for logo** - `logoBuilder` callback instead of AssetsManager dependency
4. **Removed ActionPresenter inheritance** - ConnectionActions is standalone
5. **fifty_utils dependency** - Uses extracted Duration.format() instead of internal utils
6. **Re-export for backwards compatibility** - fifty_arch re-exports all public APIs

---

**Plan created:** 2025-12-31
**Complexity:** M (Medium)
**Files affected:** 19 (9 create, 5 modify, 5 delete)
**Phases:** 9
