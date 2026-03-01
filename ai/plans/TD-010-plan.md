# Implementation Plan: TD-010

**Complexity:** S (Small)
**Estimated Duration:** 2-3 hours
**Risk Level:** Low

## Summary

Extract the triplicated `_parseColor` logic into a single shared utility, standardize error handling across all color-parsing call sites, replace the unsafe `.cast<>()` with `.whereType<>()` in `FiftyShadowsConfig.fromMap`, and add dedicated `fromMap()` unit tests for the 6 config classes currently missing them.

## Current State Audit

### `_parseColor` Implementations (3 copies)

| File | Return Type | Null handling | Error handling |
|------|-------------|---------------|----------------|
| `color_config.dart:146` | `Color?` | Returns null for null/unknown | No try-catch on `int.parse` |
| `shadows_config.dart:88` | `Color?` | Returns null for null/unknown | No try-catch on `int.parse` |
| `gradients_config.dart:38` | `Color` (non-nullable) | Throws `ArgumentError` on unknown | No try-catch on `int.parse` |

**Problem:** The gradients variant is inconsistent -- it throws instead of returning null. All three lack try-catch around `int.parse(hex, radix: 16)`, meaning a malformed hex string like `"#ZZZZZZ"` will throw an unhandled `FormatException`.

### Unsafe `.cast<>()` in `shadows_config.dart:75`

```dart
return value.cast<Map<String, dynamic>>().map((m) { ... })
```

If the list contains a non-Map element (e.g., `[42, "invalid"]`), `.cast<>()` throws a `TypeError` at access time. The defensive alternative is `.whereType<Map<String, dynamic>>()`, which silently skips non-Map entries.

### `fromMap()` Test Coverage

| Config Class | Has `fromMap()` tests? | Gap |
|-------------|------------------------|-----|
| `FiftyColorConfig` | NO | Full map, partial map, empty map, hex strings, malformed hex, non-color value |
| `FiftyShadowsConfig` | YES (7 tests) | Already good; add malformed hex test |
| `FiftyGradientsConfig` | YES (5 tests) | Throws test needs update after standardization |
| `FiftySpacingConfig` | NO | Full map, partial map, empty map, non-num values |
| `FiftyTypographyConfig` | NO | Full map, partial map, empty map, fontWeight parsing, fontSource parsing, invalid values |
| `FiftyRadiiConfig` | NO | Full map, partial map, empty map, non-num values |
| `FiftyMotionConfig` | NO | Full map, partial map, empty map, duration parsing, non-int values, curves always fallback |
| `FiftyBreakpointsConfig` | NO | Full map, partial map, empty map, non-num values |

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_tokens/lib/src/config/parse_helpers.dart` | CREATE | New file with `parseColor(dynamic) -> Color?` top-level function |
| `packages/fifty_tokens/lib/src/config/color_config.dart` | MODIFY | Remove private `_parseColor`, import and call `parseColor` from parse_helpers |
| `packages/fifty_tokens/lib/src/config/shadows_config.dart` | MODIFY | Remove private `_parseColor`, import `parseColor`; replace `.cast<>()` with `.whereType<>()` |
| `packages/fifty_tokens/lib/src/config/gradients_config.dart` | MODIFY | Remove private `_parseColor`, import `parseColor`; adapt `fromMap` to handle nullable return (use fallback) |
| `packages/fifty_tokens/test/config/parse_helpers_test.dart` | CREATE | Unit tests for the shared `parseColor` function |
| `packages/fifty_tokens/test/config/color_config_test.dart` | MODIFY | Add `fromMap()` test group |
| `packages/fifty_tokens/test/config/spacing_config_test.dart` | MODIFY | Add `fromMap()` test group |
| `packages/fifty_tokens/test/config/typography_config_test.dart` | MODIFY | Add `fromMap()` test group |
| `packages/fifty_tokens/test/config/radii_config_test.dart` | MODIFY | Add `fromMap()` test group |
| `packages/fifty_tokens/test/config/motion_config_test.dart` | MODIFY | Add `fromMap()` test group |
| `packages/fifty_tokens/test/config/breakpoints_config_test.dart` | MODIFY | Add `fromMap()` test group |
| `packages/fifty_tokens/test/config/shadows_config_test.dart` | MODIFY | Add malformed hex resilience test |
| `packages/fifty_tokens/test/config/gradients_config_test.dart` | MODIFY | Update "throws on invalid" test to expect null/fallback instead of ArgumentError |

**Note:** `parse_helpers.dart` must NOT be added to the barrel exports (`fifty_tokens.dart`). It is a package-internal utility. Since Dart's `_` prefix only works within a single file, the function will be named `parseColor` (no underscore) but will not be exported from the library barrel.

## Implementation Steps

### Phase 1: Create Shared Utility (parse_helpers.dart)

1. Create `packages/fifty_tokens/lib/src/config/parse_helpers.dart`
2. Implement a single top-level `Color? parseColor(dynamic value)` function:
   - Returns `null` if `value` is null or unrecognized type
   - Handles `int` values directly via `Color(value)`
   - Handles `String` values: strip `#` or `0x` prefix, pad 6-char hex to 8-char with `FF` prefix
   - Wrap `int.parse(hex, radix: 16)` in try-catch `FormatException` -- return `null` on failure
3. Add doc comment explaining this is a package-internal helper (not part of public API)
4. Do NOT export from `fifty_tokens.dart` barrel

### Phase 2: Refactor Config Classes to Use Shared Utility

**color_config.dart:**
1. Add `import 'parse_helpers.dart';` at top
2. Remove the `static Color? _parseColor(dynamic value)` method (lines 146-155)
3. Replace all `_parseColor(...)` calls with `parseColor(...)` (14 call sites in fromMap)

**shadows_config.dart:**
1. Add `import 'parse_helpers.dart';` at top
2. Remove the `static Color? _parseColor(dynamic value)` method (lines 88-97)
3. Replace `_parseColor(m['color'])` with `parseColor(m['color'])` in `_parseBoxShadowList`
4. Replace `.cast<Map<String, dynamic>>()` on line 75 with `.whereType<Map<String, dynamic>>()`

**gradients_config.dart:**
1. Add `import 'parse_helpers.dart';` at top
2. Remove the `static Color _parseColor(dynamic value)` method (lines 38-46)
3. In `fromMap`, change the primaryEnd parsing to handle nullable return:
   ```dart
   primaryEnd: map.containsKey('primaryEnd')
       ? parseColor(map['primaryEnd']) ?? fallback.primaryEnd
       : fallback.primaryEnd,
   ```
   This replaces the throwing behavior with graceful fallback (consistent with all other config classes).

### Phase 3: Add `fromMap()` Unit Tests

**test/config/parse_helpers_test.dart** (NEW):
- `null input returns null`
- `int value returns Color`
- `hex string without prefix (#FF0000) returns Color with FF alpha`
- `hex string with 0x prefix (0xFFAABBCC) returns correct Color`
- `8-char hex string (FFAABBCC) returns correct Color`
- `6-char hex string (AABBCC) gets FF prefix`
- `malformed hex string (not-a-color) returns null`
- `empty string returns null` (after stripping # and 0x, empty hex -> FormatException -> null)
- `boolean value returns null`
- `double value returns null`
- `list value returns null`

**test/config/color_config_test.dart** (ADD group):
- `fromMap with full valid map overrides all fields`
- `fromMap with empty map returns all fallback values`
- `fromMap with partial map uses fallback for missing keys`
- `fromMap parses hex string colors (#RRGGBB format)`
- `fromMap parses 0x-prefixed hex strings`
- `fromMap parses int color values`
- `fromMap with malformed hex falls back gracefully`
- `fromMap with non-color value (e.g., boolean) falls back`
- `fromMap handles non-num borderOpacity gracefully` (null fallback)
- `fromMap handles non-num focusOpacity gracefully` (null fallback)

**test/config/spacing_config_test.dart** (ADD group):
- `fromMap with full valid map overrides all fields`
- `fromMap with empty map returns all fallback values`
- `fromMap with partial map uses fallback for missing keys`
- `fromMap with non-num value falls back` (e.g., `{'base': 'abc'}`)
- `fromMap with int values coerces to double`

**test/config/typography_config_test.dart** (ADD group):
- `fromMap with full valid map overrides all fields`
- `fromMap with empty map returns all fallback values`
- `fromMap with partial map uses fallback for missing keys`
- `fromMap parses fontSource "asset" string`
- `fromMap parses fontSource "googleFonts" string`
- `fromMap with unknown fontSource string uses fallback`
- `fromMap parses FontWeight int values (400, 500, etc.)`
- `fromMap with invalid FontWeight int falls back to w400`
- `fromMap with null FontWeight uses fallback`

**test/config/radii_config_test.dart** (ADD group):
- `fromMap with full valid map overrides all fields`
- `fromMap with empty map returns all fallback values`
- `fromMap with partial map uses fallback for missing keys`
- `fromMap with non-num value falls back`

**test/config/motion_config_test.dart** (ADD group):
- `fromMap with full valid map overrides durations`
- `fromMap with empty map returns all fallback values`
- `fromMap with partial map uses fallback for missing keys`
- `fromMap always uses fallback curves (not parseable from JSON)`
- `fromMap with non-int duration value uses fallback`
- `fromMap with null duration value uses fallback`

**test/config/breakpoints_config_test.dart** (ADD group):
- `fromMap with full valid map overrides all fields`
- `fromMap with empty map returns all fallback values`
- `fromMap with partial map uses fallback for missing keys`
- `fromMap with non-num value falls back`

**test/config/shadows_config_test.dart** (ADD test):
- `fromMap with malformed hex in shadow color falls back to transparent`
- `fromMap with non-Map items in shadow list skips them` (tests `.whereType<>()` change)

**test/config/gradients_config_test.dart** (UPDATE test):
- Change the "throws on invalid color value" test: after refactoring, `fromMap({'primaryEnd': true})` should now return the fallback color instead of throwing an `ArgumentError`

### Phase 4: Verify

1. Run `flutter analyze` in `packages/fifty_tokens/` -- expect zero issues
2. Run `flutter test` in `packages/fifty_tokens/` -- expect all tests pass (existing + new)
3. Run `flutter analyze` in `packages/fifty_theme/` -- expect zero issues (downstream consumer)
4. Run `flutter test` in `packages/fifty_theme/` -- expect all tests pass (no behavior change)

## Testing Strategy

- **Unit tests for `parseColor`**: Cover all input types (null, int, String variants, malformed, unrecognized types). This is the core shared logic -- thorough coverage here protects all consumers.
- **`fromMap()` tests per config class**: Follow the established pattern from `shadows_config_test.dart` -- full override, partial override, empty map, edge-case values. Each test constructs a fallback, calls `fromMap`, asserts results.
- **Regression safety**: All existing tests must continue to pass with zero modifications (except the one `gradients_config_test.dart` test that currently expects `ArgumentError`).
- **No integration tests needed**: This is a pure refactoring of internal parsing logic with no behavior change to the public API.

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| `parseColor` being accidentally exported to consumers | Low | Medium | Do NOT add to `fifty_tokens.dart` barrel. Verify with `flutter analyze` that no consumer references it. |
| Breaking the `FiftyGradientsConfig.fromMap` contract by removing the throw | Low | Low | The throw behavior was inconsistent with all other configs. Existing test that expects `ArgumentError` must be updated. No downstream code catches this error (checked: `FiftyPreset.fromMap` does not wrap in try-catch). |
| `.whereType<>()` silently dropping invalid list items vs `.cast<>()` throwing | Low | Low | Silent skip is the correct defensive behavior for JSON parsing. Invalid items should not crash the app. The existing test "non-list shadow value returns empty list" already covers the non-list case; a new test covers mixed-type list. |
| New `parse_helpers.dart` import path leaking into public API | Low | Medium | The file is in `lib/src/config/` which is already behind the `src/` convention. Only explicitly exported files are public. |
| Malformed hex strings in production JSON configs | Medium | Low | Now handled gracefully (returns null -> fallback value) instead of crashing with `FormatException`. This is strictly safer than before. |

## Design Decisions

1. **Top-level function vs class with static method**: Top-level function (`parseColor`) is idiomatic Dart for utility helpers. A class with a private constructor (`ParseHelpers._()`) adds ceremony with no benefit.

2. **Naming: `parseColor` not `_parseColor`**: Dart's underscore-prefix privacy is file-scoped, not library-scoped. Since the function lives in a separate file from its callers, it cannot be prefixed with `_`. Instead, it is kept out of the barrel exports.

3. **Return type `Color?` everywhere**: Standardizing on nullable return with null-coalescing fallback (`parseColor(x) ?? fallback.field`) is the simplest, most consistent approach. It matches the pattern used by `FiftyColorConfig` and `FiftyShadowsConfig` already.

4. **`@visibleForTesting` not needed**: The function is not exported from the library barrel, so consumers cannot import it directly. Tests import the file via relative path (`import 'package:fifty_tokens/src/config/parse_helpers.dart'`), which is standard for testing internal utilities.
