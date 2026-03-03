# SENTINEL Memory

## Testing Patterns

### Flutter Test Output Parsing
- `flutter test` output uses `\r` carriage returns extensively, making grep on piped output unreliable
- Best approach: pipe through `tr '\r' '\n'` then grep, OR write to temp file first
- "All tests passed!" appears at end of successful run
- Test count format: `HH:MM +NNN: All tests passed!`

### Mono-repo Test Execution
- `flutter test packages/X` from the repo root fails with "Couldn't resolve the package" errors
- MUST run from within the package directory: `cd packages/X && flutter test`
- Alternatively, run `flutter pub get` first from within the package directory

### Flutter Analyzer
- Path dependency warnings (`invalid_dependency`) are expected in mono-repo with path deps -- acceptable
- `info` level issues (prefer_const_constructors, etc.) are non-blocking
- `error` level issues are blockers -- must be zero
- The analyzer picks up `example/` apps too, not just `lib/` and `test/`

### Const Removal Audit (AC-006)
- When tokens change from `static const` to `static get` (getter), the `const` keyword must be removed not just from direct `const FiftySpacing.xx` usages but from any parent `const` expression containing them
- Example: `const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(FiftySpacing.lg)))` -- the `const` on `RoundedRectangleBorder` must also be removed
- Simple grep for `const.*FiftySpacing\.` misses cases where `const` is on a parent constructor
- This applies to ALL configurable tokens: FiftySpacing, FiftyRadii, FiftyTypography, etc.

## Project Test Suites
- `fifty_tokens`: ~317 tests (was ~217 before AC-007 added fromMap/config tests)
- `fifty_theme`: ~205 tests
- `fifty_ui`: ~300 tests
- `fifty_skill_tree`: ~214 tests
- `fifty_forms`, `fifty_connectivity`, `fifty_achievement_engine`, `fifty_speech_engine`: no test/ directory (or no tests to run)
