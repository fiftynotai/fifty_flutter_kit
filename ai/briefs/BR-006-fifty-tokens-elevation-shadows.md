# BR-006: fifty_tokens Elevation & Shadow System Implementation

**Type:** Feature
**Priority:** P1-High
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-11-10
**Completed:** 2025-11-10
**Dependencies:** BR-001 (Package Structure) ✅, BR-002 (Color Tokens) ✅

---

## Problem

**What's broken or missing?**

The elevation and shadow token system does not exist. The fifty.dev brand uses specific shadow effects (ambient shadows and crimson glow) to create depth and focus. Without these tokens, UI elements will lack the signature glow effect.

**Why does it matter?**

- Shadows create depth and visual hierarchy
- Crimson glow is a brand signature (focus rings, highlights)
- Ambient shadows provide subtle elevation
- Components need consistent shadow definitions
- Focus states require the tech crimson glow

---

## Goal

**What should happen after this brief is completed?**

A complete elevation token system implemented in `lib/src/shadows.dart` that includes:
- Ambient shadow BoxShadow definition (black, soft blur)
- Crimson glow BoxShadow definition (tech crimson, signature effect)
- Focus ring BoxShadow (for accessibility and emphasis)
- List<BoxShadow> combinations for common patterns
- Breakpoint tokens (responsive design)
- All values as Dart constants
- Perfect fidelity to FDL specification

---

## Context & Inputs

### Shadow Specifications (from FDL)

**Ambient Shadow:**
- Color: `rgba(0,0,0,0.3)` - Black with 30% opacity
- Blur: 12px
- Offset: 0, 0 (no offset, centered glow)
- Usage: Subtle elevation, floating cards

**Crimson Glow:**
- Color: `rgba(150,14,41,0.45)` - Crimson Core with 45% opacity
- Blur: 8px
- Offset: 0, 0 (centered glow)
- Usage: Focus rings, hover states, CMD prompt glow

**Focus Ring (Accessibility):**
- Color: Tech Crimson (#B31337) with some transparency
- Blur: 4px
- Offset: 0, 0
- Usage: Keyboard focus indicators, active elements

### Breakpoint Specifications (from FDL)

**Responsive Breakpoints:**
- mobile: < 768px (gutters: 12px)
- tablet: >= 768px (gutters: 16px)
- desktop: >= 1024px (gutters: 24px)

### Implementation Pattern

```dart
import 'package:flutter/material.dart';
import 'colors.dart'; // Import FiftyColors for crimson glow

/// Fifty.dev elevation tokens - shadows and glows.
///
/// Defines BoxShadow effects following the Fifty Design Language (FDL).
/// Includes ambient shadows and signature crimson glow.
class FiftyElevation {
  FiftyElevation._(); // Private constructor - static class

  /// Ambient shadow - Subtle elevation effect
  /// rgba(0,0,0,0.3), blur: 12px
  static final BoxShadow ambient = BoxShadow(
    color: Color(0x4D000000), // 30% opacity black
    blurRadius: 12.0,
    offset: Offset.zero,
  );

  /// Crimson glow - Brand signature glow effect
  /// Uses Crimson Core with 45% opacity, blur: 8px
  static final BoxShadow crimsonGlow = BoxShadow(
    color: FiftyColors.crimsonCore.withOpacity(0.45),
    blurRadius: 8.0,
    offset: Offset.zero,
  );

  // ... etc

  // Common combinations
  /// Card elevation - Ambient shadow only
  static final List<BoxShadow> card = [ambient];

  /// Focus state - Crimson glow + ambient
  static final List<BoxShadow> focus = [crimsonGlow, ambient];

  // ... etc
}
```

```dart
/// Fifty.dev breakpoint tokens - responsive design.
///
/// Defines breakpoint widths and responsive gutters
/// following the Fifty Design Language (FDL).
class FiftyBreakpoints {
  FiftyBreakpoints._(); // Private constructor - static class

  /// Mobile breakpoint (< 768px)
  static const double mobile = 768.0;

  /// Tablet breakpoint (>= 768px)
  static const double tablet = 768.0;

  /// Desktop breakpoint (>= 1024px)
  static const double desktop = 1024.0;

  // Gutters defined in spacing.dart
}
```

### Related Files
- `lib/src/shadows.dart` - Shadow/elevation implementation
- `lib/src/breakpoints.dart` - Breakpoint implementation
- `lib/src/colors.dart` - Imports FiftyColors for crimson
- `lib/fifty_tokens.dart` - Must export both classes
- `design_system/fifty_design_system.md` - Source specification

---

## Constraints

### Architecture Rules
- BoxShadow uses `static final` (not const, due to Color operations)
- Shadow lists use `static final`
- Breakpoint values use `static const double`
- Import colors from colors.dart for crimson glow
- Documentation comment for every constant
- Include rgba notation in doc comments

### Technical Constraints
- Shadow values must match FDL specification
- Crimson glow uses `FiftyColors.crimsonCore.withOpacity(0.45)`
- Ambient uses `Color(0x4D000000)` (30% opacity black)
- Breakpoint values: 768px, 1024px
- Must pass `flutter analyze` with zero warnings

### Design Rationale
- Ambient shadow provides subtle depth
- Crimson glow is the brand's signature visual effect
- Focus ring ensures accessibility compliance
- Combined shadow lists reduce boilerplate

### Timeline
- **Deadline:** Part of Pilot 1 critical path
- **Blocks:** fifty_ui components (need shadows for cards, buttons)

### Out of Scope
- Responsive logic (handled in theme layer)
- Shadow animation (handled in consuming code)
- Platform-specific elevation mapping

---

## Tasks

### Pending
- [ ] Create FiftyElevation class in lib/src/shadows.dart
- [ ] Import FiftyColors for crimson reference
- [ ] Implement ambient shadow BoxShadow (black, 30%, blur: 12)
- [ ] Implement crimsonGlow BoxShadow (crimson core, 45%, blur: 8)
- [ ] Implement focusRing BoxShadow (tech crimson, blur: 4)
- [ ] Implement combined shadow lists (card, focus, hoverCard, etc.)
- [ ] Add documentation comments for each shadow
- [ ] Create FiftyBreakpoints class in lib/src/breakpoints.dart
- [ ] Implement breakpoint constants (mobile, tablet, desktop)
- [ ] Add documentation comments for breakpoints
- [ ] Export FiftyElevation and FiftyBreakpoints from lib/fifty_tokens.dart
- [ ] Verify shadow values match FDL specification
- [ ] Run flutter analyze to ensure zero warnings

### In Progress
_(Empty)_

### Completed
_(Empty)_

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Begin implementing FiftyElevation class with ambient shadow
**Last Updated:** 2025-11-10
**Blockers:** Requires BR-001 (structure) and BR-002 (colors) to be completed first

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] `lib/src/shadows.dart` exists with FiftyElevation class
2. [ ] Ambient shadow implemented (black, 30%, blur: 12px)
3. [ ] Crimson glow implemented (crimson core, 45%, blur: 8px)
4. [ ] Focus ring implemented (tech crimson, blur: 4px)
5. [ ] Combined shadow lists implemented (card, focus, hoverCard)
6. [ ] `lib/src/breakpoints.dart` exists with FiftyBreakpoints class
7. [ ] All breakpoint values implemented (mobile: 768, desktop: 1024)
8. [ ] All values match FDL specification exactly
9. [ ] Every constant has documentation comment with rgba/values
10. [ ] Both classes exported from main library file
11. [ ] `flutter analyze` passes with zero warnings
12. [ ] Crimson glow uses FiftyColors.crimsonCore reference

---

## Test Plan

### Automated Tests

**Shadow Tests:**
- [ ] Unit test: Verify ambient.color = Color(0x4D000000)
- [ ] Unit test: Verify ambient.blurRadius = 12.0
- [ ] Unit test: Verify crimsonGlow uses FiftyColors.crimsonCore
- [ ] Unit test: Verify crimsonGlow.blurRadius = 8.0
- [ ] Unit test: Verify focusRing uses FiftyColors.techCrimson
- [ ] Unit test: Verify card list contains ambient
- [ ] Unit test: Verify focus list contains crimsonGlow and ambient
- [ ] Unit test: All BoxShadow objects are non-null

**Breakpoint Tests:**
- [ ] Unit test: Verify mobile = 768.0
- [ ] Unit test: Verify tablet = 768.0
- [ ] Unit test: Verify desktop = 1024.0
- [ ] Unit test: All breakpoints are positive

### Manual Test Cases

#### Test Case 1: Ambient Shadow Values
**Preconditions:** Shadows implemented
**Steps:**
1. Read ambient shadow color
2. Verify rgba(0,0,0,0.3) → Color(0x4D000000)
3. Verify blur = 12.0
4. Verify offset = (0,0)

**Expected Result:** Exact match to FDL
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Crimson Glow Values
**Preconditions:** Shadows implemented
**Steps:**
1. Read crimsonGlow shadow color
2. Verify uses FiftyColors.crimsonCore.withOpacity(0.45)
3. Verify blur = 8.0
4. Verify offset = (0,0)

**Expected Result:** Crimson glow matches FDL
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 3: Combined Shadow Lists
**Preconditions:** Shadows implemented
**Steps:**
1. Verify card list has 1 shadow (ambient)
2. Verify focus list has 2 shadows (crimsonGlow + ambient)
3. Verify order: glow first, ambient second

**Expected Result:** Lists contain correct shadows in order
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 4: Breakpoint Values
**Preconditions:** Breakpoints implemented
**Steps:**
1. Verify mobile = 768.0
2. Verify desktop = 1024.0

**Expected Result:** Match FDL breakpoints
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

### Regression Checklist
- [ ] Package still imports successfully
- [ ] No analyzer warnings introduced
- [ ] Color tokens still accessible
- [ ] All constants compile correctly

---

## Delivery

### Code Changes
- [ ] New file: `lib/src/shadows.dart`
- [ ] New file: `lib/src/breakpoints.dart`
- [ ] Modified: `lib/fifty_tokens.dart` (add exports)

### Shadow Constants Created (6-8)
- [ ] ambient (BoxShadow)
- [ ] crimsonGlow (BoxShadow)
- [ ] focusRing (BoxShadow)
- [ ] card (List<BoxShadow>)
- [ ] focus (List<BoxShadow>)
- [ ] hoverCard (optional - List<BoxShadow>)

### Breakpoint Constants Created (3)
- [ ] mobile (768.0)
- [ ] tablet (768.0)
- [ ] desktop (1024.0)

### Documentation
- [ ] Each shadow has doc comment with rgba notation and usage
- [ ] Each shadow list has doc comment explaining composition
- [ ] Each breakpoint has doc comment with pixel value and usage
- [ ] Class-level documentation explains elevation system

---

## Notes

**RGBA to Dart Color Conversion:**
- `rgba(0,0,0,0.3)` → `Color(0x4D000000)` (0x4D = 30% opacity)
- `rgba(150,14,41,0.45)` → `FiftyColors.crimsonCore.withOpacity(0.45)`
- Format: `0xAARRGGBB` where AA = alpha (opacity)

**Shadow Layering:**
- Multiple shadows render in list order
- Glow effects should be listed first (on top)
- Ambient shadows listed last (bottom layer)
- Example: `[crimsonGlow, ambient]` renders glow on top

**Crimson Glow Philosophy (from FDL):**
- Signature visual effect of the brand
- Used sparingly (≤15% in UI)
- Applied to: focus states, hover, active elements, CMD prompt
- Creates "engineered glow" aesthetic

**Breakpoint Usage:**
- Mobile: < 768px (small screens, phones)
- Tablet: 768px - 1023px (medium screens, tablets)
- Desktop: >= 1024px (large screens, desktops)
- Consuming code uses `MediaQuery` to detect screen width

**Shadow Performance Note:**
- BoxShadow with blur is GPU-accelerated in Flutter
- Multiple shadows have minimal performance impact
- Avoid excessive shadow blur values (> 20px)

**Common Shadow Patterns:**
- **Card:** Subtle ambient elevation
- **Focus:** Crimson glow + ambient (accessibility + brand)
- **Hover Card:** Slightly stronger ambient (or ambient + faint glow)
- **Modal/Overlay:** Strong ambient shadow for depth

**Dependencies:**
- BR-001 must be completed first (package structure)
- BR-002 must be completed first (color tokens for crimson)
- fifty_ui will consume these for buttons, cards, inputs

---

**Created:** 2025-11-10
**Last Updated:** 2025-11-10
**Brief Owner:** Igris AI
