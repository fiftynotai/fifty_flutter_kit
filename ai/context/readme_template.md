# FDL README Template v2

Standard README structure for all Fifty Flutter Kit packages. Every package README MUST follow this template.

**Updated:** 2026-02-24
**Version:** 2.0

---

## Template

```markdown
# {Package Title}

[![pub package](https://img.shields.io/pub/v/{pub_name}.svg)](https://pub.dev/packages/{pub_name})
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

{One-line description}. Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).

| Screenshot 1 | Screenshot 2 | Screenshot 3 | Screenshot 4 |
|:------------:|:------------:|:------------:|:------------:|
| ![Alt](screenshots/file.png) | ![Alt](screenshots/file.png) | ![Alt](screenshots/file.png) | ![Alt](screenshots/file.png) |

---

## Features

- **Feature Name** - Short description
- **Feature Name** - Short description

---

## Installation

\```yaml
dependencies:
  {package_name}: ^{version}
\```

### For Contributors

\```yaml
dependencies:
  {package_name}:
    path: ../{package_name}
\```

**Dependencies:** `{dep_1}`, `{dep_2}` (list only non-Flutter deps)

---

## Quick Start

\```dart
// Minimal working example
\```

---

## Architecture

\```
{ASCII diagram showing component relationships}
\```

### Core Components

| Component | Description |
|-----------|-------------|
| `ClassName` | What it does |

---

## API Reference

### MainClass

\```dart
// Public API surface
\```

{Additional API subsections as needed}

---

## Configuration

{Optional section — include when the package has configuration objects,
builder patterns, or >3 configurable parameters. See "Optional Sections" rules below.}

### ConfigClass

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `param` | `Type` | `value` | What it controls |

---

## Error Handling

{Optional section — include when the package has typed exceptions,
error streams, or categorized error types. See "Optional Sections" rules below.}

---

## Usage Patterns

### Pattern Name

\```dart
// Example code
\```

{Additional patterns as needed}

---

## Platform Support

| Platform | Support | Notes |
|----------|---------|-------|
| Android  | Yes     |       |
| iOS      | Yes     |       |
| macOS    | Yes     |       |
| Linux    | Yes     |       |
| Windows  | Yes     |       |
| Web      | Yes     |       |

{Platform-specific setup subsections if needed (Android permissions, iOS plist, etc.)}

---

## Fifty Design Language Integration

This package is part of Fifty Flutter Kit:

- **{Integration point 1}** - How it connects to FDL
- **{Integration point 2}** - Token alignment, compatible packages

---

## Version

**Current:** {x.y.z}

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
```

---

## Rules

### Header Block

1. **Title**: `# {Package Title}` — Human-readable name (e.g., "Fifty Audio Engine"), NOT the pub name
2. **Badges**: pub.dev version badge + MIT license badge. Mandatory for all published packages. Immediately after the title.
3. **One-liner**: Single sentence ending with `. Part of [Fifty Flutter Kit](URL).`
4. **Screenshots**: Immediately after one-liner. Markdown table format. 2-4 images. No `## Screenshots` header. If the package has no visual UI (pure Dart utility), omit screenshots entirely.
5. **Separator**: `---` after screenshots (or after one-liner if no screenshots)

### Screenshot Guidelines

- **Directory**: `screenshots/` at package root (not `example/screenshots/`)
- **Naming**: `snake_case.png` — descriptive of content (e.g., `connected.png`, `dark_mode.png`)
- **Format**: PNG, taken from iOS Simulator or device
- **Count**: 2-4 images showing distinct states or features
- **Alt text**: Descriptive alt text matching the screenshot content
- **pubspec.yaml**: All screenshots must be listed in the `screenshots:` field with descriptions

### Section Order

**10 mandatory sections (every package):**

| # | Section | Required |
|---|---------|----------|
| 1 | Features | Always |
| 2 | Installation | Always |
| 3 | Quick Start | Always |
| 4 | Architecture (+ Core Components) | Always |
| 5 | API Reference | Always |
| 6 | Usage Patterns | Always |
| 7 | Platform Support (+ platform-specific setup) | Always |
| 8 | Fifty Design Language Integration | Always |
| 9 | Version | Always |
| 10 | License | Always |

**Optional sections (insert between API Reference and Usage Patterns):**

| Section | When to Include | Placement |
|---------|----------------|-----------|
| Configuration | Package has config objects with >3 parameters | After API Reference |
| Error Handling | Package has typed exceptions or error streams | After Configuration (or API Reference) |
| {Domain-Specific} | Package has unique domain concepts (e.g., "Reconnection Methods", "Channel Architecture") | After Error Handling, before Usage Patterns |

**Other allowed sections:**

| Section | When to Include | Placement |
|---------|----------------|-----------|
| Migration | Migrating from a predecessor package | After FDL Integration, before Version |

### Section Naming (Exact Headers)

These are the mandatory `##` headers. No variations.

| Standard Header | Replaces |
|----------------|----------|
| `## Features` | "Overview" (when it's just a feature list) |
| `## Installation` | "Getting Started", "Setup" |
| `## Quick Start` | "Example", "Basic Usage" |
| `## Architecture` | "Core Concepts", "How It Works" |
| `## API Reference` | (same) |
| `## Configuration` | "Settings", "Options" |
| `## Error Handling` | "Exceptions", "Error Types" |
| `## Usage Patterns` | "Advanced Usage", "Usage Examples", "Interactions", "Patterns", "Best Practices" |
| `## Platform Support` | "Platform Setup", "Compatibility" |
| `## Fifty Design Language Integration` | "FDL Integration", "Theme Support", "Integration with Fifty Flutter Kit" |

### Content Rules

- **Horizontal rules** (`---`) between every `##` section
- **Tables** for structured data (components, API, platform support, configuration parameters)
- **Code blocks** with `dart` language tag (or `yaml` for pubspec)
- **Bold** for emphasis within lists: `- **Name** - Description`
- **Badges**: Mandatory for published packages (pub.dev + license)
- No Table of Contents
- No Contributing section (covered by repo-level CONTRIBUTING.md)
- No Testing section (covered by repo-level CONTRIBUTING.md)
- No "Part of Fifty Flutter Kit" package table (redundant with header one-liner)
- Branding appears exactly twice: header one-liner + license footer

### Installation Section Rules

All packages MUST show both installation methods:

1. **pub.dev** (primary): `{package_name}: ^{version}` — the default for consumers
2. **Path** (contributor): `path: ../{package_name}` — under a `### For Contributors` sub-header
3. **Dependencies**: List non-Flutter dependencies below the yaml blocks (e.g., "Dependencies: `phoenix_socket`, `meta`")

### Quick Start Rules

- **Goal**: Shortest possible working example that demonstrates the package's core value
- **Length tiers**:
  - Simple packages (tokens, cache, storage): 10-15 lines
  - Medium packages (connectivity, forms, UI): 15-25 lines
  - Complex packages (audio engine, socket, world engine): 25-40 lines
- **Must compile**: Every code example must be syntactically valid Dart
- **No boilerplate**: Skip imports in Quick Start if obvious; skip `void main()` wrapper unless necessary

### API Reference Rules

- **One `###` subsection per major public class** (e.g., `### SocketService`, `### BgmChannel`)
- **Show method signatures** in fenced `dart` code blocks
- **Use tables** for parameter documentation when a method/constructor has >3 parameters
- **Stream documentation**: For reactive packages, document each public stream with its type and emission behavior
- **Depth**: Document every public method. Private API is excluded.

### Architecture Section Rules

- **ASCII diagram**: Show component relationships using ASCII art (box-drawing chars `┌─┐│└` or tree chars `+--`)
- **Core Components table**: Mandatory. One row per major public class.
- **State machines**: If the package has lifecycle states, include a state diagram in Architecture (not as a separate section). Use an ASCII diagram + state transition table.

---

## Compliance Checklist

When writing or reviewing a package README, verify:

- [ ] Title is human-readable (e.g., "Fifty Audio Engine" not "fifty_audio_engine")
- [ ] pub.dev + license badges present (if published)
- [ ] One-liner ends with "Part of Fifty Flutter Kit" link
- [ ] Screenshots table present (if package has visual output)
- [ ] Screenshots listed in pubspec.yaml `screenshots:` field
- [ ] All 10 mandatory sections present in correct order
- [ ] Optional sections placed correctly (between API Reference and Usage Patterns)
- [ ] `---` separator between every `##` section
- [ ] Installation shows both pub.dev and path variants
- [ ] Quick Start is minimal and compilable
- [ ] Architecture has ASCII diagram + Core Components table
- [ ] API Reference has one subsection per major class
- [ ] Platform Support table has all 6 platforms
- [ ] FDL Integration section links to relevant sister packages
- [ ] Version number matches pubspec.yaml
- [ ] License footer includes "Part of Fifty Flutter Kit" link
- [ ] No Table of Contents, Contributing, or Testing sections
- [ ] Branding appears exactly twice
- [ ] All code blocks have language tags (`dart`, `yaml`, etc.)
- [ ] No hardcoded IPs, API keys, or credentials in examples

---

## Reference Implementations

These READMEs exemplify the standard at different complexity levels:

| Package | Complexity | Notable Patterns |
|---------|-----------|-----------------|
| `fifty_connectivity` | Medium | Clean 10-section structure, platform-specific setup |
| `fifty_audio_engine` | High | Deep API Reference with stream documentation, reactive patterns |
| `fifty_socket` | High | Configuration section, error handling, state machine in architecture |

---

## Applying This Template

When writing a new package README or rewriting an existing one:

1. Read this template fully
2. Read the package's source code (pubspec.yaml, lib/ barrel file, key classes)
3. Fill in every mandatory section — skip none of the 10
4. Add optional sections only if they meet the inclusion criteria above
5. Preserve all existing code examples and technical content
6. Verify against the Compliance Checklist above
