import 'dart:collection';
import 'dart:ui';

import '../models/models.dart';
import 'tree_layout.dart';

/// Horizontal alignment options for vertical tree layout.
enum TreeAlignment {
  /// Center nodes within their tier.
  center,

  /// Align nodes to the start (left) of their tier.
  start,

  /// Align nodes to the end (right) of their tier.
  end,
}

/// A vertical tree layout that positions nodes in horizontal tiers.
///
/// This layout arranges nodes top-to-bottom (or bottom-to-top) with
/// each tier containing nodes at the same depth in the tree.
///
/// **Example:**
/// ```dart
/// final layout = VerticalTreeLayout(
///   alignment: TreeAlignment.center,
///   rootAtTop: true,
/// );
/// ```
///
/// **Visual representation (rootAtTop: true):**
/// ```
///        [Root]
///       /      \
///   [Child1]  [Child2]
///      |         |
///  [Grand1]  [Grand2]
/// ```
class VerticalTreeLayout extends TreeLayout {
  /// Creates a vertical tree layout.
  ///
  /// **Parameters:**
  /// - [alignment]: How nodes are aligned horizontally within their tier.
  ///   Defaults to [TreeAlignment.center].
  /// - [rootAtTop]: If true, root nodes are at the top and tree grows downward.
  ///   If false, root nodes are at the bottom. Defaults to true.
  const VerticalTreeLayout({
    this.alignment = TreeAlignment.center,
    this.rootAtTop = true,
  });

  /// How nodes are aligned horizontally within their tier.
  final TreeAlignment alignment;

  /// Whether root nodes appear at the top of the tree.
  ///
  /// If true, the tree grows downward from roots at the top.
  /// If false, the tree grows upward from roots at the bottom.
  final bool rootAtTop;

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

    // Calculate positions
    final positions = <String, Offset>{};
    final sortedTiers = tiers.keys.toList()..sort();

    // Starting Y position
    double startY;
    if (rootAtTop) {
      startY = nodeSize.height / 2;
    } else {
      startY = availableSize.height - nodeSize.height / 2;
    }

    for (int i = 0; i < sortedTiers.length; i++) {
      final tierIndex = sortedTiers[i];
      final tierNodes = tiers[tierIndex]!;

      // Calculate Y position for this tier
      double y;
      if (rootAtTop) {
        y = startY + i * (nodeSize.height + levelSeparation);
      } else {
        y = startY - i * (nodeSize.height + levelSeparation);
      }

      // Calculate total width for this tier
      final tierWidth = tierNodes.length * nodeSize.width +
          (tierNodes.length - 1) * nodeSeparation;

      // Calculate starting X based on alignment
      double startX;
      switch (alignment) {
        case TreeAlignment.start:
          startX = nodeSize.width / 2;
        case TreeAlignment.end:
          startX = availableSize.width - tierWidth + nodeSize.width / 2;
        case TreeAlignment.center:
          startX = (availableSize.width - tierWidth) / 2 + nodeSize.width / 2;
      }

      // Position nodes in this tier
      for (int j = 0; j < tierNodes.length; j++) {
        final nodeId = tierNodes[j];
        final x = startX + j * (nodeSize.width + nodeSeparation);
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
