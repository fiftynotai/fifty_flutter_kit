# FDL README Template

Standard README structure for all Fifty Flutter Kit packages. Every package README MUST follow this template exactly.

---

## Template

```markdown
# {Package Title}

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

Add to your `pubspec.yaml`:

\```yaml
dependencies:
  {package_name}:
    path: ../{package_name}
\```

---

## Quick Start

\```dart
// Minimal working example (10-20 lines max)
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

### Header Block (Lines 1-8)
1. **Title**: `# {Package Title}` — Human-readable name (e.g., "Fifty Audio Engine"), NOT the pub name
2. **One-liner**: Single sentence ending with `. Part of [Fifty Flutter Kit](URL).`
3. **Screenshots**: Immediately after one-liner. Markdown table format. 2-4 images. No `## Screenshots` header
4. **Separator**: `---` after screenshots

### Section Order (Mandatory)
1. Features
2. Installation
3. Quick Start
4. Architecture (+ Core Components)
5. API Reference
6. Usage Patterns
7. Platform Support (+ platform-specific setup)
8. Fifty Design Language Integration
9. Version
10. License

### Section Naming (Exact Headers)
These are the ONLY allowed `##` headers. No variations.

| Standard Header | Replaces |
|----------------|----------|
| `## Features` | "Overview" (when it's just a feature list) |
| `## Architecture` | "Core Concepts" |
| `## API Reference` | (same) |
| `## Usage Patterns` | "Advanced Usage", "Usage Examples", "Interactions", "Patterns", "Best Practices" |
| `## Platform Support` | "Platform Setup" |
| `## Fifty Design Language Integration` | "FDL Integration", "Theme Support", "Integration with Fifty Flutter Kit" |

### Content Rules
- **Horizontal rules** (`---`) between every `##` section
- **Tables** for structured data (components, API, platform support)
- **Code blocks** with `dart` language tag
- **Bold** for emphasis within lists: `- **Name** - Description`
- No badges (add when published to pub.dev)
- No Table of Contents
- No Contributing section (covered by repo-level CONTRIBUTING.md)
- No Testing section (covered by repo-level CONTRIBUTING.md)
- No "Part of Fifty Flutter Kit" package table (redundant with header one-liner)
- Branding appears exactly twice: header one-liner + license footer

### Exceptions
- **Migration sections** are allowed when package-specific (e.g., `## Migration from erune_sentences_engine`)
- Place migration sections after "Fifty Design Language Integration" and before "Version"

---

## Applying This Template

When writing a new package README or rewriting an existing one:

1. Read this template
2. Read the package's source code (pubspec.yaml, lib/ barrel file, key classes)
3. Fill in every section — skip none of the 10 standard sections
4. Preserve all existing code examples and technical content
5. Verify: 10 standard `##` headers, 2 branding refs, `---` separators, no badges/TOC/contributing
