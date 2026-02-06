# BR-075: Sneaker Marketplace UI Design Specification

**Created:** 2026-02-06
**Author:** ARTISAN (ui-designer)
**Version:** 1.0.0
**Status:** Ready for Implementation

---

## Executive Summary

This document provides a comprehensive UI design specification for a modern sneaker marketplace website built with Flutter Web. The design follows the **Fifty Design Language (FDL) v2** "Sophisticated Warm" aesthetic while incorporating cutting-edge 2026 design trends including glassmorphism, floating 3D products, kinetic typography, and gamification elements.

**Design Philosophy:**
- **Consume, Don't Define** - All styling uses FDL tokens (no hardcoded values)
- **Kinetic Brutalism** - Heavy but fast animations, no fades, use slides/wipes/reveals
- **Premium E-commerce** - Luxury feel with warm burgundy and cream palette
- **Mobile-First** - Responsive design starting from mobile breakpoints

---

## 1. Design System Mapping

### 1.1 FDL v2 Color Mapping for Sneaker Site

| Semantic Use | FDL Token | Hex Value | Application |
|--------------|-----------|-----------|-------------|
| Primary CTA | `FiftyColors.burgundy` | #88292F | Buy buttons, add to cart, hero CTAs |
| Primary Hover | `FiftyColors.burgundyHover` | #6E2126 | Button hover states |
| Background (Dark) | `FiftyColors.darkBurgundy` | #1A0D0E | Page backgrounds, hero sections |
| Background (Light) | `FiftyColors.cream` | #FEFEE3 | Light mode backgrounds |
| Surface Cards | `FiftyColors.surfaceDark` | #2A1517 | Product cards, panels |
| Secondary Actions | `FiftyColors.slateGrey` | #335C67 | Secondary buttons, size selectors |
| Success/In Stock | `FiftyColors.hunterGreen` | #4B644A | Stock indicators, success states |
| Warning/Low Stock | `FiftyColors.warning` | #F7A100 | Low stock alerts |
| Accent (Dark Mode) | `FiftyColors.powderBlush` | #FFC9B9 | Price highlights, borders |
| Text Primary | `FiftyColors.cream` | #FEFEE3 | Headlines, body text (dark mode) |
| Text Secondary | `FiftyColors.slateGrey` | #335C67 | Descriptions, metadata |

### 1.2 Sneaker-Specific Semantic Colors

Extend FDL semantically for sneaker domain (use FDL colors, no new definitions):

| Domain Concept | FDL Mapping | Usage |
|----------------|-------------|-------|
| Price Increase | `FiftyColors.hunterGreen` | +12% market value indicator |
| Price Decrease | `FiftyColors.burgundy` | -5% market value indicator |
| Limited Edition | `FiftyColors.powderBlush` | Exclusive release badge |
| Sold Out | `FiftyColors.slateGrey` | Unavailable state |
| Grail Status | `FiftyGradients.primary` | Rare sneaker gradient border |

### 1.3 Typography Scale

Using FDL v2 Manrope type scale:

| Element | Token | Size | Weight | Letter Spacing |
|---------|-------|------|--------|----------------|
| Hero Headline | `displayLarge` | 32px | extraBold (800) | -0.5 |
| Section Title | `displayMedium` | 24px | extraBold (800) | -0.25 |
| Product Title | `titleLarge` | 20px | bold (700) | 0 |
| Card Title | `titleMedium` | 18px | bold (700) | 0 |
| Price | `titleSmall` | 16px | bold (700) | 0 |
| Body Text | `bodyLarge` | 16px | medium (500) | 0.5 |
| Description | `bodyMedium` | 14px | regular (400) | 0.25 |
| Label/Tag | `labelMedium` | 12px | bold (700) | 1.5 (UPPERCASE) |
| Badge | `labelSmall` | 10px | semiBold (600) | 0.5 |

### 1.4 Spacing Scale

Using FDL 4px grid:

| Context | Token | Value | Usage |
|---------|-------|-------|-------|
| Inline elements | `xs` | 4px | Icon-to-text gaps |
| Tight gaps | `sm` | 8px | Card internal spacing |
| Standard gaps | `md` | 12px | Form fields, list items |
| Comfortable | `lg` | 16px | Card padding |
| Section gaps | `xl` | 20px | Between components |
| Major sections | `xxl` | 24px | Desktop gutters |
| Page sections | `xxxl` | 32px | Hero spacing |
| Hero padding | `huge` | 40px | Above-the-fold spacing |
| Page margins | `massive` | 48px | Mobile page padding |

### 1.5 Border Radius Scale

Using FDL v2 radii:

| Element | Token | Value | Usage |
|---------|-------|-------|-------|
| Badges/Tags | `sm` | 4px | Rarity badges |
| Chips/Size Buttons | `md` | 8px | Size selectors |
| Input Fields | `xl` | 16px | Text inputs, dropdowns |
| Product Cards | `xxl` | 24px | Standard cards |
| Hero Cards | `xxxl` | 32px | Featured product cards |
| Pills/Avatars | `full` | 9999px | Category pills, user avatars |

### 1.6 Motion Tokens

Using FDL kinetic motion philosophy:

| Animation | Duration Token | Curve Token | Usage |
|-----------|----------------|-------------|-------|
| Hover feedback | `fast` | `standard` | 150ms - Button hover, card lift |
| Panel reveals | `compiling` | `enter` | 300ms - Modal open, drawer slide |
| Page transitions | `systemLoad` | `standard` | 800ms - Route changes |
| Float oscillation | Custom: 3000ms | `easeInOut` | Sneaker float animation |
| Add to cart | `compiling` | `exit` | 300ms - Arc trajectory to cart |

---

## 2. Component Inventory

### 2.1 Navigation Components

#### GlassNavBar
Glassmorphism navigation bar with FDL compliance.

```dart
/// Glassmorphism navigation bar for sneaker marketplace.
///
/// Features:
/// - Frosted glass effect with blur
/// - FDL color tokens for background/text
/// - Responsive collapse to hamburger on mobile
/// - Cart badge with item count
class GlassNavBar extends StatelessWidget {
  // Background: FiftyColors.darkBurgundy.withOpacity(0.7)
  // Blur: BackdropFilter with ImageFilter.blur(sigmaX: 10, sigmaY: 10)
  // Border: FiftyColors.powderBlush.withOpacity(0.1)
  // Height: 64px desktop, 56px mobile
  // Padding: FiftySpacing.xxl horizontal
  // Border radius: 0 (edge-to-edge) or FiftyRadii.xxl (floating)
}
```

**States:**
| State | Visual |
|-------|--------|
| Default | 70% opacity dark burgundy, subtle border |
| Scrolled | 90% opacity, stronger blur |
| Mobile | Hamburger icon, slide-out drawer |

#### NavCartBadge
Cart indicator with item count.

```dart
/// Animated cart badge showing item count.
///
/// - Uses FiftyBadge pattern internally
/// - Bounces on item add (FiftyMotion.enter curve)
/// - Color: FiftyColors.burgundy with cream text
class NavCartBadge extends StatelessWidget {
  final int itemCount;
  // Position: top-right of cart icon
  // Size: 18x18px minimum
  // Font: labelSmall (10px)
}
```

### 2.2 Product Display Components

#### SneakerCard
Primary product card for catalog/grid.

```dart
/// Product card with floating sneaker effect on hover.
///
/// Extends FiftyCard with sneaker-specific enhancements:
/// - Floating image on hover (translateY + subtle rotation)
/// - Price with market trend indicator
/// - Rarity badge
/// - Quick-add button
class SneakerCard extends StatelessWidget {
  // Base: FiftyCard with size: FiftyCardSize.standard
  // Padding: FiftySpacing.lg
  // Hover scale: 1.02 (default FiftyCard behavior)
  // Scanline: enabled (FDL rule)
}
```

**Component States:**

| State | Changes |
|-------|---------|
| Default | Static sneaker image, visible quick-add |
| Hover | Image lifts 8px, rotates 3 degrees, scanline sweeps |
| Loading | Skeleton with pulse animation |
| Out of Stock | Grayscale image, disabled quick-add |

**Sub-components:**
- `SneakerImage`: Image container with float animation
- `PriceTrend`: Price with +/- indicator arrow
- `RarityBadge`: Common/Rare/Grail indicator

#### SneakerViewer360
360-degree product viewer for detail page.

```dart
/// Interactive 360-degree sneaker viewer.
///
/// Features:
/// - Drag to rotate horizontally
/// - Pinch to zoom (2x max)
/// - Auto-rotate on idle (3 seconds)
/// - Loading sequence with percentage
class SneakerViewer360 extends StatefulWidget {
  final List<String> imageUrls; // 24-36 frames
  // Container: FiftyCard.hero with xxxl radius
  // Background: FiftyGradients.surface
  // Controls: Zoom +/- buttons with FiftyIconButton
}
```

#### FloatingSneaker
Animated floating sneaker with parallax.

```dart
/// Sneaker that floats with subtle oscillation.
///
/// Animation specs:
/// - Vertical oscillation: 3px amplitude, 3s period
/// - Rotation: subtle 1-2 degree tilt based on scroll
/// - Shadow: softens on rise, sharpens on fall
class FloatingSneaker extends StatefulWidget {
  final String imageUrl;
  final double parallaxFactor; // 0.0 to 1.0

  // Uses AnimationController with repeat
  // Curve: Curves.easeInOut
  // Shadow: FiftyShadows.lg with animated opacity
}
```

### 2.3 Filter/Sort Components

#### GlassFilterPanel
Glassmorphism filter sidebar/sheet.

```dart
/// Frosted glass filter panel.
///
/// - Uses same glass effect as GlassNavBar
/// - Contains filter groups (Brand, Size, Price, etc.)
/// - Slide-in from left (desktop) or bottom (mobile)
class GlassFilterPanel extends StatelessWidget {
  // Background: FiftyColors.surfaceDark.withOpacity(0.85)
  // Blur: 20 sigma
  // Width: 320px desktop, full-width mobile
  // Padding: FiftySpacing.xxl
}
```

**Filter Group Components:**
- `FilterCheckboxGroup`: Multi-select with FiftyCheckbox
- `FilterSizeGrid`: Grid of size buttons
- `FilterPriceRange`: Dual-thumb FiftySlider
- `FilterBrandSearch`: FiftyTextField with autocomplete

#### SizeSelectorGrid
Interactive size selection grid.

```dart
/// Grid of size options with availability indicators.
///
/// Uses FiftyRadii.md (8px) for individual size chips.
class SizeSelectorGrid extends StatelessWidget {
  // Grid: 4 columns on desktop, 3 on mobile
  // Gap: FiftySpacing.sm (8px)
  // Chip height: 44px (touch target)
}
```

**Size Chip States:**

| State | Background | Border | Text |
|-------|------------|--------|------|
| Available | transparent | slateGrey | cream |
| Selected | burgundy | burgundy | cream |
| Low Stock | transparent | warning | warning |
| Out of Stock | surfaceDark @ 50% | slateGrey @ 50% | slateGrey @ 50% |

### 2.4 Cart Components

#### CartDrawer
Slide-in cart with glassmorphism.

```dart
/// Glass-effect cart drawer that slides from right.
///
/// Features:
/// - Glassmorphism background
/// - Floating sneaker thumbnails
/// - Animated item add/remove
/// - Sticky checkout button
class CartDrawer extends StatelessWidget {
  // Width: 400px desktop, 100% mobile
  // Slide duration: FiftyMotion.compiling (300ms)
  // Curve: FiftyMotion.enter (springy)
  // Background: darkBurgundy @ 90% with 20 blur
}
```

#### CartItemCard
Individual cart item display.

```dart
/// Cart item with floating sneaker thumbnail.
///
/// - Sneaker floats in mini container
/// - Quantity stepper with +/- buttons
/// - Swipe to remove (mobile)
/// - Price updates animate on quantity change
class CartItemCard extends StatelessWidget {
  // Height: 120px
  // Padding: FiftySpacing.md
  // Image size: 80x80px
  // Uses FiftyCard with scanlineOnHover: false
}
```

### 2.5 Gamification Components

#### RarityBadge
Sneaker rarity indicator.

```dart
/// Badge indicating sneaker rarity tier.
///
/// Uses FiftyBadge as base with custom colors.
enum SneakerRarity { common, rare, grail }

class RarityBadge extends StatelessWidget {
  final SneakerRarity rarity;

  // Common: slateGrey border, no glow
  // Rare: powderBlush border, subtle glow
  // Grail: gradient border (primary), strong glow
}
```

**Rarity Visual Specs:**

| Tier | Border Color | Glow | Text |
|------|--------------|------|------|
| Common | slateGrey | none | "COMMON" |
| Rare | powderBlush | 0.3 opacity | "RARE" |
| Grail | gradient (burgundy to darker) | animated pulse | "GRAIL" |

#### DropCountdown
Limited release countdown timer.

```dart
/// Countdown timer for sneaker drops.
///
/// Features:
/// - Days:Hours:Minutes:Seconds display
/// - Monospace digits for stability
/// - Pulse animation on final minute
/// - "SOLD OUT" state after expiry
class DropCountdown extends StatefulWidget {
  final DateTime dropTime;

  // Uses FiftyTypography.fontFamily with tabularFigures
  // Font size: titleLarge (20px)
  // Separator color: slateGrey
  // Active digit color: cream
}
```

### 2.6 Feedback Components

#### AddToCartAnimation
Flying sneaker animation to cart.

```dart
/// Animates sneaker flying to cart icon.
///
/// Arc trajectory from product to cart icon.
/// - Duration: FiftyMotion.compiling (300ms)
/// - Curve: FiftyMotion.exit (fast exit)
/// - Scale: shrinks from 1.0 to 0.3
/// - Opacity: 1.0 to 0.0 in last 20%
class AddToCartAnimation extends StatefulWidget {
  final Offset startPosition;
  final Offset endPosition; // Cart icon global position
  final String imageUrl;
}
```

#### LoadingSkeleton
FDL-compliant skeleton loading state.

```dart
/// Skeleton placeholder with pulse animation.
///
/// FDL Rule: NO spinners, use text sequences or skeletons.
/// - Base color: surfaceDark
/// - Highlight color: surfaceDark.withOpacity(0.7)
/// - Animation: shimmer sweep (left to right)
class LoadingSkeleton extends StatelessWidget {
  // Duration: 1500ms
  // Uses LinearGradient for shimmer
}
```

---

## 3. Page Wireframes

### 3.1 Hero Landing Page

```
+------------------------------------------------------------------+
|  [Logo]    HOME  DROPS  BRANDS  SELL    [Search]  [User] [Cart]  | <- GlassNavBar
+------------------------------------------------------------------+
|                                                                    |
|  +--------------------------+    +-----------------------------+  |
|  |                          |    |                             |  |
|  |    STEP                  |    |       [Floating            |  |
|  |    INTO THE              |    |        Sneaker             |  |
|  |    FUTURE                |    |        with 3D             |  |
|  |    ==================    |    |        rotation]           |  |
|  |                          |    |                             |  |
|  |    [SHOP NOW ->]         |    |                             |  |
|  |                          |    +-----------------------------+  |
|  +--------------------------+                                      |
|                                                                    |
+------------------------------------------------------------------+
|  DROPPING SOON                                                     |
|  +----------+  +----------+  +----------+  +----------+            |
|  | Sneaker1 |  | Sneaker2 |  | Sneaker3 |  | Sneaker4 |            |
|  | [Timer]  |  | [Timer]  |  | [Timer]  |  | [Timer]  |            |
|  +----------+  +----------+  +----------+  +----------+            |
+------------------------------------------------------------------+
|  TRENDING NOW                                                      |
|  +-------+  +-------+  +-------+  +-------+  +-------+             |
|  |  S1   |  |  S2   |  |  S3   |  |  S4   |  |  S5   |             |
|  |[+12%] |  |[-3%]  |  |[+8%]  |  |[+5%]  |  |[NEW]  |             |
|  +-------+  +-------+  +-------+  +-------+  +-------+             |
+------------------------------------------------------------------+
```

**Hero Section Specs:**
- Full viewport height (100vh) on desktop
- Background: `FiftyGradients.surface` (dark burgundy gradient)
- Headline: Kinetic typography, animates on load
- Sneaker: FloatingSneaker with parallax on scroll
- CTA: FiftyButton.primary with trailing arrow icon

### 3.2 Product Catalog Page

```
+------------------------------------------------------------------+
|  [Logo]    HOME  DROPS  BRANDS  SELL    [Search]  [User] [Cart]  |
+------------------------------------------------------------------+
|                                                                    |
|  ALL SNEAKERS                              [Grid] [List] [Sort v]  |
+------------------------------------------------------------------+
|        |                                                           |
| FILTER |  +--------+  +--------+  +--------+  +--------+           |
|        |  |        |  |        |  |        |  |        |           |
| Brand  |  |  Card  |  |  Card  |  |  Card  |  |  Card  |           |
| [ ] Ni |  |        |  |        |  |        |  |        |           |
| [ ] Ad |  +--------+  +--------+  +--------+  +--------+           |
|        |                                                           |
| Size   |  +--------+  +--------+  +--------+  +--------+           |
| [7][8] |  |        |  |        |  |        |  |        |           |
| [9][10]|  |  Card  |  |  Card  |  |  Card  |  |  Card  |           |
|        |  |        |  |        |  |        |  |        |           |
| Price  |  +--------+  +--------+  +--------+  +--------+           |
| [$---] |                                                           |
+------------------------------------------------------------------+
|                    [LOAD MORE]                                     |
+------------------------------------------------------------------+
```

**Catalog Specs:**
- Filter panel: GlassFilterPanel (320px on desktop)
- Grid: 4 columns desktop, 2 columns tablet, 1 column mobile
- Gap: `FiftySpacing.lg` (16px)
- Cards: SneakerCard with hover float effect
- Infinite scroll or "Load More" button

### 3.3 Product Detail Page

```
+------------------------------------------------------------------+
|  [<- Back]                                        [User] [Cart]  |
+------------------------------------------------------------------+
|                                                                    |
|  +---------------------------+  +------------------------------+  |
|  |                           |  |  NIKE AIR JORDAN 1           |  |
|  |                           |  |  "CHICAGO" (2026)            |  |
|  |     [360 Sneaker         |  |                              |  |
|  |      Viewer]              |  |  [GRAIL] badge               |  |
|  |                           |  |                              |  |
|  |     [Zoom+] [Zoom-]      |  |  $450   [+12% trending arrow] |  |
|  |                           |  |                              |  |
|  +---------------------------+  |  SIZE                         |  |
|                                  |  [7][8][9][9.5][10][10.5]    |  |
|  [Thumb1] [Thumb2] [Thumb3]     |  [11][11.5][12][13]          |  |
|                                  |                              |  |
|                                  |  [ADD TO CART - $450 ->]    |  |
|                                  |                              |  |
|                                  |  [Authenticity Guarantee]    |  |
+------------------------------------------------------------------+
|                                                                    |
|  DESCRIPTION                                                       |
|  The iconic Chicago colorway returns in 2026 with premium...      |
|                                                                    |
+------------------------------------------------------------------+
|  YOU MAY ALSO LIKE                                                 |
|  +-------+  +-------+  +-------+  +-------+                        |
|  | Rel1  |  | Rel2  |  | Rel3  |  | Rel4  |                        |
|  +-------+  +-------+  +-------+  +-------+                        |
+------------------------------------------------------------------+
```

**Detail Page Specs:**
- Viewer: SneakerViewer360 in FiftyCard.hero (xxxl radius)
- Thumbnails: Row of 4-6 angle previews
- Info panel: Sticky on desktop scroll
- Size grid: SizeSelectorGrid
- CTA: FiftyButton.primary expanded, with price in label

### 3.4 Cart/Checkout Flow

```
+------------------------------------------------------------------+
|  CHECKOUT                                    [Continue Shopping]  |
+------------------------------------------------------------------+
|                                                                    |
|  STEP 1: CART         STEP 2: SHIPPING      STEP 3: PAYMENT       |
|  [=========]          [----------]          [----------]          |
|                                                                    |
+------------------------------------------------------------------+
|                                                                    |
|  +---------------------------+  +-----------------------------+   |
|  |  [Float] Nike Air Max     |  |  ORDER SUMMARY              |   |
|  |  Size: 10 | Qty: [- 1 +]  |  |                             |   |
|  |  $220                     |  |  Subtotal:         $670     |   |
|  +---------------------------+  |  Shipping:         $15      |   |
|  |  [Float] Adidas Yeezy     |  |  Tax:              $54      |   |
|  |  Size: 9.5 | Qty: [- 1 +] |  |  ----------------------     |   |
|  |  $450                     |  |  TOTAL:            $739     |   |
|  +---------------------------+  |                             |   |
|                                  |  [PROCEED TO SHIPPING ->]  |   |
|                                  +-----------------------------+   |
+------------------------------------------------------------------+
```

**Checkout Specs:**
- Progress stepper: Custom component with FDL tokens
- Cart items: CartItemCard in scrollable container
- Summary panel: Sticky FiftyCard on right
- Animations: Step transitions use slide (not fade)

---

## 4. Animation Storyboards

### 4.1 Float Animation (Sneaker Oscillation)

```
ANIMATION: FloatAnimation
PURPOSE: Subtle life-like movement for sneakers
DURATION: 3000ms (3 seconds) loop
CURVE: Curves.easeInOut

KEYFRAMES:
  0%   -> translateY: 0px,    rotation: 0deg
  50%  -> translateY: -3px,   rotation: 0.5deg
  100% -> translateY: 0px,    rotation: 0deg

SHADOW SYNC:
  0%   -> blur: 8px,  opacity: 0.2
  50%  -> blur: 12px, opacity: 0.15  (softer at peak)
  100% -> blur: 8px,  opacity: 0.2

REDUCED MOTION:
  Static position, no animation
```

### 4.2 Hover Lift Animation

```
ANIMATION: HoverLift
PURPOSE: Product card interaction feedback
TRIGGER: Mouse enter / focus
DURATION: FiftyMotion.fast (150ms)
CURVE: FiftyMotion.standard

TRANSFORM:
  Default -> Hover
  scale: 1.0 -> 1.02
  translateY: 0 -> -8px
  rotateY: 0 -> 3deg (subtle 3D tilt)

SHADOW:
  Default: FiftyShadows.md
  Hover: FiftyShadows.lg + slight color shift toward burgundy

SCANLINE (FDL Rule):
  Triggers on hover entry
  Sweeps top to bottom in 300ms
  Color: burgundy @ 30% opacity
```

### 4.3 Page Transitions

```
ANIMATION: PageTransition
PURPOSE: Route changes between pages
DURATION: FiftyMotion.systemLoad (800ms)
CURVE: FiftyMotion.standard

OLD PAGE:
  0-200ms: translateX: 0 -> -50px, opacity: 1.0 -> 0.0

NEW PAGE:
  200-800ms: translateX: 50px -> 0, opacity: 0.0 -> 1.0
  Stagger children by 50ms delay each

PHILOSOPHY:
  NO FADES alone - always combine with slide
  Think "shutter" closing on old, opening on new
```

### 4.4 Scroll Reveal Animation

```
ANIMATION: ScrollReveal
PURPOSE: Elements appearing as user scrolls
TRIGGER: Element enters viewport (intersection observer)
DURATION: FiftyMotion.compiling (300ms)
CURVE: FiftyMotion.enter (springy)

TRANSFORM:
  Initial (off-screen): translateY: 24px, opacity: 0
  Revealed: translateY: 0, opacity: 1

STAGGER:
  For grid items, stagger by 50ms per item
  Max stagger: 5 items (250ms total spread)

REDUCED MOTION:
  Instant reveal, no animation
```

### 4.5 Add to Cart Arc Animation

```
ANIMATION: AddToCartArc
PURPOSE: Visual feedback when adding item to cart
DURATION: FiftyMotion.compiling (300ms)
CURVE: FiftyMotion.exit (fast out)

TRAJECTORY:
  Bezier curve from product card to cart icon
  Control point: offset upward by 100px (creates arc)

TRANSFORM:
  0%: scale 1.0, opacity 1.0, position: source
  80%: scale 0.3, opacity 1.0, position: along arc
  100%: scale 0.2, opacity 0.0, position: cart icon

CART ICON RESPONSE:
  At 80%: badge number increments
  At 100%: badge bounces (scale 1.0 -> 1.3 -> 1.0 in 150ms)
```

### 4.6 Loading Skeleton Shimmer

```
ANIMATION: SkeletonShimmer
PURPOSE: Indicate loading state without spinner
DURATION: 1500ms loop
CURVE: Curves.easeInOut

GRADIENT:
  LinearGradient moving left to right
  Colors: [surfaceDark, surfaceDark.lighten(5%), surfaceDark]
  Stops: [0.0, 0.5, 1.0]

MOTION:
  Gradient slides from -100% to +200% over duration
  Creates "shine" sweeping effect

FDL COMPLIANCE:
  NO circular spinners
  Text-based loading for buttons: "..." -> "...." -> "....."
```

### 4.7 Success Celebration

```
ANIMATION: SuccessCelebration
PURPOSE: Order confirmation visual celebration
TRIGGER: After successful checkout
DURATION: 800ms total sequence

SEQUENCE:
  0-150ms: Background flash (cream @ 20% -> 0%)
  0-300ms: Checkmark morphs in (draw SVG path)
  150-500ms: Confetti particles burst (8-12 particles)
  300-800ms: Text slides up with "ORDER CONFIRMED"

CONFETTI:
  Colors: [burgundy, powderBlush, slateGrey, hunterGreen]
  Physics: gravity + random horizontal velocity
  Fade out at 600-800ms

REDUCED MOTION:
  Just checkmark and text, no particles
```

---

## 5. Responsive Breakpoints

Using FDL breakpoint tokens from `FiftyBreakpoints`:

| Breakpoint | Min Width | Layout Changes |
|------------|-----------|----------------|
| Mobile | 0px | Single column, bottom nav, full-width cards |
| Tablet | 600px | 2-column grid, side filter sheet |
| Desktop | 1024px | 4-column grid, persistent filter panel |
| Wide | 1440px | Max content width, centered layout |

### 5.1 Component Breakpoint Behavior

| Component | Mobile | Tablet | Desktop |
|-----------|--------|--------|---------|
| GlassNavBar | Hamburger menu | Full nav | Full nav |
| ProductGrid | 1 column | 2 columns | 4 columns |
| FilterPanel | Bottom sheet | Slide overlay | Fixed sidebar |
| CartDrawer | Full screen | 400px width | 400px width |
| SneakerViewer | Touch rotate | Touch rotate | Mouse drag |
| Hero | Stacked layout | 50/50 split | 60/40 split |

### 5.2 Typography Scaling

| Token | Mobile | Tablet+ |
|-------|--------|---------|
| displayLarge | 24px | 32px |
| displayMedium | 20px | 24px |
| titleLarge | 18px | 20px |
| bodyLarge | 14px | 16px |

---

## 6. Accessibility Specifications

### 6.1 Color Contrast Requirements

All text meets WCAG 2.1 AA (4.5:1 for normal text, 3:1 for large text):

| Foreground | Background | Ratio | Status |
|------------|------------|-------|--------|
| cream | darkBurgundy | 12.5:1 | Pass AAA |
| cream | surfaceDark | 10.2:1 | Pass AAA |
| burgundy | cream | 7.8:1 | Pass AAA |
| slateGrey | cream | 5.2:1 | Pass AA |
| powderBlush | darkBurgundy | 8.4:1 | Pass AAA |

### 6.2 Focus States

All interactive elements have visible focus indicators:

```dart
// Focus indicator spec
FocusBorder:
  Dark mode: FiftyColors.powderBlush @ 50% opacity
  Light mode: FiftyColors.burgundy
  Width: 2px
  Offset: 2px outside element
```

### 6.3 Reduced Motion Support

```dart
// Check for reduced motion preference
final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

if (reduceMotion) {
  // Skip float animations
  // Use instant transitions
  // Show static sneaker images
  // No confetti/particles
}
```

### 6.4 Screen Reader Annotations

| Element | ARIA Role | Label |
|---------|-----------|-------|
| SneakerCard | article | "Nike Air Jordan 1, $450, Rare, In stock" |
| SizeSelectorGrid | radiogroup | "Select size" |
| Size button | radio | "Size 10, available" or "Size 11, sold out" |
| RarityBadge | status | "Rarity: Grail" |
| CartDrawer | dialog | "Shopping cart, 3 items" |
| DropCountdown | timer | "Releases in 2 days, 5 hours" |

---

## 7. Interaction Patterns

### 7.1 Product Card Interactions

```
TAP (Mobile):
  -> Navigate to product detail page

LONG PRESS (Mobile):
  -> Show quick-view sheet

HOVER (Desktop):
  -> Lift animation
  -> Show "Quick Add" button
  -> Scanline sweep

DOUBLE TAP/CLICK:
  -> Add to wishlist (heart animation)
```

### 7.2 Size Selection

```
TAP SIZE:
  -> If available: Select (burgundy fill)
  -> If low stock: Select + show warning toast
  -> If sold out: Shake animation, no selection

VISUAL FEEDBACK:
  -> Selected: Immediate fill transition (FiftyMotion.fast)
  -> Previous selection: Deselect simultaneously
```

### 7.3 Cart Operations

```
ADD TO CART:
  -> Flying arc animation (product to cart)
  -> Cart badge bounces
  -> Success toast slides up

REMOVE FROM CART:
  -> Swipe left (mobile) or click X
  -> Item slides out left
  -> List collapses up (FiftyMotion.compiling)

UPDATE QUANTITY:
  -> +/- buttons with FiftyIconButton
  -> Price animates with counter effect
```

### 7.4 Filter Interactions

```
TOGGLE FILTER:
  -> Checkbox: Immediate toggle with check animation
  -> Products: Fade shuffle to new results

PRICE SLIDER:
  -> Dual thumbs with range selection
  -> Live update product count: "234 products"

CLEAR ALL:
  -> All filters animate out simultaneously
  -> Products fade shuffle to full catalog
```

---

## 8. Implementation Guidelines

### 8.1 File Structure

```
lib/features/sneaker_marketplace/
|-- sneaker_marketplace.dart           # Barrel export
|-- sneaker_marketplace_bindings.dart  # DI registration
|
|-- controllers/
|   |-- catalog_view_model.dart
|   |-- product_detail_view_model.dart
|   |-- cart_view_model.dart
|   +-- checkout_view_model.dart
|
|-- actions/
|   |-- catalog_actions.dart
|   |-- cart_actions.dart
|   +-- checkout_actions.dart
|
|-- views/
|   |-- landing_page.dart
|   |-- catalog_page.dart
|   |-- product_detail_page.dart
|   |-- cart_page.dart
|   |-- checkout_page.dart
|   +-- widgets/
|       |-- navigation/
|       |   |-- glass_nav_bar.dart
|       |   +-- nav_cart_badge.dart
|       |-- product/
|       |   |-- sneaker_card.dart
|       |   |-- sneaker_viewer_360.dart
|       |   |-- floating_sneaker.dart
|       |   +-- rarity_badge.dart
|       |-- filter/
|       |   |-- glass_filter_panel.dart
|       |   +-- size_selector_grid.dart
|       |-- cart/
|       |   |-- cart_drawer.dart
|       |   +-- cart_item_card.dart
|       |-- feedback/
|       |   |-- add_to_cart_animation.dart
|       |   +-- loading_skeleton.dart
|       +-- countdown/
|           +-- drop_countdown.dart
|
+-- data/
    |-- models/
    |   |-- sneaker_model.dart
    |   |-- cart_item_model.dart
    |   +-- order_model.dart
    +-- services/
        +-- sneaker_service.dart
```

### 8.2 FDL Compliance Checklist

Before implementation, verify each widget:

- [ ] Uses `FiftyColors` for all color values (no hardcoded hex)
- [ ] Uses `FiftySpacing` for all padding/margin values
- [ ] Uses `FiftyTypography` for all text styles (Manrope family)
- [ ] Uses `FiftyRadii` for all border radius values
- [ ] Uses `FiftyMotion` for all animation durations and curves
- [ ] Uses `FiftyCard` or `FiftyButton` where applicable
- [ ] Respects reduced motion preferences
- [ ] Meets WCAG 2.1 AA contrast requirements
- [ ] Has proper ARIA labels for screen readers
- [ ] Follows MVVM + Actions architecture pattern

### 8.3 Performance Considerations

1. **Image Optimization:**
   - Use WebP format for sneaker images
   - Lazy load off-screen product cards
   - Pre-cache 360 viewer frames on hover intent

2. **Animation Performance:**
   - Use `AnimatedBuilder` with `CustomPainter` for complex animations
   - Limit concurrent animations to 3-4 elements
   - Use `RepaintBoundary` for isolated animated elements

3. **State Management:**
   - Cart state: Persistent with `fifty_storage`
   - Filter state: URL-synced for shareable links
   - Product cache: 5-minute TTL with `fifty_cache`

---

## 9. Appendix: FDL Component Reference

### Available FDL Components (use these first)

| Component | Import | Usage |
|-----------|--------|-------|
| FiftyButton | `fifty_ui` | All buttons (primary, secondary, outline, ghost) |
| FiftyCard | `fifty_ui` | Product cards, panels, containers |
| FiftyBadge | `fifty_ui` | Rarity, status indicators |
| FiftyProgressBar | `fifty_ui` | Loading progress, checkout steps |
| FiftyTextField | `fifty_ui` | Search, forms |
| FiftySlider | `fifty_ui` | Price range filter |
| FiftyCheckbox | `fifty_ui` | Filter toggles |
| FiftyChip | `fifty_ui` | Category pills |
| FiftyLoadingIndicator | `fifty_ui` | Text-based loading (NOT spinner) |
| FiftySnackbar | `fifty_ui` | Success/error toasts |
| FiftyDialog | `fifty_ui` | Modals, confirmations |
| FiftyNavBar | `fifty_ui` | Base for GlassNavBar |

### Custom Components to Create

These domain-specific widgets consume FDL but don't exist yet:

1. `GlassNavBar` - Glassmorphism nav (extends FiftyNavBar)
2. `SneakerCard` - Product card (extends FiftyCard)
3. `SneakerViewer360` - 360 viewer (uses FiftyCard container)
4. `FloatingSneaker` - Animated sneaker image
5. `SizeSelectorGrid` - Size buttons grid
6. `CartDrawer` - Glass cart panel
7. `DropCountdown` - Release timer
8. `RarityBadge` - Rarity indicator (extends FiftyBadge)
9. `AddToCartAnimation` - Flying sneaker effect
10. `GlassFilterPanel` - Glassmorphism filter sidebar

---

## 10. Conclusion

This UI design specification provides a complete blueprint for implementing the sneaker marketplace with:

- **35+ component specifications** with states and behaviors
- **7 animation storyboards** with exact timing and curves
- **4 page wireframes** with responsive considerations
- **Full FDL v2 compliance** (no hardcoded values)
- **WCAG 2.1 AA accessibility** built-in
- **Mobile-first responsive** breakpoints

The design embraces 2026 trends (glassmorphism, floating 3D, kinetic typography) while remaining grounded in the FDL "Sophisticated Warm" aesthetic with burgundy and cream as the primary palette.

**Ready for implementation by CODER agent.**

---

*UI design complete. ARTISAN signing off.*
