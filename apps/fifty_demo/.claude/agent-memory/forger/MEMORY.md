# FORGER Memory

## fifty_tokens v3.0.0 Migration Pattern

All token accessors in fifty_tokens v3.0.0 changed from `static const` to `static get` (runtime getters reading from FiftyTokens.active preset). This means:

- `FiftySpacing.*`, `FiftyRadii.*`, `FiftyTypography.*`, `FiftyMotion.*` are all getters
- `FiftyColors.*` semantic colors (primary, error, success, warning, burgundy, cream, slateGrey, etc.) are getters
- Only deprecated v1 `FiftyColors` constants (voidBlack, crimsonPulse, gunmetal, etc.) remain `static const`
- Any `const` expression using these tokens will fail with `invalid_constant`
- Fix: Remove `const` from the containing expression (EdgeInsets, TextStyle, SizedBox, etc.)
- Keep `const` on expressions that only use literal values

## AudioTrack Enum Change (fifty_demo)

AudioTrack enum values changed from `exploration`, `combat`, `peaceful` (3 values) to:
- `clockworkGrove`, `clockworkGroveAlt`, `pathOfFirstLight`, `pathOfFirstLightAlt` (4 values)

## Project Conventions

- Uses MVVM + Actions pattern with GetX
- `flutter analyze` must show zero errors before committing
- Conventional Commits format, no AI signatures
