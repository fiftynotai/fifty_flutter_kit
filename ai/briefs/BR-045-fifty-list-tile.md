# BR-045: FiftyListTile Component

**Type:** Feature
**Priority:** P1-High
**Effort:** S-Small (< 1d)
**Status:** Done
**Created:** 2026-01-27
**Completed:** 2026-01-27

---

## Problem

The FDL v2 design system includes styled list items for transactions, settings, and other list-based content. We don't have a dedicated list tile component in fifty_ui.

---

## Goal

Create `FiftyListTile` widget for displaying list items with:
- Leading icon in colored circle
- Title and subtitle
- Trailing content (value, date, chevron, etc.)
- Optional divider
- Tap handling with hover state

---

## Design Reference

**File:** `design_system/v2/fifty_ui_kit_components_4/screen.png`

```
┌─────────────────────────────────────────┐
│ [🔵]  Subscription         -$54.00      │
│       Adobe Creative Cloud    Today     │
├─────────────────────────────────────────┤
│ [🟢]  Deposit              +$850.00     │
│       Freelance Work       Yesterday    │
└─────────────────────────────────────────┘
```

---

## Implementation

### API Design

```dart
class FiftyListTile extends StatelessWidget {
  const FiftyListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.leadingIcon,
    this.leadingIconColor,
    this.leadingIconBackgroundColor,
    this.trailing,
    this.trailingText,
    this.trailingSubtext,
    this.trailingTextColor,
    this.onTap,
    this.showDivider = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final Color? leadingIconBackgroundColor;
  final Widget? trailing;
  final String? trailingText;
  final String? trailingSubtext;
  final Color? trailingTextColor;
  final VoidCallback? onTap;
  final bool showDivider;
}
```

### Usage

```dart
// Transaction item
FiftyListTile(
  leadingIcon: Icons.subscriptions,
  leadingIconColor: Colors.blue,
  leadingIconBackgroundColor: Colors.blue.withOpacity(0.1),
  title: 'Subscription',
  subtitle: 'Adobe Creative Cloud',
  trailingText: '-\$54.00',
  trailingSubtext: 'Today',
  onTap: () => navigateToDetail(),
)

// Settings item with chevron
FiftyListTile(
  leadingIcon: Icons.notifications,
  title: 'Notifications',
  subtitle: 'Push alerts enabled',
  trailing: Icon(Icons.chevron_right),
  onTap: () => openSettings(),
)
```

---

## Related Files

**Create:**
- `packages/fifty_ui/lib/src/display/fifty_list_tile.dart`
- `packages/fifty_ui/test/display/fifty_list_tile_test.dart`

**Modify:**
- `packages/fifty_ui/lib/fifty_ui.dart` (export)
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/display_section.dart`

**Reference:**
- `design_system/v2/fifty_ui_kit_components_4/screen.png`
- `design_system/v2/fifty_ui_kit_components_4/code.html`

---

## Acceptance Criteria

1. [x] FiftyListTile renders with icon, title, subtitle
2. [x] Leading icon has circular colored background
3. [x] Trailing text supports two lines (value + date)
4. [x] Custom trailing text color (green for positive, default for negative)
5. [x] Hover state with subtle background change
6. [x] Optional divider below tile
7. [x] Dark/light mode support
8. [x] Tests pass (10/10)
9. [x] Demo showcases transaction list example

---

## Implementation Notes

**Commit:** 586162b - feat(fifty_ui): add FiftyListTile component

**Files Created:**
- `packages/fifty_ui/lib/src/display/fifty_list_tile.dart` - New component implementation

**Files Modified:**
- `packages/fifty_ui/lib/fifty_ui.dart` - Added export for FiftyListTile
- `packages/fifty_ui/test/display/fifty_list_tile_test.dart` - 10 tests added
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/display_section.dart` - Added transaction list showcase

**Key Implementation Details:**
- Leading icon rendered in circular container with customizable background color
- Support for both custom `leading` widget and convenience `leadingIcon` parameter
- Two-line trailing text (value + subtext) for transaction displays
- Subtle hover background animation
- Optional bottom divider via `showDivider` parameter
- Flexible trailing area: can use `trailing` widget or `trailingText`/`trailingSubtext` strings

**Deviations from Spec:**
- None - implementation matches FDL v2 design specification

---

**Created:** 2026-01-27
**Design Source:** fifty_ui_kit_components_4
