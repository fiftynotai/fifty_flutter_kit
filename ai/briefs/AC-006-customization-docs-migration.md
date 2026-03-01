# AC-006: Documentation + Migration Guide

**Type:** Architecture Cleanup
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** In Progress
**Created:** 2026-02-28
**Parent:** AC-001 (Theme Customization System)
**Blocked By:** AC-004 + AC-005

---

## Architecture Issue

**What's the problem?**

After AC-002 through AC-005, the Fifty Flutter Kit will have a new configuration system. Consumers need:
1. Migration guide for the `static const` → getter breaking change
2. Updated README documentation for each affected package
3. Example app demonstrating custom theme configuration
4. Updated `coding_guidelines.md` to reflect the new patterns

---

## Goal

After this brief:

- Every consumer knows how to configure Fifty Flutter Kit for their brand
- Breaking changes are documented with migration steps
- Example code shows all 4 customization levels
- coding_guidelines.md reflects new engine package theming rules

---

## Tasks

### Pending
- [ ] Task 1: Write migration guide for `static const` → getter change (const context breakage)
- [ ] Task 2: Update `packages/fifty_tokens/README.md` — add Configuration section
- [ ] Task 3: Update `packages/fifty_theme/README.md` — add Customization section
- [ ] Task 4: Update `packages/fifty_ui/README.md` — add Theming section
- [ ] Task 5: Add configuration example to example app or create standalone example
- [ ] Task 6: Update `ai/context/coding_guidelines.md` — Engine Package Checklist section
- [ ] Task 7: Document FontSource (Google Fonts vs asset fonts) with examples
- [ ] Task 8: Document all 4 customization levels with code examples
- [ ] Task 9: Version bump all affected packages (minor version for breaking, patch for non-breaking)
- [ ] Task 10: Update CHANGELOG.md for each affected package

### In Progress

### Completed

---

## Documentation Outline

### Migration Guide (for existing consumers)

```markdown
## Migrating to Configurable Tokens

### Breaking Change: `static const` → Getters

Token values like `FiftyColors.primary` are no longer `const`.
This means they cannot be used in `const` widget constructors.

**Before (won't compile):**
```dart
const Text('Hello', style: TextStyle(color: FiftyColors.primary));
```

**After:**
```dart
Text('Hello', style: TextStyle(color: FiftyColors.primary));
// Remove const — value is now a runtime getter
```

**Impact:** Low. Most usage is inside `build()` methods where `const` isn't used.
Search for `const.*FiftyColors` and `const.*FiftySpacing` in your codebase.

### New Feature: Token Configuration

```dart
// Before runApp(), optionally configure:
FiftyTokens.configure(
  colors: FiftyColorConfig(primary: Color(0xFF1E88E5)),
);
```

If you don't call `configure()`, everything works exactly as before.
```

### README Configuration Section Template

```markdown
## Configuration

### Quick Start (FDL Defaults)
```dart
// Zero configuration — Fifty Design Language v2 defaults
runApp(MaterialApp(theme: FiftyTheme.dark(), home: MyApp()));
```

### Custom Brand Colors
```dart
FiftyTokens.configure(
  colors: FiftyColorConfig(
    primary: Color(0xFF1E88E5),
    secondary: Color(0xFF43A047),
  ),
);
```

### Custom Font (Google Fonts)
```dart
FiftyTokens.configure(
  typography: FiftyTypographyConfig(
    fontFamily: 'Inter',
    source: FontSource.googleFonts,
  ),
);
```

### Custom Font (Local Assets)
```dart
FiftyTokens.configure(
  typography: FiftyTypographyConfig(
    fontFamily: 'CustomBrand',
    source: FontSource.asset,
  ),
);
```
// Ensure font is declared in pubspec.yaml:
// fonts:
//   - family: CustomBrand
//     fonts:
//       - asset: assets/fonts/CustomBrand-Regular.ttf
```

---

## Workflow State

**Phase:** COMMITTING
**Active Agent:** none
**Retry Count:** 1

### Current Work
All phases complete. Committing.

### Next Steps
Commit and complete.

### Agent Log
| Time | Agent | Action | Result |
|------|-------|--------|--------|
| 2026-02-28 | architect | Create implementation plan | SUCCESS — ~1,377 const removals across ~148 files + docs/versioning |
| 2026-02-28 | forger | Implement all changes | SUCCESS — ~160+ files modified, 936 tests pass, zero analyzer errors |
| 2026-02-28 | sentinel | Run test suite | FAIL — 2 remaining const errors in example files |
| 2026-02-28 | forger | Fix 2 const errors | SUCCESS — removed const from 2 example files |
| 2026-02-28 | sentinel | Re-run test suite | PASS — 0 errors, 936 tests, 0 const residue |
| 2026-02-28 | warden | Code review | APPROVE — 0 critical/major, 7 minor (all non-blocking) |
| 2026-02-28 | /document | Documentation | Skipped — AC-006 IS the documentation brief |

---

## Session State (Tactical - This Brief)

**Current State:** In Progress — INIT phase
**Next Steps When Resuming:** Continue with current phase
**Last Updated:** 2026-02-28
**Blockers:** None (AC-004 + AC-005 Done)

---

## Acceptance Criteria

1. [ ] Migration guide covers `const` → getter breaking change
2. [ ] fifty_tokens README has Configuration section with all options
3. [ ] fifty_theme README has Customization section with 4 levels
4. [ ] Font configuration documented for both Google Fonts and asset fonts
5. [ ] Example code compiles and demonstrates custom theme
6. [ ] coding_guidelines.md updated with new engine package rules
7. [ ] CHANGELOG.md updated for all affected packages
8. [ ] Version bumps applied

---

## References

**Parent Brief:** AC-001
**Depends On:** AC-004 + AC-005 (all implementation complete)

---

**Created:** 2026-02-28
**Last Updated:** 2026-02-28
**Brief Owner:** Fifty.ai
