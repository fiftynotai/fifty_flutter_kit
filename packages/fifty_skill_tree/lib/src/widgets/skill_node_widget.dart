import 'package:fifty_tokens/fifty_tokens.dart';
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

  // ---- FDL Default Colors ----

  /// Gets the FDL default background color based on state.
  static Color _getFdlBackgroundColor(SkillState state) {
    switch (state) {
      case SkillState.locked:
        return FiftyColors.surfaceDark;
      case SkillState.available:
        return FiftyColors.surfaceDark;
      case SkillState.unlocked:
        return FiftyColors.hunterGreen.withAlpha(51);
      case SkillState.maxed:
        return FiftyColors.warning.withAlpha(51);
    }
  }

  /// Gets the FDL default border color based on state.
  static Color _getFdlBorderColor(SkillState state) {
    switch (state) {
      case SkillState.locked:
        return FiftyColors.borderDark;
      case SkillState.available:
        return FiftyColors.primary;
      case SkillState.unlocked:
        return FiftyColors.success;
      case SkillState.maxed:
        return FiftyColors.warning;
    }
  }

  /// Gets the FDL default icon color based on node type.
  static Color _getFdlIconColor(SkillType type) {
    switch (type) {
      case SkillType.passive:
        return FiftyColors.slateGrey;
      case SkillType.active:
        return FiftyColors.primary;
      case SkillType.ultimate:
        return FiftyColors.powderBlush;
      case SkillType.keystone:
        return FiftyColors.warning;
      case SkillType.minor:
        return FiftyColors.slateGrey.withAlpha(179);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final borderColor = _getBorderColor();
    final borderWidth = theme?.nodeBorderWidth ?? 2.0;

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
  /// Uses custom theme if provided, otherwise FDL defaults.
  Color _getBackgroundColor() {
    if (theme != null) {
      switch (state) {
        case SkillState.locked:
          return theme!.lockedNodeColor;
        case SkillState.available:
          return theme!.availableNodeColor;
        case SkillState.unlocked:
          return theme!.unlockedNodeColor;
        case SkillState.maxed:
          return theme!.maxedNodeColor;
      }
    }
    return _getFdlBackgroundColor(state);
  }

  /// Gets the border color based on state.
  /// Uses custom theme if provided, otherwise FDL defaults.
  Color _getBorderColor() {
    if (theme != null) {
      switch (state) {
        case SkillState.locked:
          return theme!.lockedNodeBorderColor;
        case SkillState.available:
          return theme!.availableNodeBorderColor;
        case SkillState.unlocked:
          return theme!.unlockedNodeBorderColor;
        case SkillState.maxed:
          return theme!.maxedNodeBorderColor;
      }
    }
    return _getFdlBorderColor(state);
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
    final borderColor = _getBorderColor();
    final availableBorderColor = theme?.availableNodeBorderColor ?? FiftyColors.primary;

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
  /// Uses custom theme if provided, otherwise FDL defaults.
  Color _getIconColor() {
    if (theme != null) {
      switch (node.type) {
        case SkillType.passive:
          return theme!.passiveColor;
        case SkillType.active:
          return theme!.activeColor;
        case SkillType.ultimate:
          return theme!.ultimateColor;
        case SkillType.keystone:
          return theme!.keystoneColor;
        case SkillType.minor:
          return theme!.passiveColor.withAlpha(179);
      }
    }
    return _getFdlIconColor(node.type);
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
    final levelStyle = theme?.nodeLevelStyle ??
        const TextStyle(
          color: FiftyColors.cream,
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
            color: _getBorderColor(),
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
