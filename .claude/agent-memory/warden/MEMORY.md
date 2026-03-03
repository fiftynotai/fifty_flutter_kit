# WARDEN Memory

## Reviewed Packages

### fifty_tokens v3.0.0 (2026-03-01)
- First review: REJECTED with 3 blockers (shadow JSON keys, unused meta dep, README version mismatch)
- Re-review (2026-03-02): APPROVED -- all 3 blockers fixed, full 8-category JSON/parser alignment verified
- Minor: README FiftyCard example still missing super.key (non-blocking)
- Pattern: Always cross-reference JSON schema files against their parsers
- Pattern: Always verify README dependency versions match pubspec.yaml

## Review Patterns

### Common Issues to Check
- JSON reference/schema files must use the exact same keys as their Dart parsers
- README code examples must be lint-clean against the package's own analysis_options.yaml
- Declared dependencies must actually be imported somewhere in lib/
- Deprecated items spanning 2+ major versions should be evaluated for removal
- Widget examples in README should include `super.key` in constructors
