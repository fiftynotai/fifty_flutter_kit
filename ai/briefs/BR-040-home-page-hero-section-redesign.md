# BR-040: Home Page & Hero Section Redesign

**Type:** Feature / UI Enhancement
**Priority:** P1-High
**Effort:** M-Medium
**Status:** Ready

---

## Problem

**Hero Section Issue:**
The current hero section uses `FiftyHeroSection` which displays TEXT with a gradient. The design reference shows a CARD with a gradient BACKGROUND IMAGE (wave pattern), badge, title, and dot indicators. These are completely different components.

**Home Page Issue:**
The home page shows a simple list of ecosystem status and feature cards. The design reference shows:
- Featured cards with images, prices, ratings
- Analytics cards with statistics (45.2k views, 8.4k likes, 350 orders, $12.5k revenue)
- Recent transactions list

---

## Goal

Redesign the hero section and home page to match the design system reference images.

---

## Context & Inputs

### Affected Files
- `apps/fifty_demo/lib/app/fifty_demo_app.dart` (hero section)
- `apps/fifty_demo/lib/features/home/views/home_page.dart`
- `apps/fifty_demo/lib/features/home/views/widgets/ecosystem_status.dart`
- `apps/fifty_demo/lib/features/home/views/widgets/feature_nav_card.dart`

### Design Reference
- `design_system/v2/fifty_ui_kit_components_1/screen.png` - Shows hero card with gradient background
- `design_system/v2/fifty_ui_kit_components_4/screen.png` - Shows analytics cards layout

---

## Required Changes

### 1. Hero Section - Create Hero Card (not hero text)

**Current (Wrong):**
```dart
FiftyHeroSection(
  title: 'FIFTY DEMO',
  subtitle: 'Flutter Kit Showcase',
  titleGradient: LinearGradient(...),
)
```

**Target (Hero Card with background):**
```dart
FiftyCard(
  padding: EdgeInsets.zero,
  child: Stack(
    children: [
      // Gradient background (or image)
      Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [FiftyColors.burgundy, FiftyColors.darkBurgundy],
          ),
          borderRadius: FiftyRadii.lgRadius,
        ),
      ),
      // Badge
      Positioned(
        top: 16,
        left: 16,
        child: FiftyBadge(label: 'FLUTTER KIT', variant: FiftyBadgeVariant.accent),
      ),
      // Title and subtitle
      Positioned(
        bottom: 24,
        left: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fifty Demo', style: FiftyTypography.headingStyle),
            Text('Design System v2.0', style: FiftyTypography.bodyStyle),
          ],
        ),
      ),
      // Dot indicators (optional)
    ],
  ),
)
```

### 2. Home Page - Add Analytics Cards

Add stats section matching design:
```dart
Row(
  children: [
    _StatsCard(icon: Icons.visibility, value: '45.2k', label: 'Total Views', trend: '+12%'),
    _StatsCard(icon: Icons.favorite, value: '8.4k', label: 'Likes', trend: '+5%'),
  ],
)
Row(
  children: [
    _StatsCard(icon: Icons.shopping_cart, value: '350', label: 'Orders', trend: '+2%'),
    _StatsCard(icon: Icons.attach_money, value: '\$12.5k', label: 'Revenue', color: FiftyColors.hunterGreen),
  ],
)
```

### 3. Section Headers - Add Dot Indicator

Design shows: `● SECTION NAME` (burgundy dot + uppercase label)

Current SectionHeader may need update to match this pattern.

---

## Design Decision

**Hero card location decision:**
- If unique to this app → Create in `apps/fifty_demo/lib/shared/widgets/`
- If useful globally (2+ packages could use it) → Create `FiftyHeroCard` in fifty_ui

Recommend: Create as demo-specific widget first, promote to fifty_ui later if needed.

---

## Constraints

- Follow FDL v2 design tokens
- Use FiftyCard, FiftyBadge, and other fifty_ui components
- Match design reference images

---

## FDL v2 Colors Reference

| Name | Hex | Usage |
|------|-----|-------|
| darkBurgundy | #1A0D0E | Background |
| surfaceDark | #2A1517 | Cards/surfaces |
| burgundy | #88292F | Primary/CTA |
| slateGrey | #335C67 | Secondary, switch ON state |
| hunterGreen | #4B644A | Success |
| cream | #FEFEE3 | Text |
| powderBlush | #FFC9B9 | Accent |

---

## Acceptance Criteria

- [ ] Hero section shows a CARD with gradient background (not text with gradient)
- [ ] Hero card has badge, title, subtitle layout matching design
- [ ] Home page has analytics/stats cards section
- [ ] Section headers have burgundy dot indicator
- [ ] Overall home layout matches design_system/v2 images
- [ ] No more "old gradient color style" on title

---

## Test Plan

### Manual Testing
1. Launch app
2. Verify hero card appears with gradient background
3. Verify analytics cards display with proper styling
4. Verify section headers have dot indicators
5. Compare with design_system/v2 images

### Automated Testing
- No new tests required (UI layout)

---

## Delivery

- [ ] Update/create hero card widget
- [ ] Update home_page.dart
- [ ] Add analytics/stats cards
- [ ] Update section_header.dart if needed
- [ ] Run `flutter analyze` - 0 issues
- [ ] Visual verification against design_system/v2 images
