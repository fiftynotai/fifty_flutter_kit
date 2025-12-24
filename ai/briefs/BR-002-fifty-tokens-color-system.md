# BR-002: fifty_tokens Color System Implementation

**Type:** Feature
**Priority:** P0-Critical
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-11-10
**Completed:** 2025-11-10
**Dependencies:** BR-001 (Package Structure) ✅

---

## Problem

**What's broken or missing?**

The color token system does not exist. The fifty.dev brand relies on a precise crimson-centered dark palette with specific surface hierarchy and semantic colors. Without these tokens, no visual consistency can be maintained across the ecosystem.

**Why does it matter?**

- Colors are the visual signature of the fifty.dev brand
- Crimson identity must be exact (`#960E29` and `#B31337`)
- Surface hierarchy is critical for dark mode design
- Semantic colors (success, warning, error) ensure usability
- All other packages depend on these color definitions

---

## Goal

**What should happen after this brief is completed?**

A complete color token system implemented in `lib/src/colors.dart` that includes:
- Primary crimson palette (base + tech variant)
- Complete surface hierarchy (Surface 0-3)
- Text colors (primary, secondary, muted)
- Border and divider colors
- Semantic state colors (success, warning, error)
- All values as Dart `Color` constants
- Perfect fidelity to the Fifty Design Language specification

---

## Context & Inputs

### Color Specifications (from FDL)

**Primary Crimson:**
- Crimson Core: `#960E29` - Base identity color
- Tech Crimson: `#B31337` - Accent for glow/focus

**Surfaces (Dark Mode Primary):**
- Surface 0: `#0E0E0F` - Background
- Surface 1: `#161617` - Card base
- Surface 2: `#1D1D1F` - Panel
- Surface 3: `rgba(255,255,255,0.03)` - Floating layer (translucent)

**Borders & Dividers:**
- Border: `#2C2C2E` - Outlines
- Divider: `#3A3A3C` - Subtle separators

**Text:**
- Text Primary: `#FFFFFF` - Headings
- Text Secondary: `#E5E5E7` - Body text
- Muted: `#9E9EA0` - Captions

**Semantic (State Colors):**
- Success: `#00BA33` - Positive actions
- Warning: `#F7A100` - Alerts
- Error: `#B31337` - Destructive actions (same as Tech Crimson)

### Implementation Pattern

```dart
import 'package:flutter/material.dart';

/// Fifty.dev color tokens - the visual signature of the brand.
///
/// All colors follow the Fifty Design Language (FDL) specification.
/// Dark mode is the primary environment.
class FiftyColors {
  FiftyColors._(); // Private constructor - static class

  // Primary Crimson
  /// Crimson Core (#960E29) - The brand's primary identity color
  static const Color crimsonCore = Color(0xFF960E29);

  /// Tech Crimson (#B31337) - Accent for glow, focus rings, CMD prompts
  static const Color techCrimson = Color(0xFFB31337);

  // ... etc
}
```

### Related Files
- `lib/src/colors.dart` - Implementation file
- `lib/fifty_tokens.dart` - Must export FiftyColors
- `design_system/fifty_design_system.md` - Source specification
- `design_system/fifty_brand_sheet.md` - Quick reference

---

## Constraints

### Architecture Rules
- All colors must be `static const Color`
- No logic, no computation, pure constants
- Use Flutter's `Color` class (from `package:flutter/material.dart`)
- Documentation comment for every color explaining usage
- Hex values must match FDL exactly

### Technical Constraints
- Hex to `Color(0xFFRRGGBB)` conversion must be accurate
- Surface 3 uses alpha channel: `Color(0x08FFFFFF)` (3% opacity)
- Colors must work in dark mode (primary environment)
- Must pass `flutter analyze` with zero warnings

### Color Accuracy Requirements
- **CRITICAL:** Crimson Core must be exactly `#960E29`
- **CRITICAL:** Tech Crimson must be exactly `#B31337`
- All hex values must match design system specification
- No approximations or "close enough" values

### Timeline
- **Deadline:** Part of Pilot 1 critical path
- **Blocks:** BR-006 (needs colors for shadows), fifty_theme package

### Out of Scope
- Color generation or manipulation logic
- Theme integration (handled in fifty_theme)
- Light mode variants (future enhancement)

---

## Tasks

### Pending
- [ ] Create FiftyColors class in lib/src/colors.dart
- [ ] Implement primary crimson colors (crimsonCore, techCrimson)
- [ ] Implement surface colors (surface0, surface1, surface2, surface3)
- [ ] Implement border and divider colors
- [ ] Implement text colors (textPrimary, textSecondary, muted)
- [ ] Implement semantic colors (success, warning, error)
- [ ] Add documentation comments for each color
- [ ] Export FiftyColors from lib/fifty_tokens.dart
- [ ] Verify hex values match FDL specification exactly
- [ ] Run flutter analyze to ensure zero warnings

### In Progress
_(Empty)_

### Completed
_(Empty)_

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Begin implementing FiftyColors class with primary crimson values
**Last Updated:** 2025-11-10
**Blockers:** Requires BR-001 to be completed first

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] `lib/src/colors.dart` exists with FiftyColors class
2. [ ] All primary colors implemented (crimsonCore, techCrimson)
3. [ ] All surface colors implemented (surface0-3)
4. [ ] All text colors implemented (textPrimary, textSecondary, muted)
5. [ ] All border colors implemented (border, divider)
6. [ ] All semantic colors implemented (success, warning, error)
7. [ ] All hex values match FDL specification exactly
8. [ ] Every color has documentation comment explaining usage
9. [ ] FiftyColors exported from main library file
10. [ ] `flutter analyze` passes with zero warnings
11. [ ] Manual hex verification completed (crimson values are critical)

---

## Test Plan

### Automated Tests
- [ ] Unit test: Verify crimsonCore = `Color(0xFF960E29)`
- [ ] Unit test: Verify techCrimson = `Color(0xFFB31337)`
- [ ] Unit test: Verify surface3 has alpha channel (translucent)
- [ ] Unit test: All colors are non-null
- [ ] Unit test: All colors are const

### Manual Test Cases

#### Test Case 1: Crimson Core Accuracy
**Preconditions:** Colors implemented
**Steps:**
1. Read `FiftyColors.crimsonCore` value
2. Convert to hex string
3. Compare to `#960E29`

**Expected Result:** Exact match
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Tech Crimson Accuracy
**Preconditions:** Colors implemented
**Steps:**
1. Read `FiftyColors.techCrimson` value
2. Convert to hex string
3. Compare to `#B31337`

**Expected Result:** Exact match
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 3: Surface 3 Alpha Channel
**Preconditions:** Colors implemented
**Steps:**
1. Read `FiftyColors.surface3` alpha value
2. Calculate opacity percentage
3. Verify ~3% opacity

**Expected Result:** Alpha = 0x08 (~3%)
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

### Regression Checklist
- [ ] Package still imports successfully
- [ ] No analyzer warnings introduced
- [ ] All colors compile as const

---

## Delivery

### Code Changes
- [ ] New file: `lib/src/colors.dart`
- [ ] Modified: `lib/fifty_tokens.dart` (add FiftyColors export)

### Color Constants Created
- [ ] crimsonCore, techCrimson
- [ ] surface0, surface1, surface2, surface3
- [ ] border, divider
- [ ] textPrimary, textSecondary, muted
- [ ] success, warning, error

### Documentation
- [ ] Each color has doc comment with hex value and usage
- [ ] Class-level documentation explains color system

---

## Notes

**Hex to Dart Conversion:**
- Hex `#960E29` → Dart `Color(0xFF960E29)`
- Hex `#B31337` → Dart `Color(0xFFB31337)`
- Format: `0xFF` prefix + 6-digit hex (RRGGBB)

**Surface 3 Special Case:**
- Design spec: `rgba(255,255,255,0.03)`
- Dart equivalent: `Color(0x08FFFFFF)` (alpha = 0x08 ≈ 3%)

**Crimson Usage Philosophy (from FDL):**
- ≤15% in UI (accent, not dominant)
- Glow effects, focus rings, highlights
- CMD prompt signature color

**Color Naming Convention:**
- camelCase (e.g., `crimsonCore`, not `CrimsonCore`)
- Descriptive (e.g., `techCrimson`, not `crimson2`)
- Semantic for state colors (e.g., `success`, not `green`)

**Dependencies:**
- BR-001 must be completed first (package structure)
- BR-006 depends on this brief (needs colors for shadow definitions)
- fifty_theme package will depend on these tokens

---

**Created:** 2025-11-10
**Last Updated:** 2025-11-10
**Brief Owner:** Igris AI
