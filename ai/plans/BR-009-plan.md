# Implementation Plan: BR-009 - fifty_theme Package

**Complexity:** L (Large)
**Risk Level:** Medium
**Created:** 2025-12-25
**Status:** Awaiting Approval

---

## Summary

Create the `fifty_theme` Flutter package that consumes `fifty_tokens` design tokens and produces complete `ThemeData` objects with `FiftyTheme.light()` and `FiftyTheme.dark()` factory methods.

---

## Files to Create (16 files)

| File | Purpose |
|------|---------|
| `packages/fifty_theme/pubspec.yaml` | Package manifest with fifty_tokens dependency |
| `packages/fifty_theme/analysis_options.yaml` | Linter configuration |
| `packages/fifty_theme/lib/fifty_theme.dart` | Barrel export file |
| `packages/fifty_theme/lib/src/fifty_theme_data.dart` | Main FiftyTheme class |
| `packages/fifty_theme/lib/src/color_scheme.dart` | FiftyColorScheme (tokens → ColorScheme) |
| `packages/fifty_theme/lib/src/text_theme.dart` | FiftyTextTheme (tokens → TextTheme) |
| `packages/fifty_theme/lib/src/component_themes.dart` | Component themes (buttons, cards, inputs) |
| `packages/fifty_theme/lib/src/theme_extensions.dart` | FiftyThemeExtension for FDL-specific tokens |
| `packages/fifty_theme/test/fifty_theme_test.dart` | Main theme tests |
| `packages/fifty_theme/test/color_scheme_test.dart` | ColorScheme tests |
| `packages/fifty_theme/test/text_theme_test.dart` | TextTheme tests |
| `packages/fifty_theme/test/component_themes_test.dart` | Component theme tests |
| `packages/fifty_theme/README.md` | Package documentation |
| `packages/fifty_theme/CHANGELOG.md` | Version history |
| `packages/fifty_theme/LICENSE` | MIT License |
| `packages/fifty_theme/example/fifty_theme_example.dart` | Usage example |

---

## Implementation Phases

### Phase 1: Package Scaffold
- Create directory structure
- pubspec.yaml with fifty_tokens path dependency
- analysis_options.yaml (copy from fifty_tokens)

### Phase 2: Color Scheme
**Dark Mode (PRIMARY):**
| ColorScheme | FiftyColors |
|-------------|-------------|
| primary | crimsonPulse |
| surface | gunmetal |
| surfaceContainerLowest | voidBlack |
| onSurface | terminalWhite |
| error | error (crimsonPulse) |
| outline | border |

**Light Mode (Secondary):**
| ColorScheme | Value |
|-------------|-------|
| primary | crimsonPulse |
| surface | terminalWhite |
| onSurface | gunmetal |

### Phase 3: Text Theme
| TextTheme Property | FiftyTypography |
|-------------------|-----------------|
| displayLarge | hero (64px), Monument Extended, ultrabold |
| displayMedium | display (48px), Monument Extended, ultrabold |
| displaySmall | section (32px), Monument Extended, regular |
| bodyLarge | body (16px), JetBrains Mono, regular |
| bodySmall | mono (12px), JetBrains Mono, regular |

### Phase 4: Component Themes
- ElevatedButton: crimsonPulse, 0 elevation, 12px radius
- Card: gunmetal, 0 elevation, border outline
- InputDecoration: gunmetal fill, crimson focus border
- AppBar: voidBlack, 0 elevation
- Dialog: gunmetal, 24px radius
- Checkbox/Radio/Switch: crimsonPulse active

### Phase 5: Theme Extensions
```dart
class FiftyThemeExtension extends ThemeExtension<FiftyThemeExtension> {
  final Color igrisGreen;
  final List<BoxShadow> focusGlow;
  final Duration fastDuration;
  final Duration compilingDuration;
  final Curve enterCurve;
  // ...
}
```

### Phase 6: Main Theme Assembly
```dart
class FiftyTheme {
  static ThemeData dark() => ThemeData(
    useMaterial3: true,
    colorScheme: FiftyColorScheme.dark(),
    textTheme: FiftyTextTheme.dark(),
    // component themes...
    extensions: [FiftyThemeExtension.dark()],
  );

  static ThemeData light() => ...
}
```

### Phase 7: Barrel Export
Export FiftyTheme, FiftyThemeExtension, re-export fifty_tokens

### Phase 8: Tests (40+ tests)
- Theme construction validity
- ColorScheme mapping correctness
- TextTheme font/size validation
- Component theme properties
- Extension values

### Phase 9: Documentation
- README with usage examples
- CHANGELOG v0.1.0

### Phase 10: Example App
- Showcase all themed components

---

## API Design

```dart
// Usage
import 'package:fifty_theme/fifty_theme.dart';

MaterialApp(
  theme: FiftyTheme.light(),
  darkTheme: FiftyTheme.dark(),
  themeMode: ThemeMode.dark, // Primary
)

// Accessing extensions
final ext = Theme.of(context).extension<FiftyThemeExtension>()!;
```

---

## Quality Gates

- [ ] `flutter analyze` - zero issues
- [ ] `flutter test` - all tests pass (40+)
- [ ] Manual smoke test in example app

---

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Monument Extended font unavailability | Document font requirements, fallback works |
| Light mode contrast issues | Test accessibility, adjust if needed |

---

**Awaiting Monarch approval to proceed.**
