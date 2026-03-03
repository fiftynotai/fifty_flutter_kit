# Implementation Plan: FR-004

**Complexity:** S (Small)
**Estimated Duration:** 1-2 hours
**Risk Level:** Low

## Summary

Add an optional `contentBuilder` to `ConnectivityCheckerSplash` so consumers can replace the default splash content per connectivity state (checking/connected/failed) while the connectivity check pipeline and Scaffold remain widget-owned. The widget currently delegates to `ConnectionHandler` which already handles three states -- the builder intercepts at the splash level with a simpler enum.

---

## Key Design Decisions

### Decision 1: New enum vs. reuse ConnectivityType

**Answer: New enum `SplashConnectivityState` with 3 values: `checking`, `connected`, `failed`.**

`ConnectivityType` has 5 values (`mobileData`, `wifi`, `disconnected`, `noInternet`, `connecting`) which are infrastructure-level distinctions. For a splash screen, consumers care about 3 states:
- **checking** -- maps to `ConnectivityType.connecting`
- **connected** -- maps to `ConnectivityType.wifi` or `ConnectivityType.mobileData`
- **failed** -- maps to `ConnectivityType.disconnected` or `ConnectivityType.noInternet`

A 3-value enum is cleaner API surface for splash consumers than exposing 5 infrastructure states.

### Decision 2: Data class vs. positional params

**Answer: Positional params (no data class).** The builder only needs 2 params: `BuildContext` and `SplashConnectivityState`. That is well under the 5-param threshold. A typedef with positional params is sufficient.

### Decision 3: Where does the builder intercept?

**Answer: The builder replaces the `ConnectionHandler` widget entirely.** Currently the splash renders:

```
Scaffold
  body: Center
    child: ConnectionHandler(
      connectedWidget: Padding > _buildLogo(context)
      tryAgainAction: _init
    )
```

When `contentBuilder` is provided, it replaces the `ConnectionHandler`:

```
Scaffold
  body: Center
    child: contentBuilder(context, splashState)
```

The `Scaffold` and `Center` remain widget-owned (outer container preserved -- FR-001/FR-003 pattern). The builder replaces the inner content.

When `contentBuilder` is null, the existing `ConnectionHandler` path executes unchanged.

### Decision 4: How does the splash know the current state when bypassing ConnectionHandler?

The splash's `_ConnectivityCheckerSplashState` currently calls `ConnectionActions.instance.initSplash()` in `initState()` and relies on `ConnectionHandler` (which internally reads `ConnectionViewModel.connectionType` via `Obx`). When using the builder path:

1. The State must directly observe `ConnectionViewModel.connectionType` to derive `SplashConnectivityState`.
2. Use `Get.find<ConnectionViewModel>()` and `Obx(() => ...)` in the builder path -- same pattern `ConnectionHandler` uses internally.
3. The `_init()` call stays in `initState()` regardless (it triggers the connectivity check + navigation pipeline).

### Decision 5: tryAgainAction in builder path

When the builder is active, the consumer controls the UI -- but they may want a retry callback. The builder typedef does NOT include a retry callback because:
1. Consumers already control the retry affordance (they build the UI).
2. They can call `ConnectionActions.instance.checkConnectivity()` directly.
3. The splash re-runs `_init()` on retry, but this is splash-internal logic -- the splash could expose an `onRetry` VoidCallback separately if needed (not in this brief's scope).

However, to keep it practical, the builder should receive `VoidCallback retryAction` as the third param so consumers do not need to know about `ConnectionActions`. This keeps it at 3 positional params -- still under the threshold.

**Final typedef:**
```dart
typedef SplashContentBuilder = Widget Function(
  BuildContext context,
  SplashConnectivityState state,
  VoidCallback retryAction,
);
```

---

## Enum

```dart
/// States exposed to splash content builders.
///
/// Simplifies the 5-value [ConnectivityType] into 3 consumer-facing states.
enum SplashConnectivityState {
  /// Connectivity check is in progress.
  checking,

  /// Device is connected to the internet.
  connected,

  /// Connectivity check failed (disconnected or no internet).
  failed,
}
```

Lives at the top of `connectivity_checker_splash.dart` (same file, not a new file -- it is a 3-value enum tightly coupled to this one widget).

---

## Typedef

```dart
/// Builder for custom splash screen content based on connectivity state.
///
/// - [context]: The build context.
/// - [state]: The current connectivity check state.
/// - [retryAction]: Callback to retry the connectivity check.
///
/// When provided to [ConnectivityCheckerSplash.contentBuilder], replaces
/// the default splash content while preserving the [Scaffold] wrapper
/// and connectivity check pipeline.
typedef SplashContentBuilder = Widget Function(
  BuildContext context,
  SplashConnectivityState state,
  VoidCallback retryAction,
);
```

Lives at the top of `connectivity_checker_splash.dart`, before the class declaration, after the enum.

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_connectivity/lib/src/widgets/connectivity_checker_splash.dart` | MODIFY | Add `SplashConnectivityState` enum, `SplashContentBuilder` typedef, `contentBuilder` optional param, builder-path rendering with `Obx` |
| `packages/fifty_connectivity/test/connectivity_checker_splash_test.dart` | CREATE | Widget tests for builder rendering, default fallback, state mapping |

**Total: 1 modified, 1 new = 2 files**

No barrel export changes needed -- the enum and typedef are in an already-exported file (`connectivity_checker_splash.dart` is exported from `fifty_connectivity.dart`).

---

## Implementation Steps

### Phase 1: Enum + Typedef + Field (modify existing)

**File:** `packages/fifty_connectivity/lib/src/widgets/connectivity_checker_splash.dart`

1. Add `SplashConnectivityState` enum (3 values: `checking`, `connected`, `failed`) at the top of the file, before the widget class, with doc comments.
2. Add `SplashContentBuilder` typedef immediately after the enum.
3. Add `this.contentBuilder` optional param to the `ConnectivityCheckerSplash` constructor (after `logoBuilder`).
4. Add `final SplashContentBuilder? contentBuilder;` field with doc comment.
5. Update class-level doc comment to document the new param with usage example.

### Phase 2: Builder Path in Build Method (modify existing)

**File:** `packages/fifty_connectivity/lib/src/widgets/connectivity_checker_splash.dart`

1. Add import for `'package:get/get.dart'` and `'../controllers/connection_view_model.dart'`.
2. In `_ConnectivityCheckerSplashState.build()`, add builder path before the existing return:

```dart
@override
Widget build(BuildContext context) {
  // Builder path: consumer replaces inner content
  if (widget.contentBuilder != null) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          final state = _mapToSplashState(
            Get.find<ConnectionViewModel>().connectionType.value,
          );
          return widget.contentBuilder!(context, state, _init);
        }),
      ),
    );
  }

  // Default path (existing code unchanged)
  return Scaffold(
    body: Center(
      child: ConnectionHandler(
        tryAgainAction: _init,
        connectedWidget: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildLogo(context),
        ),
      ),
    ),
  );
}
```

3. Add private helper method to `_ConnectivityCheckerSplashState`:

```dart
SplashConnectivityState _mapToSplashState(ConnectivityType type) {
  switch (type) {
    case ConnectivityType.connecting:
      return SplashConnectivityState.checking;
    case ConnectivityType.wifi:
    case ConnectivityType.mobileData:
      return SplashConnectivityState.connected;
    case ConnectivityType.disconnected:
    case ConnectivityType.noInternet:
      return SplashConnectivityState.failed;
  }
}
```

### Phase 3: Tests

**File:** `packages/fifty_connectivity/test/connectivity_checker_splash_test.dart`

Test helpers needed:
- `FakeConnectionViewModel` extending `GetxController` with a manually-settable `Rx<ConnectivityType> connectionType` (mimic `ConnectionViewModel` API without real connectivity).
- `FakeConnectionActions` or mock the singleton -- since `initSplash` triggers async navigation, tests should either:
  - Set `ConnectivityConfig.navigateOff = null` (disables navigation), OR
  - Use a no-op callback.
- Register fakes in `Get` before each test, clean up with `Get.reset()` in tearDown.
- Wrap widget in `GetMaterialApp` (required for `Get.find` and `Obx`).

Test groups:

1. **SplashConnectivityState enum:**
   - Has 3 values (checking, connected, failed)

2. **contentBuilder - rendering:**
   - When `contentBuilder` is null, renders default ConnectionHandler content
   - When `contentBuilder` is provided, renders builder output
   - Builder receives `SplashConnectivityState.checking` when type is `connecting`
   - Builder receives `SplashConnectivityState.connected` when type is `wifi`
   - Builder receives `SplashConnectivityState.connected` when type is `mobileData`
   - Builder receives `SplashConnectivityState.failed` when type is `disconnected`
   - Builder receives `SplashConnectivityState.failed` when type is `noInternet`

3. **contentBuilder - retryAction:**
   - `retryAction` callback is usable from within builder

4. **contentBuilder - reactivity:**
   - Builder rebuilds when `connectionType` changes (set type -> pump -> verify new state in builder)

5. **contentBuilder - Scaffold preserved:**
   - Scaffold exists in widget tree when builder is active

**Estimated test count:** ~10-12 tests

### Phase 4: Verify

1. Run `flutter test` in `packages/fifty_connectivity/` -- all existing + new tests pass.
2. Run `flutter analyze` in `packages/fifty_connectivity/` -- zero issues.

---

## Testing Strategy

- **Unit tests:** Enum has 3 values (trivial, 1 test)
- **Widget tests:** Builder rendering per state, reactivity, default fallback, retry callback (~10 tests)
- **Regression:** Existing `fifty_connectivity_test.dart` must pass unchanged
- **Analyzer:** Zero issues on `flutter analyze`
- **Total new tests:** ~10-12

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| `Get.find<ConnectionViewModel>()` throws in builder path if bindings not registered | Medium | Medium | Guard same way as `ConnectionHandler` (GetWidget does this implicitly) -- the splash already requires bindings to be registered for `ConnectionActions.instance` to work, so this is not a new requirement |
| `initSplash()` triggers async navigation during tests | Medium | Low | Set `ConnectivityConfig.navigateOff = null` in test setUp to disable navigation; or use a captured flag |
| `Obx` requires `GetMaterialApp` in test harness | Low | Low | Use `GetMaterialApp(home: ...)` wrapper in tests |
| Existing `ConnectionHandler`-based tests (if any widget tests exist) | Low | Low | Only `fifty_connectivity_test.dart` exists and it tests config/enums only -- no widget rendering tests to break |

---

## Backward Compatibility

- `contentBuilder` is optional with `null` default
- No constructor param order changes (new param added at end)
- No changes to existing build output when builder is null
- `SplashConnectivityState` enum and `SplashContentBuilder` typedef are purely additive API
- Barrel export already covers the file -- no changes needed
- `logoBuilder` param still works when `contentBuilder` is null (default path unchanged)
- When `contentBuilder` is provided, `logoBuilder` is ignored (builder controls all inner content) -- document this

---

## File Count Summary

| Category | Count |
|----------|-------|
| New source files | 0 |
| Modified source files | 1 |
| New test files | 1 |
| Total files affected | 2 |
