import 'package:flutter/material.dart';

import '../models/models.dart';
import '../themes/skill_tree_theme.dart';

/// A widget that displays detailed information about a skill node.
///
/// Shows the node name, description, cost, level progress, and current state
/// with styling based on the provided theme.
///
/// **Example:**
/// ```dart
/// SkillTooltip(
///   node: myNode,
///   state: SkillState.available,
///   theme: SkillTreeTheme.dark(),
///   availablePoints: 5,
/// )
/// ```
class SkillTooltip<T> extends StatelessWidget {
  /// Creates a skill tooltip widget.
  ///
  /// **Parameters:**
  /// - [node]: The skill node to display information for
  /// - [state]: Current state of the node
  /// - [theme]: Theme containing colors and styles
  /// - [showCost]: Whether to display the cost line (default true)
  /// - [showPrerequisites]: Whether to display prerequisites (default true)
  /// - [availablePoints]: Points available for the player (default 0)
  const SkillTooltip({
    super.key,
    required this.node,
    required this.state,
    required this.theme,
    this.showCost = true,
    this.showPrerequisites = true,
    this.availablePoints = 0,
  });

  /// The skill node to display information for.
  final SkillNode<T> node;

  /// Current state of the node.
  final SkillState state;

  /// Theme containing colors and styles.
  final SkillTreeTheme theme;

  /// Whether to display the cost line.
  final bool showCost;

  /// Whether to display prerequisites.
  final bool showPrerequisites;

  /// Points available for the player.
  final int availablePoints;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 250),
      decoration: BoxDecoration(
        color: theme.tooltipBackground ?? const Color(0xF0212121),
        border: Border.all(
          color: theme.tooltipBorder ?? const Color(0xFF616161),
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
            style: theme.tooltipTitleStyle ??
                const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),

          // Description
          if (node.description != null) ...[
            const SizedBox(height: 8),
            Text(
              node.description!,
              style: theme.tooltipDescriptionStyle ??
                  const TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 12,
                  ),
            ),
          ],

          // Cost line (if not maxed)
          if (showCost && !node.isMaxed) ...[
            const SizedBox(height: 12),
            _buildCostLine(),
          ],

          // Level line (if multi-level)
          if (node.maxLevel > 1) ...[
            const SizedBox(height: 8),
            _buildLevelLine(),
          ],

          // Prerequisites
          if (showPrerequisites && node.prerequisites.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildPrerequisitesLine(),
          ],

          // State indicator
          const SizedBox(height: 12),
          _buildStateIndicator(),
        ],
      ),
    );
  }

  /// Builds the cost display line.
  Widget _buildCostLine() {
    final cost = node.nextCost;
    final hasEnoughPoints = availablePoints >= cost;

    return Row(
      children: [
        Text(
          'Cost: ',
          style: theme.tooltipDescriptionStyle?.copyWith(
                fontWeight: FontWeight.w600,
              ) ??
              const TextStyle(
                color: Color(0xFFBDBDBD),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          '$cost',
          style: theme.nodeCostStyle?.copyWith(
                color: hasEnoughPoints
                    ? theme.nodeCostStyle?.color
                    : const Color(0xFFFF5252),
              ) ??
              TextStyle(
                color:
                    hasEnoughPoints ? const Color(0xFFFFD700) : const Color(0xFFFF5252),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
        ),
        if (!hasEnoughPoints) ...[
          const SizedBox(width: 8),
          Text(
            '(Insufficient points)',
            style: TextStyle(
              color: const Color(0xFFFF5252).withAlpha(179),
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  /// Builds the level display line.
  Widget _buildLevelLine() {
    return Row(
      children: [
        Text(
          'Level: ',
          style: theme.tooltipDescriptionStyle?.copyWith(
                fontWeight: FontWeight.w600,
              ) ??
              const TextStyle(
                color: Color(0xFFBDBDBD),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
        ),
        Text(
          '${node.currentLevel}/${node.maxLevel}',
          style: theme.nodeLevelStyle ??
              const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: node.currentLevel / node.maxLevel,
              backgroundColor: const Color(0xFF333333),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(),
              ),
              minHeight: 4,
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the prerequisites display line.
  Widget _buildPrerequisitesLine() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requires: ',
          style: theme.tooltipDescriptionStyle?.copyWith(
                fontWeight: FontWeight.w600,
              ) ??
              const TextStyle(
                color: Color(0xFFBDBDBD),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
        ),
        Expanded(
          child: Text(
            node.prerequisites.join(', '),
            style: theme.tooltipDescriptionStyle?.copyWith(
                  fontStyle: FontStyle.italic,
                ) ??
                const TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
      ],
    );
  }

  /// Builds the state indicator badge.
  Widget _buildStateIndicator() {
    final (label, color) = _getStateInfo();

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

  /// Gets the state label and color.
  (String, Color) _getStateInfo() {
    switch (state) {
      case SkillState.locked:
        return ('Locked', const Color(0xFF9E9E9E));
      case SkillState.available:
        return ('Available', const Color(0xFF4CAF50));
      case SkillState.unlocked:
        return ('Unlocked', const Color(0xFF2196F3));
      case SkillState.maxed:
        return ('Maxed', const Color(0xFFFFD700));
    }
  }

  /// Gets the progress bar color based on state.
  Color _getProgressColor() {
    switch (state) {
      case SkillState.locked:
        return const Color(0xFF9E9E9E);
      case SkillState.available:
        return const Color(0xFF4CAF50);
      case SkillState.unlocked:
        return const Color(0xFF2196F3);
      case SkillState.maxed:
        return const Color(0xFFFFD700);
    }
  }
}
