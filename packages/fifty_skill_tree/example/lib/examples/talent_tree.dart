import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../data/sample_trees.dart';

/// Defense branch color - Azure blue for protection theme.
/// Not in FDL core palette but appropriate for game UI.
const Color _defenseBlue = Color(0xFF2196F3);

/// MOBA-style talent tree example.
///
/// Demonstrates:
/// - 3 vertical talent paths
/// - Multi-level skills with point allocation
/// - Points allocation and reset functionality
class TalentTreeExample extends StatefulWidget {
  const TalentTreeExample({super.key});

  @override
  State<TalentTreeExample> createState() => _TalentTreeExampleState();
}

class _TalentTreeExampleState extends State<TalentTreeExample> {
  late SkillTreeController<void> _controller;

  @override
  void initState() {
    super.initState();

    final tree = createTalentTree();
    tree.addPoints(20);

    // Use FDL defaults (no custom theme needed)
    _controller = SkillTreeController<void>(
      tree: tree,
    );

    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  Future<void> _handleNodeTap(SkillNode<void> node) async {
    final result = await _controller.unlock(node.id);

    if (!mounted) return;

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${node.name} upgraded to level ${result.newLevel}!',
          ),
          duration: const Duration(milliseconds: 800),
          backgroundColor: _getBranchColor(node.branch).withValues(alpha: 0.9),
        ),
      );
    }
  }

  void _handleReset() {
    _controller.reset();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All talents reset! Points refunded.'),
        duration: const Duration(seconds: 1),
        backgroundColor: FiftyColors.surfaceDark,
      ),
    );
  }

  Color _getBranchColor(String? branch) {
    switch (branch) {
      case 'offense':
        return FiftyColors.burgundy;
      case 'defense':
        return _defenseBlue;
      case 'utility':
        return FiftyColors.warning;
      default:
        return FiftyColors.slateGrey;
    }
  }

  int _getBranchPoints(String branch) {
    return _controller.nodes
        .where((n) => n.branch == branch)
        .fold(0, (sum, n) => sum + n.currentLevel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TALENT TREE',
          style: TextStyle(
            letterSpacing: FiftyTypography.lineHeightTitle,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: FiftySpacing.sm),
            child: FiftyButton(
              label: 'RESET',
              icon: Icons.refresh,
              variant: FiftyButtonVariant.ghost,
              size: FiftyButtonSize.small,
              onPressed: _handleReset,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Points header
          Container(
            padding: const EdgeInsets.all(FiftySpacing.lg),
            decoration: BoxDecoration(
              color: FiftyColors.surfaceDark,
              border: Border(
                bottom: BorderSide(color: FiftyColors.borderDark),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PointsDisplay(
                  label: 'AVAILABLE',
                  value: _controller.availablePoints,
                  color: FiftyColors.warning,
                ),
                _PointsDisplay(
                  label: 'SPENT',
                  value: _controller.spentPoints,
                  color: FiftyColors.slateGrey,
                ),
              ],
            ),
          ),

          // Branch headers
          Container(
            padding: const EdgeInsets.symmetric(vertical: FiftySpacing.md),
            color: FiftyColors.darkBurgundy,
            child: Row(
              children: [
                _BranchHeader(
                  label: 'OFFENSE',
                  icon: Icons.flash_on,
                  color: FiftyColors.burgundy,
                  points: _getBranchPoints('offense'),
                ),
                _BranchHeader(
                  label: 'DEFENSE',
                  icon: Icons.shield,
                  color: _defenseBlue,
                  points: _getBranchPoints('defense'),
                ),
                _BranchHeader(
                  label: 'UTILITY',
                  icon: Icons.bolt,
                  color: FiftyColors.warning,
                  points: _getBranchPoints('utility'),
                ),
              ],
            ),
          ),

          // Talent tree
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Offense path
                Expanded(
                  child: _TalentPath(
                    branch: 'offense',
                    color: FiftyColors.burgundy,
                    controller: _controller,
                    onNodeTap: _handleNodeTap,
                  ),
                ),
                Container(width: 1, color: FiftyColors.borderDark),
                // Defense path
                Expanded(
                  child: _TalentPath(
                    branch: 'defense',
                    color: _defenseBlue,
                    controller: _controller,
                    onNodeTap: _handleNodeTap,
                  ),
                ),
                Container(width: 1, color: FiftyColors.borderDark),
                // Utility path
                Expanded(
                  child: _TalentPath(
                    branch: 'utility',
                    color: FiftyColors.warning,
                    controller: _controller,
                    onNodeTap: _handleNodeTap,
                  ),
                ),
              ],
            ),
          ),

          // Footer hint
          Container(
            padding: const EdgeInsets.all(FiftySpacing.md),
            color: FiftyColors.surfaceDark,
            child: Text(
              'Tap a talent to invest a point',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: FiftyColors.slateGrey,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsDisplay extends StatelessWidget {
  const _PointsDisplay({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.titleLarge,
            fontWeight: FiftyTypography.extraBold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            color: FiftyColors.slateGrey,
            fontSize: FiftyTypography.bodySmall,
            letterSpacing: FiftyTypography.lineHeightTitle,
          ),
        ),
      ],
    );
  }
}

class _BranchHeader extends StatelessWidget {
  const _BranchHeader({
    required this.label,
    required this.icon,
    required this.color,
    required this.points,
  });

  final String label;
  final IconData icon;
  final Color color;
  final int points;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: FiftySpacing.xxl),
          const SizedBox(height: FiftySpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              color: color,
              fontWeight: FiftyTypography.medium,
              letterSpacing: FiftyTypography.lineHeightTitle,
            ),
          ),
          Text(
            '$points PTS',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              color: FiftyColors.slateGrey,
              fontSize: FiftyTypography.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _TalentPath extends StatelessWidget {
  const _TalentPath({
    required this.branch,
    required this.color,
    required this.controller,
    required this.onNodeTap,
  });

  final String branch;
  final Color color;
  final SkillTreeController<void> controller;
  final void Function(SkillNode<void>) onNodeTap;

  @override
  Widget build(BuildContext context) {
    final nodes = controller.nodes
        .where((n) => n.branch == branch)
        .toList()
      ..sort((a, b) => a.tier.compareTo(b.tier));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: FiftySpacing.lg),
      child: Column(
        children: [
          for (int i = 0; i < nodes.length; i++) ...[
            if (i > 0)
              Container(
                width: 2,
                height: FiftySpacing.xl,
                color: nodes[i - 1].isUnlocked ? color : FiftyColors.borderDark,
              ),
            _TalentNode(
              node: nodes[i],
              state: controller.getNodeState(nodes[i].id),
              color: color,
              onTap: () => onNodeTap(nodes[i]),
            ),
          ],
        ],
      ),
    );
  }
}

/// Size constants for talent nodes.
class _NodeSizes {
  _NodeSizes._();

  /// Standard node width.
  static const double nodeWidth = 64;

  /// Keystone node width (larger for emphasis).
  static const double keystoneWidth = 80;

  /// Standard icon size.
  static const double iconSize = 20;

  /// Keystone icon size.
  static const double keystoneIconSize = 24;

  /// Level indicator dot size.
  static const double dotSize = 8;

  /// Node label font size.
  static const double labelFontSize = 10;

  /// Glow blur radius for maxed nodes.
  static const double glowBlurRadius = 8;
}

class _TalentNode extends StatelessWidget {
  const _TalentNode({
    required this.node,
    required this.state,
    required this.color,
    required this.onTap,
  });

  final SkillNode<void> node;
  final SkillState state;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnlocked = state == SkillState.unlocked || state == SkillState.maxed;
    final isAvailable = state == SkillState.available;
    final isMaxed = state == SkillState.maxed;
    final isKeystone = node.type == SkillType.keystone;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isKeystone ? _NodeSizes.keystoneWidth : _NodeSizes.nodeWidth,
        padding: const EdgeInsets.all(FiftySpacing.sm),
        decoration: BoxDecoration(
          color: isUnlocked ? color.withValues(alpha: 0.2) : FiftyColors.surfaceDark,
          borderRadius: BorderRadius.circular(isKeystone ? FiftySpacing.md : FiftySpacing.sm),
          border: Border.all(
            color: isMaxed
                ? color
                : isUnlocked
                    ? color.withValues(alpha: 0.8)
                    : isAvailable
                        ? color.withValues(alpha: 0.5)
                        : FiftyColors.borderDark,
            width: isMaxed ? 3 : 2,
          ),
          boxShadow: isMaxed
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: _NodeSizes.glowBlurRadius,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              node.icon ?? Icons.star,
              color: isUnlocked ? color : FiftyColors.slateGrey,
              size: isKeystone ? _NodeSizes.keystoneIconSize : _NodeSizes.iconSize,
            ),
            const SizedBox(height: FiftySpacing.xs),
            Text(
              node.name.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: _NodeSizes.labelFontSize,
                color: isUnlocked ? FiftyColors.cream : FiftyColors.slateGrey,
                fontWeight: isKeystone ? FiftyTypography.medium : FiftyTypography.regular,
                letterSpacing: FiftyTypography.lineHeightTitle,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: FiftySpacing.xs),
            // Level indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                node.maxLevel,
                (index) => Container(
                  width: _NodeSizes.dotSize,
                  height: _NodeSizes.dotSize,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < node.currentLevel
                        ? color
                        : FiftyColors.borderDark,
                    border: Border.all(
                      color: index < node.currentLevel
                          ? color
                          : FiftyColors.slateGrey.withValues(alpha: 0.6),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
