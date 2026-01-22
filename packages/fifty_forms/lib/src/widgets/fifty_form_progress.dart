import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Progress indicator for multi-step forms.
///
/// Shows current step, total steps, and completion status.
/// Steps can be labeled and show visual indication of completion.
///
/// **Example:**
/// ```dart
/// FiftyFormProgress(
///   currentStep: 2,
///   totalSteps: 4,
///   stepLabels: ['Account', 'Profile', 'Preferences', 'Review'],
/// )
/// ```
///
/// **Without labels (numbers only):**
/// ```dart
/// FiftyFormProgress(
///   currentStep: 1,
///   totalSteps: 3,
///   showLabels: false,
/// )
/// ```
class FiftyFormProgress extends StatelessWidget {
  /// The current step (1-indexed).
  ///
  /// Must be between 1 and [totalSteps].
  final int currentStep;

  /// Total number of steps in the form.
  final int totalSteps;

  /// Optional labels for each step.
  ///
  /// If provided, must have exactly [totalSteps] elements.
  final List<String>? stepLabels;

  /// Whether to show step labels below the indicators.
  ///
  /// Defaults to true. If [stepLabels] is null, step numbers are shown instead.
  final bool showLabels;

  /// Animation duration for step transitions.
  ///
  /// Defaults to 200 milliseconds.
  final Duration animationDuration;

  /// Creates a form progress indicator.
  const FiftyFormProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
    this.showLabels = true,
    this.animationDuration = const Duration(milliseconds: 200),
  })  : assert(currentStep >= 1 && currentStep <= totalSteps),
        assert(stepLabels == null || stepLabels.length == totalSteps);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Step indicators with connecting lines
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            // Even indices are step circles, odd indices are lines
            if (index.isEven) {
              final stepNumber = index ~/ 2 + 1;
              return _StepCircle(
                stepNumber: stepNumber,
                currentStep: currentStep,
                colorScheme: colorScheme,
                animationDuration: animationDuration,
              );
            } else {
              final stepBefore = index ~/ 2 + 1;
              return Expanded(
                child: _ConnectingLine(
                  isCompleted: stepBefore < currentStep,
                  colorScheme: colorScheme,
                  animationDuration: animationDuration,
                ),
              );
            }
          }),
        ),
        // Labels
        if (showLabels) ...[
          const SizedBox(height: FiftySpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              final stepNumber = index + 1;
              final label = stepLabels?[index] ?? 'Step $stepNumber';
              final isActive = stepNumber == currentStep;
              final isCompleted = stepNumber < currentStep;

              return Expanded(
                child: Center(
                  child: Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.labelSmall,
                      fontWeight: isActive || isCompleted
                          ? FiftyTypography.bold
                          : FiftyTypography.regular,
                      letterSpacing: FiftyTypography.letterSpacingLabel,
                      color: isActive
                          ? colorScheme.primary
                          : isCompleted
                              ? colorScheme.onSurface
                              : colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

/// Circular step indicator.
class _StepCircle extends StatelessWidget {
  final int stepNumber;
  final int currentStep;
  final ColorScheme colorScheme;
  final Duration animationDuration;

  const _StepCircle({
    required this.stepNumber,
    required this.currentStep,
    required this.colorScheme,
    required this.animationDuration,
  });

  bool get isCompleted => stepNumber < currentStep;
  bool get isCurrent => stepNumber == currentStep;
  bool get isFuture => stepNumber > currentStep;

  @override
  Widget build(BuildContext context) {
    const size = 32.0;

    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeInOut,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted || isCurrent
            ? colorScheme.primary
            : colorScheme.surface,
        border: Border.all(
          color: isCompleted || isCurrent
              ? colorScheme.primary
              : colorScheme.outline,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: animationDuration,
          child: isCompleted
              ? Icon(
                  Icons.check,
                  key: const ValueKey('check'),
                  color: colorScheme.onPrimary,
                  size: 18,
                )
              : Text(
                  '$stepNumber',
                  key: ValueKey('number_$stepNumber'),
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    fontWeight: FiftyTypography.bold,
                    color: isCurrent
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
        ),
      ),
    );
  }
}

/// Line connecting step circles.
class _ConnectingLine extends StatelessWidget {
  final bool isCompleted;
  final ColorScheme colorScheme;
  final Duration animationDuration;

  const _ConnectingLine({
    required this.isCompleted,
    required this.colorScheme,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: animationDuration,
      curve: Curves.easeInOut,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: FiftySpacing.xs),
      decoration: BoxDecoration(
        color: isCompleted ? colorScheme.primary : colorScheme.outline,
        borderRadius: FiftyRadii.fullRadius,
      ),
    );
  }
}
