import 'package:fifty_tokens/fifty_tokens.dart';
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

  // ---- FDL Default Styles ----

  /// FDL default tooltip background color.
  static Color get _fdlTooltipBackground => FiftyColors.surfaceDark;

  /// FDL default tooltip border color.
  static Color get _fdlTooltipBorder => FiftyColors.borderDark;

  /// FDL default tooltip title style.
  static const TextStyle _fdlTitleStyle = TextStyle(
    color: FiftyColors.cream,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  /// FDL default tooltip description style.
  static TextStyle get _fdlDescriptionStyle => TextStyle(
    color: FiftyColors.cream.withAlpha(179),
    fontSize: 12,
  );

  /// FDL default cost text style.
  static const TextStyle _fdlCostStyle = TextStyle(
    color: FiftyColors.warning,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  /// FDL default level text style.
  static const TextStyle _fdlLevelStyle = TextStyle(
    color: FiftyColors.cream,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    final tooltipBackground = theme?.tooltipBackground ?? _fdlTooltipBackground;
    final tooltipBorder = theme?.tooltipBorder ?? _fdlTooltipBorder;
    final titleStyle = theme?.tooltipTitleStyle ?? _fdlTitleStyle;
    final descriptionStyle = theme?.tooltipDescriptionStyle ?? _fdlDescriptionStyle;

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
    final descriptionStyle = theme?.tooltipDescriptionStyle ?? _fdlDescriptionStyle;
    final costColor = hasEnoughPoints
        ? (theme?.nodeCostStyle?.color ?? FiftyColors.warning)
        : FiftyColors.burgundy;

    return Row(
      children: [
        Text(
          'Cost: ',
          style: descriptionStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          '$cost',
          style: (theme?.nodeCostStyle ?? _fdlCostStyle).copyWith(color: costColor),
        ),
        if (!hasEnoughPoints) ...[
          const SizedBox(width: 8),
          Text(
            '(Insufficient points)',
            style: TextStyle(
              color: FiftyColors.burgundy.withAlpha(179),
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
    final descriptionStyle = theme?.tooltipDescriptionStyle ?? _fdlDescriptionStyle;
    final levelStyle = theme?.nodeLevelStyle ?? _fdlLevelStyle;

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
              backgroundColor: FiftyColors.surfaceDark,
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
    final descriptionStyle = theme?.tooltipDescriptionStyle ?? _fdlDescriptionStyle;

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

  /// Gets the state label and color using FDL colors.
  (String, Color) _getStateInfo() {
    switch (state) {
      case SkillState.locked:
        return ('Locked', FiftyColors.slateGrey);
      case SkillState.available:
        return ('Available', FiftyColors.success);
      case SkillState.unlocked:
        return ('Unlocked', FiftyColors.primary);
      case SkillState.maxed:
        return ('Maxed', FiftyColors.warning);
    }
  }

  /// Gets the progress bar color based on state using FDL colors.
  Color _getProgressColor() {
    switch (state) {
      case SkillState.locked:
        return FiftyColors.slateGrey;
      case SkillState.available:
        return FiftyColors.success;
      case SkillState.unlocked:
        return FiftyColors.primary;
      case SkillState.maxed:
        return FiftyColors.warning;
    }
  }
}
