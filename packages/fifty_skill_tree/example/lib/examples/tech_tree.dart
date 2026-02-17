import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../data/sample_trees.dart';

/// Strategy game tech tree example.
///
/// Demonstrates:
/// - Grid layout
/// - Multiple tiers with prerequisites
/// - Bottom sheet details panel
/// - Interactive node tapping
class TechTreeExample extends StatefulWidget {
  const TechTreeExample({super.key});

  @override
  State<TechTreeExample> createState() => _TechTreeExampleState();
}

class _TechTreeExampleState extends State<TechTreeExample> {
  late SkillTreeController<void> _controller;
  String? _selectedNodeId;

  // Define cyan color for technology branch (not in FDL, so define locally)
  static const Color _techCyan = Color(0xFF00BCD4);

  @override
  void initState() {
    super.initState();

    final tree = createTechTree();
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

  void _handleNodeTap(SkillNode<void> node) {
    setState(() {
      _selectedNodeId = node.id;
    });

    // Show bottom sheet with node details
    _showNodeDetails(node);
  }

  void _showNodeDetails(SkillNode<void> node) {
    final state = _controller.getNodeState(node.id);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: FiftyColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(FiftySpacing.lg),
        ),
      ),
      builder: (context) => _NodeDetailsSheet(
        node: node,
        state: state,
        branchLabel: _getBranchLabel(node.branch),
        branchColor: _getBranchColor(node.branch),
        availablePoints: _controller.availablePoints,
        onResearch: () async {
          Navigator.of(context).pop();
          await _unlockNode(node);
        },
      ),
    );
  }

  Future<void> _unlockNode(SkillNode<void> node) async {
    final state = _controller.getNodeState(node.id);
    if (state == SkillState.available) {
      final result = await _controller.unlock(node.id);

      if (!mounted) return;

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Researched ${node.name}!'),
            duration: const Duration(seconds: 1),
            backgroundColor: FiftyColors.success.withValues(alpha: 0.9),
          ),
        );
      }
    }
  }

  String _getBranchLabel(String? branch) {
    switch (branch) {
      case 'military':
        return 'MILITARY';
      case 'economy':
        return 'ECONOMY';
      case 'technology':
        return 'TECHNOLOGY';
      default:
        return 'BASIC';
    }
  }

  Color _getBranchColor(String? branch) {
    switch (branch) {
      case 'military':
        return FiftyColors.burgundy;
      case 'economy':
        return FiftyColors.warning;
      case 'technology':
        return _techCyan;
      default:
        return FiftyColors.slateGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FiftyColors.darkBurgundy,
      appBar: AppBar(
        backgroundColor: FiftyColors.surfaceDark,
        title: Text(
          'TECH TREE',
          style: TextStyle(
            color: FiftyColors.cream,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: FiftyColors.cream),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: FiftyColors.cream),
            onPressed: () {
              _controller.reset();
              setState(() {
                _selectedNodeId = null;
              });
            },
            tooltip: 'Reset Research',
          ),
        ],
      ),
      body: Column(
        children: [
          // Resource bar
          Container(
            padding: const EdgeInsets.all(FiftySpacing.lg),
            color: FiftyColors.surfaceDark,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ResourceDisplay(
                  icon: Icons.science,
                  label: 'RESEARCH POINTS',
                  value: _controller.availablePoints.toString(),
                  color: _techCyan,
                ),
                _ResourceDisplay(
                  icon: Icons.check_circle,
                  label: 'COMPLETED',
                  value: _controller.tree.getUnlockedNodes().length.toString(),
                  color: FiftyColors.success,
                ),
                _ResourceDisplay(
                  icon: Icons.lock_open,
                  label: 'AVAILABLE',
                  value: _controller.tree.getAvailableNodes().length.toString(),
                  color: FiftyColors.warning,
                ),
              ],
            ),
          ),

          // Tech tree view - full width
          Expanded(
            child: SkillTreeView<void>(
              controller: _controller,
              layout: const GridLayout(columns: 3),
              padding: const EdgeInsets.all(FiftySpacing.xxl),
              nodeSize: const Size(72, 72),
              levelSeparation: 60,
              nodeSeparation: 40,
              onNodeTap: _handleNodeTap,
              nodeBuilder: (node, state) {
                final isSelected = node.id == _selectedNodeId;
                // Wrap in GestureDetector to ensure taps work
                return GestureDetector(
                  onTap: () => _handleNodeTap(node),
                  child: _TechNode(
                    node: node,
                    state: state,
                    branchColor: _getBranchColor(node.branch),
                    isSelected: isSelected,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourceDisplay extends StatelessWidget {
  const _ResourceDisplay({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: FiftySpacing.xs),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: FiftySpacing.xs),
        Text(
          label,
          style: TextStyle(
            color: FiftyColors.slateGrey,
            letterSpacing: 0.5,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _TechNode extends StatelessWidget {
  const _TechNode({
    required this.node,
    required this.state,
    required this.branchColor,
    required this.isSelected,
  });

  final SkillNode<void> node;
  final SkillState state;
  final Color branchColor;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final isUnlocked =
        state == SkillState.unlocked || state == SkillState.maxed;
    final isAvailable = state == SkillState.available;
    final isKeystone = node.type == SkillType.keystone;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          isKeystone ? FiftySpacing.lg : FiftySpacing.sm,
        ),
        color: isUnlocked
            ? branchColor.withValues(alpha: 0.2)
            : FiftyColors.surfaceDark,
        border: Border.all(
          color: isSelected
              ? FiftyColors.cream
              : isUnlocked
                  ? branchColor
                  : isAvailable
                      ? branchColor.withValues(alpha: 0.6)
                      : FiftyColors.slateGrey.withValues(alpha: 0.3),
          width: isSelected ? 3 : 2,
        ),
        boxShadow: isSelected || isUnlocked
            ? [
                BoxShadow(
                  color: (isSelected ? FiftyColors.cream : branchColor)
                      .withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            node.icon ?? Icons.science,
            color: isUnlocked
                ? branchColor
                : isAvailable
                    ? FiftyColors.cream.withValues(alpha: 0.7)
                    : FiftyColors.slateGrey,
            size: 28,
          ),
          const SizedBox(height: 2),
          if (node.tier > 0)
            Text(
              'T${node.tier}',
              style: TextStyle(
                color: FiftyColors.slateGrey,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}

/// Bottom sheet for node details.
class _NodeDetailsSheet extends StatelessWidget {
  const _NodeDetailsSheet({
    required this.node,
    required this.state,
    required this.branchLabel,
    required this.branchColor,
    required this.availablePoints,
    required this.onResearch,
  });

  final SkillNode<void> node;
  final SkillState state;
  final String branchLabel;
  final Color branchColor;
  final int availablePoints;
  final VoidCallback onResearch;

  @override
  Widget build(BuildContext context) {
    final isAvailable = state == SkillState.available;
    final isUnlocked =
        state == SkillState.unlocked || state == SkillState.maxed;
    final canAfford = availablePoints >= node.nextCost;

    return Padding(
      padding: const EdgeInsets.all(FiftySpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: FiftySpacing.lg),
              decoration: BoxDecoration(
                color: FiftyColors.slateGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header row
          Row(
            children: [
              // Branch badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FiftySpacing.sm,
                  vertical: FiftySpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: branchColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(FiftySpacing.xs),
                ),
                child: Text(
                  branchLabel,
                  style: TextStyle(
                    color: branchColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              // Tier badge
              Text(
                'TIER ${node.tier}',
                style: TextStyle(
                  color: FiftyColors.slateGrey,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.lg),

          // Name
          Text(
            node.name.toUpperCase(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: FiftyColors.cream,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),

          // Description
          Text(
            node.description ?? 'No description available.',
            style: TextStyle(
              color: FiftyColors.cream.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: FiftySpacing.lg),

          // Prerequisites
          if (node.prerequisites.isNotEmpty) ...[
            Text(
              'REQUIREMENTS:',
              style: TextStyle(
                color: FiftyColors.slateGrey,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: FiftySpacing.xs),
            ...node.prerequisites.map(
              (prereq) => Text(
                '  - $prereq',
                style: TextStyle(
                  color: FiftyColors.slateGrey.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: FiftySpacing.lg),
          ],

          // Cost row
          Row(
            children: [
              Icon(Icons.science, size: 16, color: branchColor),
              const SizedBox(width: FiftySpacing.xs),
              Text(
                'COST: ${node.nextCost} POINTS',
                style: TextStyle(
                  color: canAfford ? branchColor : FiftyColors.burgundy,
                  letterSpacing: 0.5,
                ),
              ),
              if (!canAfford && !isUnlocked) ...[
                const SizedBox(width: FiftySpacing.sm),
                Text(
                  '(Need ${node.nextCost - availablePoints} more)',
                  style: TextStyle(
                    color: FiftyColors.burgundy,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: FiftySpacing.xl),

          // Research button
          SizedBox(
            width: double.infinity,
            child: FiftyButton(
              label: isUnlocked
                  ? 'RESEARCHED'
                  : isAvailable
                      ? 'RESEARCH'
                      : 'LOCKED',
              onPressed: isAvailable && canAfford ? onResearch : null,
              variant: FiftyButtonVariant.primary,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
        ],
      ),
    );
  }
}
