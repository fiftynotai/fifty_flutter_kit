# Implementation Plan: MG-001

**Complexity:** M (Medium)
**Estimated Duration:** 2-3 hours
**Risk Level:** Low
**Created:** 2026-01-11

## Summary

Migrate and rebrand `printing_engine` package from `opaala_admin_app_v3/packages/` to `fifty_flutter_kit/packages/fifty_printing_engine` following Fifty ecosystem conventions. This is a pure rebrand - no functionality changes.

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_printing_engine/` | CREATE | Copy entire package structure |
| `pubspec.yaml` | MODIFY | Update name, description, homepage, repository |
| `lib/printing_engine.dart` | RENAME | Rename to `lib/fifty_printing_engine.dart` |
| `lib/src/**/*.dart` | MODIFY | Update all imports |
| `test/**/*.dart` | MODIFY | Update all imports |
| `example/pubspec.yaml` | MODIFY | Update package name |
| `example/lib/**/*.dart` | MODIFY | Update all imports |
| `README.md` | MODIFY | Add Fifty ecosystem branding |
| `CHANGELOG.md` | MODIFY | Add migration entry |

## Implementation Phases

### Phase 1: Copy Package
```bash
rsync -av --exclude='.dart_tool' --exclude='build' --exclude='.idea' \
  --exclude='.flutter-plugins' --exclude='.flutter-plugins-dependencies' \
  --exclude='.packages' --exclude='pubspec.lock' --exclude='*.iml' \
  /Users/m.elamin/StudioProjects/opaala_admin_app_v3/packages/printing_engine/ \
  /Users/m.elamin/StudioProjects/fifty_flutter_kit/packages/fifty_printing_engine/
```

### Phase 2: Update pubspec.yaml
- name: `fifty_printing_engine`
- homepage: `https://github.com/fiftynotai/fifty_flutter_kit`
- repository: `https://github.com/fiftynotai/fifty_flutter_kit/tree/main/packages/fifty_printing_engine`

### Phase 3: Rename Library File
- `lib/printing_engine.dart` → `lib/fifty_printing_engine.dart`
- Update library directive

### Phase 4: Update All Internal Imports
- Pattern: `package:printing_engine/` → `package:fifty_printing_engine/`
- Files: ~29 .dart files in lib/ and test/

### Phase 5: Update Example App
- Update example/pubspec.yaml
- Update all imports in example/lib/

### Phase 6: Update Documentation
- README.md: Add Fifty ecosystem branding
- CHANGELOG.md: Add migration entry

### Phase 7: Clean and Verify
- `flutter clean && flutter pub get`
- `flutter analyze` (zero issues)
- `flutter test` (all pass)

### Phase 8: Commit
- Conventional commit format
- Reference MG-001

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Missing import update | Medium | Low | grep for remaining references |
| Test failures | Low | Medium | Run full test suite |
| Example app issues | Low | Low | Clean and pub get |

## Total Files: ~35
