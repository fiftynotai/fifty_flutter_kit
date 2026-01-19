import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter/material.dart';

import '../data/sample_trees.dart';

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

    _controller = SkillTreeController<void>(
      tree: tree,
      theme: SkillTreeTheme.dark(),
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
          backgroundColor: _getBranchColor(node.branch),
        ),
      );
    }
  }

  void _handleReset() {
    _controller.reset();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All talents reset! Points refunded.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Color _getBranchColor(String? branch) {
    switch (branch) {
      case 'offense':
        return Colors.red;
      case 'defense':
        return Colors.blue;
      case 'utility':
        return Colors.amber;
      default:
        return Colors.grey;
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
        title: const Text('Talent Tree'),
        actions: [
          TextButton.icon(
            onPressed: _handleReset,
            icon: const Icon(Icons.refresh, color: Colors.white70),
            label: const Text('Reset', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Points header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              border: Border(
                bottom: BorderSide(color: Colors.grey[800]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PointsDisplay(
                  label: 'Available',
                  value: _controller.availablePoints,
                  color: Colors.amber,
                ),
                _PointsDisplay(
                  label: 'Spent',
                  value: _controller.spentPoints,
                  color: Colors.grey,
                ),
              ],
            ),
          ),

          // Branch headers
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: const Color(0xFF1A1A1A),
            child: Row(
              children: [
                _BranchHeader(
                  label: 'Offense',
                  icon: Icons.flash_on,
                  color: Colors.red,
                  points: _getBranchPoints('offense'),
                ),
                _BranchHeader(
                  label: 'Defense',
                  icon: Icons.shield,
                  color: Colors.blue,
                  points: _getBranchPoints('defense'),
                ),
                _BranchHeader(
                  label: 'Utility',
                  icon: Icons.bolt,
                  color: Colors.amber,
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
                    color: Colors.red,
                    controller: _controller,
                    onNodeTap: _handleNodeTap,
                  ),
                ),
                Container(width: 1, color: Colors.grey[800]),
                // Defense path
                Expanded(
                  child: _TalentPath(
                    branch: 'defense',
                    color: Colors.blue,
                    controller: _controller,
                    onNodeTap: _handleNodeTap,
                  ),
                ),
                Container(width: 1, color: Colors.grey[800]),
                // Utility path
                Expanded(
                  child: _TalentPath(
                    branch: 'utility',
                    color: Colors.amber,
                    controller: _controller,
                    onNodeTap: _handleNodeTap,
                  ),
                ),
              ],
            ),
          ),

          // Footer hint
          Container(
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF1E1E1E),
            child: Text(
              'Tap a talent to invest a point',
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
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$points pts',
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 12,
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          for (int i = 0; i < nodes.length; i++) ...[
            if (i > 0)
              Container(
                width: 2,
                height: 20,
                color: nodes[i - 1].isUnlocked ? color : Colors.grey[700],
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
        width: isKeystone ? 80 : 64,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isUnlocked ? color.withValues(alpha: 0.2) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(isKeystone ? 12 : 8),
          border: Border.all(
            color: isMaxed
                ? color
                : isUnlocked
                    ? color.withValues(alpha: 0.8)
                    : isAvailable
                        ? color.withValues(alpha: 0.5)
                        : Colors.grey[700]!,
            width: isMaxed ? 3 : 2,
          ),
          boxShadow: isMaxed
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              node.icon ?? Icons.star,
              color: isUnlocked ? color : Colors.white38,
              size: isKeystone ? 24 : 20,
            ),
            const SizedBox(height: 4),
            Text(
              node.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isUnlocked ? Colors.white : Colors.white54,
                fontWeight: isKeystone ? FontWeight.bold : FontWeight.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Level indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                node.maxLevel,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < node.currentLevel
                        ? color
                        : Colors.grey[700],
                    border: Border.all(
                      color: index < node.currentLevel
                          ? color
                          : Colors.grey[600]!,
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
