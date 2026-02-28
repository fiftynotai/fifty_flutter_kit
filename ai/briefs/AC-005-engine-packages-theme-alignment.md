# AC-005: Engine Packages — Theme Alignment

**Type:** Architecture Cleanup
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Ready
**Created:** 2026-02-28
**Parent:** AC-001 (Theme Customization System)
**Blocked By:** AC-003 (fifty_theme parameterization)

---

## Architecture Issue

**What's the problem?**

- [x] Logical inconsistency (some engine packages hardcode `FiftyColors.*` in widgets instead of reading from theme)

**Where is it?**

3 packages have gaps:

| Package | File | Issue | Severity |
|---------|------|-------|----------|
| **fifty_connectivity** | `widgets/offline_status_card.dart` | `FiftyColors.burgundy` hardcoded for "Signal Lost" title | Low |
| **fifty_connectivity** | `widgets/offline_status_card.dart` | `FiftyColors.slateGrey` hardcoded for status text | Low |
| **fifty_achievement_engine** | `widgets/achievement_card.dart` | Rarity color map hardcodes 5 hex values | Medium |
| **fifty_skill_tree** | `themes/skill_tree_theme.dart` | Custom theme system with hardcoded dark/light presets | Low (has copyWith) |

5 packages are clean — no changes needed:
- fifty_forms (pure Theme.of)
- fifty_audio_engine (safe extension fallback)
- fifty_speech_engine (pure Theme.of)
- fifty_printing_engine (no UI)
- fifty_scroll_sequence (no color styling)

---

## Goal

After this brief:

- All engine package widgets respect consumer's `Theme.of(context)`
- Rarity colors in achievements are configurable via parameter (default to current values)
- SkillTreeTheme has a factory that reads from `Theme.of(context)`
- Connectivity widgets use `colorScheme.error` instead of `FiftyColors.burgundy`

---

## Cleanup Steps

### 1. fifty_connectivity: Replace FiftyColors References

```dart
// BEFORE:
Text('SIGNAL LOST', style: TextStyle(color: FiftyColors.burgundy))
Text(message, style: TextStyle(color: FiftyColors.slateGrey))

// AFTER:
Text('SIGNAL LOST', style: TextStyle(color: colorScheme.error))
Text(message, style: TextStyle(color: colorScheme.onSurfaceVariant))
```

### 2. fifty_achievement_engine: Configurable Rarity Colors

```dart
// BEFORE: Hardcoded rarity map (not configurable)
Color _getRarityColor(AchievementRarity rarity) {
  switch (rarity) {
    case AchievementRarity.common: return FiftyColors.slateGrey;
    case AchievementRarity.rare: return Color(0xFF5B8BD4);
    case AchievementRarity.epic: return Color(0xFF9B59B6);
    case AchievementRarity.legendary: return Color(0xFFE67E22);
  }
}

// AFTER: Accept optional rarity color map, default to current values
class AchievementCard<T> extends StatelessWidget {
  /// Custom rarity color mapping. If null, uses default colors.
  final Map<AchievementRarity, Color>? rarityColors;

  Color _getRarityColor(AchievementRarity rarity, ColorScheme colorScheme) {
    if (rarityColors != null && rarityColors!.containsKey(rarity)) {
      return rarityColors![rarity]!;
    }
    // Default rarity colors (domain-specific, not theme-derived)
    switch (rarity) {
      case AchievementRarity.common: return colorScheme.onSurfaceVariant;
      case AchievementRarity.uncommon: return colorScheme.tertiary;
      case AchievementRarity.rare: return Color(0xFF5B8BD4);
      case AchievementRarity.epic: return Color(0xFF9B59B6);
      case AchievementRarity.legendary: return Color(0xFFE67E22);
    }
  }
}
```

Note: Rare/Epic/Legendary colors are intentionally not theme-derived — they're game domain colors. But they're now overridable via parameter.

### 3. fifty_skill_tree: Theme-Reading Factory

```dart
// BEFORE: Only hardcoded presets
SkillTreeTheme.dark()  // Hardcoded dark palette
SkillTreeTheme.light() // Hardcoded light palette

// AFTER: Add factory that reads from Theme.of(context)
factory SkillTreeTheme.fromContext(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final fifty = Theme.of(context).extension<FiftyThemeExtension>();

  return SkillTreeTheme(
    backgroundColor: colorScheme.surface,
    lockedNodeColor: colorScheme.surfaceContainerHighest,
    availableNodeColor: colorScheme.surfaceContainer,
    unlockedNodeColor: colorScheme.primaryContainer,
    maxedNodeColor: colorScheme.primary,
    connectionColor: colorScheme.outline,
    connectionUnlockedColor: colorScheme.primary,
    textColor: colorScheme.onSurface,
    // ... map all properties from theme
  );
}

// Keep existing presets as-is for backward compat:
SkillTreeTheme.dark()   // Still works
SkillTreeTheme.light()  // Still works
SkillTreeTheme.fromContext(context) // NEW: reads app theme
```

---

## Tasks

### Pending
- [ ] Task 1: Fix fifty_connectivity `OfflineStatusCard` — replace `FiftyColors.burgundy` with `colorScheme.error`
- [ ] Task 2: Fix fifty_connectivity `OfflineStatusCard` — replace `FiftyColors.slateGrey` with `colorScheme.onSurfaceVariant`
- [ ] Task 3: Audit fifty_connectivity for any other direct token references
- [ ] Task 4: Add `rarityColors` parameter to `AchievementCard`
- [ ] Task 5: Update `_getRarityColor` to use parameter or default
- [ ] Task 6: Use `colorScheme.onSurfaceVariant` for common rarity (instead of `FiftyColors.slateGrey`)
- [ ] Task 7: Use `colorScheme.tertiary` for uncommon rarity (instead of `FiftyColors.hunterGreen`)
- [ ] Task 8: Audit achievement engine for other direct token references
- [ ] Task 9: Add `SkillTreeTheme.fromContext(BuildContext)` factory
- [ ] Task 10: Document `fromContext` in SkillTreeTheme API docs
- [ ] Task 11: Write tests — connectivity widgets with custom theme
- [ ] Task 12: Write tests — achievement card with custom rarity colors
- [ ] Task 13: Write tests — SkillTreeTheme.fromContext reads from theme
- [ ] Task 14: Run `flutter analyze` — zero issues across affected packages

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** Brief registered, blocked by AC-003
**Next Steps When Resuming:** Wait for AC-003, then start with connectivity fixes
**Last Updated:** 2026-02-28
**Blockers:** AC-003 (fifty_theme parameterization)

---

## Acceptance Criteria

1. [ ] Zero `FiftyColors.*` references in fifty_connectivity widget build methods
2. [ ] `AchievementCard` accepts optional `rarityColors` parameter
3. [ ] `SkillTreeTheme.fromContext(context)` reads from consumer's theme
4. [ ] All existing presets (dark/light) still work unchanged
5. [ ] Common/Uncommon rarity use theme colors by default
6. [ ] Custom theme propagates through all engine package widgets
7. [ ] All existing tests pass
8. [ ] `flutter analyze` passes (zero issues)

---

## Affected Areas

### Files to Modify
- `packages/fifty_connectivity/lib/src/widgets/offline_status_card.dart`
- `packages/fifty_achievement_engine/lib/src/widgets/achievement_card.dart`
- `packages/fifty_skill_tree/lib/src/themes/skill_tree_theme.dart`

### Files Unaffected (Clean)
- `packages/fifty_forms/` — no changes
- `packages/fifty_audio_engine/` — no changes
- `packages/fifty_speech_engine/` — no changes
- `packages/fifty_printing_engine/` — no changes
- `packages/fifty_scroll_sequence/` — no changes

**Total files affected:** 3
**Estimated changes:** ~80-120 lines

---

## References

**Parent Brief:** AC-001
**Depends On:** AC-003 (fifty_theme parameterization)
**Can Parallel With:** AC-004 (fifty_ui)

---

**Created:** 2026-02-28
**Last Updated:** 2026-02-28
**Brief Owner:** Fifty.ai
