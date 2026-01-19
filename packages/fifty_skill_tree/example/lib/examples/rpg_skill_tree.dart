import 'dart:convert';

import 'package:fifty_skill_tree/fifty_skill_tree.dart';
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
          backgroundColor: Colors.amber[700],
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
      const SnackBar(
        content: Text('Progress saved!'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _loadProgress() {
    if (_savedProgress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No saved progress found'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final progress = jsonDecode(_savedProgress!) as Map<String, dynamic>;
    _controller.importProgress(progress);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Progress loaded!'),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Color _getBranchColor(String? branch) {
    switch (branch) {
      case 'warrior':
        return Colors.red;
      case 'mage':
        return Colors.purple;
      case 'rogue':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRadial = _currentLayout is RadialTreeLayout;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RPG Skill Tree'),
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
                const SnackBar(
                  content: Text('Tree reset!'),
                  duration: Duration(seconds: 1),
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
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E1E),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.stars, color: Colors.amber),
                    const SizedBox(width: 8),
                    Text(
                      'Points: ${_controller.availablePoints}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LegendItem(color: Colors.red, label: 'Warrior'),
                    const SizedBox(width: 16),
                    _LegendItem(color: Colors.purple, label: 'Mage'),
                    const SizedBox(width: 16),
                    _LegendItem(color: Colors.green, label: 'Rogue'),
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
              padding: const EdgeInsets.all(32),
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
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E1E),
            child: Text(
              'Choose your path: Warrior, Mage, or Rogue',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white38,
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
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white54,
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
        borderRadius: isUltimate ? BorderRadius.circular(8) : null,
        color: isUnlocked
            ? branchColor.withValues(alpha: 0.3)
            : const Color(0xFF2A2A2A),
        border: Border.all(
          color: isUnlocked
              ? branchColor
              : isAvailable
                  ? branchColor.withValues(alpha: 0.6)
                  : Colors.grey[700]!,
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
                  ? Colors.white70
                  : Colors.grey[600],
          size: isUltimate ? 28 : 24,
        ),
      ),
    );
  }
}
