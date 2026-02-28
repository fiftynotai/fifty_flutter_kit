import 'package:flutter/material.dart';

import '../layouts/layouts.dart';
import '../models/models.dart';
import '../painters/painters.dart';
import '../themes/skill_tree_theme.dart';
import 'skill_node_widget.dart';
import 'skill_tree_controller.dart';

/// A widget that displays an interactive skill tree.
///
/// The [SkillTreeView] renders nodes using the provided layout algorithm,
/// draws connections between them, and handles user interactions like
/// tapping, panning, and zooming.
///
/// **Example:**
/// ```dart
/// SkillTreeView(
///   controller: myController,
///   layout: VerticalTreeLayout(),
///   onNodeTap: (node) => controller.unlock(node.id),
///   onNodeLongPress: (node) => showNodeDetails(node),
/// )
/// ```
class SkillTreeView<T> extends StatefulWidget {
  /// Creates a skill tree view.
  ///
  /// **Parameters:**
  /// - [controller]: Controller managing tree state
  /// - [layout]: Layout algorithm for positioning nodes
  /// - [width]: Optional fixed width (uses available space if null)
  /// - [height]: Optional fixed height (uses available space if null)
  /// - [padding]: Padding around the tree content
  /// - [nodeBuilder]: Custom builder for node widgets
  /// - [nodeSize]: Size of each node widget
  /// - [nodeSeparation]: Horizontal spacing between sibling nodes
  /// - [levelSeparation]: Vertical spacing between tiers
  /// - [connectionBuilder]: Custom builder for connection painters
  /// - [connectionStyle]: Default style for connections
  /// - [connectionCurved]: Whether to use bezier curves for connections
  /// - [onNodeTap]: Callback when a node is tapped
  /// - [onNodeLongPress]: Callback when a node is long-pressed
  /// - [enablePan]: Whether panning is enabled
  /// - [enableZoom]: Whether zooming is enabled
  /// - [minZoom]: Minimum zoom level
  /// - [maxZoom]: Maximum zoom level
  /// - [initialZoom]: Initial zoom level
  const SkillTreeView({
    super.key,
    required this.controller,
    this.layout = const VerticalTreeLayout(),
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.nodeBuilder,
    this.nodeSize = const Size(56, 56),
    this.nodeSeparation = 24.0,
    this.levelSeparation = 80.0,
    this.connectionBuilder,
    this.connectionStyle = ConnectionStyle.solid,
    this.connectionCurved = true,
    this.onNodeTap,
    this.onNodeLongPress,
    this.enablePan = true,
    this.enableZoom = true,
    this.minZoom = 0.5,
    this.maxZoom = 2.0,
    this.initialZoom = 1.0,
  });

  /// Controller managing tree state.
  final SkillTreeController<T> controller;

  /// Layout algorithm for positioning nodes.
  final TreeLayout layout;

  /// Optional fixed width.
  final double? width;

  /// Optional fixed height.
  final double? height;

  /// Padding around the tree content.
  final EdgeInsets padding;

  /// Custom builder for node widgets.
  ///
  /// If null, uses [SkillNodeWidget] with default styling.
  final Widget Function(SkillNode<T> node, SkillState state)? nodeBuilder;

  /// Size of each node widget.
  final Size nodeSize;

  /// Horizontal spacing between sibling nodes.
  final double nodeSeparation;

  /// Vertical spacing between tiers.
  final double levelSeparation;

  /// Custom builder for connection painters.
  ///
  /// If null, uses [ConnectionPainter] with default styling.
  final CustomPainter Function(SkillConnection connection)? connectionBuilder;

  /// Default style for connections.
  final ConnectionStyle connectionStyle;

  /// Whether to use bezier curves for connections.
  final bool connectionCurved;

  /// Callback when a node is tapped.
  final void Function(SkillNode<T> node)? onNodeTap;

  /// Callback when a node is long-pressed.
  final void Function(SkillNode<T> node)? onNodeLongPress;

  /// Whether panning is enabled.
  final bool enablePan;

  /// Whether zooming is enabled.
  final bool enableZoom;

  /// Minimum zoom level.
  final double minZoom;

  /// Maximum zoom level.
  final double maxZoom;

  /// Initial zoom level.
  final double initialZoom;

  @override
  State<SkillTreeView<T>> createState() => _SkillTreeViewState<T>();
}

class _SkillTreeViewState<T> extends State<SkillTreeView<T>> {
  late TransformationController _transformController;
  Map<String, Offset> _nodePositions = {};
  String? _hoveredNodeId;

  @override
  void initState() {
    super.initState();
    _transformController = TransformationController();
    _initializeTransform();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _transformController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SkillTreeView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  void _initializeTransform() {
    final matrix = Matrix4.identity()
      ..setEntry(0, 0, widget.initialZoom)
      ..setEntry(1, 1, widget.initialZoom)
      ..setEntry(2, 2, widget.initialZoom);
    _transformController.value = matrix;
  }

  void _onControllerChanged() {
    setState(() {});
  }

  void _calculateLayout(Size availableSize) {
    _nodePositions = widget.layout.calculatePositions(
      nodes: widget.controller.nodes.cast<SkillNode>(),
      connections: widget.controller.connections,
      nodeSize: widget.nodeSize,
      nodeSeparation: widget.nodeSeparation,
      levelSeparation: widget.levelSeparation,
      availableSize: Size(
        availableSize.width - widget.padding.horizontal,
        availableSize.height - widget.padding.vertical,
      ),
    );
  }

  void _handleNodeTap(SkillNode<T> node) {
    widget.controller.selectNode(node.id);
    widget.onNodeTap?.call(node);
  }

  void _handleNodeLongPress(SkillNode<T> node) {
    widget.onNodeLongPress?.call(node);
  }

  void _handleNodeHover(String? nodeId) {
    if (_hoveredNodeId != nodeId) {
      setState(() {
        _hoveredNodeId = nodeId;
      });
      widget.controller.hoverNode(nodeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableSize = Size(
          widget.width ?? constraints.maxWidth,
          widget.height ?? constraints.maxHeight,
        );

        _calculateLayout(availableSize);

        // Resolve theme from context if controller doesn't have one
        final resolvedTheme = widget.controller.theme ??
            SkillTreeTheme.fromContext(context);

        return SizedBox(
          width: availableSize.width,
          height: availableSize.height,
          child: InteractiveViewer(
            transformationController: _transformController,
            panEnabled: widget.enablePan,
            scaleEnabled: widget.enableZoom,
            minScale: widget.minZoom,
            maxScale: widget.maxZoom,
            boundaryMargin: const EdgeInsets.all(100),
            child: Padding(
              padding: widget.padding,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Connections (behind nodes)
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ConnectionPainter(
                        connections: widget.controller.connections,
                        nodePositions: _nodePositions,
                        nodeSize: widget.nodeSize,
                        theme: resolvedTheme,
                        getNodeState: widget.controller.getNodeState,
                        useCurvedConnections: widget.connectionCurved,
                      ),
                    ),
                  ),
                  // Nodes
                  ..._buildNodeWidgets(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildNodeWidgets() {
    final widgets = <Widget>[];

    for (final node in widget.controller.nodes) {
      final position = _nodePositions[node.id];
      if (position == null) continue;

      final state = widget.controller.getNodeState(node.id);
      final isSelected = widget.controller.selectedNodeId == node.id;
      final isHovered = _hoveredNodeId == node.id;

      // Calculate top-left position from center
      final topLeft = Offset(
        position.dx - widget.nodeSize.width / 2,
        position.dy - widget.nodeSize.height / 2,
      );

      Widget nodeWidget;

      if (widget.nodeBuilder != null) {
        nodeWidget = widget.nodeBuilder!(node, state);
      } else {
        nodeWidget = SkillNodeWidget<T>(
          node: node,
          state: state,
          theme: widget.controller.theme,
          size: widget.nodeSize,
          onTap: () => _handleNodeTap(node),
          onLongPress: () => _handleNodeLongPress(node),
          selected: isSelected,
          hovered: isHovered,
        );
      }

      widgets.add(
        Positioned(
          left: topLeft.dx,
          top: topLeft.dy,
          child: MouseRegion(
            onEnter: (_) => _handleNodeHover(node.id),
            onExit: (_) => _handleNodeHover(null),
            child: nodeWidget,
          ),
        ),
      );
    }

    return widgets;
  }
}
