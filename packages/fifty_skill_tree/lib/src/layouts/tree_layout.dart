import 'dart:ui';

import '../models/models.dart';

/// Abstract interface for tree layout algorithms.
///
/// Layout algorithms determine how skill nodes are positioned in the
/// visual tree representation. Different layouts are suited for different
/// tree structures and visual styles.
///
/// **Example:**
/// ```dart
/// final layout = VerticalTreeLayout();
/// final positions = layout.calculatePositions(
///   nodes: tree.nodes,
///   connections: tree.connections,
///   nodeSize: Size(56, 56),
///   nodeSeparation: 24.0,
///   levelSeparation: 80.0,
///   availableSize: Size(400, 600),
/// );
/// ```
abstract class TreeLayout {
  /// Creates a new tree layout.
  const TreeLayout();

  /// Calculate positions for all nodes.
  ///
  /// Returns a map of nodeId to Offset where the Offset represents
  /// the center position of the node in the layout coordinate space.
  ///
  /// **Parameters:**
  /// - [nodes]: All nodes in the skill tree
  /// - [connections]: All connections between nodes
  /// - [nodeSize]: The size of each node widget
  /// - [nodeSeparation]: Horizontal spacing between sibling nodes
  /// - [levelSeparation]: Vertical spacing between tiers/levels
  /// - [availableSize]: The total available space for the layout
  ///
  /// **Returns:**
  /// Map of nodeId to center Offset position.
  Map<String, Offset> calculatePositions({
    required List<SkillNode> nodes,
    required List<SkillConnection> connections,
    required Size nodeSize,
    required double nodeSeparation,
    required double levelSeparation,
    required Size availableSize,
  });

  /// Whether this layout supports animation between layouts.
  ///
  /// If true, the widget can smoothly animate node positions when
  /// switching from another layout or when the tree structure changes.
  bool get supportsAnimation => true;

  /// Get the minimum size required for this layout.
  ///
  /// Calculates the minimum bounding box needed to display all nodes
  /// without overlap based on the given parameters.
  ///
  /// **Parameters:**
  /// - [nodes]: All nodes in the skill tree
  /// - [connections]: All connections between nodes
  /// - [nodeSize]: The size of each node widget
  /// - [nodeSeparation]: Horizontal spacing between sibling nodes
  /// - [levelSeparation]: Vertical spacing between tiers/levels
  ///
  /// **Returns:**
  /// The minimum Size required to display the tree.
  Size getMinimumSize({
    required List<SkillNode> nodes,
    required List<SkillConnection> connections,
    required Size nodeSize,
    required double nodeSeparation,
    required double levelSeparation,
  }) {
    // Default implementation calculates from positions
    if (nodes.isEmpty) {
      return nodeSize;
    }

    final positions = calculatePositions(
      nodes: nodes,
      connections: connections,
      nodeSize: nodeSize,
      nodeSeparation: nodeSeparation,
      levelSeparation: levelSeparation,
      availableSize: const Size(double.infinity, double.infinity),
    );

    if (positions.isEmpty) {
      return nodeSize;
    }

    double maxX = 0;
    double maxY = 0;

    for (final offset in positions.values) {
      final right = offset.dx + nodeSize.width / 2;
      final bottom = offset.dy + nodeSize.height / 2;
      if (right > maxX) maxX = right;
      if (bottom > maxY) maxY = bottom;
    }

    return Size(maxX + nodeSize.width / 2, maxY + nodeSize.height / 2);
  }
}
