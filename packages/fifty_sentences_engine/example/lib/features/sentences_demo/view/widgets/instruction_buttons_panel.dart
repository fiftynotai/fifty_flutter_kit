/// Instruction buttons panel widget.
///
/// Provides buttons to add sentences of different instruction types
/// and control processing with FDL styling.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FiftySpacing.lg),
      decoration: BoxDecoration(
        color: FiftyColors.gunmetal.withValues(alpha: 0.5),
        borderRadius: FiftyRadii.standardRadius,
        border: Border.all(color: FiftyColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add Instructions Section
          _buildSectionHeader('ADD INSTRUCTIONS'),
          const SizedBox(height: FiftySpacing.sm),
          _buildAddInstructionButtons(),

          const SizedBox(height: FiftySpacing.lg),

          // Demo Story Section
          _buildSectionHeader('DEMO STORY'),
          const SizedBox(height: FiftySpacing.sm),
          _buildDemoStoryButton(),

          const SizedBox(height: FiftySpacing.lg),

          // Control Section
          _buildSectionHeader('CONTROLS'),
          const SizedBox(height: FiftySpacing.sm),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: FiftyTypography.mono,
        fontWeight: FiftyTypography.medium,
        color: FiftyColors.hyperChrome,
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildAddInstructionButtons() {
    return Wrap(
      spacing: FiftySpacing.sm,
      runSpacing: FiftySpacing.sm,
      children: [
        _buildInstructionButton(
          label: '+ WRITE',
          color: FiftyColors.igrisGreen,
          onPressed: isActive ? null : onAddWriteTapped,
        ),
        _buildInstructionButton(
          label: '+ READ',
          color: FiftyColors.success,
          onPressed: isActive ? null : onAddReadTapped,
        ),
        _buildInstructionButton(
          label: '+ ASK',
          color: FiftyColors.warning,
          onPressed: isActive ? null : onAddAskTapped,
        ),
        _buildInstructionButton(
          label: '+ WAIT',
          color: FiftyColors.crimsonPulse,
          onPressed: isActive ? null : onAddWaitTapped,
        ),
      ],
    );
  }

  Widget _buildInstructionButton({
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: FiftySpacing.md,
          vertical: FiftySpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isEnabled
              ? color.withValues(alpha: 0.2)
              : FiftyColors.gunmetal.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
          border: Border.all(
            color: isEnabled ? color : FiftyColors.hyperChrome.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamilyMono,
            fontSize: FiftyTypography.mono,
            fontWeight: FiftyTypography.medium,
            color: isEnabled ? color : FiftyColors.hyperChrome.withValues(alpha: 0.5),
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildDemoStoryButton() {
    return GestureDetector(
      onTap: isActive ? null : onLoadDemoStoryTapped,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: FiftySpacing.md,
        ),
        decoration: BoxDecoration(
          gradient: isActive
              ? null
              : const LinearGradient(
                  colors: [
                    FiftyColors.crimsonPulse,
                    FiftyColors.igrisGreen,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: isActive ? FiftyColors.gunmetal.withValues(alpha: 0.3) : null,
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
          border: Border.all(
            color: isActive
                ? FiftyColors.hyperChrome.withValues(alpha: 0.3)
                : FiftyColors.crimsonPulse,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_rounded,
              color: isActive
                  ? FiftyColors.hyperChrome.withValues(alpha: 0.5)
                  : FiftyColors.terminalWhite,
              size: 20,
            ),
            const SizedBox(width: FiftySpacing.sm),
            Text(
              'LOAD DEMO STORY',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.mono,
                fontWeight: FiftyTypography.medium,
                color: isActive
                    ? FiftyColors.hyperChrome.withValues(alpha: 0.5)
                    : FiftyColors.terminalWhite,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Wrap(
      spacing: FiftySpacing.sm,
      runSpacing: FiftySpacing.sm,
      children: [
        // Process / Resume button
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

        // Pause button
        FiftyButton(
          label: 'PAUSE',
          icon: Icons.pause_rounded,
          variant: FiftyButtonVariant.secondary,
          onPressed: canPause ? onPauseTapped : null,
        ),

        // Clear Queue button
        FiftyButton(
          label: 'CLEAR QUEUE',
          icon: Icons.delete_outline_rounded,
          variant: FiftyButtonVariant.secondary,
          onPressed: canClearQueue ? onClearQueueTapped : null,
        ),

        // Clear All button
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
