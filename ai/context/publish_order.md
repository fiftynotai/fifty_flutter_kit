# Pub.dev Publish Order — Fifty Flutter Kit

**Created:** 2026-02-18
**Status:** Ready for publish (metadata complete)
**Packages:** 15

---

## Pre-Publish Checklist (Per Package)

Before running `dart pub publish` for each package:

1. Convert path deps to hosted deps (`fifty_tokens: ^1.0.0`)
2. Run `flutter analyze` — zero issues
3. Run `dart pub publish --dry-run` — zero warnings
4. Verify CHANGELOG has entry for current version
5. Tag release: `git tag fifty_{name}-v{version}`

---

## Publish Phases

### Phase 1: Foundation (no internal deps)

| Package | Version | Dependencies | Notes |
|---------|---------|-------------|-------|
| `fifty_tokens` | 1.0.0 | none | Publish first — all core packages depend on this |
| `fifty_utils` | 0.1.0 | none | Pure utilities |
| `fifty_cache` | 0.1.0 | none | Pure Dart (no Flutter SDK dep) |
| `fifty_storage` | 0.1.0 | none | Uses flutter_secure_storage |

**After Phase 1:** All 4 packages live on pub.dev. Update downstream pubspecs.

### Phase 2: Core Theme

| Package | Version | Dependencies | Notes |
|---------|---------|-------------|-------|
| `fifty_theme` | 1.0.0 | `fifty_tokens: ^1.0.0` | Convert path dep before publish |

**After Phase 2:** fifty_theme live. Update fifty_ui, fifty_forms, engine pubspecs.

### Phase 3: UI + Clean Engines

| Package | Version | Dependencies | Notes |
|---------|---------|-------------|-------|
| `fifty_ui` | 0.6.0 | `fifty_tokens: ^1.0.0`, `fifty_theme: ^1.0.0` | Convert 2 path deps |
| `fifty_printing_engine` | 1.0.0 | none (external only) | Clean — no internal deps |
| `fifty_sentences_engine` | 0.1.0 | none (external only) | Plugin package — clean |

### Phase 4: Feature Packages

| Package | Version | Dependencies | Notes |
|---------|---------|-------------|-------|
| `fifty_forms` | 0.1.0 | `fifty_tokens`, `fifty_theme`, `fifty_ui`, `fifty_storage` | Convert 4 path deps |
| `fifty_connectivity` | 0.1.0 | `fifty_tokens`, `fifty_ui`, `fifty_utils` | Convert 3 path deps |

### Phase 5: Engine Packages

| Package | Version | Dependencies | Notes |
|---------|---------|-------------|-------|
| `fifty_audio_engine` | 0.7.0 | `fifty_tokens`, `fifty_theme`, `fifty_ui` | Plugin package — convert 3 path deps |
| `fifty_speech_engine` | 0.1.0 | `fifty_tokens`, `fifty_theme`, `fifty_ui` | Plugin package — convert 3 path deps |
| `fifty_world_engine` | 0.1.0 | none (external only) | Plugin package — clean |
| `fifty_achievement_engine` | 0.1.1 | `fifty_tokens`, `fifty_ui` | Convert 2 path deps |
| `fifty_skill_tree` | 0.1.0 | `fifty_tokens` | Convert 1 path dep |

---

## Dependency Conversion Template

When converting path deps to hosted deps at publish time:

```yaml
# BEFORE (development)
fifty_tokens:
  path: ../fifty_tokens

# AFTER (publishing)
fifty_tokens: ^1.0.0
```

**Example subdirectory pubspecs** (`example/pubspec.yaml`) should KEEP path deps — they are not published.

---

## Post-Publish Verification

After each phase:

1. Visit `https://pub.dev/packages/{name}` — verify page renders
2. Check pub.dev score (aim for 130+ points)
3. Verify documentation tab has dartdoc content
4. Check example tab shows example code
5. Update downstream package pubspecs with hosted dep versions

---

## Version Constraints

| Dependency | Constraint | Rationale |
|-----------|-----------|-----------|
| `fifty_tokens` | `^1.0.0` | Stable API, semver major |
| `fifty_theme` | `^1.0.0` | Stable API, semver major |
| `fifty_ui` | `^0.6.0` | Pre-1.0, minor breaking allowed |
| `fifty_utils` | `^0.1.0` | Pre-1.0 |
| `fifty_cache` | `^0.1.0` | Pre-1.0 |
| `fifty_storage` | `^0.1.0` | Pre-1.0 |
