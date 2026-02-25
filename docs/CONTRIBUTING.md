# Contributing

Thank you for your interest in contributing to Fifty Flutter Kit. This guide covers everything you need to get started.

---

## Prerequisites

- **Flutter SDK** 3.x or later
- **Dart SDK** 3.x or later
- A code editor with Dart/Flutter support (VS Code, Android Studio, IntelliJ)
- Git

---

## Setup

### 1. Fork and Clone

```bash
# Fork the repository on GitHub, then:
git clone https://github.com/<your-username>/fifty_eco_system.git
cd fifty_eco_system
```

### 2. Understand the Monorepo Structure

The repository is a monorepo containing 16 independent packages:

```
fifty_eco_system/
  packages/           # 16 published packages (each has its own pubspec.yaml)
  apps/               # Demo applications
  templates/          # Architecture templates
  docs/               # Documentation
```

Each package under `packages/` is self-contained with its own `pubspec.yaml`, `lib/`, `test/`, and `README.md`. Packages are published to [pub.dev](https://pub.dev/publishers/fifty.dev/packages) independently.

### 3. Install Dependencies

Navigate to the package you want to work on and install its dependencies:

```bash
cd packages/fifty_utils
flutter pub get
```

If you are working on a package that depends on other packages in the ecosystem (e.g., `fifty_theme` depends on `fifty_tokens`), the `pubspec.yaml` uses path dependencies in development:

```yaml
dependencies:
  fifty_tokens:
    path: ../fifty_tokens
```

---

## Development Workflow

### 1. Pick a Package

Each package is independent. Work on one package at a time unless your change spans multiple packages.

### 2. Create a Branch

```bash
git checkout -b feat/fifty-utils-add-string-extension
```

Use the naming convention: `<type>/<package>-<description>`

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

### 3. Make Your Changes

- Follow existing code patterns within the package
- Add documentation comments to all public APIs
- Keep changes focused -- one concern per PR

### 4. Run the Analyzer

Every package must pass `flutter analyze` with zero issues:

```bash
cd packages/fifty_utils
flutter analyze
```

### 5. Run Tests

```bash
flutter test
```

All existing tests must continue to pass. New code should include tests.

---

## Running Tests

### Single Package

```bash
cd packages/fifty_utils
flutter test
```

### With Coverage

```bash
flutter test --coverage
# Generate HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### All Packages

From the repository root:

```bash
for pkg in packages/*/; do
  echo "Testing $pkg..."
  (cd "$pkg" && flutter test) || echo "FAILED: $pkg"
done
```

---

## Code Style

### Dart Formatting

All code must be formatted with `dart format`:

```bash
dart format .
```

### Linting

Packages use the default Flutter linting rules. Run `flutter analyze` and fix all warnings and errors before submitting.

### Commit Messages

This project uses [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <summary>

<optional body>

<optional footer>
```

Examples:

```
feat(fifty-utils): add String.capitalize() extension
fix(fifty-theme): correct dark mode surface color
docs(fifty-forms): update validation examples in README
test(fifty-cache): add TTL expiration edge case tests
```

---

## Pull Request Process

### 1. Ensure Quality

Before opening a PR, verify:

- [ ] `flutter analyze` passes with zero issues
- [ ] `flutter test` passes (all tests green)
- [ ] New public APIs have documentation comments
- [ ] `dart format .` has been run
- [ ] Commit messages follow Conventional Commits

### 2. Open the PR

- Target the `main` branch
- Write a clear title following the commit message convention
- Describe what changed and why in the PR body
- Reference any related issues

### 3. Review

A maintainer will review your PR. Be prepared for feedback -- the goal is to maintain consistent quality across all 16 packages.

---

## Adding a New Package

If you are proposing a new package for the ecosystem:

### Checklist

1. **Create the package directory** under `packages/`:
   ```bash
   cd packages
   flutter create --template=package fifty_<name>
   ```

2. **Set up `pubspec.yaml`** with:
   - Publisher: `fifty.dev`
   - Appropriate version (start at `0.1.0`)
   - Correct dependencies

3. **Follow the standard directory structure:**
   ```
   fifty_<name>/
     lib/
       fifty_<name>.dart       # Barrel export file
       src/                    # Implementation
     test/                     # Tests
     example/                  # Example app (optional but recommended)
     README.md                 # Package README
     CHANGELOG.md              # Version history
     LICENSE                   # MIT License
   ```

4. **Write a README** following the package README standard (see below)

5. **Add tests** -- every public API should have test coverage

6. **Add the package** to the root README package table

### Package Layer Placement

Determine which layer the new package belongs to:

| Layer | Criteria |
|-------|----------|
| Foundation | Design system primitives (tokens, theme, components) |
| Infrastructure | Standalone services (no UI dependency) |
| App Development | Application-specific tools consuming Foundation |
| Game Development | Game-specific engines and systems |

---

## Package README Standard

All package READMEs follow the **FDL Template v2** format. The standard structure:

1. **Header** -- Package name, badges (pub.dev version, license, Flutter platform)
2. **Overview** -- One-paragraph description
3. **Features** -- Bullet list of key capabilities
4. **Installation** -- `dart pub add` command and `pubspec.yaml` snippet
5. **Quick Start** -- Minimal working code example
6. **API Reference** -- Key classes and methods with brief descriptions
7. **Architecture** -- Internal design decisions (if applicable)
8. **Example** -- Link to `example/` directory
9. **Contributing** -- Link back to this file
10. **License** -- MIT

---

## Questions?

Open an issue on GitHub if you have questions about contributing. We are happy to help you get started.
