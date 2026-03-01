# Implementation Plan: AC-006 (Documentation + Migration Guide + Const Fix)

**Complexity:** L (Large)
**Estimated Duration:** 6-8 hours
**Risk Level:** Medium

## Summary

Fix the `const` compilation breakage across the entire codebase caused by AC-002's `static const` to `static get` conversion in `fifty_tokens`, then write migration guide, update READMEs for three core packages, update CHANGELOGs, bump versions, and update `coding_guidelines.md` with new engine package theming rules.

---

## Critical Finding: Scope of `const` Breakage

### Only `FiftySpacing` is Affected

The audit reveals that **only `FiftySpacing.*`** tokens appear in `const` contexts. `FiftyRadii`, `FiftyTypography`, `FiftyMotion`, and `FiftyBreakpoints` have **zero** const-context usages anywhere in the codebase.

This is because `FiftySpacing` values are `double` (used in `const SizedBox(height: FiftySpacing.sm)` and `const EdgeInsets.all(FiftySpacing.md)`), while `FiftyRadii` convenience objects (`xxlRadius` etc.) were already non-const `static final` and the raw `double` values are rarely used in const contexts.

### Counts by Location

| Location | Files | Occurrences |
|----------|-------|-------------|
| `packages/` (lib/ source) | 45 | ~280 |
| `packages/` (example/ apps) | 53 | ~360 |
| `apps/` (coffee_showcase, fifty_demo, tactical_grid) | 42 | ~517 |
| `templates/` (mvvm_actions) | 13 | ~74 |
| **TOTAL** | **153** | **~1,231** |

### Breakdown by Package (lib/ source only -- the critical path)

| Package | Files | Occurrences | Notes |
|---------|-------|-------------|-------|
| `fifty_ui` | 26 | ~119 | SizedBox, EdgeInsets in widget layouts |
| `fifty_forms` | 12 | ~26 | Form widgets + field widgets |
| `fifty_achievement_engine` | 5 | ~31 | Widget spacing |
| `fifty_connectivity` | 2 | ~13 | Overlay + handler widgets |
| `fifty_speech_engine` | 2 | ~7 | TTS + STT controls |
| `fifty_theme` (README only) | 1 | ~1 | Code example in README |

### Breakdown by Package (example/ apps inside packages)

| Package Example | Files | Occurrences |
|-----------------|-------|-------------|
| `fifty_ui/example` | 1 | ~119 |
| `fifty_forms/example` | 5 | ~71 |
| `fifty_printing_engine/example` | 7 | ~79 |
| `fifty_connectivity/example` | 4 | ~36 |
| `fifty_achievement_engine/example` | 4 | ~35 |
| `fifty_speech_engine/example` | 4 | ~29 |
| `fifty_skill_tree/example` | 5 | ~47 |
| `fifty_audio_engine/example` | 6 | ~41 |
| `fifty_socket/example` | 3 | ~17 |
| `fifty_scroll_sequence/example` | 6 | ~20 |
| `fifty_world_engine/example` | 1 | ~5 |

### Breakdown by App

| App | Files | Occurrences |
|-----|-------|-------------|
| `fifty_demo` | 34 | ~472 |
| `tactical_grid` | 7 | ~46 |
| `coffee_showcase` | 1 | ~6 |

### The Fix

The fix is mechanical: remove the `const` keyword from expressions containing `FiftySpacing.*`. Two patterns:

**Pattern A: `const SizedBox(height: FiftySpacing.sm)`**
```dart
// Before (won't compile)
const SizedBox(height: FiftySpacing.sm)

// After
SizedBox(height: FiftySpacing.sm)
```

**Pattern B: `const EdgeInsets.all(FiftySpacing.md)`**
```dart
// Before (won't compile)
padding: const EdgeInsets.all(FiftySpacing.md),

// After
padding: EdgeInsets.all(FiftySpacing.md),
```

**Pattern C: `const EdgeInsets.only(top: FiftySpacing.md)`**
```dart
// Before
margin: const EdgeInsets.only(top: FiftySpacing.md),

// After
margin: EdgeInsets.only(top: FiftySpacing.md),
```

**Pattern D: Propagation -- parent widget `const` constructor**
```dart
// Before (if const propagates up through a parent)
const Padding(
  padding: EdgeInsets.all(FiftySpacing.md),
  child: Text('hello'),
)

// After
Padding(
  padding: EdgeInsets.all(FiftySpacing.md),
  child: const Text('hello'), // const moves to child if child is truly const
)
```

**IMPORTANT:** When removing `const` from a parent widget, check if children can retain `const`. The goal is to preserve as many `const` widgets as possible for performance.

---

## Files to Modify

### Phase 1: Const Removal (packages/lib/ -- CRITICAL)

| File | Action | Occurrences |
|------|--------|-------------|
| `packages/fifty_ui/lib/src/buttons/fifty_button.dart` | MODIFY | 5 |
| `packages/fifty_ui/lib/src/buttons/fifty_labeled_icon_button.dart` | MODIFY | 1 |
| `packages/fifty_ui/lib/src/inputs/fifty_text_field.dart` | MODIFY | 4 |
| `packages/fifty_ui/lib/src/inputs/fifty_switch.dart` | MODIFY | 1 |
| `packages/fifty_ui/lib/src/inputs/fifty_radio.dart` | MODIFY | 1 |
| `packages/fifty_ui/lib/src/inputs/fifty_dropdown.dart` | MODIFY | 3 |
| `packages/fifty_ui/lib/src/inputs/fifty_slider.dart` | MODIFY | 1 |
| `packages/fifty_ui/lib/src/inputs/fifty_checkbox.dart` | MODIFY | 1 |
| `packages/fifty_ui/lib/src/inputs/fifty_radio_card.dart` | MODIFY | 2 |
| `packages/fifty_ui/lib/src/containers/fifty_card.dart` | MODIFY | 1 |
| `packages/fifty_ui/lib/src/display/fifty_list_tile.dart` | MODIFY | 2 |
| `packages/fifty_ui/lib/src/display/fifty_status_indicator.dart` | MODIFY | 2 |
| `packages/fifty_ui/lib/src/display/fifty_data_slate.dart` | MODIFY | 4 |
| `packages/fifty_ui/lib/src/display/fifty_stat_card.dart` | MODIFY | 3 |
| `packages/fifty_ui/lib/src/display/fifty_chip.dart` | MODIFY | 2 |
| `packages/fifty_ui/lib/src/display/fifty_section_header.dart` | MODIFY | 5 |
| `packages/fifty_ui/lib/src/display/fifty_progress_bar.dart` | MODIFY | 1 |
| `packages/fifty_ui/lib/src/display/fifty_settings_row.dart` | MODIFY | 3 |
| `packages/fifty_ui/lib/src/display/fifty_progress_card.dart` | MODIFY | 5 |
| `packages/fifty_ui/lib/src/display/fifty_info_row.dart` | MODIFY | 3 |
| `packages/fifty_ui/lib/src/controls/fifty_segmented_control.dart` | MODIFY | 1 |
| `packages/fifty_ui/lib/src/controls/fifty_nav_pill.dart` | MODIFY | 1 |
| `packages/fifty_ui/lib/src/feedback/fifty_snackbar.dart` | MODIFY | 3 |
| `packages/fifty_ui/lib/src/feedback/fifty_dialog.dart` | MODIFY | 1 |
| `packages/fifty_ui/lib/src/molecules/fifty_code_block.dart` | MODIFY | 4 |
| `packages/fifty_forms/lib/src/widgets/fifty_form_array.dart` | MODIFY | 2 |
| `packages/fifty_forms/lib/src/widgets/fifty_multi_step_form.dart` | MODIFY | 4 |
| `packages/fifty_forms/lib/src/widgets/fifty_field_error.dart` | MODIFY | 2 |
| `packages/fifty_forms/lib/src/widgets/fifty_form_error.dart` | MODIFY | 3 |
| `packages/fifty_forms/lib/src/widgets/fifty_form_progress.dart` | MODIFY | 2 |
| `packages/fifty_forms/lib/src/widgets/fifty_validation_summary.dart` | MODIFY | 6 |
| `packages/fifty_forms/lib/src/widgets/fifty_form_field.dart` | MODIFY | 1 |
| `packages/fifty_forms/lib/src/fields/switch_form_field.dart` | MODIFY | 1 |
| `packages/fifty_forms/lib/src/fields/file_form_field.dart` | MODIFY | 3 |
| `packages/fifty_forms/lib/src/fields/slider_form_field.dart` | MODIFY | 1 |
| `packages/fifty_forms/lib/src/fields/checkbox_form_field.dart` | MODIFY | 1 |
| `packages/fifty_forms/lib/src/fields/radio_form_field.dart` | MODIFY | 1 |
| `packages/fifty_forms/lib/src/fields/dropdown_form_field.dart` | MODIFY | 1 |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_progress_bar.dart` | MODIFY | 1 |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_popup.dart` | MODIFY | 7 |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_summary.dart` | MODIFY | 13 |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_list.dart` | MODIFY | 4 |
| `packages/fifty_achievement_engine/lib/src/widgets/achievement_card.dart` | MODIFY | 6 |
| `packages/fifty_connectivity/lib/src/widgets/connection_overlay.dart` | MODIFY | 8 |
| `packages/fifty_connectivity/lib/src/widgets/connection_handler.dart` | MODIFY | 5 |
| `packages/fifty_speech_engine/lib/src/widgets/speech_tts_controls.dart` | MODIFY | 2 |
| `packages/fifty_speech_engine/lib/src/widgets/speech_stt_controls.dart` | MODIFY | 5 |

**Subtotal: 47 files, ~280 occurrences**

### Phase 2: Const Removal (packages/example/ apps)

| Location | Files | Occurrences |
|----------|-------|-------------|
| `packages/fifty_ui/example/lib/main.dart` | 1 | ~119 |
| `packages/fifty_forms/example/lib/` | 5 | ~71 |
| `packages/fifty_printing_engine/example/lib/` | 7 | ~79 |
| `packages/fifty_connectivity/example/lib/` | 4 | ~36 |
| `packages/fifty_achievement_engine/example/lib/` | 4 | ~35 |
| `packages/fifty_speech_engine/example/lib/` | 4 | ~29 |
| `packages/fifty_skill_tree/example/lib/` | 5 | ~47 |
| `packages/fifty_audio_engine/example/lib/` | 6 | ~41 |
| `packages/fifty_socket/example/lib/` | 3 | ~17 |
| `packages/fifty_scroll_sequence/example/lib/` | 6 | ~20 |
| `packages/fifty_world_engine/example/lib/` | 1 | ~5 |

**Subtotal: 46 files, ~499 occurrences**

### Phase 3: Const Removal (apps/)

| Location | Files | Occurrences |
|----------|-------|-------------|
| `apps/fifty_demo/lib/` | 34 | ~472 |
| `apps/tactical_grid/lib/` | 7 | ~46 |
| `apps/coffee_showcase/lib/` | 1 | ~6 |

**Subtotal: 42 files, ~524 occurrences**

### Phase 4: Const Removal (templates/)

| Location | Files | Occurrences |
|----------|-------|-------------|
| `templates/mvvm_actions/lib/` | 13 | ~74 |

**Subtotal: 13 files, ~74 occurrences**

### Phase 5: Documentation

| File | Action | Changes |
|------|--------|---------|
| `docs/MIGRATION_GUIDE.md` | CREATE | Migration guide for AC-001 pipeline |
| `packages/fifty_tokens/README.md` | MODIFY | Add Configuration section, update code examples |
| `packages/fifty_theme/README.md` | MODIFY | Add Customization section, fix const in code examples |
| `packages/fifty_ui/README.md` | MODIFY | Add Theming section, note const change |
| `packages/fifty_tokens/CHANGELOG.md` | MODIFY | Add 2.0.0 entry |
| `packages/fifty_theme/CHANGELOG.md` | MODIFY | Add 2.0.0 entry |
| `packages/fifty_ui/CHANGELOG.md` | MODIFY | Add 0.7.0 entry |
| `packages/fifty_forms/CHANGELOG.md` | MODIFY | Add 0.2.0 entry |
| `packages/fifty_connectivity/CHANGELOG.md` | MODIFY | Add 0.2.0 entry |
| `packages/fifty_achievement_engine/CHANGELOG.md` | MODIFY | Add 0.2.0 entry |
| `packages/fifty_speech_engine/CHANGELOG.md` | MODIFY | Add 0.2.0 entry |
| `packages/fifty_skill_tree/CHANGELOG.md` | MODIFY | Add 0.2.0 entry |
| `ai/context/coding_guidelines.md` | MODIFY | Update Engine Package section |

### Phase 6: Version Bumps

| File | Action | Version Change |
|------|--------|----------------|
| `packages/fifty_tokens/pubspec.yaml` | MODIFY | 1.0.3 -> 2.0.0 (MAJOR: breaking const change, 1.x semver) |
| `packages/fifty_theme/pubspec.yaml` | MODIFY | 1.0.1 -> 2.0.0 (MAJOR: new API surface, depends on tokens 2.0) |
| `packages/fifty_ui/pubspec.yaml` | MODIFY | 0.6.2 -> 0.7.0 (MINOR: 0.x semver allows breaking in minor) |
| `packages/fifty_forms/pubspec.yaml` | MODIFY | 0.1.2 -> 0.2.0 |
| `packages/fifty_connectivity/pubspec.yaml` | MODIFY | 0.1.3 -> 0.2.0 |
| `packages/fifty_achievement_engine/pubspec.yaml` | MODIFY | 0.1.3 -> 0.2.0 |
| `packages/fifty_speech_engine/pubspec.yaml` | MODIFY | 0.1.2 -> 0.2.0 |
| `packages/fifty_skill_tree/pubspec.yaml` | MODIFY | 0.1.2 -> 0.2.0 |

**Note on Semver:**
- `fifty_tokens` (v1.0.3) and `fifty_theme` (v1.0.1) are >= 1.0.0, so breaking changes require MAJOR bump -> 2.0.0
- All other packages are 0.x, so breaking changes can go in MINOR bump -> 0.2.0 / 0.7.0
- Packages without source changes (fifty_printing_engine, fifty_audio_engine, etc.) do NOT get version bumps -- only their example/ apps get const fixes, which are not published

---

## Implementation Steps

### Phase 1: Fix Const Breakage in Package Sources (CRITICAL)

**Goal:** Make all packages compile again.

**Strategy:** Process packages in dependency order (bottom-up):
1. fifty_ui (26 files, ~119 occurrences)
2. fifty_forms (12 files, ~26 occurrences)
3. fifty_achievement_engine (5 files, ~31 occurrences)
4. fifty_connectivity (2 files, ~13 occurrences)
5. fifty_speech_engine (2 files, ~7 occurrences)

**For each file:**
1. Read the file
2. Find all `const` expressions containing `FiftySpacing.*`
3. Remove `const` from the immediate expression (SizedBox, EdgeInsets, etc.)
4. If removing `const` from a parent, check if children can retain `const`
5. Do NOT change any logic, only remove `const` keywords

**Verification after each package:**
- Run `flutter analyze --no-fatal-warnings` in the package directory
- Ensure zero `invalid_constant` / `const_with_non_constant_argument` errors
- Run existing tests to ensure no regressions

### Phase 2: Fix Const Breakage in Package Examples

**Goal:** Make all example apps compile.

Process each package's `example/` directory. Same mechanical fix.

**Order:** fifty_ui/example (119 occurrences in 1 file!) -> fifty_forms/example -> fifty_printing_engine/example -> fifty_connectivity/example -> fifty_achievement_engine/example -> fifty_speech_engine/example -> fifty_skill_tree/example -> fifty_audio_engine/example -> fifty_socket/example -> fifty_scroll_sequence/example -> fifty_world_engine/example

**Verification:** `flutter analyze` in each example directory.

### Phase 3: Fix Const Breakage in Apps

**Goal:** Make all demo/showcase apps compile.

1. `apps/fifty_demo/` (34 files, ~472 occurrences -- largest single target)
2. `apps/tactical_grid/` (7 files, ~46 occurrences)
3. `apps/coffee_showcase/` (1 file, ~6 occurrences)

**Verification:** `flutter analyze` in each app directory.

### Phase 4: Fix Const Breakage in Templates

**Goal:** Keep the MVVM+Actions template compilable.

1. `templates/mvvm_actions/` (13 files, ~74 occurrences)

**Verification:** `flutter analyze` in template directory.

### Phase 5: Documentation

#### 5A: Migration Guide

Create `docs/MIGRATION_GUIDE.md` with these sections:

1. **Overview** -- What changed and why (AC-001 Theme Customization pipeline)
2. **Breaking Change: `const` Removal**
   - Which tokens changed (`FiftySpacing`, `FiftyRadii`, `FiftyTypography`, `FiftyMotion`, `FiftyBreakpoints`, `FiftyColors` -- all are now getters)
   - In practice, only `FiftySpacing.*` appears in `const` contexts
   - Search patterns: `const.*FiftySpacing\.` in your codebase
   - Before/after code examples (3 patterns: SizedBox, EdgeInsets.all, EdgeInsets.only)
   - Impact: purely mechanical -- no behavioral change
3. **New Feature: Token Configuration**
   - `FiftyTokens.configure()` API with code example
   - Color, typography, spacing, radii, motion, breakpoints configs
   - Font source (Google Fonts vs asset fonts)
   - "If you don't call configure(), everything works as before"
4. **New Feature: Theme Parameterization**
   - `FiftyTheme.dark(colorScheme: ..., fontFamily: ...)` API
   - `FiftyThemeExtension` customization via copyWith
5. **New Feature: colorScheme-based theming in widgets**
   - fifty_ui widgets now use `Theme.of(context).colorScheme` not `FiftyColors.*`
   - Engine packages (achievement, skill_tree, forms, connectivity) similarly updated
6. **4 Levels of Customization** (with code for each):
   - Level 1: Zero config (FDL defaults)
   - Level 2: Token-level (`FiftyTokens.configure(colors: ...)`)
   - Level 3: Theme-level (`FiftyTheme.dark(colorScheme: ...)`)
   - Level 4: Widget-level (copyWith on individual component themes)
7. **Package Version Changes** -- table of old version -> new version

#### 5B: Update fifty_tokens README

Add after "Quick Start" section:

- **Configuration** section with `FiftyTokens.configure()` examples
- **Font Configuration** section showing Google Fonts vs asset font setup
- Update "Zero UI, Pure Constants" in features to "Zero UI, Design Tokens"
- Update code examples to remove `const` from any `FiftySpacing.*` usage
- Update version number to 2.0.0

#### 5C: Update fifty_theme README

Add after "Quick Start" section:

- **Customization** section showing 4 levels
- `FiftyTheme.dark(colorScheme: ..., fontFamily: ..., fontSource: ...)` API
- `FiftyThemeExtension` customization
- Update code examples: remove `const` from `FiftySpacing.*` usages (line 420-421)
- Add note about colorScheme consumption pattern
- Update version number to 2.0.0

#### 5D: Update fifty_ui README

Add after "Theme Access Pattern" section:

- **Theming** section explaining colorScheme integration
- Note that widgets now resolve colors from context, not FDL statics
- FiftyThemeExtension access pattern for shadows/semantic colors
- Update version number to 0.7.0

#### 5E: Update coding_guidelines.md

In the "Engine Package Architecture" section:

1. Update the "Correct Pattern: FDL Consumption" code example to show `colorScheme` access:
   ```dart
   final colorScheme = Theme.of(context).colorScheme;
   final fifty = Theme.of(context).extension<FiftyThemeExtension>();
   ```
   instead of `FiftyColors.surface`, `FiftyColors.border`
2. Update the "Engine Package Checklist":
   - Change "FDL Colors: Uses `FiftyColors.*`" to "Theme Colors: Uses `colorScheme.*` or `FiftyThemeExtension` for semantic colors"
   - Add: "No direct FiftyColors/FiftyShadows in build() methods"
   - Add: "FiftySpacing/FiftyRadii/FiftyTypography may be used directly (structural tokens)"
3. Update the "State-Based Styling" example to use `colorScheme` instead of `FiftyColors`
4. Update the "Override Pattern" example
5. Add a "Const Context" note explaining that tokens are getters, not constants

### Phase 6: CHANGELOGs

#### fifty_tokens CHANGELOG (2.0.0)
```markdown
## [2.0.0] - 2026-02-28

### BREAKING CHANGES

- All token values converted from `static const` to `static get` backed by configurable defaults
- Existing `const` contexts using `FiftySpacing.*`, `FiftyRadii.*`, `FiftyTypography.*`, `FiftyMotion.*`, or `FiftyBreakpoints.*` must remove the `const` keyword
- See [Migration Guide](../../docs/MIGRATION_GUIDE.md) for details

### Added

- `FiftyTokens.configure()` -- single entry point for overriding all token defaults
- `FiftyTokens.reset()` -- restore FDL v2 defaults
- Per-category config classes: `FiftyColorConfig`, `FiftyTypographyConfig`, `FiftySpacingConfig`, `FiftyRadiiConfig`, `FiftyMotionConfig`, `FiftyBreakpointsConfig`
- `FiftyFontResolver` for resolving fonts via Google Fonts or local asset fonts
- `FontSource` enum (`googleFonts`, `asset`) for font loading strategy
```

#### fifty_theme CHANGELOG (2.0.0)
```markdown
## [2.0.0] - 2026-02-28

### BREAKING CHANGES

- `FiftyTheme.dark()` and `FiftyTheme.light()` now accept optional parameters: `colorScheme`, `primaryColor`, `secondaryColor`, `fontFamily`, `fontSource`, `extension`
- `FiftyThemeExtension.dark()` and `.light()` accept optional color overrides
- All component themes now consume `ColorScheme` parameter instead of hardcoded `FiftyColors.*`
- Removed direct `google_fonts` import (now transitive via `fifty_tokens`)

### Changed

- 191 `FiftyColors.*` references replaced with `colorScheme.*` in component themes
- 57 `GoogleFonts.manrope()` calls replaced with `FiftyFontResolver.resolve()`
- Light theme consolidated (~280 lines of duplicated code eliminated)
- Component themes use `FiftyComponentThemes.*()` static methods consistently
```

#### fifty_ui CHANGELOG (0.7.0)
```markdown
## [0.7.0] - 2026-02-28

### BREAKING CHANGES

- `const` keyword removed from all widget expressions using `FiftySpacing.*` (values are now getters, not compile-time constants)
- Widgets now resolve colors from `Theme.of(context).colorScheme` and `FiftyThemeExtension` instead of direct `FiftyColors.*` / `FiftyShadows.*` access

### Changed

- `FiftyButton._getShadow()` uses `FiftyThemeExtension.shadowPrimary` instead of `FiftyShadows.primary`
- `FiftyBadge` variant colors resolved from `colorScheme` (tertiary, onSurfaceVariant)
- 8 shadow references migrated from `FiftyShadows.sm/md/lg` to `FiftyThemeExtension.shadowSm/Md/Lg`
- `extension()!` force-unwrap converted to nullable fallback pattern
```

#### Other packages (fifty_forms 0.2.0, fifty_connectivity 0.2.0, fifty_achievement_engine 0.2.0, fifty_speech_engine 0.2.0, fifty_skill_tree 0.2.0)

Each gets a CHANGELOG entry noting:
- `const` keyword removed from `FiftySpacing.*` usages
- Colors resolved from `colorScheme` instead of `FiftyColors.*` (where applicable, per AC-004/005 changes)

### Phase 7: Version Bumps

Update `pubspec.yaml` version field for each affected package. Also update dependency constraints:
- Packages depending on `fifty_tokens` need `^2.0.0`
- Packages depending on `fifty_theme` need `^2.0.0`
- Packages depending on `fifty_ui` need `^0.7.0`

**Affected pubspec.yaml files:**

| File | Version | Dependency Updates |
|------|---------|-------------------|
| `packages/fifty_tokens/pubspec.yaml` | 1.0.3 -> 2.0.0 | None |
| `packages/fifty_theme/pubspec.yaml` | 1.0.1 -> 2.0.0 | `fifty_tokens: ^2.0.0` |
| `packages/fifty_ui/pubspec.yaml` | 0.6.2 -> 0.7.0 | `fifty_tokens: ^2.0.0`, `fifty_theme: ^2.0.0` |
| `packages/fifty_forms/pubspec.yaml` | 0.1.2 -> 0.2.0 | `fifty_tokens: ^2.0.0`, `fifty_theme: ^2.0.0`, `fifty_ui: ^0.7.0` |
| `packages/fifty_connectivity/pubspec.yaml` | 0.1.3 -> 0.2.0 | `fifty_tokens: ^2.0.0` |
| `packages/fifty_achievement_engine/pubspec.yaml` | 0.1.3 -> 0.2.0 | `fifty_tokens: ^2.0.0` |
| `packages/fifty_speech_engine/pubspec.yaml` | 0.1.2 -> 0.2.0 | `fifty_tokens: ^2.0.0` |
| `packages/fifty_skill_tree/pubspec.yaml` | 0.1.2 -> 0.2.0 | `fifty_tokens: ^2.0.0` |

**Also update README version references:**
- `packages/fifty_tokens/README.md` version section
- `packages/fifty_theme/README.md` version section
- `packages/fifty_ui/README.md` version section

---

## Testing Strategy

### Per-Package Verification
1. After const fixes in each package: `flutter analyze` -- zero errors
2. After const fixes in each package: `flutter test` -- all existing tests pass
3. No NEW tests needed for const removal (it is a mechanical, non-behavioral change)

### Full Ecosystem Verification
1. Run `flutter analyze` in all packages with source changes
2. Run `flutter test` in all packages with source changes
3. Run `flutter analyze` in all example apps
4. Run `flutter analyze` in all apps (fifty_demo, tactical_grid, coffee_showcase)
5. Run `flutter analyze` in templates/mvvm_actions

### Documentation Verification
1. All code examples in READMEs compile conceptually (no `const` with token getters)
2. Migration guide examples are accurate
3. CHANGELOG entries are properly formatted
4. Version numbers consistent between pubspec.yaml, README, and CHANGELOG

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Missing some `const` occurrences | Low | High | Use grep patterns to verify zero remaining `const.*FiftySpacing\.` after fixes |
| Removing `const` from parent causes child to lose constness unnecessarily | Medium | Low | When removing `const` from parent widget, push `const` down to children where possible |
| Dependency version constraint conflicts between packages | Medium | Medium | Process in dependency order; verify resolution with `flutter pub get` |
| Large diff size makes review difficult | Medium | Low | Split into logical commits per phase |
| Missing a package's CHANGELOG or pubspec | Low | Medium | Use the explicit file lists above; verify all 8 packages updated |
| Example apps depend on unpublished path deps, version mismatch | Low | Low | Path deps don't enforce version constraints; just needs compile |
| AC-004/005 changes not yet committed | Low | High | Verify git log shows AC-004 and AC-005 commits before starting |

---

## Commit Strategy

Recommend 4 commits:

1. `fix(ecosystem): remove const from FiftySpacing usage across all packages`
   - Phases 1-4 (all const removals)
   - This is the compilation-critical fix

2. `docs(ecosystem): add migration guide for theme customization pipeline`
   - Phase 5A (migration guide)

3. `docs(ecosystem): update READMEs and coding guidelines for v2.0`
   - Phases 5B-5E (README updates, coding_guidelines update)

4. `chore(ecosystem): version bumps and CHANGELOG updates for AC-001 pipeline`
   - Phases 6-7 (CHANGELOGs, version bumps, dependency constraints)

---

## Execution Order

1. **Verify preconditions**: Confirm AC-002, AC-003, AC-004, AC-005 commits are all present
2. **Phase 1**: Fix package lib/ sources (47 files)
3. **Phase 2**: Fix package examples (46 files)
4. **Phase 3**: Fix apps (42 files)
5. **Phase 4**: Fix templates (13 files)
6. **Commit 1**: All const fixes
7. **Phase 5A**: Write migration guide
8. **Commit 2**: Migration guide
9. **Phase 5B-5E**: Update READMEs and coding_guidelines
10. **Commit 3**: Documentation updates
11. **Phase 6**: CHANGELOGs
12. **Phase 7**: Version bumps + dependency constraints
13. **Commit 4**: Version bumps and changelogs
14. **Final verification**: `flutter analyze` and `flutter test` across ecosystem
15. **Update brief AC-006 status**: Done
16. **Update CURRENT_SESSION.md**: AC-006 complete, AC-001 pipeline finished

---

## Notes for FORGER

- The const removal is 100% mechanical. Search `const.*FiftySpacing\.` and remove `const`. No judgment calls needed except for Pattern D (propagation).
- The `fifty_ui/example/lib/main.dart` file alone has 119 occurrences -- this is a large gallery file.
- `apps/fifty_demo/` has 472 occurrences across 34 files -- the largest single app.
- FiftyColors, FiftyShadows, FiftyGradients are NOT affected (zero const-context usages found).
- FiftyRadii, FiftyTypography, FiftyMotion, FiftyBreakpoints are also NOT affected (zero const-context usages found).
- Only FiftySpacing is affected because `const SizedBox(height: FiftySpacing.sm)` and `const EdgeInsets.all(FiftySpacing.md)` are extremely common patterns.
- When checking AC-004/AC-005 prerequisites: the git log shows only AC-002 (9bcd528) and AC-003 (55c6d90) committed. CURRENT_SESSION.md says AC-004 and AC-005 are Done but those commits may be from the same session. Verify before starting.
