# TD-007: Improve ActionPresenter Error Visibility

**Type:** Technical Debt
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2026-02-02
**Audit Reference:** H-007

---

## What is the Technical Debt?

**Current situation:**

Empty catch blocks silently swallow errors when showing/hiding loader overlay in ActionPresenter.

**Why is it technical debt?**

Legitimate errors are hidden, making debugging difficult. When overlay operations fail, there's no indication of what went wrong.

**Examples:**
```dart
// Current code in action_presenter.dart:35-36, 64-65
} catch (_) {
  /* no overlay present; ignore */
}
```

---

## Why It Matters

**Consequences of not fixing:**

- [x] **Maintainability:** Hard to debug overlay issues
- [x] **Readability:** Silent failures are confusing
- [ ] **Performance:** N/A
- [ ] **Security:** N/A
- [ ] **Scalability:** N/A
- [x] **Developer Experience:** Frustrating to track down issues

**Impact:** Medium

---

## Cleanup Steps

**How to pay off this debt:**

1. [ ] Review all catch blocks in ActionPresenter
2. [ ] Add debug logging for caught exceptions
3. [ ] Wrap logging in `kDebugMode` check
4. [ ] Consider if any errors should be rethrown
5. [ ] Test overlay show/hide operations

---

## Tasks

### Pending
- [ ] Task 4: Test overlay operations

### In Progress
_(None)_

### Completed
- [x] Task 1: Identified 2 empty catch blocks (lines 35-37, 64-66) + 1 print statement
- [x] Task 2: Added kDebugMode-wrapped debugPrint for all catch blocks
- [x] Task 3: Kept catch-and-log strategy (overlay absence is expected, not error)

---

## Session State (Tactical - This Brief)

**Current State:** Implementation complete, pending verification
**Next Steps When Resuming:** Run flutter analyze and test overlay operations
**Last Updated:** 2026-02-02
**Blockers:** None

---

## Affected Areas

### Files
- `lib/core/presentation/actions/action_presenter.dart`

### Count
**Total files affected:** 1
**Total lines to change:** ~10

---

## Acceptance Criteria

**The debt is paid off when:**

1. [ ] No silent error swallowing
2. [ ] Debug mode shows caught exceptions
3. [ ] Release mode remains quiet
4. [ ] `flutter analyze` passes (zero issues)
5. [ ] Overlay operations still work correctly

---

**Created:** 2026-02-02
**Last Updated:** 2026-02-02
**Brief Owner:** Igris AI
