import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/rendering.dart';

import '../models/models.dart';
import '../themes/skill_tree_theme.dart';
import 'bezier_painter.dart';
import 'line_painter.dart';

/// Base CustomPainter for drawing all connections in a skill tree.
///
/// This painter iterates through all connections and delegates the actual
/// drawing to either [LinePainter] or [BezierPainter] based on the
/// [useCurvedConnections] setting.
///
/// **Theming:**
/// - If [theme] is null, FDL (Fifty Design Language) defaults are used
/// - If [theme] is provided, custom theme colors are used
///
/// **Example:**
/// ```dart
/// CustomPaint(
///   painter: ConnectionPainter(
///     connections: tree.connections,
///     nodePositions: positions,
///     nodeSize: Size(56, 56),
///     theme: null, // FDL defaults
///     getNodeState: (id) => tree.getNodeState(id),
///     useCurvedConnections: true,
///   ),
/// )
/// ```
class ConnectionPainter extends CustomPainter {
  /// Creates a connection painter.
  ///
  /// **Parameters:**
  /// - [connections]: All connections to draw
  /// - [nodePositions]: Map of node IDs to their center positions
  /// - [nodeSize]: The size of each node (used to calculate edge points)
  /// - [theme]: Optional custom theme. If null, FDL defaults are used.
  /// - [getNodeState]: Function to get the current state of a node
  /// - [useCurvedConnections]: Whether to use bezier curves (true) or straight lines (false)
  /// - [highlightedConnectionIds]: Optional set of connection IDs to highlight
  ConnectionPainter({
    required this.connections,
    required this.nodePositions,
    required this.nodeSize,
    this.theme,
    required this.getNodeState,
    this.useCurvedConnections = true,
    this.highlightedConnectionIds,
  });

  /// All connections to draw.
  final List<SkillConnection> connections;

  /// Map of node IDs to their center positions.
  final Map<String, Offset> nodePositions;

  /// The size of each node widget.
  final Size nodeSize;

  /// Optional custom theme. If null, FDL defaults are used.
  final SkillTreeTheme? theme;

  /// Function to get the current state of a node by ID.
  final SkillState Function(String nodeId) getNodeState;

  /// Whether to use curved bezier connections.
  final bool useCurvedConnections;

  /// Optional set of connection IDs to highlight.
  ///
  /// Connection IDs are formatted as "fromId->toId".
  final Set<String>? highlightedConnectionIds;

  // ---- FDL Default Colors ----

  /// FDL default color for locked connections.
  static Color get _fdlLockedColor => FiftyColors.borderDark;

  /// FDL default color for unlocked connections.
  static Color get _fdlUnlockedColor => FiftyColors.success;

  /// FDL default color for highlighted connections.
  static Color get _fdlHighlightColor => FiftyColors.primary;

  @override
  void paint(Canvas canvas, Size size) {
    // Get colors from theme or use FDL defaults
    final lockedColor = theme?.connectionLockedColor ?? _fdlLockedColor;
    final unlockedColor = theme?.connectionUnlockedColor ?? _fdlUnlockedColor;
    final highlightColor = theme?.connectionHighlightColor ?? _fdlHighlightColor;
    final connectionWidth = theme?.connectionWidth ?? 2.0;

    for (final connection in connections) {
      final fromPos = nodePositions[connection.fromId];
      final toPos = nodePositions[connection.toId];

      if (fromPos == null || toPos == null) continue;

      // Determine connection color based on node states
      final fromState = getNodeState(connection.fromId);
      final toState = getNodeState(connection.toId);

      Color connectionColor;
      if (connection.color != null) {
        connectionColor = connection.color!;
      } else if (fromState == SkillState.unlocked ||
          fromState == SkillState.maxed) {
        if (toState == SkillState.unlocked || toState == SkillState.maxed) {
          connectionColor = unlockedColor;
        } else {
          connectionColor = unlockedColor.withAlpha(128);
        }
      } else {
        connectionColor = lockedColor;
      }

      // Check if this connection should be highlighted
      final connectionId = '${connection.fromId}->${connection.toId}';
      final isHighlighted = highlightedConnectionIds?.contains(connectionId) ?? false;
      if (isHighlighted) {
        connectionColor = highlightColor;
      }

      final thickness = connection.thickness ?? connectionWidth;

      // Calculate edge points (from node edge, not center)
      final edgePoints = _calculateEdgePoints(fromPos, toPos, nodeSize);

      if (useCurvedConnections) {
        final bezierPainter = BezierPainter(
          from: edgePoints.$1,
          to: edgePoints.$2,
          color: connectionColor,
          thickness: thickness,
          style: connection.style,
        );
        bezierPainter.paint(canvas, size);
      } else {
        final linePainter = LinePainter(
          from: edgePoints.$1,
          to: edgePoints.$2,
          color: connectionColor,
          thickness: thickness,
          style: connection.style,
        );
        linePainter.paint(canvas, size);
      }
    }
  }

  /// Calculates the edge points of the connection line.
  ///
  /// Instead of drawing from center to center, this calculates
  /// points on the edge of the node circles.
  (Offset, Offset) _calculateEdgePoints(
    Offset from,
    Offset to,
    Size nodeSize,
  ) {
    final radius = nodeSize.width / 2;
    final direction = (to - from);
    final distance = direction.distance;

    if (distance == 0) {
      return (from, to);
    }

    final normalized = direction / distance;

    final fromEdge = from + normalized * radius;
    final toEdge = to - normalized * radius;

    return (fromEdge, toEdge);
  }

  @override
  bool shouldRepaint(ConnectionPainter oldDelegate) {
    return connections != oldDelegate.connections ||
        nodePositions != oldDelegate.nodePositions ||
        nodeSize != oldDelegate.nodeSize ||
        theme != oldDelegate.theme ||
        useCurvedConnections != oldDelegate.useCurvedConnections ||
        highlightedConnectionIds != oldDelegate.highlightedConnectionIds;
  }
}
