# BR-116: Root README Overhaul to Top-Tier Standard

**Type:** Feature
**Priority:** P1-High
**Effort:** L-Large
**Status:** Done
**Created:** 2026-02-25

---

## Problem

The root README is functional (476 lines) but lacks the visual polish and structure of top-tier Flutter ecosystem repos (bloc, Flame, melos, riverpod). Key gaps:

1. No visual header/banner (THE #1 differentiator for premium repos)
2. No screenshots despite having 42+ screenshots across packages
3. Static hardcoded version badges that go stale immediately
4. Flat package table with no domain grouping
5. 140-line "Package Details" section duplicating package READMEs
6. ASCII architecture diagrams when Mermaid renders natively on GitHub
7. No collapsible sections for progressive disclosure
8. No community/support links
9. Empty `docs/` directory — no supporting documentation

## Goal

Transform the root README into a ~300-line premium landing page (portal, not encyclopedia) backed by a proper `docs/` directory. Match the quality bar set by bloc, Flame, and melos.

## Deliverables

1. `ai/context/root_readme_template.md` — Standard root README template (like FDL Template v2 for packages)
2. `assets/banner.svg` — SVG banner with brand colors
3. `README.md` — Complete rewrite using the template
4. `docs/ARCHITECTURE.md` — Full architecture doc with Mermaid diagrams
5. `docs/QUICK_START.md` — All code examples expanded
6. `docs/CONTRIBUTING.md` — Proper ecosystem contributor guide

## Acceptance Criteria

- [ ] Root README follows new root template
- [ ] SVG banner renders on GitHub
- [ ] 8-screenshot showcase grid displays correctly
- [ ] All pub.dev badges are dynamic (auto-update)
- [ ] Packages grouped by domain (Foundation / App / Game)
- [ ] Mermaid architecture diagram renders on GitHub
- [ ] Collapsible sections for Installation (contributor) and Development
- [ ] All relative links resolve correctly
- [ ] Line count ~280-320 (down from 476)
- [ ] docs/ directory populated with 3 supporting documents

---

**Created:** 2026-02-25
**Brief Owner:** Igris AI
