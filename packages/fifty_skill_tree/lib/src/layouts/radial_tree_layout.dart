import 'dart:collection';
import 'dart:math' as math;
import 'dart:ui';

import '../models/models.dart';
import 'tree_layout.dart';

/// A radial tree layout that positions nodes in concentric circles.
///
/// This layout places root nodes at the center (or specified position)
/// and arranges child nodes in rings radiating outward. Each ring
/// corresponds to a depth level in the tree.
///
/// **Example:**
/// ```dart
/// final layout = RadialTreeLayout(
///   startAngle: -pi / 2,  // Start from top
///   angleSpan: 2 * pi,    // Full circle
///   centerRadius: 0,
///   ringSpacing: 100,
/// );
/// ```
///
/// **Visual representation:**
/// ```
///        [Child3]
///           |
///  [Child2]-[Root]-[Child1]
///           |
///        [Child4]
/// ```
class RadialTreeLayout extends TreeLayout {
  /// Creates a radial tree layout.
  ///
  /// **Parameters:**
  /// - [startAngle]: Starting angle in radians (default -pi/2 for top)
  /// - [angleSpan]: Total angle span in radians (default 2*pi for full circle)
  /// - [centerRadius]: Radius of the center/root area (default 0)
  /// - [ringSpacing]: Distance between concentric rings (default 100)
  /// - [centerNodeId]: Optional ID of node to place at center (uses first root if null)
  const RadialTreeLayout({
    this.startAngle = -math.pi / 2,
    this.angleSpan = 2 * math.pi,
    this.centerRadius = 0,
    this.ringSpacing = 100,
    this.centerNodeId,
  });

  /// Starting angle in radians.
  ///
  /// Default is -pi/2 which places the first node at the top.
  final double startAngle;

  /// Total angle span in radians.
  ///
  /// Default is 2*pi for a full circle.
  /// Use pi for a half circle, pi/2 for quarter circle, etc.
  final double angleSpan;

  /// Radius of the center area.
  ///
  /// If 0, the center node is at the exact center.
  /// If > 0, there's empty space in the middle.
  final double centerRadius;

  /// Distance between concentric rings.
  final double ringSpacing;

  /// Optional ID of the node to place at the center.
  ///
  /// If null, uses the first root node found.
  final String? centerNodeId;

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

    // Use ringSpacing if levelSeparation is default, otherwise respect the parameter
    final effectiveRingSpacing =
        levelSeparation > 0 ? levelSeparation : ringSpacing;

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

    // Find root nodes
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

    // Determine center node
    String centerNode;
    if (centerNodeId != null && nodes.any((n) => n.id == centerNodeId)) {
      centerNode = centerNodeId!;
    } else if (rootNodes.isNotEmpty) {
      centerNode = rootNodes.first;
    } else {
      centerNode = nodes.first.id;
    }

    // BFS from center to assign rings (depth levels)
    final rings = <int, List<String>>{};
    final nodeRings = <String, int>{};
    final visited = <String>{};
    final queue = Queue<String>();

    queue.add(centerNode);
    nodeRings[centerNode] = 0;

    while (queue.isNotEmpty) {
      final nodeId = queue.removeFirst();
      if (visited.contains(nodeId)) continue;
      visited.add(nodeId);

      final ring = nodeRings[nodeId] ?? 0;
      rings.putIfAbsent(ring, () => []);
      rings[ring]!.add(nodeId);

      // Add children to queue
      final children = childrenMap[nodeId] ?? [];
      for (final childId in children) {
        if (!visited.contains(childId)) {
          final currentRing = nodeRings[childId];
          final newRing = ring + 1;
          if (currentRing == null || newRing > currentRing) {
            nodeRings[childId] = newRing;
          }
          queue.add(childId);
        }
      }

      // For bidirectional graphs, also check parents at same/higher level
      final parents = parentsMap[nodeId] ?? [];
      for (final parentId in parents) {
        if (!visited.contains(parentId) && !nodeRings.containsKey(parentId)) {
          nodeRings[parentId] = ring + 1;
          queue.add(parentId);
        }
      }
    }

    // Handle disconnected nodes
    for (final node in nodes) {
      if (!visited.contains(node.id)) {
        final ring = node.tier;
        rings.putIfAbsent(ring, () => []);
        rings[ring]!.add(node.id);
        nodeRings[node.id] = ring;
      }
    }

    // Calculate center of the available space
    final centerX = availableSize.width / 2;
    final centerY = availableSize.height / 2;

    // Calculate positions
    final positions = <String, Offset>{};
    final sortedRings = rings.keys.toList()..sort();

    for (final ringIndex in sortedRings) {
      final ringNodes = rings[ringIndex]!;

      if (ringIndex == 0) {
        // Center ring - place at center
        if (ringNodes.length == 1) {
          positions[ringNodes.first] = Offset(centerX, centerY);
        } else {
          // Multiple center nodes - distribute in a small circle
          _distributeNodesInRing(
            nodeIds: ringNodes,
            positions: positions,
            centerX: centerX,
            centerY: centerY,
            radius: centerRadius + nodeSize.width,
            startAngle: startAngle,
            angleSpan: angleSpan,
          );
        }
      } else {
        // Outer rings - calculate radius and distribute
        final radius =
            centerRadius + nodeSize.width / 2 + ringIndex * effectiveRingSpacing;

        _distributeNodesInRing(
          nodeIds: ringNodes,
          positions: positions,
          centerX: centerX,
          centerY: centerY,
          radius: radius,
          startAngle: startAngle,
          angleSpan: angleSpan,
        );
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

  /// Distributes nodes evenly around a ring.
  void _distributeNodesInRing({
    required List<String> nodeIds,
    required Map<String, Offset> positions,
    required double centerX,
    required double centerY,
    required double radius,
    required double startAngle,
    required double angleSpan,
  }) {
    if (nodeIds.isEmpty) return;

    final count = nodeIds.length;

    // Calculate angle step
    // For full circle, use count; for partial, use count - 1 to avoid overlap
    final isFullCircle = (angleSpan - 2 * math.pi).abs() < 0.01;
    final angleStep = isFullCircle ? angleSpan / count : angleSpan / (count - 1).clamp(1, count);

    for (int i = 0; i < count; i++) {
      final angle = startAngle + i * angleStep;

      // Convert polar to cartesian
      final x = centerX + radius * math.cos(angle);
      final y = centerY + radius * math.sin(angle);

      positions[nodeIds[i]] = Offset(x, y);
    }
  }

  @override
  bool get supportsAnimation => true;
}
