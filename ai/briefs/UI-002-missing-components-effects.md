# UI-002: Missing Components & Kinetic Effects

**Type:** Feature
**Priority:** P1-High
**Effort:** L-Large (3-5d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2025-12-25
**Completed:** —

---

## Problem

**What's broken or missing?**

The `definition.md` specification defines several components and effects that were not implemented in the initial fifty_ui release:

1. **Missing Components:**
   - `FiftyNavBar` - Dynamic Island / Command Deck with glassmorphism
   - `FiftyCodeBlock` - Syntax highlighter for code display
   - `FiftyHero` - Monument text headers with dramatic typography

2. **Missing Effects:**
   - `kinetic_effect.dart` - Reusable hover/scale/press wrapper
   - `glitch_effect.dart` - RGB chromatic aberration shader
   - Halftone texture asset for card backgrounds

3. **Missing Dependencies:**
   - `flutter_animate` for kinetic motion
   - `glass_kit` for glassmorphism effects

**Why does it matter?**

- Incomplete implementation of FDL specification
- Missing signature "Kinetic Brutalism" effects
- Cannot build full FDL-compliant interfaces

---

## Goal

**What should happen after this brief is completed?**

1. All components from `definition.md` are implemented
2. Kinetic effects (glitch, scale, hover) are available as utilities
3. `flutter_animate` integrated for smooth animations
4. Glassmorphism available for FiftyNavBar

---

## Components to Implement

### A. FiftyNavBar (The Command Deck)

**Concept:** Floating "Dynamic Island" HUD

**Design:**
- Container: Glassmorphism (Blur 20px) + Black Opacity 50%
- Shape: Pill
- Items: Text-only or Icon-only
- Selection: Active item gets Crimson underbar `_`

**Properties:**
```dart
FiftyNavBar({
  required List<FiftyNavItem> items,
  required int selectedIndex,
  required ValueChanged<int> onItemSelected,
  FiftyNavBarStyle style = FiftyNavBarStyle.pill,
})
```

### B. FiftyCodeBlock (Syntax Highlighter)

**Concept:** Terminal-style code display

**Design:**
- Background: VoidBlack or Gunmetal
- Border: HyperChrome 10% opacity
- Line numbers: Optional, in HyperChrome
- Syntax colors: Crimson (keywords), IgrisGreen (strings), HyperChrome (comments)

**Properties:**
```dart
FiftyCodeBlock({
  required String code,
  String language = 'dart',
  bool showLineNumbers = true,
  bool copyButton = true,
})
```

### C. FiftyHero (Monument Headers)

**Concept:** Dramatic headline text with Monument Extended font

**Design:**
- Text: ALL CAPS, Monument Extended
- Size: 64px (display) / 48px (h1) / 32px (h2)
- Optional: Glitch effect on mount
- Optional: Gradient fill (Crimson to HyperChrome)

**Properties:**
```dart
FiftyHero({
  required String text,
  FiftyHeroSize size = FiftyHeroSize.display,
  bool glitchOnMount = false,
  Gradient? gradient,
})
```

---

## Effects to Implement

### D. KineticEffect Wrapper

**Concept:** Reusable hover/press animation wrapper

**Features:**
- Scale on hover (1.02)
- Scale on press (0.95)
- Configurable durations
- Respects reduced-motion

```dart
KineticEffect({
  required Widget child,
  double hoverScale = 1.02,
  double pressScale = 0.95,
  Duration duration = FiftyMotion.fast,
  VoidCallback? onTap,
})
```

### E. GlitchEffect Shader

**Concept:** RGB chromatic aberration on hover

**Features:**
- RGB channel split (2-4px offset)
- Triggers on hover or configurable
- Uses CustomPainter or shader
- Respects reduced-motion

```dart
GlitchEffect({
  required Widget child,
  double intensity = 1.0,
  bool triggerOnHover = true,
})
```

### F. Halftone Texture Asset

**Concept:** Dot pattern overlay for cards

**Implementation:**
- Create `assets/textures/halftone_pattern.png`
- 5% opacity overlay
- Repeatable pattern

---

## Dependencies to Add

```yaml
dependencies:
  flutter_animate: ^4.5.0
  glass_kit: ^4.0.0  # or backdrop_filter approach
```

---

## Tasks

### Pending
- [ ] Task 1: Add flutter_animate and glass_kit dependencies
- [ ] Task 2: Create halftone texture asset
- [ ] Task 3: Implement KineticEffect wrapper utility
- [ ] Task 4: Implement GlitchEffect shader/painter
- [ ] Task 5: Implement FiftyNavBar with glassmorphism
- [ ] Task 6: Implement FiftyCodeBlock with syntax highlighting
- [ ] Task 7: Implement FiftyHero with monument typography
- [ ] Task 8: Write tests for all new components
- [ ] Task 9: Update barrel exports
- [ ] Task 10: Update example app with new components

### In Progress
_(None yet)_

### Completed
_(None yet)_

---

## Session State (Tactical - This Brief)

**Current State:** Building phase - ARTISAN (coder) implementing components
**Next Steps When Resuming:** Continue with coder implementation
**Last Updated:** 2025-12-25
**Blockers:** None

### Workflow State
- **Phase:** COMMITTING
- **Active Agent:** none
- **Retry Count:** 0

### Agent Log
- [2025-12-25 INIT] Brief registered: UI-002
- [2025-12-25 BUILDING] Invoking ARTISAN (coder in UI mode)...
- [2025-12-25 BUILDING] ARTISAN complete - 9 files created, 69 tests added
- [2025-12-25 TESTING] Invoking SENTINEL (tester)...
- [2025-12-25 TESTING] PASS - 164/164 tests passing
- [2025-12-25 REVIEWING] Invoking WATCHER (reviewer)...
- [2025-12-25 REVIEWING] APPROVE - 9/10, ready for commit
- [2025-12-25 COMMITTING] Creating commit...

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] FiftyNavBar renders with glassmorphism effect
2. [ ] FiftyCodeBlock displays code with syntax highlighting
3. [ ] FiftyHero displays monument-style headlines
4. [ ] KineticEffect provides hover/press animations
5. [ ] GlitchEffect provides RGB split effect
6. [ ] Halftone texture asset exists and works in FiftyCard
7. [ ] flutter_animate integrated properly
8. [ ] All new components have tests
9. [ ] `dart analyze` passes
10. [ ] `flutter test` passes
11. [ ] Example app showcases all new components

---

## Test Plan

### Automated Tests
- [ ] Widget test: FiftyNavBar renders, selection works
- [ ] Widget test: FiftyCodeBlock renders code
- [ ] Widget test: FiftyHero renders with correct style
- [ ] Widget test: KineticEffect applies animations
- [ ] Widget test: GlitchEffect triggers on hover

---

**Created:** 2025-12-25
**Last Updated:** 2025-12-25
**Brief Owner:** Igris AI
