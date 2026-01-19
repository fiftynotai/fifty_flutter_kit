/// Interactive skill tree widget for Flutter games.
///
/// This library provides a customizable, animated, and game-ready skill tree
/// widget system for Flutter applications.
///
/// ## Features
///
/// - **Flexible Node System**: Generic `SkillNode<T>` for custom game data
/// - **Prerequisite Logic**: Automatic unlocking based on dependencies
/// - **Point Management**: Built-in point spending and refund system
/// - **Multiple Layout Options**: Vertical, horizontal, radial, and custom
/// - **Serialization**: Save/load progress with JSON support
/// - **Theming**: Customizable visual appearance
///
/// ## Quick Start
///
/// ```dart
/// import 'package:fifty_skill_tree/fifty_skill_tree.dart';
///
/// // Create a skill tree
/// final tree = SkillTree<void>(
///   id: 'warrior',
///   name: 'Warrior Skills',
/// );
///
/// // Add nodes
/// tree.addNode(SkillNode(id: 'slash', name: 'Slash'));
/// tree.addNode(SkillNode(
///   id: 'power_slash',
///   name: 'Power Slash',
///   prerequisites: ['slash'],
/// ));
///
/// // Add connection
/// tree.addConnection(SkillConnection(
///   fromId: 'slash',
///   toId: 'power_slash',
/// ));
///
/// // Add points and unlock
/// tree.addPoints(5);
/// final result = tree.unlock('slash');
/// if (result.success) {
///   print('Unlocked ${result.node?.name}!');
/// }
/// ```
///
/// ## Displaying the Tree
///
/// ```dart
/// // Create a controller
/// final controller = SkillTreeController(
///   tree: myTree,
///   theme: SkillTreeTheme.dark(),
/// );
///
/// // Build the widget
/// SkillTreeView(
///   controller: controller,
///   layout: VerticalTreeLayout(),
///   onNodeTap: (node) => controller.unlock(node.id),
/// )
/// ```
///
/// ## Serialization
///
/// ```dart
/// // Export full tree
/// final json = tree.toJson();
///
/// // Export only progress (for save games)
/// final progress = tree.exportProgress();
///
/// // Import progress
/// tree.importProgress(savedProgress);
/// ```
library;

export 'src/animations/animations.dart';
export 'src/layouts/layouts.dart';
export 'src/models/models.dart';
export 'src/painters/painters.dart';
export 'src/serialization/serialization.dart';
export 'src/themes/themes.dart';
export 'src/widgets/widgets.dart';
