# Implementation Plan: BR-008

**Brief:** BR-008 - Fifty Tokens Design System Alignment
**Complexity:** L (Large)
**Estimated Duration:** 4-6 hours
**Risk Level:** Medium
**Created:** 2025-12-25

---

## Summary

Complete rewrite of the fifty_tokens package to align with the updated Fifty Design Language (FDL) specification. This is a BREAKING CHANGE affecting colors, typography, radii, motion, shadows, and spacing.

---

## Gap Analysis: Current vs FDL Specification

### Colors - MAJOR CHANGES

| FDL Spec | Current Implementation | Gap |
|----------|----------------------|-----|
| `VOID_BLACK` #050505 | `surface0` #0E0E0F | Different color + name |
| `CRIMSON_PULSE` #960E29 | `crimsonCore` #960E29 | Name change only |
| `GUNMETAL` #1A1A1A | `surface1` #161617 | Different color + name |
| `TERMINAL_WHITE` #EAEAEA | `textPrimary` #FFFFFF | Different color + name |
| `HYPER_CHROME` #888888 | `muted` #9E9EA0 | Different color + name |
| `IGRIS_GREEN` #00FF41 | N/A | **NEW TOKEN** |

### Typography - MAJOR CHANGES

| FDL Spec | Current Implementation | Gap |
|----------|----------------------|-----|
| Monument Extended | Space Grotesk | **Wrong font family** |
| JetBrains Mono (Body/Code) | Inter (Body) | **Remove Inter** |
| Ultrabold (800) | bold (700) | **Add ultrabold** |
| 64px (Hero) | 48px (displayXL) | **Update size** |
| -2% tracking | -1% tracking | **Update value** |

### Radii - SIMPLIFY

| FDL Spec | Current | Gap |
|----------|---------|-----|
| Standard: 12px | md: 10px | Update to 12px |
| Smooth: 24px | lg: 16px | Update to 24px |

### Motion - RENAME + NEW VALUES

| FDL Spec | Current | Gap |
|----------|---------|-----|
| Instant: 0ms | N/A | **Add token** |
| Fast: 150ms | fast: 120ms | Update value |
| Compiling: 300ms | N/A | **Add token** |
| System Load: 800ms | N/A | **Add token** |

### Shadows - PHILOSOPHY CHANGE

- **FDL:** "No drop shadows. Use Outlines and Overlays."
- **Current:** Has drop shadows (ambient, hoverCard)
- **Action:** Remove drop shadows, keep crimson glow (brand signature)

---

## Files to Modify

| File | Action |
|------|--------|
| `lib/src/colors.dart` | REWRITE |
| `lib/src/typography.dart` | REWRITE |
| `lib/src/radii.dart` | MODIFY |
| `lib/src/motion.dart` | REWRITE |
| `lib/src/shadows.dart` | REWRITE |
| `lib/src/spacing.dart` | MODIFY |
| `lib/src/breakpoints.dart` | REVIEW |
| `lib/fifty_tokens.dart` | MODIFY |
| `test/*.dart` | REWRITE (all 7 test files) |
| `example/fifty_tokens_example.dart` | REWRITE |
| `README.md` | REWRITE |

---

## Implementation Phases

### Phase 1: Colors (Foundation)

**File:** `lib/src/colors.dart`

```dart
class FiftyColors {
  FiftyColors._();

  // CORE PALETTE (from FDL Brand Sheet)

  /// Void Black (#050505) - Backgrounds (OLED-friendly)
  static const Color voidBlack = Color(0xFF050505);

  /// Crimson Pulse (#960E29) - Primary Action (heartbeat)
  static const Color crimsonPulse = Color(0xFF960E29);

  /// Gunmetal (#1A1A1A) - Surfaces (cards, panels)
  static const Color gunmetal = Color(0xFF1A1A1A);

  /// Terminal White (#EAEAEA) - Primary Text
  static const Color terminalWhite = Color(0xFFEAEAEA);

  /// Hyper Chrome (#888888) - Borders, metadata
  static const Color hyperChrome = Color(0xFF888888);

  /// Igris Green (#00FF41) - AI Agent / Terminal output
  static const Color igrisGreen = Color(0xFF00FF41);

  // DERIVED COLORS

  /// Border - Hyper Chrome at 10% opacity (per FDL spec)
  static const Color border = Color(0x1A888888);

  // SEMANTIC COLORS

  static const Color success = Color(0xFF00BA33);
  static const Color warning = Color(0xFFF7A100);
  static const Color error = Color(0xFF960E29); // Uses Crimson Pulse
}
```

---

### Phase 2: Typography

**File:** `lib/src/typography.dart`

```dart
class FiftyTypography {
  FiftyTypography._();

  // FONT FAMILIES
  static const String fontFamilyHeadline = 'Monument Extended';
  static const String fontFamilyMono = 'JetBrains Mono';

  // FONT WEIGHTS
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight ultrabold = FontWeight.w800;

  // TYPE SCALE (from FDL)
  static const double hero = 64;      // Hero
  static const double display = 48;   // Display
  static const double section = 32;   // Section headers
  static const double body = 16;      // Body text
  static const double mono = 12;      // Terminal/code

  // LETTER SPACING
  static const double tight = -0.02;     // Headlines (-2%)
  static const double standard = 0.0;    // Body (0%)

  // LINE HEIGHTS
  static const double displayLineHeight = 1.1;
  static const double headingLineHeight = 1.2;
  static const double bodyLineHeight = 1.5;
  static const double codeLineHeight = 1.6;
}
```

---

### Phase 3: Radii (Simplify)

**File:** `lib/src/radii.dart`

```dart
class FiftyRadii {
  FiftyRadii._();

  // RADIUS VALUES (from FDL)
  static const double standard = 12;   // Default
  static const double smooth = 24;     // Softer elements
  static const double full = 999;      // Pills/circles

  // BORDERRADIUS OBJECTS
  static final BorderRadius standardRadius = BorderRadius.circular(standard);
  static final BorderRadius smoothRadius = BorderRadius.circular(smooth);
  static final BorderRadius fullRadius = BorderRadius.circular(full);
}
```

---

### Phase 4: Motion (Semantic Naming)

**File:** `lib/src/motion.dart`

```dart
class FiftyMotion {
  FiftyMotion._();

  // DURATIONS (from FDL)
  static const Duration instant = Duration.zero;           // 0ms
  static const Duration fast = Duration(milliseconds: 150);      // Hover
  static const Duration compiling = Duration(milliseconds: 300); // Reveals
  static const Duration systemLoad = Duration(milliseconds: 800); // Stagger

  // EASING CURVES
  static const Curve standard = Cubic(0.2, 0, 0, 1);
  static const Curve enter = Cubic(0.2, 0.8, 0.2, 1);
  static const Curve exit = Cubic(0.4, 0, 1, 1);

  // PHILOSOPHY: NO FADES - Use Slides, Wipes, Reveals
}
```

---

### Phase 5: Shadows (No Drop Shadows)

**File:** `lib/src/shadows.dart`

```dart
class FiftyElevation {
  FiftyElevation._();

  // PHILOSOPHY: "No drop shadows. Use Outlines and Overlays."
  // Exception: Crimson glow for focus/hover (brand signature)

  // GLOW EFFECTS (Brand Signature)
  static final BoxShadow crimsonGlow = BoxShadow(
    color: FiftyColors.crimsonPulse.withValues(alpha: 0.45),
    blurRadius: 8,
  );

  static final BoxShadow focusRing = BoxShadow(
    color: FiftyColors.crimsonPulse.withValues(alpha: 0.6),
    blurRadius: 4,
  );

  // GLOW LISTS
  static final List<BoxShadow> focus = [crimsonGlow];
  static final List<BoxShadow> strongFocus = [focusRing, crimsonGlow];

  // NO DROP SHADOWS - Use border and surface colors instead
}
```

---

### Phase 6: Spacing (4px Base)

**File:** `lib/src/spacing.dart`

```dart
class FiftySpacing {
  FiftySpacing._();

  // BASE UNIT (from FDL)
  static const double base = 4;

  // GAP SIZES (FDL: "tight density")
  static const double tight = 8;      // Standard gap
  static const double standard = 12;  // Comfortable gap

  // SPACING SCALE (multiples of base)
  static const double xs = 4;       // 1x
  static const double sm = 8;       // 2x
  static const double md = 12;      // 3x
  static const double lg = 16;      // 4x
  static const double xl = 20;      // 5x
  static const double xxl = 24;     // 6x
  static const double xxxl = 32;    // 8x
  static const double huge = 40;    // 10x
  static const double massive = 48; // 12x

  // RESPONSIVE GUTTERS
  static const double gutterDesktop = 24;
  static const double gutterTablet = 16;
  static const double gutterMobile = 12;
}
```

---

### Phase 7: Breakpoints (Review Only)

No changes expected. Verify consistency with FDL.

---

### Phase 8: Tests

Rewrite all test files to validate:
- Exact hex values match FDL
- New token names
- Removed tokens no longer exist
- New tokens exist with correct values

---

### Phase 9: Example & Documentation

- Update example file with new token names
- Rewrite README with FDL alignment documentation

---

## Implementation Order

1. Colors (foundation - others depend on it)
2. Typography (independent)
3. Spacing (independent)
4. Radii (independent)
5. Motion (independent)
6. Shadows (depends on Colors)
7. Breakpoints (review only)
8. Main export
9. Tests
10. Example
11. README

---

## Risks

| Risk | Mitigation |
|------|------------|
| Monument Extended font unavailable | Document font requirements, provide fallback |
| Motion philosophy confusion | Add detailed documentation about NO FADES |

---

## Acceptance Criteria

- [ ] Colors match FDL spec exactly
- [ ] Typography uses Monument Extended + JetBrains Mono
- [ ] Type scale: 64/48/32/16/12
- [ ] Radii: 12px standard, 24px smooth
- [ ] Motion: instant/fast/compiling/systemLoad
- [ ] No drop shadows (only glows)
- [ ] 4px base spacing unit
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes
- [ ] Documentation updated

---

**Plan Status:** Ready for Implementation
