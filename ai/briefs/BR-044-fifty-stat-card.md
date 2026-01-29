# BR-044: FiftyStatCard Component

**Type:** Feature
**Priority:** P1-High
**Effort:** S-Small (< 1d)
**Status:** Done
**Created:** 2026-01-27
**Completed:** 2026-01-27

---

## Problem

The FDL v2 design system includes small metric/stat cards for displaying KPIs with trend indicators. We don't have this component in fifty_ui.

---

## Goal

Create `FiftyStatCard` widget for displaying metrics with:
- Icon in colored container
- Trend indicator (up/down arrow with percentage)
- Label text
- Large value display
- Optional highlight variant (primary background)

---

## Design Reference

**File:** `design_system/v2/fifty_ui_kit_components_4/screen.png`

```
┌─────────────────────────┐
│ [icon]          ↑ 12%   │
│                         │
│ Total Views             │
│ 45.2k                   │
└─────────────────────────┘
```

**Variants:**
1. **Standard** - White/surface background, colored icon
2. **Highlight** - Primary burgundy background, white text

---

## Implementation

### API Design

```dart
enum FiftyStatTrend { up, down, neutral }

class FiftyStatCard extends StatelessWidget {
  const FiftyStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.trend,
    this.trendValue,
    this.iconColor,
    this.highlight = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final FiftyStatTrend? trend;
  final String? trendValue; // e.g., "12%"
  final Color? iconColor;
  final bool highlight;
}
```

### Usage

```dart
// Standard stat card
FiftyStatCard(
  label: 'Total Views',
  value: '45.2k',
  icon: Icons.visibility,
  trend: FiftyStatTrend.up,
  trendValue: '12%',
)

// Highlight variant
FiftyStatCard(
  label: 'Revenue',
  value: '\$12.5k',
  icon: Icons.account_balance_wallet,
  highlight: true,
)
```

---

## Related Files

**Create:**
- `packages/fifty_ui/lib/src/display/fifty_stat_card.dart`
- `packages/fifty_ui/test/display/fifty_stat_card_test.dart`

**Modify:**
- `packages/fifty_ui/lib/fifty_ui.dart` (export)
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/display_section.dart`

**Reference:**
- `design_system/v2/fifty_ui_kit_components_4/screen.png`
- `design_system/v2/fifty_ui_kit_components_4/code.html`

---

## Acceptance Criteria

1. [x] FiftyStatCard renders with icon, label, and value
2. [x] Trend indicator shows up/down arrow with color
3. [x] Highlight variant uses primary background
4. [x] Icon container has subtle background color
5. [x] Responsive sizing (fixed height ~128px per design)
6. [x] Dark/light mode support
7. [x] Tests pass (8/8)
8. [x] Demo showcases both variants

---

## Implementation Notes

**Commit:** d3306b7 - feat(fifty_ui): add FiftyStatCard component

**Files Created:**
- `packages/fifty_ui/lib/src/display/fifty_stat_card.dart` - New component implementation

**Files Modified:**
- `packages/fifty_ui/lib/fifty_ui.dart` - Added export for FiftyStatCard
- `packages/fifty_ui/test/display/fifty_stat_card_test.dart` - 8 tests added
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/display_section.dart` - Added showcase

**Key Implementation Details:**
- `FiftyStatTrend` enum with `up`, `down`, `neutral` values
- Trend indicator color: green for up, red for down, neutral for unchanged
- Icon rendered in circular container with subtle background
- Highlight variant inverts colors for emphasis
- Fixed height of 128px per FDL v2 specification

**Deviations from Spec:**
- None - implementation matches FDL v2 design specification

---

**Created:** 2026-01-27
**Design Source:** fifty_ui_kit_components_4
