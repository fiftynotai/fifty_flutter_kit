/// Flutter theming layer for the fifty.dev ecosystem.
///
/// This package provides complete Flutter ThemeData built from fifty_tokens.
/// It converts design tokens into Material Design components following
/// the Fifty Design Language (FDL) specification.
///
/// Dark mode is the primary environment. All components are designed for
/// maximum impact with minimal visual noise.
///
/// Usage:
/// ```dart
/// import 'package:fifty_theme/fifty_theme.dart';
///
/// MaterialApp(
///   theme: FiftyTheme.dark(),
///   // ...
/// );
/// ```
library fifty_theme;

export 'src/color_scheme.dart';
export 'src/component_themes.dart';
export 'src/fifty_theme_data.dart';
export 'src/text_theme.dart';
export 'src/theme_extensions.dart';
