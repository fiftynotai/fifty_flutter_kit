# FORGER Memory

## fifty_tokens Configuration Pattern (AC-007)

### Pattern: Agnostic reader (replaces config-backed static getters)
- Token classes are pure readers: `static Type get xxx => FiftyTokens.active.category.xxx;`
- No `@internal`, no `config` fields, no `_defaultX` constants
- Config classes have ALL fields `required` and non-nullable
- Partial overrides done via `FiftyPreset.fdlV2.category.copyWith(field: value)`
- `FiftyTokens.configure()` accepts full config objects
- `FiftyTokens.reset()` sets `_active = FiftyPreset.fdlV2;`
- `FiftyTokens.isConfigured` uses `!identical(_active, FiftyPreset.fdlV2)`

### Semantic color names (AC-007 Phase 3)
- `burgundy` -> `primary`, `burgundyHover` -> `primaryHover`
- `cream` -> `background`, `darkBurgundy` -> `backgroundDark`
- `slateGrey` -> `secondary`, `slateGreyHover` -> `secondaryHover`
- `hunterGreen` -> `success`, `powderBlush` -> `accent`
- `surfaceLight` -> `surface`
- New fields: `onPrimary`, `onBackground`, `borderOpacity`, `focusOpacity`
- Old palette names kept as `@Deprecated` getters delegating to semantic ones

### Computed colors in FiftyColors
- `borderLight` = `Colors.black.withValues(alpha: config.borderOpacity)`
- `borderDark` = `Colors.white.withValues(alpha: config.borderOpacity)`
- `focusLight` = `primary` (computed, not in config)
- `focusDark` = `accent.withValues(alpha: config.focusOpacity)`

### Key decisions
- No bridge code (`_syncBridge`) -- removed entirely in AC-007
- `meta` package no longer imported (can be removed from pubspec.yaml)
- Shadows: sm/md/lg from config, primary/glow computed from FiftyColors
- Gradients: primaryEnd from config, colors from FiftyColors
- Deprecated members always stay `static const` -- never touch them
- GoogleFonts tests need `TestWidgetsFlutterBinding.ensureInitialized()` and `testWidgets` (not `test`) to handle async font loading

### Test patterns
- Every test group: `setUp(() => FiftyTokens.reset());`
- Partial override: `FiftyPreset.fdlV2.colors.copyWith(primary: Color(...))`
- Full config: must provide all required fields
- GoogleFonts tests: `GoogleFonts.config.allowRuntimeFetching = false;`

## Widget Testing Patterns

### Theme requirement for fifty_ui widgets
- `FiftySwitch`, `FiftySlider`, `FiftyCard` etc. require `FiftyThemeExtension` in the theme
- Use `FiftyTheme.dark()` (from `package:fifty_theme/fifty_theme.dart`), NOT `ThemeData.dark()`
- `ThemeData.dark()` causes null check error at `theme.extension<FiftyThemeExtension>()!`

### PulsingDot animation (SpeechSttControls)
- When `isListening: true`, `_PulsingDot` has repeating AnimationController
- Do NOT use `pumpAndSettle()` -- it will timeout
- Use `pump(Duration(milliseconds: 100))` instead
