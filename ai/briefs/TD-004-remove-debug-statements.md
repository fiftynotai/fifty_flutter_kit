# TD-004: Remove Debug Print Statements

**Type:** Technical Debt
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2026-02-02
**Audit Reference:** H-004

---

## What is the Technical Debt?

**Current situation:**

Multiple `debugPrint()` and `print()` statements left in production code across several files.

**Why is it technical debt?**

Debug statements leak internal details to console in production, cause minor performance overhead, and clutter logs.

**Affected files:**
- `lib/shared/services/audio_integration_service.dart:93,144,177`
- `lib/shared/services/speech_integration_service.dart:61,106,114`
- `lib/core/presentation/actions/action_presenter.dart:116`
- `lib/features/map_demo/service/map_audio_coordinator.dart:65`

---

## Why It Matters

**Consequences of not fixing:**

- [ ] **Maintainability:** Cluttered logs make debugging harder
- [x] **Readability:** Noise in console output
- [x] **Performance:** Minor overhead from string formatting
- [ ] **Security:** Could leak implementation details
- [ ] **Scalability:** N/A
- [x] **Developer Experience:** Noisy console during development

**Impact:** Medium

---

## Cleanup Steps

**How to pay off this debt:**

1. [ ] Search for all `debugPrint(` and `print(` statements
2. [ ] Remove unnecessary debug statements
3. [ ] Wrap essential debug logging in `kDebugMode` check
4. [ ] Run `flutter analyze` to verify no issues
5. [ ] Test app still functions correctly

---

## Tasks

### Pending
_(None)_

### In Progress
_(None)_

### Completed
- [x] Task 1: Wrap debug prints in kDebugMode in audio_integration_service.dart (3 locations)
- [x] Task 2: Wrap debug prints in kDebugMode in speech_integration_service.dart (3 locations)
- [x] Task 3: Standardize debug prints in action_presenter.dart (already wrapped, improved format)
- [x] Task 4: Wrap debug print in kDebugMode in map_audio_coordinator.dart (added import)
- [x] Task 5: All debug statements now wrapped in kDebugMode

---

## Session State (Tactical - This Brief)

**Current State:** Implementation complete, pending verification
**Next Steps When Resuming:** Run flutter analyze and verify
**Last Updated:** 2026-02-02
**Blockers:** None

---

## Affected Areas

### Files
- `lib/shared/services/audio_integration_service.dart`
- `lib/shared/services/speech_integration_service.dart`
- `lib/core/presentation/actions/action_presenter.dart`
- `lib/features/map_demo/service/map_audio_coordinator.dart`

### Count
**Total files affected:** 4+
**Total lines to change:** ~15

---

## Acceptance Criteria

**The debt is paid off when:**

1. [ ] No unwrapped `print()` or `debugPrint()` statements
2. [ ] Essential logging wrapped in `kDebugMode`
3. [ ] `flutter analyze` passes (zero issues)
4. [ ] All existing tests pass
5. [ ] Console is clean in release mode

---

**Created:** 2026-02-02
**Last Updated:** 2026-02-02
**Brief Owner:** Igris AI
