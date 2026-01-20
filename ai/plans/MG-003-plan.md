# Implementation Plan: MG-003 - Design System v2 Migration

**Complexity:** L-Large
**Estimated Duration:** 2-3 weeks (phased execution)
**Risk Level:** High (Breaking Changes)
**Created:** 2026-01-20
**Agent:** ARCHITECT (planner)

---

## Summary

Complete migration of the Fifty Design Language (FDL) ecosystem from "Kinetic Brutalism" aesthetic to "Sophisticated Warm" design system. This affects three core packages (fifty_tokens, fifty_theme, fifty_ui) with breaking changes requiring major version bumps from v0.x to v1.0.0.

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_tokens/lib/src/colors.dart` | MODIFY | Replace entire color palette (10+ colors) |
| `packages/fifty_tokens/lib/src/typography.dart` | MODIFY | Change font family to Manrope, update scale |
| `packages/fifty_tokens/lib/src/radii.dart` | MODIFY | Expand scale (none, sm, md, lg, xl, 2xl, 3xl, full) |
| `packages/fifty_tokens/lib/src/shadows.dart` | MODIFY | Replace glow-only with proper shadow tokens |
| `packages/fifty_tokens/lib/src/gradients.dart` | CREATE | New file for gradient tokens |
| `packages/fifty_tokens/lib/fifty_tokens.dart` | MODIFY | Export gradients.dart |
| `packages/fifty_tokens/pubspec.yaml` | MODIFY | Add google_fonts dependency, bump to v1.0.0 |
| `packages/fifty_theme/lib/src/color_scheme.dart` | MODIFY | Map new color palette to ColorScheme |
| `packages/fifty_theme/lib/src/text_theme.dart` | MODIFY | Update to Manrope typography |
| `packages/fifty_theme/lib/src/fifty_theme_data.dart` | MODIFY | Update scaffoldBackground, cardColor, light theme |
| `packages/fifty_theme/lib/src/component_themes.dart` | MODIFY | Update all component themes with new styling |
| `packages/fifty_theme/lib/src/theme_extensions.dart` | MODIFY | Update focusGlow, add shadow helpers |
| `packages/fifty_theme/pubspec.yaml` | MODIFY | Bump to v1.0.0 |
| `packages/fifty_ui/lib/src/buttons/fifty_button.dart` | MODIFY | New heights, radii (xl), shadow-primary |
| `packages/fifty_ui/lib/src/inputs/fifty_text_field.dart` | MODIFY | Height 48px, xl radius, icon prefix support |
| `packages/fifty_ui/lib/src/containers/fifty_card.dart` | MODIFY | 2xl/3xl radius, shadow-md, new border style |
| `packages/fifty_ui/lib/src/inputs/fifty_switch.dart` | MODIFY | slateGrey on-state, new dimensions |
| `packages/fifty_ui/lib/src/controls/fifty_segmented_control.dart` | CREATE | New component |
| `packages/fifty_ui/lib/fifty_ui.dart` | MODIFY | Export segmented control |
| `packages/fifty_ui/pubspec.yaml` | MODIFY | Bump to v1.0.0 |

---

## Implementation Steps

### Phase 1: fifty_tokens v1.0.0 (Foundation Layer)

**Priority:** CRITICAL - All other phases depend on this

#### Step 1.1: Update colors.dart

Replace the entire `FiftyColors` class with new palette:

```dart
// OLD → NEW Mapping
// voidBlack (#050505) → DEPRECATED (use darkBurgundy or cream)
// crimsonPulse (#960E29) → burgundy (#88292F)
// gunmetal (#1A1A1A) → surfaceDark (#2A1517)
// terminalWhite (#EAEAEA) → cream (#FEFEE3)
// hyperChrome (#888888) → slateGrey (#335C67)
// igrisGreen (#00FF41) → hunterGreen (#4B644A)
```

**New color tokens to add:**

| Token | Hex | Role |
|-------|-----|------|
| `burgundy` | `#88292F` | Primary |
| `burgundyHover` | `#6E2126` | Primary hover |
| `cream` | `#FEFEE3` | Light background |
| `darkBurgundy` | `#1A0D0E` | Dark background |
| `slateGrey` | `#335C67` | Secondary |
| `slateGreyHover` | `#274750` | Secondary hover |
| `hunterGreen` | `#4B644A` | Success |
| `powderBlush` | `#FFC9B9` | Dark mode accent |
| `surfaceLight` | `#FFFFFF` | Light surfaces |
| `surfaceDark` | `#2A1517` | Dark surfaces |

**Semantic color getters (light/dark mode aware):**

| Semantic | Light Mode | Dark Mode |
|----------|------------|-----------|
| `primary` | burgundy | burgundy |
| `background` | cream | darkBurgundy |
| `surface` | surfaceLight | surfaceDark |
| `textPrimary` | darkBurgundy | cream |
| `accent` | burgundy | powderBlush |
| `success` | hunterGreen | hunterGreen |
| `border` | black/5% | white/5% |

**Deprecation strategy:**
- Mark old colors as `@Deprecated('Use [newColor] instead')`
- Keep for one minor version for migration path
- Document mapping in CHANGELOG

#### Step 1.2: Update typography.dart

```dart
// OLD
fontFamilyHeadline = 'Monument Extended'
fontFamilyMono = 'JetBrains Mono'

// NEW
fontFamily = 'Manrope'  // Single font family
```

**New type scale:**

| Token | Size | Weight | Letter Spacing |
|-------|------|--------|----------------|
| `displayLarge` | 32px | 800 (extrabold) | -0.5 |
| `displayMedium` | 24px | 800 | -0.25 |
| `titleLarge` | 20px | 700 (bold) | 0 |
| `titleMedium` | 18px | 700 | 0 |
| `titleSmall` | 16px | 700 | 0 |
| `bodyLarge` | 16px | 500 (medium) | 0.5 |
| `bodyMedium` | 14px | 400 (regular) | 0.25 |
| `bodySmall` | 12px | 400 | 0.4 |
| `labelLarge` | 14px | 700 | 0.5 |
| `labelMedium` | 12px | 700 | **1.5** (UPPERCASE) |
| `labelSmall` | 10px | 600 (semibold) | 0.5 |

#### Step 1.3: Update radii.dart

**NEW scale (complete):**

| Token | Value | BorderRadius |
|-------|-------|--------------|
| `none` | 0 | `BorderRadius.zero` |
| `sm` | 4px | `BorderRadius.circular(4)` |
| `md` | 8px | `BorderRadius.circular(8)` |
| `lg` | 12px | `BorderRadius.circular(12)` |
| `xl` | 16px | `BorderRadius.circular(16)` |
| `xxl` (2xl) | 24px | `BorderRadius.circular(24)` |
| `xxxl` (3xl) | 32px | `BorderRadius.circular(32)` |
| `full` | 9999px | `BorderRadius.circular(9999)` |

#### Step 1.4: Update shadows.dart

Replace `FiftyElevation` class with `FiftyShadows`:

| Token | Value | Use |
|-------|-------|-----|
| `sm` | `0 1px 2px rgba(0,0,0,0.05)` | Subtle elevation |
| `md` | `0 4px 6px rgba(0,0,0,0.07)` | Cards |
| `lg` | `0 10px 15px rgba(0,0,0,0.1)` | Modals, dropdowns |
| `primary` | `0 4px 14px rgba(136,41,47,0.2)` | Primary buttons |
| `glow` | `0 0 15px rgba(254,254,227,0.1)` | Dark mode accent |

#### Step 1.5: Create gradients.dart (NEW FILE)

```dart
import 'package:flutter/material.dart';
import 'colors.dart';

class FiftyGradients {
  FiftyGradients._();

  /// Primary gradient - Hero sections
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF88292F), Color(0xFF5A1B1F)],
  );

  /// Progress gradient - Progress bars
  static const LinearGradient progress = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFFFC9B9), Color(0xFF88292F)],
  );
}
```

#### Step 1.6: Update pubspec.yaml

```yaml
name: fifty_tokens
version: 1.0.0  # MAJOR bump

dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.2.1  # NEW
```

---

### Phase 2: fifty_theme v1.0.0 (Theme Layer)

**Priority:** HIGH - Depends on Phase 1

#### Step 2.1: Update color_scheme.dart

**Dark ColorScheme mapping:**
- primary: burgundy
- onPrimary: cream
- secondary: slateGrey
- surface: darkBurgundy
- onSurface: cream
- outline: white/5%

**Light ColorScheme mapping:**
- primary: burgundy
- surface: cream
- onSurface: darkBurgundy
- outline: black/5%

#### Step 2.2: Update text_theme.dart

Replace all font references with `GoogleFonts.manrope()` calls.

#### Step 2.3: Update fifty_theme_data.dart

- scaffoldBackgroundColor: cream (light) / darkBurgundy (dark)
- cardColor: surfaceLight / surfaceDark
- Remove `shadowColor: Colors.transparent`

#### Step 2.4: Update theme_extensions.dart

Add shadow helpers to FiftyThemeExtension:
- shadowSm, shadowMd, shadowLg, shadowPrimary, shadowGlow
- accent color (mode-aware)

---

### Phase 3: fifty_ui v1.0.0 (Component Layer)

**Priority:** HIGH - Depends on Phase 1 & 2

#### Step 3.1: Update FiftyButton

| Property | OLD | NEW |
|----------|-----|-----|
| Height (default) | 40px | 48px |
| Height (large) | 48px | 56px |
| Border radius | 4px | xl (16px) |
| Shadow | None | shadow-primary on primary |

**Variants:** primary, secondary, outline, ghost, disabled

#### Step 3.2: Update FiftyTextField

| Property | OLD | NEW |
|----------|-----|-----|
| Height | Variable | 48px |
| Border radius | 12px | xl (16px) |
| Focus ring | crimson | primary / powderBlush/50% |

Add: Icon prefix support enhancement

#### Step 3.3: Update FiftyCard

| Property | OLD | NEW |
|----------|-----|-----|
| Border radius | 12px | 2xl (24px) / 3xl (32px) |
| Shadow | None | shadow-md |

#### Step 3.4: Update FiftySwitch

**CRITICAL:** On-state uses `slateGrey`, NOT primary!

| Property | OLD | NEW |
|----------|-----|-----|
| Track height | 24px | 28px |
| Thumb size | 20px | 24px |
| On color | primary | slateGrey |

#### Step 3.5: Create FiftySegmentedControl (NEW)

| Property | Value |
|----------|-------|
| Container bg | surfaceDark |
| Container radius | xl (16px) |
| Active bg (light) | cream |
| Active bg (dark) | slateGrey |

#### Step 3.6: Update FiftyBottomNav

- Background: surface/90% + backdrop blur
- Active color: primary / powderBlush

---

### Phase 4: Documentation & Examples

- Update all example apps
- Refresh README screenshots
- Write migration guide
- Document breaking changes

---

### Phase 5: Verification & Testing

- Unit tests for token values
- Widget tests for components
- Golden tests for visual regression
- Integration with engine packages
- Accessibility tests (contrast, touch targets)

---

## Breaking Changes Summary

| Package | Change | Migration |
|---------|--------|-----------|
| fifty_tokens | Color names | Find/replace old names |
| fifty_tokens | Font family | Remove Monument/JetBrains refs |
| fifty_tokens | New dependency | Add google_fonts |
| fifty_ui | Button heights | Update layout if hardcoded |
| fifty_ui | Input heights | Update layout if hardcoded |
| fifty_ui | Card radii | Visual change only |
| fifty_ui | Switch on color | Now slateGrey, not primary |

---

## Acceptance Checklist

### Phase 1: fifty_tokens
- [ ] All v2 colors implemented with correct hex values
- [ ] Manrope typography via google_fonts
- [ ] Complete radii scale (none through 3xl + full)
- [ ] Shadow tokens (sm, md, lg, primary, glow)
- [ ] Gradient tokens (primaryGradient, progressGradient)
- [ ] Barrel export updated
- [ ] pubspec.yaml bumped to v1.0.0
- [ ] CHANGELOG updated

### Phase 2: fifty_theme
- [ ] Dark ColorScheme uses new palette
- [ ] Light ColorScheme uses new palette
- [ ] TextTheme uses Manrope via GoogleFonts
- [ ] ThemeData updated (backgrounds, shadows)
- [ ] FiftyThemeExtension has shadow helpers
- [ ] pubspec.yaml bumped to v1.0.0
- [ ] CHANGELOG updated

### Phase 3: fifty_ui
- [ ] FiftyButton - 5 variants, new heights, xl radius, shadow-primary
- [ ] FiftyTextField - 48px height, xl radius, icon prefix
- [ ] FiftyCard - 2xl/3xl radius, shadow-md
- [ ] FiftySwitch - slateGrey on-state, 48x28 track, 24px thumb
- [ ] FiftySegmentedControl - NEW component implemented
- [ ] FiftyBottomNav - backdrop blur, new styling
- [ ] All other components updated
- [ ] Barrel export includes segmented control
- [ ] pubspec.yaml bumped to v1.0.0
- [ ] CHANGELOG updated

### Phase 4: Documentation
- [ ] Example apps updated and working
- [ ] README screenshots refreshed
- [ ] Migration guide written
- [ ] BREAKING CHANGES documented

### Phase 5: Verification
- [ ] All unit tests passing
- [ ] Widget tests passing
- [ ] Golden tests captured
- [ ] Engine packages verified
- [ ] Accessibility tests passed

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Breaking existing apps | HIGH | HIGH | Deprecation warnings, migration guide |
| Google Fonts dependency issues | LOW | MEDIUM | Bundle Manrope as asset fallback |
| Color contrast accessibility | MEDIUM | HIGH | Test against WCAG AA |
| Engine package incompatibility | MEDIUM | MEDIUM | Test TD-001 early |
| Visual regression | MEDIUM | MEDIUM | Golden tests |

---

**Plan ready for approval.**
