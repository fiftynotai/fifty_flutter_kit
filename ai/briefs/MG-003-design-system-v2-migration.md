# MG-003: Design System v2 Migration

**Type:** Migration
**Priority:** P0-Critical
**Effort:** L-Large (2-3 weeks)
**Status:** Ready
**Created:** 2026-01-20
**Assignee:** -

---

## Problem

The current FDL (Fifty Design Language) uses "Kinetic Brutalism" aesthetic which is being replaced with a new "Sophisticated Warm" design system. This affects:

- **Color palette** - Complete replacement (5 new core colors)
- **Typography** - Font family change (Monument/JetBrains → Manrope)
- **Border radii** - Softer, more rounded corners
- **Component styling** - All components need restyling
- **New components** - Segmented control to be added

This is a **breaking change** requiring major version bumps across all FDL packages.

---

## Goal

Migrate the entire FDL ecosystem to Design System v2:

1. Update `fifty_tokens` to v1.0.0 with new color palette, typography, radii, gradients
2. Update `fifty_theme` to v1.0.0 with new theme data
3. Update `fifty_ui` to v1.0.0 with restyled components
4. Ensure all engine packages consume from updated FDL
5. Full dark/light mode support (dark is primary)

---

## Design System v2 Specification

### Color Palette

**Source:** `design_system/v2/palette.scss`

| Token Name | Hex | Role |
|------------|-----|------|
| `burgundy` | `#88292f` | Primary |
| `burgundyHover` | `#6e2126` | Primary hover state |
| `cream` | `#fefee3` | Light background |
| `darkBurgundy` | `#1a0d0e` | Dark background |
| `slateGrey` | `#335c67` | Secondary actions |
| `slateGreyHover` | `#274750` | Secondary hover |
| `hunterGreen` | `#4b644a` | Success/positive |
| `powderBlush` | `#ffc9b9` | Accent (especially dark mode) |
| `surfaceLight` | `#ffffff` | Light mode surfaces |
| `surfaceDark` | `#2a1517` | Dark mode surfaces |

**Semantic Mapping:**

| Semantic | Light Mode | Dark Mode |
|----------|------------|-----------|
| `primary` | burgundy | burgundy |
| `primaryHover` | burgundyHover | burgundyHover |
| `secondary` | slateGrey | slateGrey |
| `background` | cream | darkBurgundy |
| `surface` | surfaceLight | surfaceDark |
| `textPrimary` | darkBurgundy | cream |
| `textSecondary` | slateGrey | gray-400 |
| `accent` | burgundy | powderBlush |
| `success` | hunterGreen | hunterGreen |
| `border` | black/5% | white/5% |
| `borderFocus` | primary | powderBlush/50% |

### Typography

**Font Family:** Manrope (via Google Fonts)

| Style | Weight | Size | Use |
|-------|--------|------|-----|
| `displayLarge` | 800 | 32px | Hero headlines |
| `displayMedium` | 800 | 24px | Section headlines |
| `titleLarge` | 700 | 20px | Card titles |
| `titleMedium` | 700 | 18px | App bar titles |
| `titleSmall` | 700 | 16px | List item titles |
| `bodyLarge` | 500 | 16px | Primary body text |
| `bodyMedium` | 400 | 14px | Secondary body text |
| `bodySmall` | 400 | 12px | Captions, hints |
| `labelLarge` | 700 | 14px | Button labels |
| `labelMedium` | 700 | 12px | Input labels (UPPERCASE) |
| `labelSmall` | 600 | 10px | Bottom nav, badges |

**Label Style:** UPPERCASE with `letterSpacing: 1.5` for form labels and section headers

### Border Radii

| Token | Value | Use |
|-------|-------|-----|
| `none` | 0 | No radius |
| `sm` | 4px | Small elements |
| `md` | 8px | Default (0.5rem) |
| `lg` | 12px | Cards, inputs |
| `xl` | 16px | Buttons, large inputs |
| `2xl` | 24px | Large cards |
| `3xl` | 32px | Hero cards |
| `full` | 9999px | Pills, avatars |

### Shadows

| Token | Value | Use |
|-------|-------|-----|
| `sm` | `0 1px 2px rgba(0,0,0,0.05)` | Subtle elevation |
| `md` | `0 4px 6px rgba(0,0,0,0.07)` | Cards |
| `lg` | `0 10px 15px rgba(0,0,0,0.1)` | Modals, dropdowns |
| `primary` | `0 4px 14px rgba(136,41,47,0.2)` | Primary buttons |
| `glow` | `0 0 15px rgba(254,254,227,0.1)` | Dark mode accent |

### Gradients

| Token | Value | Use |
|-------|-------|-----|
| `primaryGradient` | `linear(burgundy → #5a1b1f)` | Hero sections |
| `progressGradient` | `linear(powderBlush → burgundy)` | Progress bars |

### Spacing (unchanged)

Keep existing spacing scale: 4, 8, 12, 16, 24, 32, 48, 64

---

## Component Specifications

### FiftyButton

| Property | Value |
|----------|-------|
| Height (default) | 48px |
| Height (large) | 56px |
| Border radius | xl (16px) |
| Font | labelLarge, semibold |
| Shadow | shadow-primary on primary variant |

**Variants:**
- `primary` - Burgundy bg, cream text, shadow
- `secondary` - SlateGrey bg, cream text
- `outline` - Border burgundy/powderBlush, transparent bg
- `ghost` - No border, text only
- `disabled` - bg white/5%, text white/20%

### FiftyTextField

| Property | Value |
|----------|-------|
| Height | 48px |
| Border radius | xl (16px) |
| Border | 1px gray-200 / white/10% |
| Focus | ring-2 primary / powderBlush/50% |
| Icon prefix | Supported |
| Label | UPPERCASE, labelMedium |

### FiftyCard

| Property | Value |
|----------|-------|
| Border radius | 2xl (24px) or 3xl (32px) |
| Background | surface |
| Border | 1px black/5% / white/5% |
| Shadow | shadow-md |
| Padding | 16-24px |

### FiftySwitch

| Property | Value |
|----------|-------|
| Track width | 48px |
| Track height | 28px |
| Thumb size | 24px |
| On color | slateGrey (NOT primary) |
| Off color | gray-200 / gray-700 |

### FiftyCheckbox

| Property | Value |
|----------|-------|
| Size | 20px |
| Border radius | sm (4px) |
| Checked bg | primary |
| Check icon | Material check, white |

### FiftySegmentedControl (NEW)

| Property | Value |
|----------|-------|
| Container | surfaceDark, rounded-xl, p-1.5 |
| Segment | rounded-lg, py-2.5 |
| Active segment | cream bg (light) / slateGrey bg (dark) |
| Inactive | transparent, gray-400 text |

### FiftyBottomNav

| Property | Value |
|----------|-------|
| Background | surface/90% + backdrop-blur |
| Border top | 1px gray-100 / white/5% |
| Active color | primary / powderBlush |
| Inactive | gray-400 |
| Label size | labelSmall (10px) |

---

## Migration Phases

### Phase 1: fifty_tokens (v0.2.0 → v1.0.0)

**Files to modify:**
- `lib/src/colors.dart` - Replace all color definitions
- `lib/src/typography.dart` - Change to Manrope, update scale
- `lib/src/radii.dart` - Add xl, 2xl, 3xl
- `lib/src/shadows.dart` - Add new shadow tokens
- `lib/src/gradients.dart` - NEW file for gradient tokens
- `pubspec.yaml` - Add google_fonts dependency

**Breaking changes:**
- Color names change (e.g., `crimsonPulse` → `burgundy`)
- Typography names change
- Font family changes

### Phase 2: fifty_theme (v0.1.0 → v1.0.0)

**Files to modify:**
- `lib/src/fifty_theme_data.dart` - Update to use new tokens
- `lib/src/extensions.dart` - Update theme extensions

**Changes:**
- Map semantic colors to new palette
- Ensure proper light/dark mode switching
- Add gradient theme support

### Phase 3: fifty_ui (v0.5.0 → v1.0.0)

**Files to modify:**
- `lib/src/buttons/fifty_button.dart` - New styling
- `lib/src/inputs/fifty_text_field.dart` - New styling, icon support
- `lib/src/cards/fifty_card.dart` - Softer corners, shadows
- `lib/src/selection/fifty_switch.dart` - SlateGrey on state
- `lib/src/selection/fifty_checkbox.dart` - Updated colors
- `lib/src/selection/fifty_radio.dart` - Updated colors
- `lib/src/navigation/fifty_bottom_nav.dart` - Backdrop blur styling
- `lib/src/controls/fifty_segmented_control.dart` - NEW component

**New component:**
- `FiftySegmentedControl` - Pill-style tab selector

### Phase 4: Example Apps & Documentation

- Update all example apps to use new styling
- Update README screenshots
- Update component documentation
- Verify visual consistency

### Phase 5: Engine Package Verification

- Verify TD-001 (fifty_skill_tree) works with new FDL
- Test any other engine packages
- Update example apps in engine packages

---

## Acceptance Criteria

### fifty_tokens v1.0.0
- [ ] All v2 colors implemented with semantic mapping
- [ ] Manrope typography via google_fonts
- [ ] Updated radii scale (sm through 3xl + full)
- [ ] Shadow tokens (sm, md, lg, primary, glow)
- [ ] Gradient tokens (primaryGradient, progressGradient)
- [ ] Light/dark mode color mappings
- [ ] All tests passing
- [ ] CHANGELOG updated

### fifty_theme v1.0.0
- [ ] FiftyThemeData uses new tokens
- [ ] Light mode fully functional
- [ ] Dark mode fully functional (primary target)
- [ ] Theme extensions updated
- [ ] All tests passing
- [ ] CHANGELOG updated

### fifty_ui v1.0.0
- [ ] FiftyButton - 5 variants with new styling
- [ ] FiftyTextField - New height, radii, icon support
- [ ] FiftyCard - Soft corners, subtle shadows
- [ ] FiftySwitch - SlateGrey on state
- [ ] FiftyCheckbox - Updated colors
- [ ] FiftyRadio - Updated colors
- [ ] FiftySegmentedControl - NEW component
- [ ] FiftyBottomNav - Backdrop blur, new styling
- [ ] All other components updated
- [ ] All tests passing
- [ ] CHANGELOG updated

### Documentation
- [ ] Example apps updated
- [ ] Screenshots refreshed
- [ ] Migration guide written
- [ ] BREAKING CHANGES documented

---

## Test Plan

**Visual Testing:**
- Compare implemented components against design_system/v2 screenshots
- Test both light and dark modes
- Test all component states (hover, focus, disabled, etc.)

**Unit Testing:**
- All token values correct
- Theme data correctly maps tokens
- Components render without errors

**Integration Testing:**
- Engine packages (skill_tree) work with new FDL
- Example apps render correctly

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

## Dependencies

- **Blocks:** TD-001 (skill_tree refactor) - Should complete first or in parallel
- **Blocked by:** None
- **External:** google_fonts package

---

## Reference Files

- `design_system/v2/palette.scss` - Color definitions
- `design_system/v2/fifty_ui_kit_components_1/` - Overview, buttons, inputs, cards
- `design_system/v2/fifty_ui_kit_components_2/` - Button variants
- `design_system/v2/fifty_ui_kit_components_3/` - Forms and inputs
- `design_system/v2/fifty_ui_kit_components_4/` - Cards and layouts

---

## Workflow State

**Phase:** Not Started
**Active Agent:** None
**Retry Count:** 0

### Agent Log
_(empty - not started)_

---
