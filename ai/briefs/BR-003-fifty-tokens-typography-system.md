# BR-003: fifty_tokens Typography System Implementation

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

The typography token system does not exist. The fifty.dev brand uses a specific typographic hierarchy with three font families (Space Grotesk, Inter, JetBrains Mono) and a minor third scale. Without these tokens, text rendering will be inconsistent.

**Why does it matter?**

- Typography defines the voice and readability of the brand
- Font families must be exactly specified (Space Grotesk, Inter, JetBrains Mono)
- Type scale must follow the minor third ratio (1.25)
- Font weights, letter spacing, and line heights affect brand perception
- All UI components depend on consistent typography

---

## Goal

**What should happen after this brief is completed?**

A complete typography token system implemented in `lib/src/typography.dart` that includes:
- Font family constants (Space Grotesk, Inter, JetBrains Mono)
- Font weight tokens (400-700)
- Type scale sizes (Display XL → Caption)
- Letter spacing tokens (headings and body)
- Line height multipliers
- All values as Dart constants
- Perfect fidelity to FDL typography specification

---

## Context & Inputs

### Typography Specifications (from FDL)

**Font Families:**
- **Display / Headings:** Space Grotesk (weights: 500, 600, 700)
- **Body Text:** Inter (weights: 400, 500, 600)
- **Code / Terminal:** JetBrains Mono (weights: 400, 500)

**Type Scale (Minor Third, 1.25 ratio):**
- Display XL: 48px
- H1: 32px
- H2: 28px
- H3: 24px
- Body Large: 20px
- Body Base: 16px
- Body Small: 14px
- Caption: 12px

**Letter Spacing:**
- Headings: -0.5% to -1% (tighter)
- Body: +0.25% for small sizes (looser)

**Line Heights:**
- Display: 1.1 (tight)
- Headings: 1.2
- Body: 1.5 (comfortable reading)
- Code: 1.6 (monospace spacing)

### Implementation Pattern

```dart
/// Fifty.dev typography tokens - the voice of the brand.
///
/// Defines font families, sizes, weights, spacing, and line heights
/// following the Fifty Design Language (FDL) specification.
class FiftyTypography {
  FiftyTypography._(); // Private constructor - static class

  // Font Families
  /// Space Grotesk - Display and heading font
  static const String fontFamilyDisplay = 'Space Grotesk';

  /// Inter - Body text font
  static const String fontFamilyBody = 'Inter';

  /// JetBrains Mono - Code and terminal font
  static const String fontFamilyCode = 'JetBrains Mono';

  // Font Weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Type Scale (px values)
  static const double displayXL = 48.0;
  static const double h1 = 32.0;
  static const double h2 = 28.0;
  // ... etc
}
```

### Related Files
- `lib/src/typography.dart` - Implementation file
- `lib/fifty_tokens.dart` - Must export FiftyTypography
- `design_system/fifty_design_system.md` - Source specification
- `design_system/fifty_brand_sheet.md` - Quick reference

---

## Constraints

### Architecture Rules
- All values must be `static const`
- Font families as `String` constants
- Font sizes as `double` (logical pixels)
- Font weights using Flutter's `FontWeight` enum
- Letter spacing as percentages (converted to actual values in theme layer)
- Line heights as multipliers (unitless)
- Documentation comment for every constant

### Technical Constraints
- Font sizes must match FDL exactly (48, 32, 28, 24, 20, 16, 14, 12)
- Font families must be spelled correctly (Space Grotesk, Inter, JetBrains Mono)
- Font weights must match FDL ranges (400-700)
- Must pass `flutter analyze` with zero warnings

### Font Integration Note
- This package defines font *names* only
- Actual font files will be included in fifty_theme or app-level
- Font fallbacks handled by Flutter automatically

### Timeline
- **Deadline:** Part of Pilot 1 critical path
- **Blocks:** fifty_theme package (needs typography tokens)

### Out of Scope
- Actual font file assets (handled in consuming packages)
- TextStyle creation (handled in fifty_theme)
- Responsive typography (handled in fifty_theme)

---

## Tasks

### Pending
- [ ] Create FiftyTypography class in lib/src/typography.dart
- [ ] Implement font family constants (fontFamilyDisplay, fontFamilyBody, fontFamilyCode)
- [ ] Implement font weight constants (regular, medium, semiBold, bold)
- [ ] Implement type scale sizes (displayXL, h1, h2, h3, bodyLarge, bodyBase, bodySmall, caption)
- [ ] Implement letter spacing tokens (headingLetterSpacing, bodyLetterSpacing)
- [ ] Implement line height multipliers (displayLineHeight, headingLineHeight, bodyLineHeight, codeLineHeight)
- [ ] Add documentation comments for each constant
- [ ] Export FiftyTypography from lib/fifty_tokens.dart
- [ ] Verify values match FDL specification exactly
- [ ] Run flutter analyze to ensure zero warnings

### In Progress
_(Empty)_

### Completed
_(Empty)_

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Begin implementing FiftyTypography class with font families
**Last Updated:** 2025-11-10
**Blockers:** Requires BR-001 to be completed first

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] `lib/src/typography.dart` exists with FiftyTypography class
2. [ ] All font families implemented (fontFamilyDisplay, fontFamilyBody, fontFamilyCode)
3. [ ] All font weights implemented (regular, medium, semiBold, bold)
4. [ ] All type scale sizes implemented (8 sizes: displayXL → caption)
5. [ ] Letter spacing tokens implemented
6. [ ] Line height multipliers implemented
7. [ ] All values match FDL specification exactly
8. [ ] Every constant has documentation comment explaining usage
9. [ ] FiftyTypography exported from main library file
10. [ ] `flutter analyze` passes with zero warnings
11. [ ] Font family names spelled correctly

---

## Test Plan

### Automated Tests
- [ ] Unit test: Verify displayXL = 48.0
- [ ] Unit test: Verify h1 = 32.0
- [ ] Unit test: Verify bodyBase = 16.0
- [ ] Unit test: Verify caption = 12.0
- [ ] Unit test: Verify fontFamilyDisplay = 'Space Grotesk'
- [ ] Unit test: Verify fontFamilyBody = 'Inter'
- [ ] Unit test: Verify fontFamilyCode = 'JetBrains Mono'
- [ ] Unit test: All font weights are valid FontWeight values
- [ ] Unit test: All sizes are positive doubles
- [ ] Unit test: All line heights > 1.0

### Manual Test Cases

#### Test Case 1: Type Scale Verification
**Preconditions:** Typography implemented
**Steps:**
1. Read all type scale values
2. Compare to FDL specification (48, 32, 28, 24, 20, 16, 14, 12)

**Expected Result:** Exact match
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Font Family Spelling
**Preconditions:** Typography implemented
**Steps:**
1. Read fontFamilyDisplay
2. Verify spelling: "Space Grotesk" (with space, capital G)
3. Read fontFamilyBody
4. Verify spelling: "Inter" (capital I)
5. Read fontFamilyCode
6. Verify spelling: "JetBrains Mono" (capital J, B, M, with space)

**Expected Result:** Exact spelling match
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

#### Test Case 3: Font Weight Range
**Preconditions:** Typography implemented
**Steps:**
1. Verify regular = w400
2. Verify medium = w500
3. Verify semiBold = w600
4. Verify bold = w700

**Expected Result:** Correct weight values
**Actual Result:** [Fill during testing]
**Status:** [ ] Pass / [ ] Fail

### Regression Checklist
- [ ] Package still imports successfully
- [ ] No analyzer warnings introduced
- [ ] All constants compile as const

---

## Delivery

### Code Changes
- [ ] New file: `lib/src/typography.dart`
- [ ] Modified: `lib/fifty_tokens.dart` (add FiftyTypography export)

### Typography Constants Created

**Font Families (3):**
- [ ] fontFamilyDisplay, fontFamilyBody, fontFamilyCode

**Font Weights (4):**
- [ ] regular, medium, semiBold, bold

**Type Scale (8 sizes):**
- [ ] displayXL, h1, h2, h3, bodyLarge, bodyBase, bodySmall, caption

**Letter Spacing (2-3):**
- [ ] headingLetterSpacing, bodyLetterSpacing (negative and positive values)

**Line Heights (4):**
- [ ] displayLineHeight, headingLineHeight, bodyLineHeight, codeLineHeight

### Documentation
- [ ] Each constant has doc comment with usage and value
- [ ] Class-level documentation explains typography system

---

## Notes

**Font Family Spelling (Critical):**
- "Space Grotesk" (not "SpaceGrotesk" or "space-grotesk")
- "Inter" (capital I)
- "JetBrains Mono" (capital J, B, M with space)

**Type Scale Rationale:**
- Minor third scale: each step multiplied by 1.25
- Base size: 16px (bodyBase)
- Display: 48px (3× base)
- Caption: 12px (0.75× base)

**Letter Spacing Convention:**
- Headings: Negative spacing (-0.5% to -1%) tightens for impact
- Body: Positive spacing (+0.25%) for small sizes improves readability
- Values stored as percentages, converted to actual values in theme layer

**Line Height Multipliers:**
- Display: 1.1 (tight for visual impact)
- Headings: 1.2 (slightly tight)
- Body: 1.5 (comfortable reading)
- Code: 1.6 (monospace needs more vertical space)

**Font File Management:**
- Token package defines *names* only
- Font files (.ttf, .otf) added in fifty_theme or app
- pubspec.yaml in consuming package declares font assets

**Dependencies:**
- BR-001 must be completed first (package structure)
- fifty_theme will consume these tokens to create TextTheme

---

**Created:** 2025-11-10
**Last Updated:** 2025-11-10
**Brief Owner:** Igris AI
