# FR-004: Add builder patterns to fifty_connectivity splash widget

**Type:** Feature Request
**Priority:** P3-Low
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Ready
**Created:** 2026-03-03
**Completed:**

---

## Feature Description

**What is the proposed feature?**

Add a `contentBuilder` to `ConnectivityCheckerSplash` so consumers can provide their own splash screen content while keeping the connectivity check pipeline intact. The other two widgets (`ConnectionHandler` and `ConnectionOverlay`) already accept widget parameters — only the splash needs this.

**Why is this valuable?**

`ConnectionHandler` already takes `connectedWidget`/`notConnectedWidget` (good pattern). `ConnectionOverlay` takes `child`. But `ConnectivityCheckerSplash` has hardcoded content for the checking/connected/failed states. Consumers should be able to customize the splash experience.

---

## User Value

### Who Benefits?
- [x] Developers (building with the package)

### Pain Point Solved
**Current situation:**
`ConnectivityCheckerSplash` renders a fixed layout during connectivity checks. Consumers can't customize the loading indicator, success animation, or failure UI.

**With this feature:**
Consumers provide their own splash content per connectivity state while the package handles the actual check logic.

---

## Technical Approach

### Widget to Update

| Widget | Builder to Add | Fallback |
|--------|---------------|----------|
| `ConnectivityCheckerSplash` | `contentBuilder(state)` where state is checking/connected/failed | Default splash content |

### Pattern

```dart
ConnectivityCheckerSplash(
  // Optional — if null, uses default splash UI
  contentBuilder: (connectivityState) {
    switch (connectivityState) {
      case ConnectivityCheckState.checking:
        return MyCustomLoadingWidget();
      case ConnectivityCheckState.connected:
        return MyCustomSuccessWidget();
      case ConnectivityCheckState.failed:
        return MyCustomRetryWidget();
    }
  },
  onConnected: () => Navigator.pushReplacement(...),
)
```

### Constraints
- `ConnectionHandler` and `ConnectionOverlay` already good — no changes
- Default splash remains unchanged (backward compatible)
- Builder is optional — null means use default
- Connectivity check logic unaffected

---

## Acceptance Criteria

1. [ ] `ConnectivityCheckerSplash` has an optional `contentBuilder` callback
2. [ ] Null builder falls back to current default splash
3. [ ] Existing API unchanged (backward compatible)
4. [ ] Connectivity check logic unaffected
5. [ ] All existing tests pass

---

## Notes

Lower priority since `ConnectionHandler` and `ConnectionOverlay` already follow the composable widget pattern. Only the splash is hardcoded.

---

**Created:** 2026-03-03
**Last Updated:** 2026-03-03
**Brief Owner:** Fifty.ai
