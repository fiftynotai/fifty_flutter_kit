import 'dart:ui';

import '../models/models.dart';
import 'tree_layout.dart';

/// A custom layout that uses explicitly defined node positions.
///
/// This layout simply reads the [SkillNode.position] property for each node.
/// If a node doesn't have an explicit position, it falls back to (0, 0).
///
/// This is useful for designers who want full control over node placement
/// or for importing layouts from external tools.
///
/// **Example:**
/// ```dart
/// final layout = CustomLayout();
///
/// // Nodes should have positions set:
/// final node = SkillNode(
///   id: 'fireball',
///   name: 'Fireball',
///   position: Offset(100, 200),
/// );
/// ```
///
/// **Usage with designer tools:**
/// ```dart
/// // Load positions from JSON exported from a design tool
/// final layoutData = loadLayoutFromJson();
/// for (final entry in layoutData.entries) {
///   final node = tree.getNode(entry.key);
///   if (node != null) {
///     tree.addNode(node.copyWith(position: entry.value));
///   }
/// }
///
/// // Use custom layout to respect those positions
/// SkillTreeView(
///   controller: controller,
///   layout: CustomLayout(),
/// )
/// ```
class CustomLayout extends TreeLayout {
  /// Creates a custom layout.
  ///
  /// **Parameters:**
  /// - [fallbackPosition]: Position to use for nodes without explicit positions.
  ///   Defaults to (0, 0).
  /// - [scaleToFit]: Whether to scale positions to fit the available size.
  ///   Defaults to false.
  const CustomLayout({
    this.fallbackPosition = Offset.zero,
    this.scaleToFit = false,
  });

  /// Position to use for nodes without explicit positions.
  final Offset fallbackPosition;

  /// Whether to scale positions to fit the available size.
  ///
  /// If true, positions are normalized to fit within the available space.
  /// If false, positions are used as-is.
  final bool scaleToFit;

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

    // First pass: collect all positions
    for (final node in nodes) {
      positions[node.id] = node.position ?? fallbackPosition;
    }

    // If scale to fit is enabled, normalize positions
    if (scaleToFit && positions.isNotEmpty) {
      _scalePositionsToFit(
        positions: positions,
        nodeSize: nodeSize,
        availableSize: availableSize,
      );
    }

    return positions;
  }

  /// Scales positions to fit within the available size.
  void _scalePositionsToFit({
    required Map<String, Offset> positions,
    required Size nodeSize,
    required Size availableSize,
  }) {
    if (positions.isEmpty) return;

    // Find bounds of current positions
    double minX = double.infinity;
    double maxX = double.negativeInfinity;
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (final pos in positions.values) {
      if (pos.dx < minX) minX = pos.dx;
      if (pos.dx > maxX) maxX = pos.dx;
      if (pos.dy < minY) minY = pos.dy;
      if (pos.dy > maxY) maxY = pos.dy;
    }

    // Calculate current size
    final currentWidth = maxX - minX;
    final currentHeight = maxY - minY;

    // If all nodes at same position, no scaling needed
    if (currentWidth == 0 && currentHeight == 0) {
      // Center the single point
      final centerX = availableSize.width / 2;
      final centerY = availableSize.height / 2;

      for (final nodeId in positions.keys.toList()) {
        positions[nodeId] = Offset(centerX, centerY);
      }
      return;
    }

    // Calculate available space (accounting for node size)
    final availableWidth = availableSize.width - nodeSize.width;
    final availableHeight = availableSize.height - nodeSize.height;

    // Calculate scale factors
    final scaleX = currentWidth > 0 ? availableWidth / currentWidth : 1.0;
    final scaleY = currentHeight > 0 ? availableHeight / currentHeight : 1.0;

    // Use uniform scaling to maintain proportions
    final scale = scaleX < scaleY ? scaleX : scaleY;

    // Calculate offset to center the scaled positions
    final scaledWidth = currentWidth * scale;
    final scaledHeight = currentHeight * scale;
    final offsetX = (availableSize.width - scaledWidth) / 2;
    final offsetY = (availableSize.height - scaledHeight) / 2;

    // Apply transformation
    for (final nodeId in positions.keys.toList()) {
      final pos = positions[nodeId]!;
      final scaledX = (pos.dx - minX) * scale + offsetX;
      final scaledY = (pos.dy - minY) * scale + offsetY;
      positions[nodeId] = Offset(scaledX, scaledY);
    }
  }

  @override
  bool get supportsAnimation => true;
}
