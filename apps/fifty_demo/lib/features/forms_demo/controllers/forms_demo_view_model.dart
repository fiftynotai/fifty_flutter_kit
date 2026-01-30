/// Forms Demo ViewModel
///
/// Business logic for the forms demo feature.
/// Demonstrates form validation and field management.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Form field types for the demo.
enum FormFieldType {
  /// Text input field.
  text,

  /// Email input field.
  email,

  /// Password input field.
  password,

  /// Number input field.
  number,

  /// Phone input field.
  phone,
}

/// Validation result.
class ValidationResult {
  /// Creates a validation result.
  const ValidationResult({
    required this.isValid,
    this.errorMessage,
  });

  /// Whether validation passed.
  final bool isValid;

  /// Error message if validation failed.
  final String? errorMessage;

  /// Valid result constant.
  static const valid = ValidationResult(isValid: true);

  /// Creates an invalid result with error message.
  static ValidationResult invalid(String message) =>
      ValidationResult(isValid: false, errorMessage: message);
}

/// ViewModel for the forms demo feature.
///
/// Manages form state and validation.
class FormsDemoViewModel extends GetxController {
  /// Text controllers for form fields.
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final ageController = TextEditingController();

  /// Whether the form has been submitted.
  final _isSubmitted = false.obs;
  bool get isSubmitted => _isSubmitted.value;

  /// Whether form is currently submitting.
  final _isSubmitting = false.obs;
  bool get isSubmitting => _isSubmitting.value;

  /// Whether password is visible.
  final _passwordVisible = false.obs;
  bool get passwordVisible => _passwordVisible.value;

  /// Whether confirm password is visible.
  final _confirmPasswordVisible = false.obs;
  bool get confirmPasswordVisible => _confirmPasswordVisible.value;

  /// Submitted form data.
  final _submittedData = Rxn<Map<String, String>>();
  Map<String, String>? get submittedData => _submittedData.value;

  // ---------------------------------------------------------------------------
  // Error States (null means no error)
  // ---------------------------------------------------------------------------

  String? _nameError;
  /// Error message for name field.
  String? get nameError => _nameError;

  String? _emailError;
  /// Error message for email field.
  String? get emailError => _emailError;

  String? _passwordError;
  /// Error message for password field.
  String? get passwordError => _passwordError;

  String? _confirmPasswordError;
  /// Error message for confirm password field.
  String? get confirmPasswordError => _confirmPasswordError;

  String? _phoneError;
  /// Error message for phone field.
  String? get phoneError => _phoneError;

  String? _ageError;
  /// Error message for age field.
  String? get ageError => _ageError;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    ageController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Visibility Toggles
  // ---------------------------------------------------------------------------

  /// Toggles password visibility.
  void togglePasswordVisibility() {
    _passwordVisible.value = !_passwordVisible.value;
    update();
  }

  /// Toggles confirm password visibility.
  void toggleConfirmPasswordVisibility() {
    _confirmPasswordVisible.value = !_confirmPasswordVisible.value;
    update();
  }

  // ---------------------------------------------------------------------------
  // Validators
  // ---------------------------------------------------------------------------

  /// Validates required field.
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates name field.
  String? validateName(String? value) {
    final required = validateRequired(value, 'Name');
    if (required != null) return required;

    if (value!.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  /// Validates email field.
  String? validateEmail(String? value) {
    final required = validateRequired(value, 'Email');
    if (required != null) return required;

    if (!GetUtils.isEmail(value!.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates password field.
  String? validatePassword(String? value) {
    final required = validateRequired(value, 'Password');
    if (required != null) return required;

    if (value!.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validates confirm password field.
  String? validateConfirmPassword(String? value) {
    final required = validateRequired(value, 'Confirm password');
    if (required != null) return required;

    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates phone field.
  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.length < 10) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validates age field.
  String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid number';
    }

    if (age < 13) {
      return 'You must be at least 13 years old';
    }

    if (age > 120) {
      return 'Please enter a valid age';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Form Actions
  // ---------------------------------------------------------------------------

  /// Submits the form.
  Future<bool> submitForm() async {
    // Validate all fields and set errors
    _nameError = validateName(nameController.text);
    _emailError = validateEmail(emailController.text);
    _passwordError = validatePassword(passwordController.text);
    _confirmPasswordError = validateConfirmPassword(confirmPasswordController.text);
    _phoneError = validatePhone(phoneController.text);
    _ageError = validateAge(ageController.text);
    update();

    // Check if any required field has error
    final hasErrors = _nameError != null ||
        _emailError != null ||
        _passwordError != null ||
        _confirmPasswordError != null;

    if (hasErrors) {
      return false;
    }

    _isSubmitting.value = true;
    update();

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    _submittedData.value = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'age': ageController.text.trim(),
    };

    _isSubmitted.value = true;
    _isSubmitting.value = false;
    update();

    return true;
  }

  /// Resets the form.
  void resetForm() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    phoneController.clear();
    ageController.clear();

    _isSubmitted.value = false;
    _submittedData.value = null;
    _passwordVisible.value = false;
    _confirmPasswordVisible.value = false;

    // Clear all error states
    _nameError = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _phoneError = null;
    _ageError = null;

    update();
  }

  // ---------------------------------------------------------------------------
  // Password Strength
  // ---------------------------------------------------------------------------

  /// Gets password strength (0.0 to 1.0).
  double get passwordStrength {
    final password = passwordController.text;
    if (password.isEmpty) return 0.0;

    var strength = 0.0;

    // Length
    if (password.length >= 8) strength += 0.25;
    if (password.length >= 12) strength += 0.15;

    // Uppercase
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;

    // Lowercase
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.1;

    // Numbers
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.15;

    // Special characters
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.15;

    return strength.clamp(0.0, 1.0);
  }

  /// Gets password strength label.
  String get passwordStrengthLabel {
    final strength = passwordStrength;
    if (strength == 0) return '';
    if (strength < 0.3) return 'Weak';
    if (strength < 0.6) return 'Fair';
    if (strength < 0.8) return 'Good';
    return 'Strong';
  }

  /// Gets password strength color.
  ///
  /// Accepts theme parameters for theme-aware colors.
  Color getPasswordStrengthColor(
    double strength,
    ColorScheme colorScheme,
    FiftyThemeExtension? fiftyTheme,
  ) {
    if (strength < 0.3) return colorScheme.primary;
    if (strength < 0.6) return fiftyTheme?.warning ?? colorScheme.error;
    if (strength < 0.8) return colorScheme.onSurfaceVariant;
    return fiftyTheme?.success ?? colorScheme.tertiary;
  }
}
