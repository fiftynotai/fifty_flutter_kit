# MG-002: Rename Repository to fifty_flutter_kit

**Type:** Migration
**Priority:** P2-Medium
**Effort:** S-Small (1-2 hours)
**Status:** Done
**Created:** 2026-01-12
**Assignee:** -

---

## Problem

The current repository name `fifty_flutter_kit` is generic and doesn't communicate that this is a Flutter-specific package collection. A more descriptive name would improve discoverability and clarity.

---

## Goal

Rename the repository from `fifty_flutter_kit` to `fifty_flutter_kit` across all references while maintaining zero breaking changes to package imports and APIs.

---

## Context & Inputs

### Current State
- **Repository:** `https://github.com/fiftynotai/fifty_flutter_kit`
- **Local Path:** `/Users/m.elamin/StudioProjects/fifty_flutter_kit`
- **Packages:** 12 packages with `homepage` and `repository` URLs pointing to current repo

### New State
- **Repository:** `https://github.com/fiftynotai/fifty_flutter_kit`
- **Local Path:** `/Users/m.elamin/StudioProjects/fifty_flutter_kit` (optional rename)

### Files Requiring Updates

**Package pubspec.yaml files (12):**
```
packages/fifty_tokens/pubspec.yaml
packages/fifty_theme/pubspec.yaml
packages/fifty_ui/pubspec.yaml
packages/fifty_cache/pubspec.yaml
packages/fifty_storage/pubspec.yaml
packages/fifty_utils/pubspec.yaml
packages/fifty_connectivity/pubspec.yaml
packages/fifty_audio_engine/pubspec.yaml
packages/fifty_speech_engine/pubspec.yaml
packages/fifty_narrative_engine/pubspec.yaml
packages/fifty_map_engine/pubspec.yaml
packages/fifty_printing_engine/pubspec.yaml
```

**README files (12+):**
```
README.md (root)
packages/*/README.md (12 packages)
templates/*/README.md (if any)
apps/*/README.md (if any)
```

**Configuration files:**
```
CLAUDE.md
ai/prompts/igris_os.md (if references exist)
ai/session/CURRENT_SESSION.md
```

### What Does NOT Change
- Package names (`fifty_tokens`, `fifty_ui`, etc.)
- Import statements (`package:fifty_*/`)
- Class names and APIs
- Local package path references (`path: ../`)

---

## Constraints

1. **Zero breaking changes** - No impact on package consumers
2. **GitHub redirect** - Old URLs auto-redirect after rename
3. **Atomic update** - All changes in single commit
4. **Update local remote** - After GitHub rename

---

## Acceptance Criteria

- [ ] GitHub repository renamed to `fifty_flutter_kit`
- [ ] All `pubspec.yaml` files updated with new URLs:
  - `homepage: https://github.com/fiftynotai/fifty_flutter_kit`
  - `repository: https://github.com/fiftynotai/fifty_flutter_kit/tree/main/packages/{name}`
- [ ] All README.md files updated with new URLs
- [ ] CLAUDE.md updated with new references
- [ ] Git remote updated locally
- [ ] All packages still resolve (`flutter pub get` works)
- [ ] Commit pushed to new repository URL

---

## Test Plan

### Automated
1. Run `flutter pub get` in each package - all resolve
2. Run `flutter analyze` in each package - no new errors
3. Grep for old URL - zero matches: `grep -r "fifty_flutter_kit" .`

### Manual
1. Verify GitHub repo accessible at new URL
2. Verify old URL redirects properly
3. Verify package links work in README

---

## Implementation Approach

### Phase 1: Prepare Local Changes (Before GitHub Rename)

1. **Update all pubspec.yaml files:**
   ```bash
   # Script to replace in all pubspec.yaml
   find packages -name "pubspec.yaml" -exec sed -i '' \
     's/fifty_flutter_kit/fifty_flutter_kit/g' {} \;
   ```

2. **Update all README.md files:**
   ```bash
   find . -name "README.md" -exec sed -i '' \
     's/fifty_flutter_kit/fifty_flutter_kit/g' {} \;
   ```

3. **Update CLAUDE.md:**
   - Replace all `fifty_flutter_kit` references

4. **Update ai/ folder files:**
   - Session files, prompts if needed

5. **Commit changes (do not push yet):**
   ```bash
   git add -A
   git commit -m "chore: rename repository to fifty_flutter_kit"
   ```

### Phase 2: GitHub Rename

1. Go to: `https://github.com/fiftynotai/fifty_flutter_kit/settings`
2. Under "Repository name", change to `fifty_flutter_kit`
3. Click "Rename"

### Phase 3: Update Local Remote

1. **Update git remote:**
   ```bash
   git remote set-url origin https://github.com/fiftynotai/fifty_flutter_kit.git
   ```

2. **Push changes:**
   ```bash
   git push
   ```

3. **Verify:**
   ```bash
   git remote -v
   ```

### Phase 4: Verify & Cleanup

1. Test old URL redirects
2. Verify all package links work
3. Run `flutter pub get` in a few packages
4. Optionally rename local folder:
   ```bash
   cd ..
   mv fifty_flutter_kit fifty_flutter_kit
   ```

---

## Delivery

- [ ] Branch: Direct to `main` (repository rename)
- [ ] All URL references updated
- [ ] GitHub rename completed
- [ ] Git remote updated
- [ ] Commit pushed successfully

---

## Rollback Plan

If issues arise:
1. Rename GitHub repo back to `fifty_flutter_kit`
2. Revert commit: `git revert HEAD`
3. Update remote back: `git remote set-url origin https://github.com/fiftynotai/fifty_flutter_kit.git`

---

## Notes

- GitHub provides automatic redirects for old URLs (lasts indefinitely for most cases)
- Package consumers using `git` dependencies will need to update their pubspec.yaml
- pub.dev packages (if published) are unaffected - they use package name, not repo URL
- Consider updating any external documentation/links after migration

---

## Related

- Previous: MG-001 (fifty_printing_engine migration)
- Packages: All 12 packages in ecosystem
- Config: CLAUDE.md, ai/ folder
