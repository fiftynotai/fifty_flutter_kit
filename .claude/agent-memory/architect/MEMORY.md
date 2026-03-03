# ARCHITECT Agent Memory

## Project: fifty_eco_system

### Package: fifty_scroll_sequence (v0.1.0)
- Path: `packages/fifty_scroll_sequence/`
- Dependencies: Flutter SDK only (no external deps)
- Architecture: FrameLoader (abstract) -> AssetFrameLoader (impl), FrameCacheManager (LRU + dedup), FrameController (ticker lerp), ScrollProgressTracker, PinnedScrollSection
- Test pattern: FakeFrameLoader (1x1 images via PictureRecorder), FakeTickerProvider
- Barrel exports: each subfolder has barrel, main lib re-exports all barrels
- Existing tests: 11 files, ~173 passing tests (BR-123 through BR-126)
- Brief chain: BR-123 (done), BR-124 (done), BR-125 (done), BR-126 (done), BR-127 (in progress)

### Key Patterns
- All ui.Image must be disposed (GPU textures) -- cache.clearAll() in widget dispose
- Dedup in-flight loads via Set<int> _loading + Map<int, Completer>
- FrameController uses Ticker + LerpUtil for smooth frame transitions
- Dart 3.9.2+ SDK constraint (record types available)

### Planning Notes
- BR-125 plan: use dart:io HttpClient instead of package:http to avoid external deps
- SpriteSheetLoader: lazy-load sheet images, cache them, crop via Canvas+PictureRecorder
- PreloadStrategy: stateless const value objects (eager/chunked/progressive)
- ScrollDirection enum lives in strategies/ (tracker imports from there)

### BR-126 Plan Notes
- ScrollSequenceController: facade pattern, does NOT own internal components. Widget state calls _attach/_detach.
- Jump methods (jumpToFrame/jumpToProgress) animate via ScrollPosition.animateTo, need guard flag to prevent infinite notification loops
- SliverScrollSequence: SliverPersistentHeader with custom delegate, StatefulWidget inside delegate for lifecycle
- Example app at apps/scroll_sequence_example/: uses GeneratedFrameLoader (procedural gradient frames, no bundled assets)
- Example app is simplified MVVM+Actions: GetX routing only, no ViewModels/Actions layer (demo app)
- Plan file: ai/plans/BR-126-plan.md

### BR-127 Plan Notes
- Three features: Snap, Lifecycle Callbacks, Horizontal Scroll -- all opt-in
- SnapConfig: immutable config with binary-search nearestSnapPoint, factory ctors everyNFrames/scenes
- SnapController: Timer-based idle detection (150ms), animateTo for snap, jumpTo to cancel mid-flight
- ViewportObserver: state machine (outside/inside for non-pinned; beforePin/pinned/afterPin for pinned)
- Horizontal: Axis parameter on widgets + PinnedScrollSection, not separate widgets. Progress calc mirrors vertical with dx/width.
- Guard pattern: isSnapping flag mirrors _isUpdatingFromController pattern
- Cancel animateTo: scrollPosition.jumpTo(scrollPosition.pixels) halts animation at current pos
- ScrollSequenceStateAccessor gets scrollDirection getter; widgetTopOffset returns axis-appropriate value
- Test helpers: keep _FakeFrameLoader duplicated per test file (existing pattern)
- Plan file: ai/plans/BR-127-plan.md

### Example App Pattern (from tactical_grid)
- Structure: lib/main.dart -> app/app.dart (GetMaterialApp) -> core/routes/route_manager.dart -> features/{name}/views/
- Uses FDL: FiftyTheme.dark(), FiftyColors, FiftySpacing, FiftyTypography, FiftyButton
- pubspec: path deps to ../../packages/{pkg}, get: ^4.6.6
- RouteManager: static const route strings, static List<GetPage> get pages, static helper methods

### Package: fifty_tokens (v1.0.3)
- Path: `packages/fifty_tokens/`
- Dependencies: Flutter SDK, google_fonts ^8.0.0
- 8 source files: colors, typography, spacing, radii, motion, shadows, gradients, breakpoints
- 9 test files covering all token categories
- SDK constraint: ^3.6.0
- Downstream consumers: fifty_theme, fifty_ui, fifty_forms + 8 more packages (~651 const usages in ~100 files)

### AC-002 Plan Notes
- Config system: FiftyTokens.configure() -> per-category config singletons -> static getters with fallback
- @internal annotation on public `config` fields (package-internal but accessible, lint warns consumers)
- No config for shadows (already dynamic via FiftyColors refs) or gradients (derived from FiftyColors)
- FiftyFontResolver: GoogleFonts.getFont() vs copyWith(fontFamily:) based on FontSource enum
- Semantic alias chain: primary -> burgundy, error -> primary, focusLight -> primary
- Gradients: one endpoint (#5A1B1F) has no named color -- stays as _defaultPrimaryEnd
- Breakpoints: zero const downstream usage, but still gets config class for completeness
- CERTAIN breaking change: 651 const-context removals across 100 files in 11 downstream packages
- Plan file: ai/plans/AC-002-plan.md

### AC-003 Plan Notes
- Package: fifty_theme (v1.0.1), 5 source files, 4 test files
- 248 total changes: 191 FiftyColors.* refs + 57 GoogleFonts.manrope refs
- ColorScheme role mappings: burgundy->primary, cream->onPrimary, darkBurgundy->surface(dark), slateGrey->secondary/onSurfaceVariant, hunterGreen->tertiary, surfaceDark/Light->surfaceContainerHighest, borderDark/Light->outline
- SnackBar/Tooltip: use inverseSurface/onInverseSurface (Material standard, visual change from FDL "always dark" convention)
- 4 components retain isDark check: inputDecoration, chip, progressIndicator, slider (light fills use secondary.withValues(alpha:0.1) not surfaceContainerHighest)
- light() has 18 inlined component themes to consolidate with FiftyComponentThemes calls
- FiftyTextTheme gets fontFamily/fontSource optional params, uses FiftyFontResolver
- FiftyTheme.dark/light get: colorScheme?, primaryColor?, secondaryColor?, fontFamily?, fontSource?, extension?
- google_fonts import removed from all source files (transitive via fifty_tokens)
- Plan file: ai/plans/AC-003-plan.md

### AC-004 Plan Notes
- Package: fifty_ui (v0.6.2), 38 widget files in lib/src/, 27 test files
- Audit: 28 widgets correct, 10 files with direct FiftyColors/FiftyShadows violations in build methods
- Key violations: FiftyButton._getShadow() uses FiftyShadows.primary directly; FiftyBadge._getAccentColor() uses FiftyColors.hunterGreen/warning
- 8 files use FiftyShadows.sm/md/lg directly instead of through extension
- FiftyBadge factory constructors (tech/ai) set hardcoded FiftyColors -- change to variant-based resolution
- FiftySpacing/FiftyRadii/FiftyTypography are layout/structural tokens -- NOT violations, remain as-is
- FiftyMotion in initState/static methods acceptable (no BuildContext available)
- Force-unwrap pattern (extension()!) needs nullable conversion for graceful fallback
- Warning color has no Material colorScheme equivalent -- keep FiftyColors.warning as last-resort
- ColorScheme mappings from AC-003: hunterGreen->tertiary, slateGrey->onSurfaceVariant
- FiftyThemeExtension already has all shadow tiers: shadowSm/Md/Lg/Primary/Glow
- Plan file: ai/plans/AC-004-plan.md

### AC-005 Plan Notes
- Brief says 3 packages need fixes; audit found 4 (fifty_forms is NOT clean -- 21 violations)
- Total violations: 72 across 4 packages (10 connectivity + 6 achievement + 35 skill_tree + 21 forms)
- twelve source files to modify, ~6 new test files
- fifty_connectivity: straightforward find-replace, colorScheme already obtained in build()
- fifty_achievement_engine: add optional rarityColors Map param to Card/Popup/Summary; common->onSurfaceVariant, uncommon->tertiary, rare/epic/legendary stay hardcoded hex
- fifty_skill_tree: add SkillTreeTheme.fromContext(BuildContext) factory; uses only colorScheme (no fifty_theme dep); optional warningColor/accentColor params for FiftyThemeExtension values
- skill_tree widgets: resolve theme from context when theme==null (eliminates all FDL fallback statics)
- skill_tree ConnectionPainter: no BuildContext; resolve theme in SkillTreeView before passing to painter
- fifty_forms: date/time picker theme wrappers override consumer's colorScheme with FiftyColors -- fix by removing overrides; file_form_field has 3 direct refs
- Confirmed clean: audio_engine, speech_engine, printing_engine, scroll_sequence, narrative_engine, world_engine, socket
- Plan file: ai/plans/AC-005-plan.md

### AC-006 Plan Notes
- ONLY FiftySpacing has const-context breakage (1,231 occurrences across 153 files)
- FiftyRadii, FiftyTypography, FiftyMotion, FiftyBreakpoints = ZERO const-context usages
- FiftyColors, FiftyShadows, FiftyGradients = ZERO const-context usages
- Largest targets: fifty_ui/example/lib/main.dart (119), apps/fifty_demo (472 across 34 files)
- Package lib/ sources: 47 files, ~280 occurrences (critical path)
- Version bumps: fifty_tokens 1.0.3->2.0.0, fifty_theme 1.0.1->2.0.0, fifty_ui 0.6.2->0.7.0, rest 0.x->0.2.0
- Semver: >=1.0.0 packages need MAJOR bump for breaking; 0.x packages use MINOR bump
- Migration guide location: docs/MIGRATION_GUIDE.md
- 4 commits recommended: const-fix, migration-guide, readme-updates, version-bumps
- Plan file: ai/plans/AC-006-plan.md

### AC-007 Plan Notes
- FiftyPreset: single class holding all 8 category configs. fdlV2 static const. fromMap() + copyWith()
- FiftyTokens rewritten: _active preset, load(), configure(), reset(), active getter
- Color config: palette names -> semantic names (burgundy->primary, cream->background, etc.)
- All config classes: nullable -> non-nullable required, add fromMap() + copyWith()
- New config classes: FiftyShadowsConfig (sm/md/lg/primaryOpacity/glowOpacity), FiftyGradientsConfig (primaryEnd)
- Token classes: agnostic readers (FiftyTokens.active.category.field), zero defaults
- FiftyColors deprecated aliases: burgundy->primary, cream->background, darkBurgundy->backgroundDark, etc.
- New FiftyColors fields: onPrimary, onBackground (Color), borderOpacity, focusOpacity (double, computed helpers)
- Bridge pattern for Phase 2: FiftyTokens.configure() sets both _active AND per-class .config during transition
- BoxShadow IS const -- FiftyPreset.fdlV2 can be static const
- FiftyShadows.sm/md/lg have zero const-context usages (from AC-006 audit) -- safe to become getters
- 7 phases, strictly sequential within fifty_tokens, then fifty_theme, then docs
- ~289 palette-name references across 30 files in packages/ (deprecated aliases cover these)
- fifty_theme: 24 palette refs in color_scheme.dart, 1 in theme_extensions.dart, ~38 in tests
- Version bumps: fifty_tokens 2.0.0->3.0.0, fifty_theme 2.0.0->3.0.0
- Plan file: ai/plans/AC-007-plan.md
