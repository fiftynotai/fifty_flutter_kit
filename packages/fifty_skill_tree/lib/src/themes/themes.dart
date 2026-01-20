/// Barrel export for skill tree theming.
///
/// Import this file to get access to [SkillTreeTheme] for custom theming.
/// Note: FDL (Fifty Design Language) defaults are used when no theme is provided.
///
/// ```dart
/// import 'package:fifty_skill_tree/src/themes/themes.dart';
///
/// // Option 1: Use FDL defaults (no theme needed)
/// final controller = SkillTreeController(tree: tree);
///
/// // Option 2: Use custom theme
/// final controller = SkillTreeController(
///   tree: tree,
///   theme: SkillTreeTheme(
///     lockedNodeColor: Colors.grey,
///     // ... custom colors
///   ),
/// );
/// ```
library;

export 'skill_tree_theme.dart';
