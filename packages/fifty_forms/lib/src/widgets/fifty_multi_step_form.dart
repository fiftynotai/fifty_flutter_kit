import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import '../models/form_step.dart';
import 'fifty_form_progress.dart';

/// Multi-step wizard form with step navigation and validation.
///
/// Validates current step before allowing navigation to next step.
/// Provides callbacks for step changes and completion.
///
/// **Example:**
/// ```dart
/// FiftyMultiStepForm(
///   controller: formController,
///   steps: [
///     FormStep(title: 'Account', fields: ['email', 'password']),
///     FormStep(title: 'Profile', fields: ['name', 'phone']),
///     FormStep(title: 'Review', fields: []),
///   ],
///   stepBuilder: (context, index, step) => _buildStepContent(index),
///   onComplete: (values) => api.createUser(values),
///   onStepChanged: (step) => print('Now on step $step'),
/// )
/// ```
class FiftyMultiStepForm extends StatefulWidget {
  /// Form controller for state management.
  final FiftyFormController controller;

  /// Steps in the wizard.
  final List<FormStep> steps;

  /// Builder for each step's content.
  ///
  /// Receives the build context, step index (0-indexed), and step definition.
  final Widget Function(BuildContext context, int stepIndex, FormStep step)
      stepBuilder;

  /// Called when form is completed (all steps validated).
  ///
  /// Receives all form field values. Return a Future that completes
  /// when submission is done.
  final Future<void> Function(Map<String, dynamic> values)? onComplete;

  /// Called when current step changes.
  ///
  /// Receives the new step index (0-indexed).
  final void Function(int stepIndex)? onStepChanged;

  /// Whether to show progress indicator.
  ///
  /// Defaults to true.
  final bool showProgress;

  /// Custom progress indicator builder.
  ///
  /// If not provided, uses [FiftyFormProgress] with step titles.
  /// Receives current step (0-indexed), total steps, and step definitions.
  final Widget Function(int current, int total, List<FormStep> steps)?
      progressBuilder;

  /// Whether to validate before going to next step.
  ///
  /// When true, all fields in the current step must be valid before
  /// advancing. Defaults to true.
  final bool validateOnNext;

  /// Custom "Next" button label.
  ///
  /// Defaults to 'NEXT'.
  final String nextLabel;

  /// Custom "Previous" button label.
  ///
  /// Defaults to 'BACK'.
  final String previousLabel;

  /// Custom "Complete" button label (shown on last step).
  ///
  /// Defaults to 'COMPLETE'.
  final String completeLabel;

  /// Padding around the form content.
  ///
  /// Does not affect progress indicator or navigation buttons.
  final EdgeInsets? padding;

  /// Whether navigation buttons should expand to fill width.
  ///
  /// Defaults to false.
  final bool expandedButtons;

  /// Creates a multi-step wizard form.
  const FiftyMultiStepForm({
    super.key,
    required this.controller,
    required this.steps,
    required this.stepBuilder,
    this.onComplete,
    this.onStepChanged,
    this.showProgress = true,
    this.progressBuilder,
    this.validateOnNext = true,
    this.nextLabel = 'NEXT',
    this.previousLabel = 'BACK',
    this.completeLabel = 'COMPLETE',
    this.padding,
    this.expandedButtons = false,
  });

  @override
  State<FiftyMultiStepForm> createState() => _FiftyMultiStepFormState();
}

class _FiftyMultiStepFormState extends State<FiftyMultiStepForm> {
  int _currentStep = 0;
  bool _isSubmitting = false;
  String? _stepError;

  /// Whether we're on the first step.
  bool get isFirstStep => _currentStep == 0;

  /// Whether we're on the last step.
  bool get isLastStep => _currentStep == widget.steps.length - 1;

  /// The current step definition.
  FormStep get currentFormStep => widget.steps[_currentStep];

  /// Advances to the next step or completes the form.
  ///
  /// Validates current step if [validateOnNext] is true.
  Future<void> nextStep() async {
    if (isLastStep) {
      await _complete();
      return;
    }

    if (widget.validateOnNext) {
      final isValid = await _validateCurrentStep();
      if (!isValid) return;
    }

    setState(() {
      _currentStep++;
      _stepError = null;
    });
    widget.onStepChanged?.call(_currentStep);
  }

  /// Goes back to the previous step.
  ///
  /// Does nothing if already on the first step.
  void previousStep() {
    if (isFirstStep) return;
    setState(() {
      _currentStep--;
      _stepError = null;
    });
    widget.onStepChanged?.call(_currentStep);
  }

  /// Jumps directly to a specific step.
  ///
  /// Does not validate the current step before jumping.
  /// [index] must be between 0 and steps.length - 1.
  void goToStep(int index) {
    if (index < 0 || index >= widget.steps.length) return;
    if (index == _currentStep) return;

    setState(() {
      _currentStep = index;
      _stepError = null;
    });
    widget.onStepChanged?.call(_currentStep);
  }

  /// Validates all fields in the current step.
  ///
  /// Returns true if all field validators pass and the step-level
  /// validator (if provided) passes.
  Future<bool> _validateCurrentStep() async {
    final step = currentFormStep;

    // Skip validation for optional steps if all fields are empty
    if (step.isOptional) {
      bool allEmpty = true;
      for (final fieldName in step.fields) {
        final value = widget.controller.getValue(fieldName);
        if (value != null && value.toString().isNotEmpty) {
          allEmpty = false;
          break;
        }
      }
      if (allEmpty) return true;
    }

    // Validate all fields in the current step
    bool allValid = true;
    for (final fieldName in step.fields) {
      final isFieldValid = await widget.controller.validateField(fieldName);
      if (!isFieldValid) allValid = false;
    }

    if (!allValid) {
      setState(() => _stepError = null);
      return false;
    }

    // Run step-level validator if provided
    if (step.validator != null) {
      final error = step.validator!(widget.controller.values);
      if (error != null) {
        setState(() => _stepError = error);
        return false;
      }
    }

    setState(() => _stepError = null);
    return true;
  }

  /// Completes the form after validating the last step.
  Future<void> _complete() async {
    final isValid = await _validateCurrentStep();
    if (!isValid) return;

    if (widget.onComplete != null) {
      setState(() => _isSubmitting = true);
      try {
        await widget.onComplete!(widget.controller.values);
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Progress indicator
        if (widget.showProgress)
          SliverToBoxAdapter(
            child: widget.progressBuilder
                    ?.call(_currentStep, widget.steps.length, widget.steps) ??
                FiftyFormProgress(
                  currentStep: _currentStep + 1,
                  totalSteps: widget.steps.length,
                  stepLabels: widget.steps.map((s) => s.title).toList(),
                ),
          ),

        if (widget.showProgress)
          const SliverToBoxAdapter(
            child: SizedBox(height: FiftySpacing.lg),
          ),

        // Step error message
        if (_stepError != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: FiftySpacing.md),
              child: _StepErrorMessage(error: _stepError!),
            ),
          ),

        // Step content
        SliverToBoxAdapter(
          child: Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: widget.stepBuilder(context, _currentStep, currentFormStep),
          ),
        ),

        // Spacer
        const SliverToBoxAdapter(
          child: SizedBox(height: FiftySpacing.lg),
        ),

        // Navigation buttons
        SliverToBoxAdapter(
          child: _buildNavigationButtons(),
        ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: FiftySpacing.lg),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    if (widget.expandedButtons) {
      // Expanded buttons layout
      return Row(
        children: [
          if (!isFirstStep) ...[
            Expanded(
              child: FiftyButton(
                onPressed: _isSubmitting ? null : previousStep,
                variant: FiftyButtonVariant.ghost,
                label: widget.previousLabel,
                expanded: true,
              ),
            ),
            const SizedBox(width: FiftySpacing.md),
          ],
          Expanded(
            child: FiftyButton(
              onPressed: _isSubmitting ? null : nextStep,
              variant: FiftyButtonVariant.primary,
              label: isLastStep ? widget.completeLabel : widget.nextLabel,
              loading: _isSubmitting,
              expanded: true,
            ),
          ),
        ],
      );
    }

    // Non-expanded buttons layout
    return Row(
      children: [
        if (!isFirstStep)
          FiftyButton(
            onPressed: _isSubmitting ? null : previousStep,
            variant: FiftyButtonVariant.ghost,
            label: widget.previousLabel,
          ),
        const Spacer(),
        FiftyButton(
          onPressed: _isSubmitting ? null : nextStep,
          variant: FiftyButtonVariant.primary,
          label: isLastStep ? widget.completeLabel : widget.nextLabel,
          loading: _isSubmitting,
        ),
      ],
    );
  }
}

/// Displays step-level validation errors.
class _StepErrorMessage extends StatelessWidget {
  final String error;

  const _StepErrorMessage({required this.error});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(FiftySpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.error.withValues(alpha: 0.1),
        borderRadius: FiftyRadii.lgRadius,
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: Text(
              error,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
