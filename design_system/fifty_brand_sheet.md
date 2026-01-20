# Fifty Brand Sheet

**Status:** ACTIVE | **Classification:** SOPHISTICATED MODERN
Quick-reference for colors, typography, and visual language. Complements the full FDL v2 Design System.

---

## Color Constants

| Variable | Hex Code | Usage |
|----------|----------|-------|
| `burgundy` | `#88292f` | Primary actions, buttons, accents |
| `primary-hover` | `#6e2126` | Hover states |
| `slate-grey` | `#335c67` | Secondary buttons, supporting elements |
| `hunter-green` | `#4b644a` | Success states, toggles, checkboxes |
| `cream` | `#fefee3` | Light mode background |
| `background-dark` | `#1a0d0e` | Dark mode background |
| `surface-light` | `#ffffff` | Light mode cards |
| `surface-dark` | `#2a1517` | Dark mode cards |
| `powder-blush` | `#ffc9b9` | Accent highlights, badges |

---

## Typography

**Font Family:** Manrope (all text)

| Role | Weight | Size |
|------|--------|------|
| Display | Extrabold (800) | 48px |
| Subheads | Bold (700) | 36px, 24px |
| Body | Regular (400) | 20px, 16px |
| UI Labels | Medium (500) | 14px, 12px |

**Type Scale:** 48px - 36px - 24px - 20px - 16px - 14px - 12px

---

## Shape and Structure

| Property | Value |
|----------|-------|
| Border Radius (default) | 8px |
| Border Radius (large) | 12px |
| Border Radius (xl) | 16px |
| Border Radius (2xl) | 24px |
| Border Radius (pill) | full |
| Borders (light) | black/5% |
| Borders (dark) | white/5% |
| Shadows | soft, layered (sm, md, lg) |
| Overlays | backdrop blur |

---

## Motion

| Property | Value |
|----------|-------|
| Duration (default) | 200ms |
| Easing | ease-out |
| Transitions | opacity fades, subtle scale |
| Press feedback | scale 0.98 |

---

## Interaction States

| Trigger | Reaction |
|---------|----------|
| Hover (Button) | Soft shadow appears, background shifts to `primary-hover` |
| Hover (Card) | Subtle elevation, shadow-md |
| Focus (Input) | `burgundy` focus ring |
| Press | Scale 0.98, 200ms ease-out |

---

## Component Style

| Component | Style |
|-----------|-------|
| Buttons | Rounded (8px), soft shadows on hover |
| Cards | Elevated with subtle borders, soft shadows |
| Inputs | Clean borders, `burgundy` focus ring |
| Navigation | Floating with backdrop blur |
| Badges | `powder-blush` background, rounded pill |

---

## Brand Signatures

| Element | Specification |
|---------|---------------|
| Wordmark | fifty.dev (Manrope Bold, lowercase) |
| Primary Color | Burgundy `#88292f` |
| Light Background | Cream `#fefee3` |
| Dark Background | Deep burgundy-black `#1a0d0e` |
| Tone | Clear. Professional. Approachable. |

---

## Visual Aesthetic

**Dual Mode Design:**
- Light: Warm cream background, burgundy accents
- Dark: Deep burgundy-black background, warm surfaces

**Photography:**
- Warm, natural lighting
- Soft, inviting imagery

**Avoid:**
- Harsh contrasts
- Cold minimalism
- Industrial textures

---

## Quick Reference

```
Primary:     #88292f (burgundy)
Hover:       #6e2126 (primary-hover)
Secondary:   #335c67 (slate-grey)
Success:     #4b644a (hunter-green)
Accent:      #ffc9b9 (powder-blush)

Light BG:    #fefee3 (cream)
Dark BG:     #1a0d0e (background-dark)

Font:        Manrope
Radius:      8px (default)
Motion:      200ms ease-out
```

---

*Reference `design_system/v2/` for full implementation details.*
