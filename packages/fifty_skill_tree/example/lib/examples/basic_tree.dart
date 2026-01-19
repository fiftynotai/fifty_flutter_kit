import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter/material.dart';

import '../data/sample_trees.dart';

/// Basic skill tree example with linear progression.
///
/// Demonstrates:
/// - Creating a simple skill tree
/// - Using SkillTreeController with points
/// - SkillTreeView with vertical layout
/// - Tap to unlock functionality
/// - Points display
class BasicTreeExample extends StatefulWidget {
  const BasicTreeExample({super.key});

  @override
  State<BasicTreeExample> createState() => _BasicTreeExampleState();
}

class _BasicTreeExampleState extends State<BasicTreeExample> {
  late SkillTreeController<void> _controller;

  @override
  void initState() {
    super.initState();

    // Create the skill tree
    final tree = createBasicTree();

    // Give the player some starting points
    tree.addPoints(10);

    // Create the controller with dark theme
    _controller = SkillTreeController<void>(
      tree: tree,
      theme: SkillTreeTheme.dark(),
    );

    // Listen for changes to update the UI
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
    // Attempt to unlock the node
    final result = await _controller.unlock(node.id);

    if (!mounted) return;

    if (result.success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unlocked ${node.name}!'),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green[700],
        ),
      );
    } else {
      // Show error message based on failure reason
      String message;
      switch (result.reason) {
        case UnlockFailureReason.alreadyMaxed:
          message = '${node.name} is already maxed';
          break;
        case UnlockFailureReason.prerequisitesNotMet:
          message = 'Prerequisites not met for ${node.name}';
          break;
        case UnlockFailureReason.insufficientPoints:
          message = 'Not enough points to unlock ${node.name}';
          break;
        default:
          message = 'Cannot unlock ${node.name}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }

  void _handleReset() {
    _controller.reset();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tree reset! All points refunded.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Tree'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _handleReset,
            tooltip: 'Reset Tree',
          ),
        ],
      ),
      body: Column(
        children: [
          // Points display
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E1E),
            child: Row(
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
                const SizedBox(width: 24),
                Text(
                  'Spent: ${_controller.spentPoints}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white54,
                      ),
                ),
              ],
            ),
          ),

          // Skill tree view
          Expanded(
            child: SkillTreeView<void>(
              controller: _controller,
              layout: const VerticalTreeLayout(),
              padding: const EdgeInsets.all(32),
              nodeSize: const Size(64, 64),
              levelSeparation: 100,
              onNodeTap: _handleNodeTap,
              onNodeLongPress: (node) {
                // Show skill details on long press
                _showNodeDetails(node);
              },
            ),
          ),

          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E1E),
            child: Text(
              'Tap a skill to unlock it. Long press for details.',
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

  void _showNodeDetails(SkillNode<void> node) {
    final state = _controller.getNodeState(node.id);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(node.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (node.description != null) ...[
              Text(node.description!),
              const SizedBox(height: 16),
            ],
            Text('Level: ${node.currentLevel}/${node.maxLevel}'),
            Text('Cost: ${node.nextCost} points'),
            Text('State: ${state.name}'),
            if (node.prerequisites.isNotEmpty)
              Text('Requires: ${node.prerequisites.join(", ")}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
