import 'package:flutter/material.dart';

import '../models/models.dart';
import '../themes/skill_tree_theme.dart';

/// A widget that renders a single skill node.
///
/// Displays the node with appropriate styling based on its state,
/// including background color, border, icon, and level badge.
///
/// **Theming:**
/// - If [theme] is null, FDL (Fifty Design Language) defaults are used
/// - If [theme] is provided, custom theme colors are used
///
/// **Example:**
/// ```dart
/// // Using FDL defaults
/// SkillNodeWidget(
///   node: myNode,
///   state: SkillState.available,
///   theme: null, // FDL defaults
///   onTap: () => controller.unlock(myNode.id),
/// )
///
/// // Using custom theme
/// SkillNodeWidget(
///   node: myNode,
///   state: SkillState.available,
///   theme: customTheme,
///   onTap: () => controller.unlock(myNode.id),
/// )
/// ```
class SkillNodeWidget<T> extends StatelessWidget {
  /// Creates a skill node widget.
  ///
  /// **Parameters:**
  /// - [node]: The skill node to display
  /// - [state]: Current state of the node (affects visuals)
  /// - [theme]: Optional custom theme. If null, FDL defaults are used.
  /// - [size]: Size of the node widget (defaults to 56x56)
  /// - [onTap]: Callback when node is tapped
  /// - [onLongPress]: Callback when node is long-pressed
  /// - [selected]: Whether this node is selected
  /// - [hovered]: Whether this node is being hovered
  const SkillNodeWidget({
    super.key,
    required this.node,
    required this.state,
    this.theme,
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

  /// Optional custom theme. If null, FDL defaults are used.
  final SkillTreeTheme? theme;

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

  /// Resolves the theme to use for this widget.
  ///
  /// Returns the explicitly provided [theme] if non-null, otherwise
  /// derives one from the current [BuildContext] via
  /// [SkillTreeTheme.fromContext].
  SkillTreeTheme _resolveTheme(BuildContext context) {
    return theme ?? SkillTreeTheme.fromContext(context);
  }

  @override
  Widget build(BuildContext context) {
    final resolvedTheme = _resolveTheme(context);
    final backgroundColor = _getBackgroundColor(resolvedTheme);
    final borderColor = _getBorderColor(resolvedTheme);
    final borderWidth = resolvedTheme.nodeBorderWidth;

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
              width: borderWidth,
            ),
            boxShadow: _buildShadows(resolvedTheme),
          ),
          child: Stack(
            children: [
              // Icon in center
              Center(
                child: _buildIcon(resolvedTheme),
              ),
              // Level badge (bottom right)
              if (node.maxLevel > 1) _buildLevelBadge(resolvedTheme),
            ],
          ),
        ),
      ),
    );
  }

  /// Gets the background color based on state from the resolved theme.
  Color _getBackgroundColor(SkillTreeTheme resolvedTheme) {
    switch (state) {
      case SkillState.locked:
        return resolvedTheme.lockedNodeColor;
      case SkillState.available:
        return resolvedTheme.availableNodeColor;
      case SkillState.unlocked:
        return resolvedTheme.unlockedNodeColor;
      case SkillState.maxed:
        return resolvedTheme.maxedNodeColor;
    }
  }

  /// Gets the border color based on state from the resolved theme.
  Color _getBorderColor(SkillTreeTheme resolvedTheme) {
    switch (state) {
      case SkillState.locked:
        return resolvedTheme.lockedNodeBorderColor;
      case SkillState.available:
        return resolvedTheme.availableNodeBorderColor;
      case SkillState.unlocked:
        return resolvedTheme.unlockedNodeBorderColor;
      case SkillState.maxed:
        return resolvedTheme.maxedNodeBorderColor;
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
  List<BoxShadow>? _buildShadows(SkillTreeTheme resolvedTheme) {
    final shadows = <BoxShadow>[];
    final borderColor = _getBorderColor(resolvedTheme);
    final availableBorderColor = resolvedTheme.availableNodeBorderColor;

    // Selection glow
    if (selected) {
      shadows.add(BoxShadow(
        color: borderColor.withAlpha(128),
        blurRadius: 12,
        spreadRadius: 2,
      ));
    }

    // Hover glow
    if (hovered && !selected) {
      shadows.add(BoxShadow(
        color: borderColor.withAlpha(64),
        blurRadius: 8,
        spreadRadius: 1,
      ));
    }

    // Available state pulse (subtle glow)
    if (state == SkillState.available && !selected && !hovered) {
      shadows.add(BoxShadow(
        color: availableBorderColor.withAlpha(48),
        blurRadius: 6,
        spreadRadius: 0,
      ));
    }

    return shadows.isEmpty ? null : shadows;
  }

  /// Builds the icon widget.
  Widget _buildIcon(SkillTreeTheme resolvedTheme) {
    // Icon opacity based on state
    final opacity = state == SkillState.locked ? 0.5 : 1.0;

    if (node.icon != null) {
      return Opacity(
        opacity: opacity,
        child: Icon(
          node.icon,
          color: _getIconColor(resolvedTheme),
          size: size.width * 0.5,
        ),
      );
    }

    // Placeholder icon if none provided
    return Opacity(
      opacity: opacity,
      child: Icon(
        _getDefaultIcon(),
        color: _getIconColor(resolvedTheme),
        size: size.width * 0.4,
      ),
    );
  }

  /// Gets the icon color based on node type from the resolved theme.
  Color _getIconColor(SkillTreeTheme resolvedTheme) {
    switch (node.type) {
      case SkillType.passive:
        return resolvedTheme.passiveColor;
      case SkillType.active:
        return resolvedTheme.activeColor;
      case SkillType.ultimate:
        return resolvedTheme.ultimateColor;
      case SkillType.keystone:
        return resolvedTheme.keystoneColor;
      case SkillType.minor:
        return resolvedTheme.passiveColor.withAlpha(179);
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
  Widget _buildLevelBadge(SkillTreeTheme resolvedTheme) {
    final levelText = '${node.currentLevel}/${node.maxLevel}';
    final levelStyle = resolvedTheme.nodeLevelStyle ??
        TextStyle(
          color: resolvedTheme.lockedNodeBorderColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        );

    return Positioned(
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF000000).withAlpha(179),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: _getBorderColor(resolvedTheme),
            width: 1,
          ),
        ),
        child: Text(
          levelText,
          style: levelStyle,
        ),
      ),
    );
  }
}
