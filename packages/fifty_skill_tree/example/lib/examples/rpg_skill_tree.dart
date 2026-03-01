import 'dart:convert';

import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../data/sample_trees.dart';

/// Mage branch color - arcane purple for mystical skills.
const Color _magePurple = Color(0xFF9C27B0);

/// RPG-style skill tree example with multiple branches.
///
/// Demonstrates:
/// - Multi-branch tree (Warrior/Mage/Rogue paths)
/// - Custom node styling based on branch
/// - Radial layout option
/// - Progress save/load functionality
class RpgSkillTreeExample extends StatefulWidget {
  const RpgSkillTreeExample({super.key});

  @override
  State<RpgSkillTreeExample> createState() => _RpgSkillTreeExampleState();
}

class _RpgSkillTreeExampleState extends State<RpgSkillTreeExample> {
  late SkillTreeController<void> _controller;
  TreeLayout _currentLayout = const VerticalTreeLayout();
  String? _savedProgress;

  @override
  void initState() {
    super.initState();

    final tree = createRpgTree();
    tree.addPoints(15);

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
          content: Text('Unlocked ${node.name}!'),
          duration: const Duration(seconds: 1),
          backgroundColor: FiftyColors.success.withValues(alpha: 0.9),
        ),
      );
    }
  }

  void _toggleLayout() {
    setState(() {
      if (_currentLayout is VerticalTreeLayout) {
        _currentLayout = const RadialTreeLayout(
          angleSpan: 3.14159, // pi radians = 180 degrees
        );
      } else {
        _currentLayout = const VerticalTreeLayout();
      }
    });
  }

  void _saveProgress() {
    final progress = _controller.exportProgress();
    _savedProgress = jsonEncode(progress);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Progress saved!'),
        duration: const Duration(seconds: 1),
        backgroundColor: FiftyColors.success.withValues(alpha: 0.9),
      ),
    );
  }

  void _loadProgress() {
    if (_savedProgress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No saved progress found'),
          duration: const Duration(seconds: 1),
          backgroundColor: FiftyColors.warning,
        ),
      );
      return;
    }

    final progress = jsonDecode(_savedProgress!) as Map<String, dynamic>;
    _controller.importProgress(progress);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Progress loaded!'),
        duration: const Duration(seconds: 1),
        backgroundColor: FiftyColors.primary,
      ),
    );
  }

  Color _getBranchColor(String? branch) {
    switch (branch) {
      case 'warrior':
        return FiftyColors.burgundy;
      case 'mage':
        return _magePurple;
      case 'rogue':
        return FiftyColors.hunterGreen;
      default:
        return FiftyColors.slateGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRadial = _currentLayout is RadialTreeLayout;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RPG SKILL TREE',
          style: TextStyle(
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            color: FiftyColors.cream,
          ),
        ),
        actions: [
          FiftyIconButton(
            icon: isRadial ? Icons.account_tree : Icons.radio_button_on,
            onPressed: _toggleLayout,
            tooltip: isRadial ? 'Vertical Layout' : 'Radial Layout',
          ),
          FiftyIconButton(
            icon: Icons.save,
            onPressed: _saveProgress,
            tooltip: 'Save Progress',
          ),
          FiftyIconButton(
            icon: Icons.download,
            onPressed: _loadProgress,
            tooltip: 'Load Progress',
          ),
          FiftyIconButton(
            icon: Icons.refresh,
            onPressed: () {
              _controller.reset();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Tree reset!'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: FiftyColors.surfaceDark,
                ),
              );
            },
            tooltip: 'Reset',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with points and branch legend
          FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.lg),
            scanlineOnHover: false,
            borderRadius: BorderRadius.zero,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.stars, color: FiftyColors.warning),
                    SizedBox(width: FiftySpacing.sm),
                    Text(
                      'POINTS: ${_controller.availablePoints}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: FiftyColors.cream,
                            letterSpacing: 1.2,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: FiftySpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LegendItem(
                        color: FiftyColors.burgundy, label: 'WARRIOR'),
                    SizedBox(width: FiftySpacing.lg),
                    _LegendItem(color: _magePurple, label: 'MAGE'),
                    SizedBox(width: FiftySpacing.lg),
                    _LegendItem(color: FiftyColors.hunterGreen, label: 'ROGUE'),
                  ],
                ),
              ],
            ),
          ),

          // Skill tree view with custom node styling
          Expanded(
            child: SkillTreeView<void>(
              controller: _controller,
              layout: _currentLayout,
              padding: EdgeInsets.all(FiftySpacing.xxxl),
              nodeSize: const Size(56, 56),
              levelSeparation: 90,
              nodeSeparation: 60,
              onNodeTap: _handleNodeTap,
              nodeBuilder: (node, state) {
                return _CustomRpgNode(
                  node: node,
                  state: state,
                  branchColor: _getBranchColor(node.branch),
                );
              },
            ),
          ),

          // Footer
          FiftyCard(
            padding: EdgeInsets.all(FiftySpacing.lg),
            scanlineOnHover: false,
            borderRadius: BorderRadius.zero,
            child: Center(
              child: Text(
                'CHOOSE YOUR PATH: WARRIOR, MAGE, OR ROGUE',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: FiftyColors.slateGrey,
                      letterSpacing: 1.2,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  /// Legend dot size using spacing tokens.
  static double _dotSize = FiftySpacing.md;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _dotSize,
          height: _dotSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: FiftySpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: FiftyColors.slateGrey,
                letterSpacing: 1.2,
              ),
        ),
      ],
    );
  }
}

class _CustomRpgNode extends StatelessWidget {
  const _CustomRpgNode({
    required this.node,
    required this.state,
    required this.branchColor,
  });

  final SkillNode<void> node;
  final SkillState state;
  final Color branchColor;

  /// Node size constants.
  static const double _nodeSize = 56;
  static const double _iconSize = 24;
  static const double _ultimateIconSize = 28;
  static double _glowBlurRadius = FiftySpacing.sm;

  /// Ultimate node border radius (compact).
  static final BorderRadius _ultimateRadius =
      BorderRadius.circular(FiftySpacing.sm);

  @override
  Widget build(BuildContext context) {
    final isUnlocked = state == SkillState.unlocked || state == SkillState.maxed;
    final isAvailable = state == SkillState.available;
    final isUltimate = node.type == SkillType.ultimate;

    return Container(
      width: _nodeSize,
      height: _nodeSize,
      decoration: BoxDecoration(
        shape: isUltimate ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: isUltimate ? _ultimateRadius : null,
        color: isUnlocked
            ? branchColor.withValues(alpha: 0.3)
            : FiftyColors.surfaceDark,
        border: Border.all(
          color: isUnlocked
              ? branchColor
              : isAvailable
                  ? branchColor.withValues(alpha: 0.6)
                  : FiftyColors.borderDark,
          width: isUnlocked ? 3 : 2,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: branchColor.withValues(alpha: 0.4),
                  blurRadius: _glowBlurRadius,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          node.icon ?? Icons.star,
          color: isUnlocked
              ? branchColor
              : isAvailable
                  ? FiftyColors.cream.withValues(alpha: 0.7)
                  : FiftyColors.slateGrey.withValues(alpha: 0.6),
          size: isUltimate ? _ultimateIconSize : _iconSize,
        ),
      ),
    );
  }
}
