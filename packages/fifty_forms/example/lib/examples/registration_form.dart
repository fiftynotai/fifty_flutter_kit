import 'package:fifty_forms/fifty_forms.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Complex registration form demonstrating:
/// - Multiple field types
/// - Multiple validators (Required, Email, MinLength, HasUppercase, etc.)
/// - Password confirmation with Custom validator
/// - Async validation (simulated email check)
/// - Draft persistence with DraftManager
class RegistrationFormDemo extends StatefulWidget {
  const RegistrationFormDemo({super.key});

  @override
  State<RegistrationFormDemo> createState() => _RegistrationFormDemoState();
}

class _RegistrationFormDemoState extends State<RegistrationFormDemo> {
  late final FiftyFormController _controller;
  late final DraftManager _draftManager;
  bool _draftRestored = false;

  @override
  void initState() {
    super.initState();
    _controller = FiftyFormController(
      initialValues: {
        'username': '',
        'email': '',
        'password': '',
        'confirmPassword': '',
        'agreeTerms': false,
      },
      validators: {
        'username': [
          const Required(message: 'Username is required'),
          const MinLength(3, message: 'At least 3 characters'),
          const MaxLength(20, message: 'At most 20 characters'),
          const AlphaNumeric(message: 'Only letters and numbers'),
        ],
        'email': [
          const Required(message: 'Email is required'),
          const Email(message: 'Enter a valid email'),
          // Simulated async validation for email availability
          AsyncCustom<String>(
            (value) async {
              if (value == null || value.isEmpty) return null;

              // Simulate API check
              await Future.delayed(const Duration(milliseconds: 800));

              // Simulate some emails being taken
              if (value.toLowerCase() == 'test@example.com' ||
                  value.toLowerCase() == 'admin@fifty.ai') {
                return 'This email is already registered';
              }
              return null;
            },
            debounce: const Duration(milliseconds: 500),
          ),
        ],
        'password': [
          const Required(message: 'Password is required'),
          const MinLength(8, message: 'At least 8 characters'),
          const HasUppercase(message: 'Include an uppercase letter'),
          const HasLowercase(message: 'Include a lowercase letter'),
          const HasNumber(message: 'Include a number'),
          const HasSpecialChar(message: 'Include a special character'),
        ],
        'confirmPassword': [
          const Required(message: 'Confirm your password'),
          // Custom validator to check password match
          Custom<String>((value) {
            if (value == null || value.isEmpty) return null;
            // Note: In real usage, you'd access the controller's password value
            // This demo shows the pattern - the actual comparison happens
            // in the step validator or via form-level validation
            return null;
          }),
        ],
        'agreeTerms': [
          Custom<bool>((value) {
            if (value != true) return 'You must agree to the terms';
            return null;
          }),
        ],
      },
    );

    // Set up draft persistence
    _draftManager = DraftManager(
      controller: _controller,
      key: 'registration_form',
      debounce: const Duration(seconds: 2),
    );

    // Start auto-save and restore any existing draft
    _initDraft();
  }

  Future<void> _initDraft() async {
    _draftManager.start();

    final restored = await _draftManager.restoreDraft();
    if (restored != null && mounted) {
      setState(() => _draftRestored = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Draft restored from previous session'),
          backgroundColor: FiftyColors.igrisGreen,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _draftManager.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    // Validate password match before submission
    final password = _controller.getValue<String>('password');
    final confirmPassword = _controller.getValue<String>('confirmPassword');

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: FiftyColors.crimsonPulse,
        ),
      );
      return;
    }

    await _controller.submit((values) async {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Clear draft on successful submission
      await _draftManager.clearDraft();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created for ${values['username']}!'),
          backgroundColor: FiftyColors.igrisGreen,
        ),
      );

      // Return to home
      Navigator.of(context).pop();
    });
  }

  Future<void> _clearDraft() async {
    await _draftManager.clearDraft();
    _controller.reset();
    setState(() => _draftRestored = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft cleared'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REGISTRATION'),
        centerTitle: true,
        actions: [
          if (_draftRestored)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear draft',
              onPressed: _clearDraft,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(FiftySpacing.xl),
        child: FiftyForm(
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'CREATE ACCOUNT',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: FiftyColors.terminalWhite,
                      fontFamily: FiftyTypography.fontFamilyHeadline,
                      letterSpacing: 2,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FiftySpacing.sm),
              Text(
                'Join the network with a new identity',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: FiftyColors.hyperChrome,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FiftySpacing.xxxl),

              // Username field
              FiftyTextFormField(
                name: 'username',
                controller: _controller,
                label: 'USERNAME',
                hint: 'Choose a username',
                textInputAction: TextInputAction.next,
                prefix: const Icon(Icons.person_outline, size: 20),
              ),
              const SizedBox(height: FiftySpacing.lg),

              // Email field (with async validation)
              FiftyTextFormField(
                name: 'email',
                controller: _controller,
                label: 'EMAIL',
                hint: 'agent@fifty.ai',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefix: const Icon(Icons.email_outlined, size: 20),
              ),
              _AsyncValidationHint(),
              const SizedBox(height: FiftySpacing.lg),

              // Password field
              FiftyTextFormField(
                name: 'password',
                controller: _controller,
                label: 'PASSWORD',
                hint: 'Create a strong password',
                obscureText: true,
                textInputAction: TextInputAction.next,
                prefix: const Icon(Icons.lock_outlined, size: 20),
              ),
              const SizedBox(height: FiftySpacing.sm),
              _PasswordRequirements(controller: _controller),
              const SizedBox(height: FiftySpacing.lg),

              // Confirm password field
              FiftyTextFormField(
                name: 'confirmPassword',
                controller: _controller,
                label: 'CONFIRM PASSWORD',
                hint: 'Re-enter your password',
                obscureText: true,
                textInputAction: TextInputAction.next,
                prefix: const Icon(Icons.lock_outline, size: 20),
              ),
              const SizedBox(height: FiftySpacing.xl),

              // Terms checkbox
              FiftyCheckboxFormField(
                name: 'agreeTerms',
                controller: _controller,
                label: 'I agree to the Terms of Service and Privacy Policy',
              ),
              const SizedBox(height: FiftySpacing.xxxl),

              // Submit button
              FiftySubmitButton(
                controller: _controller,
                label: 'CREATE ACCOUNT',
                loadingText: 'CREATING',
                onPressed: _handleSubmit,
                expanded: true,
                disableWhenInvalid: false, // Allow submission to show all errors
              ),
              const SizedBox(height: FiftySpacing.lg),

              // Draft indicator
              if (_draftRestored)
                Container(
                  padding: const EdgeInsets.all(FiftySpacing.md),
                  decoration: BoxDecoration(
                    color: FiftyColors.igrisGreen.withValues(alpha: 0.1),
                    borderRadius: FiftyRadii.lgRadius,
                    border: Border.all(
                      color: FiftyColors.igrisGreen.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.save_outlined,
                        color: FiftyColors.igrisGreen,
                        size: 16,
                      ),
                      const SizedBox(width: FiftySpacing.sm),
                      Text(
                        'Auto-saving draft...',
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: FiftyTypography.bodySmall,
                          color: FiftyColors.igrisGreen,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AsyncValidationHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: FiftySpacing.xs),
      child: Text(
        'Try "test@example.com" to see async validation',
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontSize: FiftyTypography.labelSmall,
          color: FiftyColors.hyperChrome.withValues(alpha: 0.6),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _PasswordRequirements extends StatelessWidget {
  final FiftyFormController controller;

  const _PasswordRequirements({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final password = controller.getValue<String>('password') ?? '';

        return Container(
          padding: const EdgeInsets.all(FiftySpacing.md),
          decoration: BoxDecoration(
            color: FiftyColors.voidBlack,
            borderRadius: FiftyRadii.lgRadius,
            border: Border.all(color: FiftyColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PASSWORD REQUIREMENTS',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.labelSmall,
                  fontWeight: FiftyTypography.bold,
                  letterSpacing: FiftyTypography.letterSpacingLabel,
                  color: FiftyColors.hyperChrome,
                ),
              ),
              const SizedBox(height: FiftySpacing.sm),
              _RequirementRow(
                label: 'At least 8 characters',
                isMet: password.length >= 8,
              ),
              _RequirementRow(
                label: 'One uppercase letter',
                isMet: password.contains(RegExp(r'[A-Z]')),
              ),
              _RequirementRow(
                label: 'One lowercase letter',
                isMet: password.contains(RegExp(r'[a-z]')),
              ),
              _RequirementRow(
                label: 'One number',
                isMet: password.contains(RegExp(r'[0-9]')),
              ),
              _RequirementRow(
                label: 'One special character',
                isMet: password
                    .contains(RegExp(r'''[!@#$%^&*(),.?":{}|<>~`\-_+=\[\];'/\\]''')),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String label;
  final bool isMet;

  const _RequirementRow({
    required this.label,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            size: 14,
            color: isMet ? FiftyColors.igrisGreen : FiftyColors.hyperChrome,
          ),
          const SizedBox(width: FiftySpacing.sm),
          Text(
            label,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: isMet ? FiftyColors.terminalWhite : FiftyColors.hyperChrome,
            ),
          ),
        ],
      ),
    );
  }
}
