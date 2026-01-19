import 'dart:collection';
import 'dart:ui';

import '../models/models.dart';
import 'tree_layout.dart';
import 'vertical_tree_layout.dart';

/// A horizontal tree layout that positions nodes in vertical tiers.
///
/// This layout arranges nodes left-to-right (or right-to-left) with
/// each tier containing nodes at the same depth in the tree.
/// Essentially a 90-degree rotation of [VerticalTreeLayout].
///
/// **Example:**
/// ```dart
/// final layout = HorizontalTreeLayout(
///   alignment: TreeAlignment.center,
///   leftToRight: true,
/// );
/// ```
///
/// **Visual representation (leftToRight: true):**
/// ```
///   [Root] --- [Child1] --- [Grand1]
///          \
///           -- [Child2] --- [Grand2]
/// ```
class HorizontalTreeLayout extends TreeLayout {
  /// Creates a horizontal tree layout.
  ///
  /// **Parameters:**
  /// - [alignment]: How nodes are aligned vertically within their tier.
  ///   Defaults to [TreeAlignment.center].
  /// - [leftToRight]: If true, root nodes are on the left and tree grows rightward.
  ///   If false, root nodes are on the right. Defaults to true.
  const HorizontalTreeLayout({
    this.alignment = TreeAlignment.center,
    this.leftToRight = true,
  });

  /// How nodes are aligned vertically within their tier.
  final TreeAlignment alignment;

  /// Whether root nodes appear on the left side of the tree.
  ///
  /// If true, the tree grows rightward from roots on the left.
  /// If false, the tree grows leftward from roots on the right.
  final bool leftToRight;

  @override
  Map<String, Offset> calculatePositions({
    required List<SkillNode> nodes,
    required List<SkillConnection> connections,
    required Size nodeSize,
    required double nodeSeparation,
    required double levelSeparation,
    required Size availableSize,
  }) {
    if (nodes.isEmpty) {
      return {};
    }

    // Build adjacency map for quick lookup
    final childrenMap = <String, List<String>>{};
    final parentsMap = <String, List<String>>{};

    for (final node in nodes) {
      childrenMap[node.id] = [];
      parentsMap[node.id] = [];
    }

    // Build parent-child relationships from connections
    for (final connection in connections) {
      if (connection.type == ConnectionType.required ||
          connection.type == ConnectionType.optional) {
        childrenMap[connection.fromId]?.add(connection.toId);
        parentsMap[connection.toId]?.add(connection.fromId);
      }
    }

    // Also consider prerequisites as parent relationships
    for (final node in nodes) {
      for (final prereqId in node.prerequisites) {
        if (!parentsMap[node.id]!.contains(prereqId)) {
          parentsMap[node.id]!.add(prereqId);
        }
        if (!childrenMap[prereqId]!.contains(node.id)) {
          childrenMap[prereqId]?.add(node.id);
        }
      }
    }

    // Find root nodes (nodes with no incoming required connections)
    final rootNodes = <String>[];
    for (final node in nodes) {
      final hasParent = parentsMap[node.id]?.isNotEmpty ?? false;
      if (!hasParent) {
        rootNodes.add(node.id);
      }
    }

    // If no roots found, use nodes with lowest tier value
    if (rootNodes.isEmpty) {
      final minTier = nodes.map((n) => n.tier).reduce((a, b) => a < b ? a : b);
      rootNodes.addAll(nodes.where((n) => n.tier == minTier).map((n) => n.id));
    }

    // Build tier structure via BFS from roots
    final tiers = <int, List<String>>{};
    final nodeTiers = <String, int>{};
    final visited = <String>{};
    final queue = Queue<String>();

    for (final rootId in rootNodes) {
      queue.add(rootId);
      nodeTiers[rootId] = 0;
    }

    while (queue.isNotEmpty) {
      final nodeId = queue.removeFirst();
      if (visited.contains(nodeId)) continue;
      visited.add(nodeId);

      final tier = nodeTiers[nodeId] ?? 0;
      tiers.putIfAbsent(tier, () => []);
      tiers[tier]!.add(nodeId);

      final children = childrenMap[nodeId] ?? [];
      for (final childId in children) {
        if (!visited.contains(childId)) {
          final currentTier = nodeTiers[childId];
          final newTier = tier + 1;
          if (currentTier == null || newTier > currentTier) {
            nodeTiers[childId] = newTier;
          }
          queue.add(childId);
        }
      }
    }

    // Handle any unvisited nodes (disconnected components)
    for (final node in nodes) {
      if (!visited.contains(node.id)) {
        final tier = node.tier;
        tiers.putIfAbsent(tier, () => []);
        tiers[tier]!.add(node.id);
        nodeTiers[node.id] = tier;
      }
    }

    // Calculate positions (rotated 90 degrees from vertical)
    final positions = <String, Offset>{};
    final sortedTiers = tiers.keys.toList()..sort();

    // Starting X position (horizontal is now tier axis)
    double startX;
    if (leftToRight) {
      startX = nodeSize.width / 2;
    } else {
      startX = availableSize.width - nodeSize.width / 2;
    }

    for (int i = 0; i < sortedTiers.length; i++) {
      final tierIndex = sortedTiers[i];
      final tierNodes = tiers[tierIndex]!;

      // Calculate X position for this tier (horizontal movement)
      double x;
      if (leftToRight) {
        x = startX + i * (nodeSize.width + levelSeparation);
      } else {
        x = startX - i * (nodeSize.width + levelSeparation);
      }

      // Calculate total height for this tier
      final tierHeight = tierNodes.length * nodeSize.height +
          (tierNodes.length - 1) * nodeSeparation;

      // Calculate starting Y based on alignment
      double startY;
      switch (alignment) {
        case TreeAlignment.start:
          startY = nodeSize.height / 2;
        case TreeAlignment.end:
          startY = availableSize.height - tierHeight + nodeSize.height / 2;
        case TreeAlignment.center:
          startY = (availableSize.height - tierHeight) / 2 + nodeSize.height / 2;
      }

      // Position nodes in this tier
      for (int j = 0; j < tierNodes.length; j++) {
        final nodeId = tierNodes[j];
        final y = startY + j * (nodeSize.height + nodeSeparation);
        positions[nodeId] = Offset(x, y);
      }
    }

    // If any nodes have explicit positions, use those instead
    for (final node in nodes) {
      if (node.position != null) {
        positions[node.id] = node.position!;
      }
    }

    return positions;
  }

  @override
  bool get supportsAnimation => true;
}
