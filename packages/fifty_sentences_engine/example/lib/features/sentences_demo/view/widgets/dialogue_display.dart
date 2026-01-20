/// Dialogue display widget showing the current sentence.
///
/// Displays the currently processing sentence with animated text
/// and status indicator using FDL styling.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../service/sentences_service.dart';

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
  final SentencesServiceState state;

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
    return GestureDetector(
      onTap: state == SentencesServiceState.waitingForInput
          ? onTapToContinue
          : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(FiftySpacing.lg),
        decoration: BoxDecoration(
          color: FiftyColors.surfaceDark.withValues(alpha: 0.5),
          borderRadius: FiftyRadii.lgRadius,
          border: Border.all(
            color: _getBorderColor(),
            width: 1.5,
          ),
          boxShadow: _isActive
              ? [
                  BoxShadow(
                    color: _getGlowColor().withValues(alpha: 0.3),
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
            // Header row with title and status
            _buildHeader(),

            const SizedBox(height: FiftySpacing.md),

            // Dialogue text area
            _buildDialogueArea(),

            // Choices (for ask instruction)
            if (state == SentencesServiceState.waitingForChoice &&
                choices.isNotEmpty) ...[
              const SizedBox(height: FiftySpacing.lg),
              _buildChoices(),
            ],

            // Tap to continue hint
            if (state == SentencesServiceState.waitingForInput) ...[
              const SizedBox(height: FiftySpacing.md),
              _buildTapHint(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'DIALOGUE',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            fontWeight: FiftyTypography.medium,
            color: FiftyColors.slateGrey,
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

  Widget _buildDialogueArea() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 80),
      padding: const EdgeInsets.all(FiftySpacing.md),
      decoration: BoxDecoration(
        color: FiftyColors.darkBurgundy.withValues(alpha: 0.6),
        borderRadius: FiftyRadii.lgRadius,
        border: Border.all(color: FiftyColors.borderDark),
      ),
      child: Text(
        currentText.isEmpty ? 'No sentence being processed...' : currentText,
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontSize: FiftyTypography.bodyLarge,
          color: currentText.isEmpty
              ? FiftyColors.slateGrey.withValues(alpha: 0.5)
              : FiftyColors.cream,
          fontStyle: currentText.isEmpty ? FontStyle.italic : FontStyle.normal,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildChoices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'SELECT AN OPTION',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            fontWeight: FiftyTypography.medium,
            color: FiftyColors.slateGrey,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: FiftySpacing.sm),
        ...choices.map((choice) => Padding(
              padding: const EdgeInsets.only(bottom: FiftySpacing.xs),
              child: FiftyButton(
                label: choice,
                variant: FiftyButtonVariant.secondary,
                onPressed: () => onChoiceSelected?.call(choice),
              ),
            )),
      ],
    );
  }

  Widget _buildTapHint() {
    return Center(
      child: AnimatedOpacity(
        opacity: state == SentencesServiceState.waitingForInput ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: const Text(
          'TAP TO CONTINUE',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            fontWeight: FiftyTypography.medium,
            color: FiftyColors.burgundy,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }

  bool get _isActive =>
      state == SentencesServiceState.processing ||
      state == SentencesServiceState.waitingForInput ||
      state == SentencesServiceState.waitingForChoice;

  Color _getBorderColor() {
    switch (state) {
      case SentencesServiceState.processing:
        return FiftyColors.burgundy;
      case SentencesServiceState.waitingForInput:
        return FiftyColors.hunterGreen;
      case SentencesServiceState.waitingForChoice:
        return FiftyColors.success;
      case SentencesServiceState.paused:
        return FiftyColors.warning;
      case SentencesServiceState.idle:
        return FiftyColors.borderDark;
    }
  }

  Color _getGlowColor() {
    switch (state) {
      case SentencesServiceState.processing:
        return FiftyColors.burgundy;
      case SentencesServiceState.waitingForInput:
        return FiftyColors.hunterGreen;
      case SentencesServiceState.waitingForChoice:
        return FiftyColors.success;
      default:
        return FiftyColors.burgundy;
    }
  }

  FiftyChipVariant _getStatusVariant() {
    switch (state) {
      case SentencesServiceState.idle:
        return FiftyChipVariant.defaultVariant;
      case SentencesServiceState.processing:
        return FiftyChipVariant.error; // Uses burgundy
      case SentencesServiceState.paused:
        return FiftyChipVariant.warning;
      case SentencesServiceState.waitingForInput:
        return FiftyChipVariant.success;
      case SentencesServiceState.waitingForChoice:
        return FiftyChipVariant.success;
    }
  }
}
