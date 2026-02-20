/// Dialogue display widget showing the current sentence.
///
/// Displays the currently processing sentence with animated text
/// and status indicator using theme-aware styling.
library;

import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../service/narrative_service.dart';

/// Widget displaying the current dialogue/sentence.
class DialogueDisplay extends StatelessWidget {
  const DialogueDisplay({
    super.key,
    required this.currentText,
    required this.state,
    required this.statusLabel,
    required this.choices,
    this.onTapToContinue,
    this.onChoiceSelected,
  });

  /// Current sentence text to display.
  final String currentText;

  /// Current processing state.
  final NarrativeServiceState state;

  /// Status label text.
  final String statusLabel;

  /// Choices for ask instruction.
  final List<String> choices;

  /// Callback when user taps to continue.
  final VoidCallback? onTapToContinue;

  /// Callback when user selects a choice.
  final ValueChanged<String>? onChoiceSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: state == NarrativeServiceState.waitingForInput
          ? onTapToContinue
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(colorScheme),
            width: 1.5,
          ),
          boxShadow: _isActive
              ? [
                  BoxShadow(
                    color: _getGlowColor(colorScheme).withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(colorScheme),

            const SizedBox(height: 12),

            _buildDialogueArea(colorScheme),

            if (state == NarrativeServiceState.waitingForChoice &&
                choices.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildChoices(colorScheme),
            ],

            if (state == NarrativeServiceState.waitingForInput) ...[
              const SizedBox(height: 12),
              _buildTapHint(colorScheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'DIALOGUE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 2.0,
          ),
        ),
        FiftyChip(
          label: statusLabel,
          variant: _getStatusVariant(),
          selected: _isActive,
        ),
      ],
    );
  }

  Widget _buildDialogueArea(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 80),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(
        currentText.isEmpty ? 'No sentence being processed...' : currentText,
        style: TextStyle(
          fontSize: 16,
          color: currentText.isEmpty
              ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
              : colorScheme.onSurface,
          fontStyle: currentText.isEmpty ? FontStyle.italic : FontStyle.normal,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildChoices(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'SELECT AN OPTION',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        ...choices.map((choice) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: FiftyButton(
                label: choice,
                variant: FiftyButtonVariant.secondary,
                onPressed: () => onChoiceSelected?.call(choice),
              ),
            )),
      ],
    );
  }

  Widget _buildTapHint(ColorScheme colorScheme) {
    return Center(
      child: AnimatedOpacity(
        opacity: state == NarrativeServiceState.waitingForInput ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Text(
          'TAP TO CONTINUE',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorScheme.primary,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }

  bool get _isActive =>
      state == NarrativeServiceState.processing ||
      state == NarrativeServiceState.waitingForInput ||
      state == NarrativeServiceState.waitingForChoice;

  Color _getBorderColor(ColorScheme colorScheme) {
    switch (state) {
      case NarrativeServiceState.processing:
        return colorScheme.primary;
      case NarrativeServiceState.waitingForInput:
        return colorScheme.tertiary;
      case NarrativeServiceState.waitingForChoice:
        return colorScheme.secondary;
      case NarrativeServiceState.paused:
        return colorScheme.error;
      case NarrativeServiceState.idle:
        return colorScheme.outlineVariant;
    }
  }

  Color _getGlowColor(ColorScheme colorScheme) {
    switch (state) {
      case NarrativeServiceState.processing:
        return colorScheme.primary;
      case NarrativeServiceState.waitingForInput:
        return colorScheme.tertiary;
      case NarrativeServiceState.waitingForChoice:
        return colorScheme.secondary;
      default:
        return colorScheme.primary;
    }
  }

  FiftyChipVariant _getStatusVariant() {
    switch (state) {
      case NarrativeServiceState.idle:
        return FiftyChipVariant.defaultVariant;
      case NarrativeServiceState.processing:
        return FiftyChipVariant.error;
      case NarrativeServiceState.paused:
        return FiftyChipVariant.warning;
      case NarrativeServiceState.waitingForInput:
        return FiftyChipVariant.success;
      case NarrativeServiceState.waitingForChoice:
        return FiftyChipVariant.success;
    }
  }
}
