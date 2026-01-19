import 'dart:convert';

import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../data/sample_trees.dart';

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

    _controller = SkillTreeController<void>(
      tree: tree,
      theme: SkillTreeThemePresets.rpg(),
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
          backgroundColor: FiftyColors.warning.withValues(alpha: 0.9),
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
        backgroundColor: FiftyColors.igrisGreen.withValues(alpha: 0.9),
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
        backgroundColor: FiftyColors.crimsonPulse,
      ),
    );
  }

  Color _getBranchColor(String? branch) {
    switch (branch) {
      case 'warrior':
        return FiftyColors.crimsonPulse;
      case 'mage':
        return const Color(0xFF9C27B0); // Purple
      case 'rogue':
        return FiftyColors.igrisGreen;
      default:
        return FiftyColors.hyperChrome;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRadial = _currentLayout is RadialTreeLayout;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RPG SKILL TREE'),
        actions: [
          IconButton(
            icon: Icon(isRadial ? Icons.account_tree : Icons.radio_button_on),
            onPressed: _toggleLayout,
            tooltip: isRadial ? 'Vertical Layout' : 'Radial Layout',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProgress,
            tooltip: 'Save Progress',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _loadProgress,
            tooltip: 'Load Progress',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reset();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Tree reset!'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: FiftyColors.gunmetal,
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
          Container(
            padding: const EdgeInsets.all(FiftySpacing.lg),
            color: FiftyColors.gunmetal,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.stars, color: FiftyColors.warning),
                    const SizedBox(width: FiftySpacing.sm),
                    Text(
                      'POINTS: ${_controller.availablePoints}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: FiftyColors.terminalWhite,
                            letterSpacing: 1,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: FiftySpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LegendItem(
                        color: FiftyColors.crimsonPulse, label: 'WARRIOR'),
                    const SizedBox(width: FiftySpacing.lg),
                    _LegendItem(
                        color: const Color(0xFF9C27B0), label: 'MAGE'),
                    const SizedBox(width: FiftySpacing.lg),
                    _LegendItem(color: FiftyColors.igrisGreen, label: 'ROGUE'),
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
              padding: const EdgeInsets.all(FiftySpacing.xxxl),
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
          Container(
            padding: const EdgeInsets.all(FiftySpacing.lg),
            color: FiftyColors.gunmetal,
            child: Text(
              'Choose your path: Warrior, Mage, or Rogue',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: FiftyColors.hyperChrome,
                  ),
              textAlign: TextAlign.center,
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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: FiftySpacing.xs),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: FiftyColors.hyperChrome,
                letterSpacing: 0.5,
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

  @override
  Widget build(BuildContext context) {
    final isUnlocked = state == SkillState.unlocked || state == SkillState.maxed;
    final isAvailable = state == SkillState.available;
    final isUltimate = node.type == SkillType.ultimate;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: isUltimate ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: isUltimate ? BorderRadius.circular(FiftySpacing.sm) : null,
        color: isUnlocked
            ? branchColor.withValues(alpha: 0.3)
            : FiftyColors.gunmetal,
        border: Border.all(
          color: isUnlocked
              ? branchColor
              : isAvailable
                  ? branchColor.withValues(alpha: 0.6)
                  : FiftyColors.border,
          width: isUnlocked ? 3 : 2,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: branchColor.withValues(alpha: 0.4),
                  blurRadius: 8,
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
                  ? FiftyColors.terminalWhite.withValues(alpha: 0.7)
                  : FiftyColors.hyperChrome.withValues(alpha: 0.6),
          size: isUltimate ? 28 : 24,
        ),
      ),
    );
  }
}
