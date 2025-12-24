# BR-004: fifty_tokens Spacing & Radii System Implementation

**Type:** Feature
**Priority:** P0-Critical
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

The spacing and border radius token systems do not exist. The fifty.dev design follows an 8px-based spacing grid with specific radius values for different UI elements. Without these tokens, layout consistency and visual rhythm cannot be maintained.

**Why does it matter?**

- Spacing creates visual rhythm and breathing room in the UI
- 8px base grid ensures alignment and consistency
- Border radii define the softness of the UI elements
- All components need consistent spacing and shape values
- Critical for responsive layout and gutters

---

## Goal

**What should happen after this brief is completed?**

Complete spacing and radii token systems implemented in:
- `lib/src/spacing.dart` - Spacing scale and responsive gutters
- `lib/src/radii.dart` - Border radius tokens and BorderRadius objects

Both systems must have:
- All values as Dart constants
- Spacing scale: 2, 4, 8, 12, 16, 20, 24, 32, 40, 48 px
- Radii: xs(4), sm(6), md(10), lg(16), full(999) px
- BorderRadius objects for convenience
- Responsive gutter values for breakpoints
- Perfect fidelity to FDL specification

---

## Context & Inputs

### Spacing Specifications (from FDL)

**Spacing Scale (8px base grid):**
- micro: 2px (fine-tuning)
- xs: 4px (minimal gap)
- sm: 8px (base unit)
- md: 12px (small spacing)
- lg: 16px (medium spacing)
- xl: 20px (large spacing)
- xxl: 24px (section spacing)
- xxxl: 32px (major sections)
- huge: 40px (hero spacing)
- massive: 48px (page-level spacing)

**Responsive Gutters:**
- Desktop: 24px
- Tablet: 16px
- Mobile: 12px

### Radii Specifications (from FDL)

**Border Radius Values:**
- xs: 4px (subtle rounding)
- sm: 6px (buttons, inputs)
- md: 10px (cards)
- lg: 16px (panels, modals)
- full: 999px (pills, circles)

### Implementation Pattern

```dart
/// Fifty.dev spacing tokens - 8px-based grid system.
///
/// All spacing follows the Fifty Design Language (FDL) specification.
/// Based on an 8px grid with fine-tuning for micro adjustments.
class FiftySpacing {
  FiftySpacing._(); // Private constructor - static class

  /// Micro spacing (2px) - Fine-tuning
  static const double micro = 2.0;

  /// Extra small spacing (4px) - Minimal gap
  static const double xs = 4.0;

  // ... etc

  // Responsive Gutters
  /// Desktop gutter (24px)
  static const double gutterDesktop = 24.0;

  /// Tablet gutter (16px)
  static const double gutterTablet = 16.0;

  /// Mobile gutter (12px)
  static const double gutterMobile = 12.0;
}
```

```dart
import 'package:flutter/material.dart';

/// Fifty.dev border radius tokens - shape system.
///
/// Defines border radius values and BorderRadius objects
/// following the Fifty Design Language (FDL) specification.
class FiftyRadii {
  FiftyRadii._(); // Private constructor - static class

  // Raw values (px)
  /// Extra small radius (4px) - Subtle rounding
  static const double xs = 4.0;

  /// Small radius (6px) - Buttons, inputs
  static const double sm = 6.0;

  // ... etc

  // BorderRadius objects for convenience
  /// BorderRadius for extra small radius (4px)
  static final BorderRadius xsRadius = BorderRadius.circular(xs);

  /// BorderRadius for small radius (6px)
  static final BorderRadius smRadius = BorderRadius.circular(sm);

  // ... etc
}
```

### Related Files
- `lib/src/spacing.dart` - Spacing implementation
- `lib/src/radii.dart` - Radii implementation
- `lib/fifty_tokens.dart` - Must export both classes
- `design_system/fifty_design_system.md` - Source specification

---

## Constraints

### Architecture Rules
- All spacing values must be `static const double`
- All radius values must be `static const double`
- BorderRadius objects use `static final` (not const, due to circular() call)
- No logic, pure constants
- Documentation comment for every constant
- Values in logical pixels (double)

### Technical Constraints
- Spacing scale must follow 8px base grid exactly
- Radii values must match FDL specification
- Gutter values for desktop/tablet/mobile must be accurate
- Must pass `flutter analyze` with zero warnings
- BorderRadius objects must use the raw radius values

### Design Rationale
- 8px base grid provides consistent visual rhythm
- Smaller values (2px, 4px) allow fine-tuning
- Larger values follow multiples of 8 (16, 24, 32, 40, 48)
- Radii progress from subtle (4px) to fully rounded (999px)

### Timeline
- **Deadline:** Part of Pilot 1 critical path
- **Blocks:** fifty_ui components (need spacing and radii)

### Out of Scope
- Responsive logic (handled in theme layer)
- EdgeInsets creation (handled in consuming code)
- Dynamic spacing calculations

---

## Tasks

### Pending
- [ ] Create FiftySpacing class in lib/src/spacing.dart
- [ ] Implement spacing scale (micro, xs, sm, md, lg, xl, xxl, xxxl, huge, massive)
- [ ] Implement responsive gutters (gutterDesktop, gutterTablet, gutterMobile)
- [ ] Add documentation comments for spacing constants
- [ ] Create FiftyRadii class in lib/src/radii.dart
- [ ] Implement radius values (xs, sm, md, lg, full)
- [ ] Implement BorderRadius objects (xsRadius, smRadius, mdRadius, lgRadius, fullRadius)
- [ ] Add documentation comments for radii constants
- [ ] Export FiftySpacing and FiftyRadii from lib/fifty_tokens.dart
- [ ] Verify all values match FDL specification
- [ ] Run flutter analyze to ensure zero warnings

### In Progress
_(Empty)_

### Completed
_(Empty)_

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Begin implementing FiftySpacing class with spacing scale
**Last Updated:** 2025-11-10
**Blockers:** Requires BR-001 to be completed first

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] `lib/src/spacing.dart` exists with FiftySpacing class
2. [ ] All spacing scale values implemented (10 values: micro → massive)
3. [ ] All responsive gutters implemented (desktop, tablet, mobile)
4. [ ] `lib/src/radii.dart` exists with FiftyRadii class
5. [ ] All radius values implemented (xs, sm, md, lg, full)
6. [ ] All BorderRadius objects implemented (5 objects)
7. [ ] All values match FDL specification exactly
8. [ ] Every constant has documentation comment explaining usage
9. [ ] Both classes exported from main library file
10. [ ] `flutter analyze` passes with zero warnings
11. [ ] BorderRadius objects use correct raw values

---

## Test Plan

### Automated Tests

**Spacing Tests:**
- [ ] Unit test: Verify micro = 2.0
- [ ] Unit test: Verify xs = 4.0
- [ ] Unit test: Verify sm = 8.0
- [ ] Unit test: Verify massive = 48.0
- [ ] Unit test: Verify gutterDesktop = 24.0
- [ ] Unit test: Verify gutterTablet = 16.0
- [ ] Unit test: Verify gutterMobile = 12.0
- [ ] Unit test: All spacing values are positive
- [ ] Unit test: Spacing scale is ascending

**Radii Tests:**
- [ ] Unit test: Verify xs = 4.0
- [ ] Unit test: Verify sm = 6.0
- [ ] Unit test: Verify full = 999.0
- [ ] Unit test: Verify xsRadius.topLeft.x = 4.0
- [ ] Unit test: Verify smRadius.topLeft.x = 6.0
- [ ] Unit test: All radius values are positive
- [ ] Unit test: All BorderRadius objects are non-null

### Manual Test Cases

#### Test Case 1: Spacing Scale Verification
**Preconditions:** Spacing implemented
**Steps:**
1. Read all spacing values
2. Compare to FDL: 2, 4, 8, 12, 16, 20, 24, 32, 40, 48

**Expected Result:** Exact match
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Radii Values Verification
**Preconditions:** Radii implemented
**Steps:**
1. Read all radius values
2. Compare to FDL: 4, 6, 10, 16, 999

**Expected Result:** Exact match
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 3: BorderRadius Objects
**Preconditions:** Radii implemented
**Steps:**
1. Verify xsRadius uses xs value (4.0)
2. Verify smRadius uses sm value (6.0)
3. Verify all corners equal (circular)

**Expected Result:** BorderRadius objects use correct values
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

### Regression Checklist
- [ ] Package still imports successfully
- [ ] No analyzer warnings introduced
- [ ] All constants compile correctly

---

## Delivery

### Code Changes
- [ ] New file: `lib/src/spacing.dart`
- [ ] New file: `lib/src/radii.dart`
- [ ] Modified: `lib/fifty_tokens.dart` (add exports)

### Spacing Constants Created (13 total)
- [ ] micro, xs, sm, md, lg, xl, xxl, xxxl, huge, massive (10 scale values)
- [ ] gutterDesktop, gutterTablet, gutterMobile (3 responsive values)

### Radii Constants Created (10 total)
- [ ] xs, sm, md, lg, full (5 raw values)
- [ ] xsRadius, smRadius, mdRadius, lgRadius, fullRadius (5 BorderRadius objects)

### Documentation
- [ ] Each spacing constant has doc comment with value and usage
- [ ] Each radius constant has doc comment with value and usage
- [ ] Class-level documentation explains system

---

## Notes

**8px Base Grid Philosophy:**
- Base unit: 8px (sm)
- Micro adjustments: 2px, 4px (for fine-tuning)
- Standard progression: 8, 16, 24, 32, 40, 48
- Intermediate values: 12px, 20px (for flexibility)

**Radii Usage Patterns:**
- xs (4px): Subtle rounding, minimal softness
- sm (6px): Buttons, inputs, small elements
- md (10px): Cards, containers
- lg (16px): Panels, modals, large surfaces
- full (999px): Pills, avatars, circular elements

**BorderRadius Objects Rationale:**
- Convenience for common use case: `BorderRadius.circular(value)`
- Saves repetition in consuming code
- Example: `decoration: BoxDecoration(borderRadius: FiftyRadii.mdRadius)`

**Responsive Gutters Usage:**
- Desktop (>= 1024px): 24px gutter
- Tablet (>= 768px): 16px gutter
- Mobile (< 768px): 12px gutter
- Theme layer will apply based on screen width

**Naming Convention:**
- Spacing: micro, xs, sm, md, lg, xl, xxl, xxxl, huge, massive
- Radii: xs, sm, md, lg, full
- Consistent naming for cognitive ease

**Dependencies:**
- BR-001 must be completed first (package structure)
- fifty_ui components will consume these tokens
- fifty_theme will use for default widget spacing

---

**Created:** 2025-11-10
**Last Updated:** 2025-11-10
**Brief Owner:** Igris AI
