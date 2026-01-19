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
/// - Custom tooltips with research descriptions
class TechTreeExample extends StatefulWidget {
  const TechTreeExample({super.key});

  @override
  State<TechTreeExample> createState() => _TechTreeExampleState();
}

class _TechTreeExampleState extends State<TechTreeExample> {
  late SkillTreeController<void> _controller;
  String? _selectedNodeId;

  @override
  void initState() {
    super.initState();

    final tree = createTechTree();
    tree.addPoints(20);

    _controller = SkillTreeController<void>(
      tree: tree,
      theme: SkillTreeThemePresets.scifi(),
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
    setState(() {
      _selectedNodeId = node.id;
    });

    final state = _controller.getNodeState(node.id);
    if (state == SkillState.available) {
      final result = await _controller.unlock(node.id);

      if (!mounted) return;

      if (result.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Researched ${node.name}!'),
            duration: const Duration(seconds: 1),
            backgroundColor: const Color(0xFF00BCD4).withValues(alpha: 0.9),
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
        return FiftyColors.crimsonPulse;
      case 'economy':
        return FiftyColors.warning;
      case 'technology':
        return const Color(0xFF00BCD4); // Cyan
      default:
        return FiftyColors.hyperChrome;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedNode = _selectedNodeId != null
        ? _controller.getNode(_selectedNodeId!)
        : null;
    final selectedState = _selectedNodeId != null
        ? _controller.getNodeState(_selectedNodeId!)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TECH TREE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
            color: const Color(0xFF0D1B2A),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ResourceDisplay(
                  icon: Icons.science,
                  label: 'RESEARCH POINTS',
                  value: _controller.availablePoints.toString(),
                  color: const Color(0xFF00BCD4),
                ),
                _ResourceDisplay(
                  icon: Icons.check_circle,
                  label: 'COMPLETED',
                  value: _controller.tree.getUnlockedNodes().length.toString(),
                  color: FiftyColors.igrisGreen,
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

          // Tech tree view
          Expanded(
            child: Row(
              children: [
                // Tree view
                Expanded(
                  flex: 2,
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
                      return _TechNode(
                        node: node,
                        state: state,
                        branchColor: _getBranchColor(node.branch),
                        isSelected: isSelected,
                      );
                    },
                  ),
                ),

                // Details panel
                Container(
                  width: 250,
                  color: const Color(0xFF0D1B2A),
                  child: selectedNode != null
                      ? _DetailPanel(
                          node: selectedNode,
                          state: selectedState!,
                          branchLabel: _getBranchLabel(selectedNode.branch),
                          branchColor: _getBranchColor(selectedNode.branch),
                          onResearch: () => _handleNodeTap(selectedNode),
                        )
                      : Center(
                          child: Text(
                            'SELECT A TECHNOLOGY\nTO VIEW DETAILS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: FiftyColors.hyperChrome,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                ),
              ],
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
    final isUnlocked = state == SkillState.unlocked || state == SkillState.maxed;
    final isAvailable = state == SkillState.available;
    final isKeystone = node.type == SkillType.keystone;

    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isKeystone ? FiftySpacing.lg : FiftySpacing.sm),
        color: isUnlocked
            ? branchColor.withValues(alpha: 0.2)
            : const Color(0xFF1B3A4B),
        border: Border.all(
          color: isSelected
              ? FiftyColors.terminalWhite
              : isUnlocked
                  ? branchColor
                  : isAvailable
                      ? branchColor.withValues(alpha: 0.6)
                      : const Color(0xFF2A4A5B),
          width: isSelected ? 3 : 2,
        ),
        boxShadow: isSelected || isUnlocked
            ? [
                BoxShadow(
                  color: (isSelected ? FiftyColors.terminalWhite : branchColor)
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
                    ? FiftyColors.terminalWhite.withValues(alpha: 0.7)
                    : FiftyColors.hyperChrome,
            size: 28,
          ),
          const SizedBox(height: 2),
          if (node.tier > 0)
            Text(
              'T${node.tier}',
              style: TextStyle(
                color: FiftyColors.hyperChrome,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailPanel extends StatelessWidget {
  const _DetailPanel({
    required this.node,
    required this.state,
    required this.branchLabel,
    required this.branchColor,
    required this.onResearch,
  });

  final SkillNode<void> node;
  final SkillState state;
  final String branchLabel;
  final Color branchColor;
  final VoidCallback onResearch;

  @override
  Widget build(BuildContext context) {
    final isAvailable = state == SkillState.available;
    final isUnlocked = state == SkillState.unlocked || state == SkillState.maxed;

    return Padding(
      padding: const EdgeInsets.all(FiftySpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
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
              Text(
                'TIER ${node.tier}',
                style: TextStyle(
                  color: FiftyColors.hyperChrome,
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
              color: FiftyColors.terminalWhite,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),

          // Description
          Text(
            node.description ?? 'No description available.',
            style: TextStyle(color: FiftyColors.terminalWhite.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: FiftySpacing.lg),

          // Prerequisites
          if (node.prerequisites.isNotEmpty) ...[
            Text(
              'REQUIREMENTS:',
              style: TextStyle(
                color: FiftyColors.hyperChrome,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: FiftySpacing.xs),
            ...node.prerequisites.map((prereq) => Text(
                  '  - $prereq',
                  style: TextStyle(
                    color: FiftyColors.hyperChrome.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                )),
            const SizedBox(height: FiftySpacing.lg),
          ],

          // Cost
          Row(
            children: [
              Icon(Icons.science, size: 16, color: const Color(0xFF00BCD4)),
              const SizedBox(width: FiftySpacing.xs),
              Text(
                'COST: ${node.nextCost} POINTS',
                style: TextStyle(
                  color: const Color(0xFF00BCD4),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Research button
          SizedBox(
            width: double.infinity,
            child: FiftyButton(
              label: isUnlocked
                  ? 'RESEARCHED'
                  : isAvailable
                      ? 'RESEARCH'
                      : 'LOCKED',
              onPressed: isAvailable ? onResearch : null,
              variant: FiftyButtonVariant.primary,
            ),
          ),
        ],
      ),
    );
  }
}
