# BR-005: fifty_tokens Motion & Interaction System Implementation

**Type:** Feature
**Priority:** P1-High
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-11-10
**Completed:** 2025-11-10
**Dependencies:** BR-001 (Package Structure) ✅

---

## Problem

**What's broken or missing?**

The motion and interaction token system does not exist. The fifty.dev brand uses specific animation durations and easing curves to create a cohesive, engineered feel. Without these tokens, animations will be inconsistent and lack the brand's characteristic smoothness.

**Why does it matter?**

- Motion creates personality and polish in the UI
- Consistent durations ensure predictable interactions
- Easing curves define the feel (springy, sharp, smooth)
- All animations must honor "Reduce Motion" accessibility settings
- Components need standardized animation timing

---

## Goal

**What should happen after this brief is completed?**

A complete motion token system implemented in `lib/src/motion.dart` that includes:
- Duration constants (fast, base, slow, overlay)
- Easing curve objects (emphasis enter/exit, standard, spring)
- Cubic bezier curves with exact control points
- All values as Dart constants
- Perfect fidelity to FDL motion specification

---

## Context & Inputs

### Motion Specifications (from FDL)

**Animation Durations (milliseconds):**
- fast: 120ms (quick transitions, hover effects)
- base: 180ms (standard transitions)
- slow: 240ms (deliberate animations)
- overlay: 280ms (modals, drawers)

**Easing Curves (Cubic Bezier):**
- **Emphasis Enter:** `cubic-bezier(0.2, 0.8, 0.2, 1)` - Springy entrance
- **Emphasis Exit:** `cubic-bezier(0.4, 0.0, 1, 1)` - Sharp exit
- **Standard:** `cubic-bezier(0.2, 0.0, 0, 1)` - Smooth in-out
- **Spring:** `cubic-bezier(0.16, 1, 0.3, 1)` - Bouncy spring effect

### Interaction Patterns (Reference)
- Buttons: glow + scale transitions
- Cards: hover lift + border brighten
- Inputs: border → crimson focus
- Modals: scale(0.98→1) + fade
- Command Palette: scan shimmer + caret pulse

### Implementation Pattern

```dart
import 'package:flutter/material.dart';

/// Fifty.dev motion tokens - animation timing and easing.
///
/// Defines durations and curves following the Fifty Design Language (FDL).
/// All motion honors Reduce Motion accessibility settings.
class FiftyMotion {
  FiftyMotion._(); // Private constructor - static class

  // Durations (milliseconds → Duration objects)
  /// Fast duration (120ms) - Quick transitions, hover effects
  static const Duration fast = Duration(milliseconds: 120);

  /// Base duration (180ms) - Standard transitions
  static const Duration base = Duration(milliseconds: 180);

  // ... etc

  // Easing Curves (Cubic Bezier)
  /// Emphasis Enter curve - Springy entrance
  /// cubic-bezier(0.2, 0.8, 0.2, 1)
  static const Curve emphasisEnter = Cubic(0.2, 0.8, 0.2, 1.0);

  /// Emphasis Exit curve - Sharp exit
  /// cubic-bezier(0.4, 0.0, 1, 1)
  static const Curve emphasisExit = Cubic(0.4, 0.0, 1.0, 1.0);

  // ... etc
}
```

### Related Files
- `lib/src/motion.dart` - Implementation file
- `lib/fifty_tokens.dart` - Must export FiftyMotion
- `design_system/fifty_design_system.md` - Source specification

---

## Constraints

### Architecture Rules
- Duration values use `const Duration(milliseconds: N)`
- Easing curves use Flutter's `Cubic` class
- All values must be `static const`
- No logic, pure constants
- Documentation comment for every constant
- Include cubic-bezier values in doc comments

### Technical Constraints
- Duration values must match FDL exactly (120, 180, 240, 280 ms)
- Cubic bezier control points must be precise
- Must pass `flutter analyze` with zero warnings
- Curves must work with Flutter's animation system

### Accessibility Note
- Motion tokens define *available* durations
- Consuming code must check `ReduceMotion` preference
- When reduced motion enabled, use `Duration.zero` or simplify animations

### Timeline
- **Deadline:** Part of Pilot 1 critical path
- **Blocks:** fifty_ui components (need motion for animations)

### Out of Scope
- Animation controllers (handled in consuming code)
- Reduce motion detection (handled in theme layer)
- Specific animation implementations (handled in fifty_ui)

---

## Tasks

### Pending
- [ ] Create FiftyMotion class in lib/src/motion.dart
- [ ] Implement duration constants (fast, base, slow, overlay)
- [ ] Implement easing curve: emphasisEnter (0.2, 0.8, 0.2, 1)
- [ ] Implement easing curve: emphasisExit (0.4, 0.0, 1, 1)
- [ ] Implement easing curve: standard (0.2, 0.0, 0, 1)
- [ ] Implement easing curve: spring (0.16, 1, 0.3, 1)
- [ ] Add documentation comments for each constant
- [ ] Include cubic-bezier notation in doc comments
- [ ] Export FiftyMotion from lib/fifty_tokens.dart
- [ ] Verify control points match FDL specification exactly
- [ ] Run flutter analyze to ensure zero warnings

### In Progress
_(Empty)_

### Completed
_(Empty)_

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Begin implementing FiftyMotion class with duration constants
**Last Updated:** 2025-11-10
**Blockers:** Requires BR-001 to be completed first

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] `lib/src/motion.dart` exists with FiftyMotion class
2. [ ] All duration constants implemented (fast, base, slow, overlay)
3. [ ] All easing curves implemented (emphasisEnter, emphasisExit, standard, spring)
4. [ ] All duration values match FDL (120, 180, 240, 280 ms)
5. [ ] All cubic bezier control points match FDL exactly
6. [ ] Every constant has documentation comment with usage and values
7. [ ] Doc comments include cubic-bezier() notation for curves
8. [ ] FiftyMotion exported from main library file
9. [ ] `flutter analyze` passes with zero warnings
10. [ ] Curves work with Flutter's animation system

---

## Test Plan

### Automated Tests

**Duration Tests:**
- [ ] Unit test: Verify fast = Duration(milliseconds: 120)
- [ ] Unit test: Verify base = Duration(milliseconds: 180)
- [ ] Unit test: Verify slow = Duration(milliseconds: 240)
- [ ] Unit test: Verify overlay = Duration(milliseconds: 280)
- [ ] Unit test: All durations are positive

**Curve Tests:**
- [ ] Unit test: Verify emphasisEnter is Cubic(0.2, 0.8, 0.2, 1.0)
- [ ] Unit test: Verify emphasisExit is Cubic(0.4, 0.0, 1.0, 1.0)
- [ ] Unit test: Verify standard is Cubic(0.2, 0.0, 0.0, 1.0)
- [ ] Unit test: Verify spring is Cubic(0.16, 1.0, 0.3, 1.0)
- [ ] Unit test: All curves are non-null
- [ ] Unit test: Curve.transform(0.0) = 0.0 (start)
- [ ] Unit test: Curve.transform(1.0) = 1.0 (end)

### Manual Test Cases

#### Test Case 1: Duration Values
**Preconditions:** Motion implemented
**Steps:**
1. Read all duration values
2. Convert to milliseconds
3. Compare to FDL: 120, 180, 240, 280

**Expected Result:** Exact match
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Cubic Bezier Control Points
**Preconditions:** Motion implemented
**Steps:**
1. Verify emphasisEnter: (0.2, 0.8, 0.2, 1)
2. Verify emphasisExit: (0.4, 0.0, 1, 1)
3. Verify standard: (0.2, 0.0, 0, 1)
4. Verify spring: (0.16, 1, 0.3, 1)

**Expected Result:** Exact control point match
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 3: Curve Behavior
**Preconditions:** Motion implemented
**Steps:**
1. Test emphasisEnter curve with t=0.5
2. Verify it produces expected bounce effect
3. Test emphasisExit curve with t=0.5
4. Verify sharp deceleration

**Expected Result:** Curves behave as expected
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

### Regression Checklist
- [ ] Package still imports successfully
- [ ] No analyzer warnings introduced
- [ ] All constants compile correctly

---

## Delivery

### Code Changes
- [ ] New file: `lib/src/motion.dart`
- [ ] Modified: `lib/fifty_tokens.dart` (add FiftyMotion export)

### Motion Constants Created (8 total)

**Durations (4):**
- [ ] fast (120ms)
- [ ] base (180ms)
- [ ] slow (240ms)
- [ ] overlay (280ms)

**Easing Curves (4):**
- [ ] emphasisEnter - cubic-bezier(0.2, 0.8, 0.2, 1)
- [ ] emphasisExit - cubic-bezier(0.4, 0.0, 1, 1)
- [ ] standard - cubic-bezier(0.2, 0.0, 0, 1)
- [ ] spring - cubic-bezier(0.16, 1, 0.3, 1)

### Documentation
- [ ] Each duration has doc comment with ms value and usage
- [ ] Each curve has doc comment with cubic-bezier notation and feel
- [ ] Class-level documentation explains motion system and accessibility

---

## Notes

**Duration Rationale:**
- fast (120ms): Quick feedback, hover states, micro-interactions
- base (180ms): Default for most transitions
- slow (240ms): Deliberate, noticeable animations
- overlay (280ms): Large surfaces, modals, drawers

**Easing Curve Characteristics:**
- **emphasisEnter:** Springy, energetic entrance (overshoot effect)
- **emphasisExit:** Sharp, fast exit (quick deceleration)
- **standard:** Smooth, neutral in-out (most common)
- **spring:** Bouncy spring (playful, elastic feel)

**Cubic Bezier Notation:**
- Format: `cubic-bezier(x1, y1, x2, y2)`
- Flutter: `Cubic(x1, y1, x2, y2)`
- Control points define the curve shape between (0,0) and (1,1)

**Accessibility Considerations:**
- These tokens define the *default* motion
- Consuming code should check `MediaQuery.of(context).disableAnimations`
- When reduce motion is enabled:
  - Use `Duration.zero` instead of these durations
  - Use `Curves.linear` instead of these curves
  - Or skip animations entirely

**Common Animation Patterns (Reference):**
- Fade: `FadeTransition` with `FiftyMotion.base`
- Scale: `ScaleTransition` with `FiftyMotion.emphasisEnter`
- Slide: `SlideTransition` with `FiftyMotion.standard`
- Combined: Use `AnimationController` with multiple tweens

**Dependencies:**
- BR-001 must be completed first (package structure)
- fifty_ui will consume these for button hover, card lift, etc.
- fifty_cmd will use for command palette animations

---

**Created:** 2025-11-10
**Last Updated:** 2025-11-10
**Brief Owner:** Igris AI
