import 'package:fifty_skill_tree/fifty_skill_tree.dart';
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
            backgroundColor: Colors.cyan[700],
          ),
        );
      }
    }
  }

  String _getBranchLabel(String? branch) {
    switch (branch) {
      case 'military':
        return 'Military';
      case 'economy':
        return 'Economy';
      case 'technology':
        return 'Technology';
      default:
        return 'Basic';
    }
  }

  Color _getBranchColor(String? branch) {
    switch (branch) {
      case 'military':
        return Colors.red;
      case 'economy':
        return Colors.amber;
      case 'technology':
        return Colors.cyan;
      default:
        return Colors.grey;
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
        title: const Text('Tech Tree'),
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
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF0D1B2A),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ResourceDisplay(
                  icon: Icons.science,
                  label: 'Research Points',
                  value: _controller.availablePoints.toString(),
                  color: Colors.cyan,
                ),
                _ResourceDisplay(
                  icon: Icons.check_circle,
                  label: 'Completed',
                  value: _controller.tree.getUnlockedNodes().length.toString(),
                  color: Colors.green,
                ),
                _ResourceDisplay(
                  icon: Icons.lock_open,
                  label: 'Available',
                  value: _controller.tree.getAvailableNodes().length.toString(),
                  color: Colors.amber,
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
                    padding: const EdgeInsets.all(24),
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
                      : const Center(
                          child: Text(
                            'Select a technology\nto view details',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white38),
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
            const SizedBox(width: 4),
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
                color: Colors.white38,
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
        borderRadius: BorderRadius.circular(isKeystone ? 16 : 8),
        color: isUnlocked
            ? branchColor.withValues(alpha: 0.2)
            : const Color(0xFF1B3A4B),
        border: Border.all(
          color: isSelected
              ? Colors.white
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
                  color: (isSelected ? Colors.white : branchColor)
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
                    ? Colors.white70
                    : Colors.white38,
            size: 28,
          ),
          const SizedBox(height: 2),
          if (node.tier > 0)
            Text(
              'T${node.tier}',
              style: TextStyle(
                color: Colors.white38,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: branchColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  branchLabel,
                  style: TextStyle(
                    color: branchColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Tier ${node.tier}',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            node.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            node.description ?? 'No description available.',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),

          // Prerequisites
          if (node.prerequisites.isNotEmpty) ...[
            const Text(
              'Requirements:',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            ...node.prerequisites.map((prereq) => Text(
                  '  - $prereq',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                )),
            const SizedBox(height: 16),
          ],

          // Cost
          Row(
            children: [
              const Icon(Icons.science, size: 16, color: Colors.cyan),
              const SizedBox(width: 4),
              Text(
                'Cost: ${node.nextCost} points',
                style: const TextStyle(color: Colors.cyan),
              ),
            ],
          ),

          const Spacer(),

          // Research button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isAvailable ? onResearch : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: branchColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[800],
              ),
              child: Text(
                isUnlocked
                    ? 'Researched'
                    : isAvailable
                        ? 'Research'
                        : 'Locked',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
