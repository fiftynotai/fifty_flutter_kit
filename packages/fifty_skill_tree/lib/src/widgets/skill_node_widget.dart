import 'package:flutter/material.dart';

import '../models/models.dart';
import '../themes/skill_tree_theme.dart';

/// A widget that renders a single skill node.
///
/// Displays the node with appropriate styling based on its state,
/// including background color, border, icon, and level badge.
///
/// **Example:**
/// ```dart
/// SkillNodeWidget(
///   node: myNode,
///   state: SkillState.available,
///   theme: theme,
///   onTap: () => controller.unlock(myNode.id),
///   onLongPress: () => showNodeDetails(myNode),
/// )
/// ```
class SkillNodeWidget<T> extends StatelessWidget {
  /// Creates a skill node widget.
  ///
  /// **Parameters:**
  /// - [node]: The skill node to display
  /// - [state]: Current state of the node (affects visuals)
  /// - [theme]: Theme containing colors and styles
  /// - [size]: Size of the node widget (defaults to 56x56)
  /// - [onTap]: Callback when node is tapped
  /// - [onLongPress]: Callback when node is long-pressed
  /// - [selected]: Whether this node is selected
  /// - [hovered]: Whether this node is being hovered
  const SkillNodeWidget({
    super.key,
    required this.node,
    required this.state,
    required this.theme,
    this.size = const Size(56, 56),
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.hovered = false,
  });

  /// The skill node to display.
  final SkillNode<T> node;

  /// Current state of the node.
  final SkillState state;

  /// Theme containing colors and styles.
  final SkillTreeTheme theme;

  /// Size of the node widget.
  final Size size;

  /// Callback when node is tapped.
  final VoidCallback? onTap;

  /// Callback when node is long-pressed.
  final VoidCallback? onLongPress;

  /// Whether this node is selected.
  final bool selected;

  /// Whether this node is being hovered.
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final borderColor = _getBorderColor();

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: MouseRegion(
        cursor: _getCursor(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor,
            border: Border.all(
              color: borderColor,
              width: theme.nodeBorderWidth,
            ),
            boxShadow: _buildShadows(),
          ),
          child: Stack(
            children: [
              // Icon in center
              Center(
                child: _buildIcon(),
              ),
              // Level badge (bottom right)
              if (node.maxLevel > 1) _buildLevelBadge(),
            ],
          ),
        ),
      ),
    );
  }

  /// Gets the background color based on state.
  Color _getBackgroundColor() {
    switch (state) {
      case SkillState.locked:
        return theme.lockedNodeColor;
      case SkillState.available:
        return theme.availableNodeColor;
      case SkillState.unlocked:
        return theme.unlockedNodeColor;
      case SkillState.maxed:
        return theme.maxedNodeColor;
    }
  }

  /// Gets the border color based on state.
  Color _getBorderColor() {
    switch (state) {
      case SkillState.locked:
        return theme.lockedNodeBorderColor;
      case SkillState.available:
        return theme.availableNodeBorderColor;
      case SkillState.unlocked:
        return theme.unlockedNodeBorderColor;
      case SkillState.maxed:
        return theme.maxedNodeBorderColor;
    }
  }

  /// Gets the cursor based on state.
  MouseCursor _getCursor() {
    if (state == SkillState.available ||
        (state == SkillState.unlocked && !node.isMaxed)) {
      return SystemMouseCursors.click;
    }
    return SystemMouseCursors.basic;
  }

  /// Builds the shadow list based on selection/hover state.
  List<BoxShadow>? _buildShadows() {
    final shadows = <BoxShadow>[];

    // Selection glow
    if (selected) {
      shadows.add(BoxShadow(
        color: _getBorderColor().withAlpha(128),
        blurRadius: 12,
        spreadRadius: 2,
      ));
    }

    // Hover glow
    if (hovered && !selected) {
      shadows.add(BoxShadow(
        color: _getBorderColor().withAlpha(64),
        blurRadius: 8,
        spreadRadius: 1,
      ));
    }

    // Available state pulse (subtle glow)
    if (state == SkillState.available && !selected && !hovered) {
      shadows.add(BoxShadow(
        color: theme.availableNodeBorderColor.withAlpha(48),
        blurRadius: 6,
        spreadRadius: 0,
      ));
    }

    return shadows.isEmpty ? null : shadows;
  }

  /// Builds the icon widget.
  Widget _buildIcon() {
    // Icon opacity based on state
    final opacity = state == SkillState.locked ? 0.5 : 1.0;

    if (node.icon != null) {
      return Opacity(
        opacity: opacity,
        child: Icon(
          node.icon,
          color: _getIconColor(),
          size: size.width * 0.5,
        ),
      );
    }

    // Placeholder icon if none provided
    return Opacity(
      opacity: opacity,
      child: Icon(
        _getDefaultIcon(),
        color: _getIconColor(),
        size: size.width * 0.4,
      ),
    );
  }

  /// Gets the icon color based on node type.
  Color _getIconColor() {
    switch (node.type) {
      case SkillType.passive:
        return theme.passiveColor;
      case SkillType.active:
        return theme.activeColor;
      case SkillType.ultimate:
        return theme.ultimateColor;
      case SkillType.keystone:
        return theme.keystoneColor;
      case SkillType.minor:
        return theme.passiveColor.withAlpha(179);
    }
  }

  /// Gets a default icon based on node type.
  IconData _getDefaultIcon() {
    switch (node.type) {
      case SkillType.passive:
        return Icons.shield_outlined;
      case SkillType.active:
        return Icons.flash_on_outlined;
      case SkillType.ultimate:
        return Icons.star_outline;
      case SkillType.keystone:
        return Icons.vpn_key_outlined;
      case SkillType.minor:
        return Icons.circle_outlined;
    }
  }

  /// Builds the level badge for multi-level skills.
  Widget _buildLevelBadge() {
    final levelText = '${node.currentLevel}/${node.maxLevel}';

    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF000000).withAlpha(179),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _getBorderColor(),
            width: 1,
          ),
        ),
        child: Text(
          levelText,
          style: theme.nodeLevelStyle,
        ),
      ),
    );
  }
}
