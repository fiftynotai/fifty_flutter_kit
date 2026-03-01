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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: choices.map((choice) {
        final isSelected = choice.id == selectedId;

        return Padding(
          padding: EdgeInsets.only(bottom: FiftySpacing.sm),
          child: GestureDetector(
            onTap: () => onChoiceSelected(choice),
            child: Container(
              padding: EdgeInsets.all(FiftySpacing.md),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: FiftyRadii.lgRadius,
                border: Border.all(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.outline,
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
                          ? colorScheme.primary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 14,
                            color: colorScheme.onPrimary,
                          )
                        : null,
                  ),
                  SizedBox(width: FiftySpacing.md),
                  // Choice text
                  Expanded(
                    child: Text(
                      choice.text,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyLarge,
                        color: isSelected
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withValues(alpha: 0.7),
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
