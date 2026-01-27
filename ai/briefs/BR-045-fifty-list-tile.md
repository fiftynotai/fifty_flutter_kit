# BR-045: FiftyListTile Component

**Type:** Feature
**Priority:** P1-High
**Effort:** S-Small (< 1d)
**Status:** In Progress
**Created:** 2026-01-27

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

1. [ ] FiftyListTile renders with icon, title, subtitle
2. [ ] Leading icon has circular colored background
3. [ ] Trailing text supports two lines (value + date)
4. [ ] Custom trailing text color (green for positive, default for negative)
5. [ ] Hover state with subtle background change
6. [ ] Optional divider below tile
7. [ ] Dark/light mode support
8. [ ] Tests pass
9. [ ] Demo showcases transaction list example

---

**Created:** 2026-01-27
**Design Source:** fifty_ui_kit_components_4
