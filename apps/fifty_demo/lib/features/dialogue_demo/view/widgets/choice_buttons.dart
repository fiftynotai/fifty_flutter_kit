/// Choice Buttons Widget
///
/// Displays dialogue choice options (for branching dialogues).
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A single dialogue choice.
class DialogueChoice {
  const DialogueChoice({
    required this.id,
    required this.text,
  });

  final String id;
  final String text;
}

/// Choice buttons widget.
///
/// Shows selectable dialogue choices.
class ChoiceButtons extends StatelessWidget {
  const ChoiceButtons({
    required this.choices,
    required this.onChoiceSelected,
    super.key,
    this.selectedId,
  });

  final List<DialogueChoice> choices;
  final void Function(DialogueChoice) onChoiceSelected;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: choices.map((choice) {
        final isSelected = choice.id == selectedId;

        return Padding(
          padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
          child: GestureDetector(
            onTap: () => onChoiceSelected(choice),
            child: Container(
              padding: const EdgeInsets.all(FiftySpacing.md),
              decoration: BoxDecoration(
                color: isSelected
                    ? FiftyColors.crimsonPulse.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: FiftyRadii.standardRadius,
                border: Border.all(
                  color: isSelected
                      ? FiftyColors.crimsonPulse
                      : FiftyColors.border,
                ),
              ),
              child: Row(
                children: [
                  // Choice indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? FiftyColors.crimsonPulse
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? FiftyColors.crimsonPulse
                            : FiftyColors.hyperChrome,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: FiftyColors.terminalWhite,
                          )
                        : null,
                  ),
                  const SizedBox(width: FiftySpacing.md),
                  // Choice text
                  Expanded(
                    child: Text(
                      choice.text,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamilyMono,
                        fontSize: FiftyTypography.body,
                        color: isSelected
                            ? FiftyColors.terminalWhite
                            : FiftyColors.hyperChrome,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
