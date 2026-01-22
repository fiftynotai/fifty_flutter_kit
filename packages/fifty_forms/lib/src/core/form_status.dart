/// Form lifecycle status.
///
/// Represents the current state of a form during its lifecycle,
/// from idle to submitted or error.
///
/// **State Transitions:**
/// ```
/// idle -> validating -> submitting -> submitted
///                    \            \-> error
///                     \-> error
/// ```
enum FormStatus {
  /// Form is idle, ready for input.
  ///
  /// This is the initial state and the state after reset.
  idle,

  /// Form is validating fields.
  ///
  /// This state is active during async validation.
  validating,

  /// Form is being submitted.
  ///
  /// This state is active during the submit callback execution.
  submitting,

  /// Form was submitted successfully.
  ///
  /// This state indicates the form has completed submission.
  submitted,

  /// Form submission failed.
  ///
  /// This state indicates an error occurred during validation
  /// or submission.
  error,
}

/// Extension methods for [FormStatus].
extension FormStatusExtension on FormStatus {
  /// Whether the form is in a loading state (validating or submitting).
  bool get isLoading =>
      this == FormStatus.validating || this == FormStatus.submitting;

  /// Whether the form can accept input (idle or error).
  bool get canInput => this == FormStatus.idle || this == FormStatus.error;

  /// Whether the form has completed (submitted or error).
  bool get isComplete =>
      this == FormStatus.submitted || this == FormStatus.error;
}
