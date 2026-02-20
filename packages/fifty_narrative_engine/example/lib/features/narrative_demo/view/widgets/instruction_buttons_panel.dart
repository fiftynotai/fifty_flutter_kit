/// Instruction buttons panel widget.
///
/// Provides buttons to add sentences of different instruction types
/// and control processing with theme-aware styling.
library;

import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Widget displaying instruction and control buttons.
class InstructionButtonsPanel extends StatelessWidget {
  const InstructionButtonsPanel({
    super.key,
    required this.canProcess,
    required this.canPause,
    required this.canResume,
    required this.canClearQueue,
    required this.isActive,
    required this.onAddWriteTapped,
    required this.onAddReadTapped,
    required this.onAddAskTapped,
    required this.onAddWaitTapped,
    required this.onProcessTapped,
    required this.onPauseTapped,
    required this.onResumeTapped,
    required this.onClearQueueTapped,
    required this.onClearAllTapped,
    required this.onLoadDemoStoryTapped,
  });

  /// Whether processing can be started.
  final bool canProcess;

  /// Whether processing can be paused.
  final bool canPause;

  /// Whether processing can be resumed.
  final bool canResume;

  /// Whether the queue can be cleared.
  final bool canClearQueue;

  /// Whether any operation is active.
  final bool isActive;

  /// Callback when "Add Write" is tapped.
  final VoidCallback onAddWriteTapped;

  /// Callback when "Add Read" is tapped.
  final VoidCallback onAddReadTapped;

  /// Callback when "Add Ask" is tapped.
  final VoidCallback onAddAskTapped;

  /// Callback when "Add Wait" is tapped.
  final VoidCallback onAddWaitTapped;

  /// Callback when "Process" is tapped.
  final VoidCallback onProcessTapped;

  /// Callback when "Pause" is tapped.
  final VoidCallback onPauseTapped;

  /// Callback when "Resume" is tapped.
  final VoidCallback onResumeTapped;

  /// Callback when "Clear Queue" is tapped.
  final VoidCallback onClearQueueTapped;

  /// Callback when "Clear All" is tapped.
  final VoidCallback onClearAllTapped;

  /// Callback when "Load Demo Story" is tapped.
  final VoidCallback onLoadDemoStoryTapped;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSectionHeader('ADD INSTRUCTIONS', colorScheme),
          const SizedBox(height: 8),
          _buildAddInstructionButtons(colorScheme),

          const SizedBox(height: 16),

          _buildSectionHeader('DEMO STORY', colorScheme),
          const SizedBox(height: 8),
          _buildDemoStoryButton(),

          const SizedBox(height: 16),

          _buildSectionHeader('CONTROLS', colorScheme),
          const SizedBox(height: 8),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildAddInstructionButtons(ColorScheme colorScheme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildInstructionButton(
          label: '+ WRITE',
          color: colorScheme.tertiary,
          disabledColor: colorScheme.onSurfaceVariant,
          surfaceColor: colorScheme.surface,
          onPressed: isActive ? null : onAddWriteTapped,
        ),
        _buildInstructionButton(
          label: '+ READ',
          color: colorScheme.secondary,
          disabledColor: colorScheme.onSurfaceVariant,
          surfaceColor: colorScheme.surface,
          onPressed: isActive ? null : onAddReadTapped,
        ),
        _buildInstructionButton(
          label: '+ ASK',
          color: colorScheme.error,
          disabledColor: colorScheme.onSurfaceVariant,
          surfaceColor: colorScheme.surface,
          onPressed: isActive ? null : onAddAskTapped,
        ),
        _buildInstructionButton(
          label: '+ WAIT',
          color: colorScheme.primary,
          disabledColor: colorScheme.onSurfaceVariant,
          surfaceColor: colorScheme.surface,
          onPressed: isActive ? null : onAddWaitTapped,
        ),
      ],
    );
  }

  Widget _buildInstructionButton({
    required String label,
    required Color color,
    required Color disabledColor,
    required Color surfaceColor,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isEnabled
              ? color.withValues(alpha: 0.2)
              : surfaceColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEnabled ? color : disabledColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isEnabled ? color : disabledColor.withValues(alpha: 0.5),
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildDemoStoryButton() {
    return FiftyButton(
      label: 'LOAD DEMO STORY',
      icon: Icons.auto_stories_rounded,
      variant: FiftyButtonVariant.primary,
      expanded: true,
      onPressed: isActive ? null : onLoadDemoStoryTapped,
    );
  }

  Widget _buildControlButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (canResume)
          FiftyButton(
            label: 'RESUME',
            icon: Icons.play_arrow_rounded,
            variant: FiftyButtonVariant.primary,
            onPressed: onResumeTapped,
          )
        else
          FiftyButton(
            label: 'PROCESS',
            icon: Icons.play_arrow_rounded,
            variant: FiftyButtonVariant.primary,
            onPressed: canProcess ? onProcessTapped : null,
          ),

        FiftyButton(
          label: 'PAUSE',
          icon: Icons.pause_rounded,
          variant: FiftyButtonVariant.secondary,
          onPressed: canPause ? onPauseTapped : null,
        ),

        FiftyButton(
          label: 'CLEAR QUEUE',
          icon: Icons.delete_outline_rounded,
          variant: FiftyButtonVariant.secondary,
          onPressed: canClearQueue ? onClearQueueTapped : null,
        ),

        FiftyButton(
          label: 'CLEAR ALL',
          icon: Icons.delete_forever_rounded,
          variant: FiftyButtonVariant.ghost,
          onPressed: isActive ? null : onClearAllTapped,
        ),
      ],
    );
  }
}
