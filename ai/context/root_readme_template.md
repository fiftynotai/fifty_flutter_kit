# FDL Root README Template v1

Standard README structure for the root of a Fifty Flutter Kit mono-repo ecosystem. The root README is a **portal** that links outward to package READMEs and docs/ for depth.

**Updated:** 2026-02-25
**Version:** 1.0

---

## Template

```markdown
<div align="center">

<img src="assets/banner.svg" alt="{Ecosystem Name} Banner" width="800">

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Publisher](https://img.shields.io/pub/publisher/{publisher_id}.svg)](https://pub.dev/publishers/{publisher_domain}/packages)
[![Packages](https://img.shields.io/badge/packages-{count}-brightgreen.svg)](packages/)
[![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)

</div>

**{One bold sentence: what this toolkit is and who it serves.}**

{Personal paragraph: author's background, curated toolkit philosophy, what makes this collection different from scattered utilities. Two to three sentences. Authentic voice.}

**By [{Author}]({author_url})**

---

## Showcase

<table>
  <tr>
    <td align="center"><img src="packages/{pkg_1}/screenshots/{img}.png" width="180"><br><sub>{Caption 1}</sub></td>
    <td align="center"><img src="packages/{pkg_2}/screenshots/{img}.png" width="180"><br><sub>{Caption 2}</sub></td>
    <td align="center"><img src="packages/{pkg_3}/screenshots/{img}.png" width="180"><br><sub>{Caption 3}</sub></td>
    <td align="center"><img src="packages/{pkg_4}/screenshots/{img}.png" width="180"><br><sub>{Caption 4}</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="packages/{pkg_5}/screenshots/{img}.png" width="180"><br><sub>{Caption 5}</sub></td>
    <td align="center"><img src="packages/{pkg_6}/screenshots/{img}.png" width="180"><br><sub>{Caption 6}</sub></td>
    <td align="center"><img src="packages/{pkg_7}/screenshots/{img}.png" width="180"><br><sub>{Caption 7}</sub></td>
    <td align="center"><img src="packages/{pkg_8}/screenshots/{img}.png" width="180"><br><sub>{Caption 8}</sub></td>
  </tr>
</table>

---

## Packages

All packages are published on [pub.dev](https://pub.dev/publishers/{publisher_domain}/packages) and can be installed individually.

### Foundation

| Package | Version | Description |
|---------|---------|-------------|
| [{pkg_name}](packages/{pkg_name}/) | [![pub package](https://img.shields.io/pub/v/{pkg_name}.svg)](https://pub.dev/packages/{pkg_name}) | {One-line description, no period} |
| [{pkg_name}](packages/{pkg_name}/) | [![pub package](https://img.shields.io/pub/v/{pkg_name}.svg)](https://pub.dev/packages/{pkg_name}) | {One-line description, no period} |

### App Development

| Package | Version | Description |
|---------|---------|-------------|
| [{pkg_name}](packages/{pkg_name}/) | [![pub package](https://img.shields.io/pub/v/{pkg_name}.svg)](https://pub.dev/packages/{pkg_name}) | {One-line description, no period} |
| [{pkg_name}](packages/{pkg_name}/) | [![pub package](https://img.shields.io/pub/v/{pkg_name}.svg)](https://pub.dev/packages/{pkg_name}) | {One-line description, no period} |

### Game Development

| Package | Version | Description |
|---------|---------|-------------|
| [{pkg_name}](packages/{pkg_name}/) | [![pub package](https://img.shields.io/pub/v/{pkg_name}.svg)](https://pub.dev/packages/{pkg_name}) | {One-line description, no period} |
| [{pkg_name}](packages/{pkg_name}/) | [![pub package](https://img.shields.io/pub/v/{pkg_name}.svg)](https://pub.dev/packages/{pkg_name}) | {One-line description, no period} |

> Source code for each package is in [packages/](packages/).

---

## Quick Start

### Design System

\```dart
import 'package:{tokens_pkg}/{tokens_pkg}.dart';
import 'package:{theme_pkg}/{theme_pkg}.dart';
import 'package:{ui_pkg}/{ui_pkg}.dart';

// Use design tokens
final primary = {Tokens}.primary;
final heading = {Typography}.heading1;

// Apply theme
MaterialApp(
  theme: {Theme}.light(),
  darkTheme: {Theme}.dark(),
);

// Use components
{Button}(
  label: 'Submit',
  onPressed: () {},
);
\```

### {Game/Engine Example Title}

\```dart
import 'package:{engine_pkg}/{engine_pkg}.dart';

// Minimal working example demonstrating core engine value
// 10-15 lines max
\```

> See each package README for complete API docs, or browse the [full Quick Start guide](docs/QUICK_START.md).

---

## Architecture

\```mermaid
graph TD
    subgraph Foundation
        A[{tokens_pkg}] --> B[{theme_pkg}]
        B --> C[{ui_pkg}]
    end

    subgraph App Development
        C --> D[{app_pkg_1}]
        C --> E[{app_pkg_2}]
    end

    subgraph Game Development
        F[{game_pkg_1}]
        G[{game_pkg_2}]
    end

    H[{utils_pkg}] --> D
    H --> F
\```

> Full architecture documentation: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)

---

## Templates

### Project Scaffolds

| Template | Description | Pattern |
|----------|-------------|---------|
| [{template_name}](templates/{template_name}/) | {Description} | {Pattern name} |

### Demo Apps

| App | Description |
|-----|-------------|
| [{app_name}](apps/{app_name}/) | {Description} |

---

## Installation

Install any package using `dart pub add`:

\```bash
dart pub add {pkg_1}
dart pub add {pkg_2}
dart pub add {pkg_3}
\```

<details>
<summary>For contributors (path dependencies)</summary>

\```yaml
dependencies:
  {pkg_1}:
    path: ../packages/{pkg_1}
  {pkg_2}:
    path: ../packages/{pkg_2}
\```

</details>

---

<details>
<summary><strong>Development</strong></summary>

### Running Tests

\```bash
# All packages
flutter test packages/*/test/

# Specific package
cd packages/{pkg_name}
flutter test
\```

### Coverage

\```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
\```

</details>

---

## Contributing

See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines.

---

## License

MIT License -- see individual packages for details.

---

<div align="center">

**[{Brand Name}]({brand_url})**

[pub.dev](https://pub.dev/publishers/{publisher_domain}/packages) | [GitHub]({github_org_url}) | [Architecture](docs/ARCHITECTURE.md) | [Quick Start](docs/QUICK_START.md)

</div>
```

---

## Rules

### Header Block Rules

1. **Banner**: Centered `<div>` with `<img>` tag, max width 800px. File at `assets/banner.svg` (or `.png`).
2. **Badge order**: License, Publisher, Package Count, Dart, Flutter. Always 5 badges.
3. **All badges use shields.io**: Publisher badge uses `https://img.shields.io/pub/publisher/{id}.svg`.
4. **Centering**: Both the banner and the badge row must be inside a single centered `<div>`.
5. **No `#` title**: The banner image replaces the `# Title` header. The ecosystem name appears in the banner image alt text and the value proposition line.

### Value Proposition Rules

1. **Bold one-liner**: First line after the centered block. One sentence, bolded, stating what the toolkit is.
2. **Personal paragraph**: Two to three sentences. Author's background, curation philosophy. Authentic voice, not marketing copy.
3. **Attribution**: `**By [Author](url)**` on its own line. Always linked.
4. **Separator**: `---` after attribution.

### Screenshot Showcase Rules

1. **Section header**: `## Showcase` (not "Screenshots" or "Gallery").
2. **Layout**: HTML `<table>` with 2 rows, 4 columns (2x4 grid = 8 images).
3. **Image width**: 180px each via `width="180"` attribute.
4. **Captions**: `<sub>` tag below each image. Short (2-4 words).
5. **Domain diversity**: Row 1 should feature foundation + app development packages. Row 2 should feature game development + infrastructure packages.
6. **Cherry-pick**: Select the single most visually impressive screenshot from each featured package.
7. **Paths**: Relative paths pointing into `packages/{name}/screenshots/`.

### Package Table Rules

1. **Domain grouping**: Three sub-sections with `###` headers: `Foundation`, `App Development`, `Game Development`.
2. **Table columns**: Package | Version | Description.
3. **Package name links to source directory**: `[{name}](packages/{name}/)` -- not to pub.dev (the badge handles that).
4. **Version badge**: Dynamic pub.dev URL: `[![pub package](https://img.shields.io/pub/v/{name}.svg)](https://pub.dev/packages/{name})`. Never hardcode version numbers.
5. **Descriptions**: One line maximum, no trailing period.
6. **Ordering within groups**: Alphabetical by package name, or by dependency order (foundation first) if there is a clear hierarchy.
7. **Blockquote footer**: `> Source code for each package is in [packages/](packages/).` after the last table.

### Quick Start Rules

1. **Maximum 2 code examples** in the root README. Push all remaining examples to `docs/QUICK_START.md`.
2. **Example 1**: Always the design system stack (tokens + theme + UI). This is the ecosystem's flagship.
3. **Example 2**: A game or engine example showcasing the second domain.
4. **Each example**: Minimal, copy-pasteable, demonstrates core value. No boilerplate.
5. **Footer blockquote**: Links to individual package READMEs and `docs/QUICK_START.md`.

### Architecture Rules

1. **Use Mermaid diagram** (not ASCII art). Root README uses Mermaid; package READMEs use ASCII.
2. **Keep compact**: Show 3-layer relationships (Foundation, App Development, Game Development), not every package detail.
3. **Subgraph grouping**: One `subgraph` per domain group.
4. **Footer blockquote**: Link to `docs/ARCHITECTURE.md` for the full dependency graph.

### Templates Section Rules

1. **Two sub-tables**: "Project Scaffolds" (templates/) and "Demo Apps" (apps/).
2. **Linked names**: Each template/app name links to its directory.
3. **Pattern column**: For templates, include the architecture pattern name (e.g., "MVVM + Actions").

### Installation Section Rules

1. **Primary method**: `dart pub add` commands. Show 2-3 representative packages.
2. **Contributor method**: Collapsible `<details>` block with path dependency YAML.
3. **No version numbers in `dart pub add`**: The command installs latest by default.
4. **No full pubspec.yaml listing**: Root README is a portal; individual READMEs have full install instructions.

### Collapsible Section Rules

1. **Use `<details><summary>`** for: contributor installation, Development section.
2. **Primary content always visible**: The main install command and main sections are never collapsed.
3. **Development section**: Entire section wrapped in `<details><summary><strong>Development</strong></summary>`.

### Development Section Rules

1. **Collapsible**: Wrapped in `<details>` to reduce visual noise for consumers (most visitors are users, not contributors).
2. **Content**: Test commands (all packages + specific package) and coverage generation.
3. **No CI/CD details**: Those belong in `docs/CONTRIBUTING.md`.

### Contributing Section Rules

1. **One line only**: `See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for guidelines.`
2. **No inline contributing steps**: All contribution details live in the docs/ directory.

### License Section Rules

1. **One line**: `MIT License -- see individual packages for details.`
2. **No full license text**: The LICENSE file at root handles that.

### Footer Rules

1. **Centered `<div>`** at the very bottom.
2. **Brand attribution**: `**[{Brand Name}]({brand_url})**` on the first line.
3. **Navigation links**: pub.dev publisher page | GitHub organization | Architecture docs | Quick Start docs.
4. **Separated by pipes** (`|`) for visual clarity.
5. **No trailing separator**: The footer is the last element in the file.

### General Content Rules

1. **Horizontal rules** (`---`) between every `##` section.
2. **No Table of Contents**: The README is short enough (280-320 lines) to not need one.
3. **No Package Details section**: The root README is a portal. Package details live in individual READMEs.
4. **No duplicate content**: If content exists in a package README, link to it; do not reproduce it.
5. **Branding appears exactly three times**: value proposition one-liner, license line, footer.
6. **All code blocks have language tags**: `dart`, `yaml`, `bash`, `mermaid`.
7. **No hardcoded version numbers**: All version displays use dynamic shields.io badges.
8. **No AI signatures**: No "Generated with" or "Co-Authored-By" in any commit or content.

---

## Compliance Checklist

When writing or reviewing the root README, verify:

- [ ] Banner present and centered (`<div align="center">`, max 800px width)
- [ ] Badge row with 5 badges (License, Publisher, Count, Dart, Flutter)
- [ ] Value proposition (one bold sentence)
- [ ] Personal intro paragraph (2-3 sentences, authentic voice)
- [ ] Author attribution with link
- [ ] Showcase section with 8 screenshots in 2x4 HTML table grid
- [ ] Screenshot captions using `<sub>` tags
- [ ] Screenshots span both app and game development domains
- [ ] Packages section with 3 domain-grouped tables (Foundation, App, Game)
- [ ] All version badges are dynamic (`img.shields.io/pub/v/{name}.svg`)
- [ ] Package names link to source directories (not pub.dev)
- [ ] Package descriptions are one line, no trailing period
- [ ] Quick Start has exactly 2 code examples (design system + engine)
- [ ] Quick Start footer links to package READMEs and `docs/QUICK_START.md`
- [ ] Architecture uses Mermaid diagram with 3 subgraphs
- [ ] Architecture footer links to `docs/ARCHITECTURE.md`
- [ ] Templates section has Project Scaffolds and Demo Apps sub-tables
- [ ] Installation shows `dart pub add` (primary) and path deps (collapsible)
- [ ] Development section is collapsible (`<details>`)
- [ ] Contributing section is one line linking to `docs/CONTRIBUTING.md`
- [ ] License is one line
- [ ] Footer is centered with brand + 4 navigation links
- [ ] `---` separator between every `##` section
- [ ] Total line count 280-320
- [ ] All relative links resolve to existing files
- [ ] No hardcoded version numbers (all dynamic badges)
- [ ] All code blocks have language tags (`dart`, `yaml`, `bash`, `mermaid`)
- [ ] No Table of Contents
- [ ] No Package Details section (portal, not encyclopedia)
- [ ] No AI signatures or co-authored-by tags

---

## Differences from FDL Package README Template v2

The root README template differs from the package template in these deliberate ways:

| Aspect | Package Template v2 | Root Template v1 |
|--------|---------------------|------------------|
| **Title** | `# {Package Title}` header | Banner image (no `#` header) |
| **Badges** | 2 (pub.dev + license) | 5 (license, publisher, count, Dart, Flutter) |
| **Screenshots** | Markdown table (2-4 images) | HTML table, 2x4 grid (8 images) |
| **Architecture** | ASCII diagram + Core Components table | Mermaid diagram (compact, 3-layer) |
| **Package tables** | N/A (single package) | 3 domain-grouped tables with dynamic badges |
| **Quick Start** | 1 example (10-40 lines) | 2 examples only (design system + engine) |
| **Installation** | pub.dev + path (both visible) | pub.dev visible, path in collapsible |
| **Development** | Visible section | Collapsible section |
| **Contributing** | No section (repo-level) | One line linking to docs/ |
| **Footer** | "Part of Fifty Flutter Kit" link | Centered brand + navigation links |
| **Sections** | 10 mandatory + optional | 10 fixed (no optional sections) |

---

## Reference Implementation

The current root README at `README.md` in the repository root serves as the living reference for this template. When the template is updated, the root README should be brought into compliance.

---

## Applying This Template

When writing or rewriting the root README:

1. Read this template fully
2. Inventory all packages in `packages/` and their current pub.dev status
3. Select 8 screenshots for the Showcase (cherry-pick best from each featured package)
4. Group packages into Foundation / App Development / Game Development
5. Write exactly 2 Quick Start examples
6. Create Mermaid architecture diagram showing layer relationships
7. Verify against the Compliance Checklist above
8. Ensure total line count is 280-320 lines
