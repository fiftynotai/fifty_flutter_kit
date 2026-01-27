# BR-047: FiftyProgressCard Component

**Type:** Feature
**Priority:** P2-Medium
**Effort:** S-Small (< 1d)
**Status:** Done
**Created:** 2026-01-27

---

## Problem

The FDL v2 design system includes a horizontal progress card for displaying goals/metrics with progress bars. We don't have this component in fifty_ui.

---

## Goal

Create `FiftyProgressCard` widget for displaying progress metrics with:
- Icon in subtle background
- Title with percentage
- Progress bar (gradient)
- Subtitle/description text
- Slate-grey background (per design)

---

## Design Reference

**File:** `design_system/v2/fifty_ui_kit_components_4/screen.png`

```
┌─────────────────────────────────────────┐
│ [📈] Weekly Goal                   75%  │
│ ████████████████████░░░░░░░             │
│ 12 sales remaining to reach target      │
└─────────────────────────────────────────┘
```

**Styling:**
- Background: slate-grey
- Progress bar: gradient (powder-blush → primary)
- Text: cream/white

---

## Implementation

### API Design

```dart
class FiftyProgressCard extends StatelessWidget {
  const FiftyProgressCard({
    super.key,
    required this.title,
    required this.progress,
    this.icon,
    this.subtitle,
    this.showPercentage = true,
    this.progressGradient,
  });

  final String title;
  final double progress; // 0.0 to 1.0
  final IconData? icon;
  final String? subtitle;
  final bool showPercentage;
  final Gradient? progressGradient;
}
```

### Usage

```dart
FiftyProgressCard(
  icon: Icons.trending_up,
  title: 'Weekly Goal',
  progress: 0.75,
  subtitle: '12 sales remaining to reach target',
)

// Custom gradient
FiftyProgressCard(
  title: 'Upload Progress',
  progress: 0.45,
  progressGradient: LinearGradient(
    colors: [FiftyColors.hunterGreen, FiftyColors.slateGrey],
  ),
)
```

---

## Related Files

**Create:**
- `packages/fifty_ui/lib/src/display/fifty_progress_card.dart`
- `packages/fifty_ui/test/display/fifty_progress_card_test.dart`

**Modify:**
- `packages/fifty_ui/lib/fifty_ui.dart` (export)
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/display_section.dart`

**Reference:**
- `design_system/v2/fifty_ui_kit_components_4/screen.png`
- `design_system/v2/fifty_ui_kit_components_4/code.html`

---

## Acceptance Criteria

1. [x] FiftyProgressCard renders with title and progress bar
2. [x] Progress bar shows gradient (powder-blush → primary by default)
3. [x] Percentage displayed in top-right
4. [x] Icon rendered in subtle background container
5. [x] Subtitle text below progress bar
6. [x] Slate-grey background color
7. [x] Animates progress changes smoothly
8. [x] Tests pass (15/15)
9. [x] Demo showcases progress card

---

**Created:** 2026-01-27
**Design Source:** fifty_ui_kit_components_4
