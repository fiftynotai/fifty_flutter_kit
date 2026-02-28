import 'package:flutter/material.dart';

import '../models/models.dart';
import '../themes/skill_tree_theme.dart';

/// A widget that displays detailed information about a skill node.
///
/// Shows the node name, description, cost, level progress, and current state
/// with styling based on the provided theme.
///
/// **Theming:**
/// - If [theme] is null, FDL (Fifty Design Language) defaults are used
/// - If [theme] is provided, custom theme colors are used
///
/// **Example:**
/// ```dart
/// // Using FDL defaults
/// SkillTooltip(
///   node: myNode,
///   state: SkillState.available,
///   theme: null, // FDL defaults
///   availablePoints: 5,
/// )
///
/// // Using custom theme
/// SkillTooltip(
///   node: myNode,
///   state: SkillState.available,
///   theme: customTheme,
///   availablePoints: 5,
/// )
/// ```
class SkillTooltip<T> extends StatelessWidget {
  /// Creates a skill tooltip widget.
  ///
  /// **Parameters:**
  /// - [node]: The skill node to display information for
  /// - [state]: Current state of the node
  /// - [theme]: Optional custom theme. If null, FDL defaults are used.
  /// - [showCost]: Whether to display the cost line (default true)
  /// - [showPrerequisites]: Whether to display prerequisites (default true)
  /// - [availablePoints]: Points available for the player (default 0)
  const SkillTooltip({
    super.key,
    required this.node,
    required this.state,
    this.theme,
    this.showCost = true,
    this.showPrerequisites = true,
    this.availablePoints = 0,
  });

  /// The skill node to display information for.
  final SkillNode<T> node;

  /// Current state of the node.
  final SkillState state;

  /// Optional custom theme. If null, FDL defaults are used.
  final SkillTreeTheme? theme;

  /// Whether to display the cost line.
  final bool showCost;

  /// Whether to display prerequisites.
  final bool showPrerequisites;

  /// Points available for the player.
  final int availablePoints;

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
    final tooltipBackground = resolvedTheme.tooltipBackground ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    final tooltipBorder = resolvedTheme.tooltipBorder ??
        Theme.of(context).colorScheme.outline;
    final titleStyle = resolvedTheme.tooltipTitleStyle ??
        TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        );
    final descriptionStyle = resolvedTheme.tooltipDescriptionStyle ??
        TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 12,
        );

    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      decoration: BoxDecoration(
        color: tooltipBackground,
        border: Border.all(
          color: tooltipBorder,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Node name
          Text(
            node.name,
            style: titleStyle,
          ),

          // Description
          if (node.description != null) ...[
            const SizedBox(height: 8),
            Text(
              node.description!,
              style: descriptionStyle,
            ),
          ],

          // Cost line (if not maxed)
          if (showCost && !node.isMaxed) ...[
            const SizedBox(height: 12),
            _buildCostLine(resolvedTheme, descriptionStyle),
          ],

          // Level line (if multi-level)
          if (node.maxLevel > 1) ...[
            const SizedBox(height: 8),
            _buildLevelLine(resolvedTheme, descriptionStyle),
          ],

          // Prerequisites
          if (showPrerequisites && node.prerequisites.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildPrerequisitesLine(descriptionStyle),
          ],

          // State indicator
          const SizedBox(height: 12),
          _buildStateIndicator(resolvedTheme),
        ],
      ),
    );
  }

  /// Builds the cost display line.
  Widget _buildCostLine(SkillTreeTheme resolvedTheme, TextStyle descriptionStyle) {
    final cost = node.nextCost;
    final hasEnoughPoints = availablePoints >= cost;
    final errorColor = resolvedTheme.availableNodeBorderColor;
    final costStyle = resolvedTheme.nodeCostStyle ??
        TextStyle(
          color: resolvedTheme.keystoneColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
    final costColor = hasEnoughPoints
        ? (costStyle.color ?? resolvedTheme.keystoneColor)
        : errorColor;

    return Row(
      children: [
        Text(
          'Cost: ',
          style: descriptionStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          '$cost',
          style: costStyle.copyWith(color: costColor),
        ),
        if (!hasEnoughPoints) ...[
          const SizedBox(width: 8),
          Text(
            '(Insufficient points)',
            style: TextStyle(
              color: errorColor.withAlpha(179),
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  /// Builds the level display line.
  Widget _buildLevelLine(SkillTreeTheme resolvedTheme, TextStyle descriptionStyle) {
    final levelStyle = resolvedTheme.nodeLevelStyle ??
        TextStyle(
          color: descriptionStyle.color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );

    return Row(
      children: [
        Text(
          'Level: ',
          style: descriptionStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          '${node.currentLevel}/${node.maxLevel}',
          style: levelStyle,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: node.currentLevel / node.maxLevel,
              backgroundColor: resolvedTheme.lockedNodeColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(resolvedTheme),
              ),
              minHeight: 4,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the prerequisites display line.
  Widget _buildPrerequisitesLine(TextStyle descriptionStyle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requires: ',
          style: descriptionStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            node.prerequisites.join(', '),
            style: descriptionStyle.copyWith(fontStyle: FontStyle.italic),
          ),
        ),
      ],
    );
  }

  /// Builds the state indicator badge.
  Widget _buildStateIndicator(SkillTreeTheme resolvedTheme) {
    final (label, color) = _getStateInfo(resolvedTheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(51),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: color.withAlpha(128),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Gets the state label and color from the resolved theme.
  (String, Color) _getStateInfo(SkillTreeTheme resolvedTheme) {
    switch (state) {
      case SkillState.locked:
        return ('Locked', resolvedTheme.lockedNodeBorderColor);
      case SkillState.available:
        return ('Available', resolvedTheme.availableNodeBorderColor);
      case SkillState.unlocked:
        return ('Unlocked', resolvedTheme.unlockedNodeBorderColor);
      case SkillState.maxed:
        return ('Maxed', resolvedTheme.maxedNodeBorderColor);
    }
  }

  /// Gets the progress bar color based on state from the resolved theme.
  Color _getProgressColor(SkillTreeTheme resolvedTheme) {
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
}
