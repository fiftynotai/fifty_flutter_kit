import 'package:flutter/material.dart';

import '../../../../../core/animations/animation_constants.dart';
import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_spacing.dart';
import '../../../../../core/theme/sneaker_typography.dart';

/// **CheckoutStepper**
///
/// Progress indicator for checkout steps.
///
/// Displays a horizontal stepper with step icons, labels, and connecting lines.
/// Supports completed, current, and upcoming step states.
///
/// **Example Usage:**
/// ```dart
/// CheckoutStepper(
///   currentStep: 1,
///   steps: ['Cart', 'Shipping', 'Payment', 'Confirm'],
/// )
/// ```
class CheckoutStepper extends StatelessWidget {
  /// Current step index (0-based).
  final int currentStep;

  /// List of step labels.
  final List<String> steps;

  /// Callback when a step is tapped (for navigating back).
  final ValueChanged<int>? onStepTap;

  /// Whether to show step numbers inside circles.
  final bool showStepNumbers;

  /// Creates a [CheckoutStepper] with the specified parameters.
  const CheckoutStepper({
    required this.currentStep,
    required this.steps,
    this.onStepTap,
    this.showStepNumbers = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;

        return Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            // Even indices are steps, odd indices are connectors
            if (index.isEven) {
              final stepIndex = index ~/ 2;
              return _buildStep(
                index: stepIndex,
                label: steps[stepIndex],
                isMobile: isMobile,
              );
            } else {
              final beforeIndex = index ~/ 2;
              return _buildConnector(
                isCompleted: beforeIndex < currentStep,
              );
            }
          }),
        );
      },
    );
  }

  Widget _buildStep({
    required int index,
    required String label,
    required bool isMobile,
  }) {
    final isCompleted = index < currentStep;
    final isCurrent = index == currentStep;
    final canTap = isCompleted && onStepTap != null;

    return GestureDetector(
      onTap: canTap ? () => onStepTap!(index) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Step circle
          AnimatedContainer(
            duration: SneakerAnimations.medium,
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? SneakerColors.burgundy
                  : isCurrent
                      ? SneakerColors.burgundy
                      : SneakerColors.surfaceDark,
              border: Border.all(
                color: isCompleted || isCurrent
                    ? SneakerColors.burgundy
                    : SneakerColors.border,
                width: 2,
              ),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: SneakerColors.burgundy.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: SneakerColors.cream,
                    )
                  : showStepNumbers
                      ? Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontFamily: SneakerTypography.fontFamily,
                            fontSize: 14,
                            fontWeight: SneakerTypography.bold,
                            color: isCurrent
                                ? SneakerColors.cream
                                : SneakerColors.slateGrey,
                          ),
                        )
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCurrent
                                ? SneakerColors.cream
                                : SneakerColors.slateGrey,
                          ),
                        ),
            ),
          ),
          const SizedBox(height: SneakerSpacing.sm),

          // Step label
          if (!isMobile)
            AnimatedDefaultTextStyle(
              duration: SneakerAnimations.fast,
              style: TextStyle(
                fontFamily: SneakerTypography.fontFamily,
                fontSize: 11,
                fontWeight: isCurrent
                    ? SneakerTypography.bold
                    : SneakerTypography.medium,
                letterSpacing: 1,
                color: isCompleted || isCurrent
                    ? SneakerColors.cream
                    : SneakerColors.slateGrey,
              ),
              child: Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConnector({required bool isCompleted}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: AnimatedContainer(
          duration: SneakerAnimations.medium,
          height: 2,
          decoration: BoxDecoration(
            color: isCompleted
                ? SneakerColors.burgundy
                : SneakerColors.border,
            borderRadius: SneakerRadii.radiusFull,
          ),
        ),
      ),
    );
  }
}

/// **CheckoutStepperVertical**
///
/// Vertical variant of checkout stepper for sidebar layouts.
///
/// **Example Usage:**
/// ```dart
/// CheckoutStepperVertical(
///   currentStep: 1,
///   steps: ['Cart', 'Shipping', 'Payment', 'Confirm'],
/// )
/// ```
class CheckoutStepperVertical extends StatelessWidget {
  /// Current step index (0-based).
  final int currentStep;

  /// List of step labels.
  final List<String> steps;

  /// List of step descriptions (optional).
  final List<String>? descriptions;

  /// Callback when a step is tapped.
  final ValueChanged<int>? onStepTap;

  /// Creates a [CheckoutStepperVertical] with the specified parameters.
  const CheckoutStepperVertical({
    required this.currentStep,
    required this.steps,
    this.descriptions,
    this.onStepTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isEven) {
          final stepIndex = index ~/ 2;
          return _buildStep(
            index: stepIndex,
            label: steps[stepIndex],
            description: descriptions != null && descriptions!.length > stepIndex
                ? descriptions![stepIndex]
                : null,
          );
        } else {
          final beforeIndex = index ~/ 2;
          return _buildVerticalConnector(
            isCompleted: beforeIndex < currentStep,
          );
        }
      }),
    );
  }

  Widget _buildStep({
    required int index,
    required String label,
    String? description,
  }) {
    final isCompleted = index < currentStep;
    final isCurrent = index == currentStep;
    final canTap = isCompleted && onStepTap != null;

    return GestureDetector(
      onTap: canTap ? () => onStepTap!(index) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step circle
          AnimatedContainer(
            duration: SneakerAnimations.medium,
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted || isCurrent
                  ? SneakerColors.burgundy
                  : SneakerColors.surfaceDark,
              border: Border.all(
                color: isCompleted || isCurrent
                    ? SneakerColors.burgundy
                    : SneakerColors.border,
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: SneakerColors.cream,
                    )
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontFamily: SneakerTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: SneakerTypography.bold,
                        color: isCurrent
                            ? SneakerColors.cream
                            : SneakerColors.slateGrey,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: SneakerSpacing.md),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: SneakerTypography.fontFamily,
                      fontSize: 14,
                      fontWeight: isCurrent
                          ? SneakerTypography.bold
                          : SneakerTypography.medium,
                      color: isCompleted || isCurrent
                          ? SneakerColors.cream
                          : SneakerColors.slateGrey,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: SneakerTypography.fontFamily,
                        fontSize: 12,
                        color: SneakerColors.slateGrey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalConnector({required bool isCompleted}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: AnimatedContainer(
        duration: SneakerAnimations.medium,
        width: 2,
        height: 24,
        decoration: BoxDecoration(
          color: isCompleted
              ? SneakerColors.burgundy
              : SneakerColors.border,
          borderRadius: SneakerRadii.radiusFull,
        ),
      ),
    );
  }
}
