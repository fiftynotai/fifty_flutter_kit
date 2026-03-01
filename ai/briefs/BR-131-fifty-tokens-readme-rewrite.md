# BR-131: fifty_tokens README Rewrite — Selling Point First

**Type:** Feature
**Priority:** P2-Medium
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** In Progress
**Created:** 2026-03-01

---

## Problem

**What's broken or missing?**

The fifty_tokens README buries its key selling point — full configurability via JSON or code — at line 300, behind a wall of architecture diagrams and 170 lines of API reference. Users scanning the README see "yet another design tokens package" and miss the thing that makes fifty_tokens unique: you can ship YOUR brand, not ours, with a single configure call or JSON file.

**Why does it matter?**

- First impression is everything for pub.dev discovery
- The configuration system (AC-007) is the package's core value proposition
- Users evaluating design token packages compare READMEs side by side
- Current structure rewards completeness over persuasion

---

## Goal

**What should happen after this brief is completed?**

A rewritten README that leads with the selling point (configurability), makes it obvious within 10 seconds why someone should pick fifty_tokens, and moves reference material below the fold.

**New structure:**
1. Hero pitch — one-liner value prop
2. Why fifty_tokens — 3-4 bullet value props (configurable, JSON-driven, zero widgets)
3. Quick Start — install + 5-line configure example
4. Configuration — the full configuration story (presets, JSON, individual overrides, font sources)
5. Token Reference — compact version of the current API Reference (collapsed or table format)
6. Usage Patterns — trimmed to 2-3 best examples
7. Kit Position — where it fits in the ecosystem
8. Platform Support + License — footer

---

## Context & Inputs

### Related Files
- `packages/fifty_tokens/README.md` — the only file to modify

### Out of Scope
- No code changes
- No test changes
- No API changes
- Other package READMEs

---

## Tasks

### Pending
- [ ] Task 1: Rewrite README with new structure (selling point first, configuration prominent, API reference compact)

### In Progress

### Completed

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Configuration section appears within first 50 lines of README
2. [ ] Hero section communicates value prop in under 10 seconds of reading
3. [ ] "Why fifty_tokens" section has 3-4 clear differentiators
4. [ ] Quick Start includes a configure example (not just usage)
5. [ ] API Reference is compact (tables, not 170 lines of code blocks)
6. [ ] All current information is preserved (nothing lost, just reorganized)
7. [ ] No code changes — README only

---

## Test Plan

### Manual Test Cases

#### Test Case 1: 10-Second Scan
**Steps:**
1. Open the new README
2. Read for 10 seconds

**Expected Result:** Reader understands that fifty_tokens is a configurable design token system for Flutter

#### Test Case 2: Configuration Discovery
**Steps:**
1. Open the new README
2. Scroll to find configuration section

**Expected Result:** Configuration appears before line 50

---

**Created:** 2026-03-01
**Last Updated:** 2026-03-01
**Brief Owner:** Fifty.ai
