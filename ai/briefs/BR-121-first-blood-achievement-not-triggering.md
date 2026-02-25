# BR-121: First Blood Achievement Not Triggering

**Type:** Bug Fix
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-25

---

## Problem

**What's broken or missing?**

The "First Blood" achievement does not unlock when the player kills an enemy unit. This affects any kill made via an ability (Shoot, Fireball). Regular attacks track achievements correctly, but ability kills are completely untracked.

**Root Cause:** `onUseAbility()` in `battle_actions.dart` never calls `achievements.trackUnitDefeated()` when Shoot or Fireball kills a target. The tracking code exists for regular attacks (line 445-456) but was never added to the ability execution path (lines 620-760).

Additionally, the AI executor (`ai_turn_executor.dart`) has the same gap — `_executeAbility()` (lines 335-425) and `_executeMoveAndAbility()` (lines 609-769) never track achievement events for kills.

**Why does it matter?**

- Any achievement depending on the `'unit_defeated'` event won't unlock from ability kills
- Affected achievements: "First Blood" (EventCondition), "Total War" (CountCondition, target: 50)
- If the player's first kill in a game is via Shoot/Fireball, First Blood will never unlock
- Breaks the core progression/reward loop of the achievement system

---

## Goal

**What should happen after this brief is completed?**

All unit kills — whether from regular attacks OR abilities (Shoot, Fireball) — trigger `achievements.trackUnitDefeated()` so that kill-based achievements unlock correctly.

---

## Context & Inputs

### Affected Modules
- [x] Other: `apps/tactical_grid/lib/features/battle/`

### Key Files

**Working correctly (regular attacks):**
- `battle_actions.dart:445-456` — Calls `achievements.trackUnitDefeated()` after attack kills

**Missing tracking (ability kills):**
- `battle_actions.dart:620-760` — `onUseAbility()` handles Shoot/Fireball kills but never calls `trackUnitDefeated()`
- `ai_turn_executor.dart:335-425` — `_executeAbility()` animates defeated units, no achievement tracking
- `ai_turn_executor.dart:609-769` — `_executeMoveAndAbility()` same issue

### Affected Achievements
| Achievement | Condition Type | Event |
|------------|---------------|-------|
| First Blood | EventCondition | `unit_defeated` |
| Total War | CountCondition | `unit_defeated` (target: 50) |

---

## Constraints

### Architecture Rules
- Follow the existing pattern from regular attack tracking (lines 445-456)
- Call `trackUnitDefeated(attacker, target)` in the same way

### Out of Scope
- Adding new achievements
- Changing the achievement engine package itself
- Modifying the combat math

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Killing a unit with Shoot ability triggers `trackUnitDefeated()`
2. [ ] Killing a unit with Fireball ability triggers `trackUnitDefeated()`
3. [ ] "First Blood" unlocks on the first kill regardless of kill method
4. [ ] AI kills via abilities also track properly (for future AI-related achievements)
5. [ ] Existing regular attack tracking remains unchanged

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Ability Kill Achievement
**Steps:**
1. Start VS AI game
2. Use an Archer's Shoot ability to kill an enemy unit as first kill
3. Check if "First Blood" achievement unlocks

**Expected Result:** Achievement popup appears, "First Blood" shows as unlocked in Achievements screen

---

## Delivery

### Code Changes
- [ ] Modified: `apps/tactical_grid/lib/features/battle/actions/battle_actions.dart` — Add `trackUnitDefeated()` call in `onUseAbility()` after ability kill
- [ ] Modified: `apps/tactical_grid/lib/features/battle/services/ai_turn_executor.dart` — Add achievement tracking in `_executeAbility()` and `_executeMoveAndAbility()`

---

**Created:** 2026-02-25
**Last Updated:** 2026-02-25
**Brief Owner:** Igris AI
