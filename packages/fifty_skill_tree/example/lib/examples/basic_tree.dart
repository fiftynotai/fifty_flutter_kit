import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
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

    // Create the controller with FDL defaults (no custom theme needed)
    _controller = SkillTreeController<void>(
      tree: tree,
      // No theme = FDL defaults are used automatically
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
          backgroundColor: FiftyColors.success.withValues(alpha: 0.9),
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
          backgroundColor: FiftyColors.burgundy,
        ),
      );
    }
  }

  void _handleReset() {
    _controller.reset();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tree reset! All points refunded.'),
        duration: const Duration(seconds: 1),
        backgroundColor: FiftyColors.surfaceDark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BASIC TREE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
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
            padding: const EdgeInsets.all(FiftySpacing.lg),
            color: FiftyColors.surfaceDark,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stars, color: FiftyColors.warning),
                const SizedBox(width: FiftySpacing.sm),
                Text(
                  'POINTS: ${_controller.availablePoints}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: FiftyColors.cream,
                        letterSpacing: 1.2,
                      ),
                ),
                const SizedBox(width: FiftySpacing.xxl),
                Text(
                  'SPENT: ${_controller.spentPoints}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: FiftyColors.slateGrey,
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
              padding: const EdgeInsets.all(FiftySpacing.xxxl),
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
            padding: const EdgeInsets.all(FiftySpacing.lg),
            color: FiftyColors.surfaceDark,
            child: Text(
              'Tap a skill to unlock it. Long press for details.',
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

  void _showNodeDetails(SkillNode<void> node) {
    final state = _controller.getNodeState(node.id);

    showDialog(
      context: context,
      builder: (context) => FiftyDialog(
        title: node.name.toUpperCase(),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (node.description != null) ...[
              Text(
                node.description!,
                style: TextStyle(color: FiftyColors.cream),
              ),
              const SizedBox(height: FiftySpacing.lg),
            ],
            Text(
              'Level: ${node.currentLevel}/${node.maxLevel}',
              style: TextStyle(color: FiftyColors.slateGrey),
            ),
            Text(
              'Cost: ${node.nextCost} points',
              style: TextStyle(color: FiftyColors.slateGrey),
            ),
            Text(
              'State: ${state.name.toUpperCase()}',
              style: TextStyle(color: FiftyColors.slateGrey),
            ),
            if (node.prerequisites.isNotEmpty)
              Text(
                'Requires: ${node.prerequisites.join(", ")}',
                style: TextStyle(color: FiftyColors.slateGrey),
              ),
          ],
        ),
        actions: [
          FiftyButton(
            label: 'CLOSE',
            onPressed: () => Navigator.pop(context),
            variant: FiftyButtonVariant.ghost,
          ),
        ],
      ),
    );
  }
}
