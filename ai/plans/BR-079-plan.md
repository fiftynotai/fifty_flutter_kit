# BR-079 Implementation Plan: Tactical Skirmish Sandbox Bugfixes

**Complexity:** M (Medium)
**Files Affected:** 3 (1 engine, 1 example, 1 test)
**Phases:** 6

---

## Root Cause Analysis

| Issue | Root Cause | Scope |
|-------|-----------|-------|
| 1 - Move to unhighlighted tiles | No defensive guard in `_moveUnit()` + symptom of Issues 3 & 6 | Example |
| 2 - Shifted landing after move | `Future.delayed(250ms)` shorter than MoveToEffect duration (320ms), causing overlapping animations | Engine + Example |
| 3 - Random movement on rapid clicks | No `_isMoving` lock prevents re-entrant `_onTileTap` during movement | Example |
| 4 - No auto-deselect after move | `_moveUnit` onComplete shows attack range instead of deselecting | Example |
| 5 - No auto turn switch | No check for "all friendly units used" after each move | Example |
| 6 - BFS range looks incorrect | BFS algorithm verified correct by tests. Likely visual perception from overlapping attack + movement highlights. Add verification tests. | Engine (test) |

---

## Implementation Phases

### Phase 1: Movement Snapping (Issue 2) - Engine + Example
- Increase `Future.delayed` from 250ms to 350ms+ in `_moveUnit` step loop
- Ensures each MoveToEffect (320ms duration) completes before next step begins

### Phase 2: Rapid Click Guard (Issue 3) - Example
- Add `bool _isMoving = false` flag to state
- Guard `_onTileTap` with `if (_isMoving) return`
- Set `_isMoving = true` at start of `_moveUnit`, clear in onComplete

### Phase 3: Defensive Movement Guard (Issue 1) - Example
- Add `if (!_state.moveTargets.contains(target)) return` at top of `_moveUnit`
- Ensures movement ONLY to highlighted tiles regardless of state timing

### Phase 4: Auto-Deselect After Move (Issue 4) - Example
- Replace attack range display in onComplete with `_deselectUnit()`
- Clear both moveTargets and attackTargets

### Phase 5: Auto Turn Switch (Issue 5) - Example
- Add `_checkAutoTurnSwitch()` method
- Compare `usedUnits.length` against friendly unit count
- Auto-call `_endTurn()` with 500ms delay + snackbar feedback
- Call after deselect in onComplete

### Phase 6: BFS Verification (Issue 6) - Engine Test
- Add tests replicating exact sandbox map layout
- Verify forest cost (2.0), water impassable, movement budgets
- Confirm BFS algorithm correctness with sandbox-specific scenarios

---

## Implementation Order

```
Phase 1 (Snapping)     ─┐
Phase 2 (Click Guard)   ├─ Independent, can parallel
Phase 6 (BFS Tests)    ─┘
         │
Phase 3 (Movement Guard) ─ Depends on Phase 2 concept
         │
Phase 4 (Auto-Deselect)  ─ Shares onComplete with Phase 3
         │
Phase 5 (Auto Turn)      ─ Called after deselect
```

---

## Files Modified

| File | Changes |
|------|---------|
| `packages/fifty_map_engine/example/lib/main.dart` | Issues 1,3,4,5 - state guards, auto-deselect, auto-turn-switch |
| `packages/fifty_map_engine/lib/src/components/base/component.dart` | Issue 2 - verify MoveToEffect snapping (may not need change if timing fix sufficient) |
| `packages/fifty_map_engine/test/pathfinding_test.dart` | Issue 6 - BFS verification tests for sandbox map |

---

## Risks

| Risk | Mitigation |
|------|-----------|
| Animation timing drift even with 350ms | Add explicit position snap in final onComplete if needed |
| Auto-deselect removes attack-after-move | Brief explicitly requests this behavior |
| Auto-turn races with animation queue | 500ms delay + mounted check + winner check |
