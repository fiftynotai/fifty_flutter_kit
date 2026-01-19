import 'dart:ui';

import '../models/models.dart';
import 'tree_layout.dart';

/// A grid-based tree layout that positions nodes in a regular grid pattern.
///
/// This layout arranges nodes in rows (based on tier) and columns,
/// providing a clean, organized appearance suitable for skill trees
/// with many nodes.
///
/// **Example:**
/// ```dart
/// final layout = GridLayout(
///   columns: 5,
///   cellSize: Size(80, 80),
/// );
/// ```
///
/// **Visual representation:**
/// ```
/// Tier 0:  [N1] [N2] [N3] [N4] [N5]
/// Tier 1:  [N6] [N7] [N8] [N9] [N10]
/// Tier 2:  [N11] [N12] [N13] ...
/// ```
class GridLayout extends TreeLayout {
  /// Creates a grid layout.
  ///
  /// **Parameters:**
  /// - [columns]: Number of columns in the grid (default 5)
  /// - [cellSize]: Size of each grid cell (default 80x80)
  /// - [centerTiers]: Whether to center nodes within their tier row (default true)
  const GridLayout({
    this.columns = 5,
    this.cellSize = const Size(80, 80),
    this.centerTiers = true,
  });

  /// Number of columns in the grid.
  final int columns;

  /// Size of each grid cell.
  final Size cellSize;

  /// Whether to center nodes within their tier row.
  ///
  /// If true, nodes in a tier are centered horizontally.
  /// If false, nodes start from the left.
  final bool centerTiers;

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

    final positions = <String, Offset>{};

    // Group nodes by tier
    final tiers = <int, List<SkillNode>>{};
    for (final node in nodes) {
      tiers.putIfAbsent(node.tier, () => []);
      tiers[node.tier]!.add(node);
    }

    // Calculate effective cell size
    final effectiveCellWidth = cellSize.width + nodeSeparation;
    final effectiveCellHeight = cellSize.height + levelSeparation;

    // Calculate total grid width
    final totalGridWidth = columns * effectiveCellWidth - nodeSeparation;

    // Position nodes tier by tier
    final sortedTiers = tiers.keys.toList()..sort();

    for (int tierIdx = 0; tierIdx < sortedTiers.length; tierIdx++) {
      final tier = sortedTiers[tierIdx];
      final tierNodes = tiers[tier]!;

      // Calculate Y position for this tier (row)
      final y = nodeSize.height / 2 + tierIdx * effectiveCellHeight;

      // Calculate starting X based on centering preference
      double startX;
      if (centerTiers) {
        final tierWidth =
            tierNodes.length * effectiveCellWidth - nodeSeparation;
        startX = (availableSize.width - tierWidth) / 2 + nodeSize.width / 2;
      } else {
        final gridStartX = (availableSize.width - totalGridWidth) / 2;
        startX = gridStartX + nodeSize.width / 2;
      }

      // Position each node in the tier
      for (int colIdx = 0; colIdx < tierNodes.length; colIdx++) {
        final node = tierNodes[colIdx];

        // Check if node has explicit position
        if (node.position != null) {
          positions[node.id] = node.position!;
        } else {
          final x = startX + colIdx * effectiveCellWidth;
          positions[node.id] = Offset(x, y);
        }
      }
    }

    return positions;
  }

  @override
  bool get supportsAnimation => true;

  @override
  Size getMinimumSize({
    required List<SkillNode> nodes,
    required List<SkillConnection> connections,
    required Size nodeSize,
    required double nodeSeparation,
    required double levelSeparation,
  }) {
    if (nodes.isEmpty) {
      return nodeSize;
    }

    // Find number of tiers
    final tiers = <int>{};
    int maxNodesInTier = 0;

    final tierCounts = <int, int>{};
    for (final node in nodes) {
      tiers.add(node.tier);
      tierCounts[node.tier] = (tierCounts[node.tier] ?? 0) + 1;
    }

    for (final count in tierCounts.values) {
      if (count > maxNodesInTier) {
        maxNodesInTier = count;
      }
    }

    final numTiers = tiers.length;

    final effectiveCellWidth = cellSize.width + nodeSeparation;
    final effectiveCellHeight = cellSize.height + levelSeparation;

    final width = maxNodesInTier * effectiveCellWidth + nodeSize.width;
    final height = numTiers * effectiveCellHeight + nodeSize.height;

    return Size(width, height);
  }
}
