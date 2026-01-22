import 'package:fifty_forms/fifty_forms.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Simple login form demonstrating:
/// - FiftyFormController
/// - FiftyTextFormField for email/password
/// - Required, Email validators
/// - FiftySubmitButton
class LoginFormDemo extends StatefulWidget {
  const LoginFormDemo({super.key});

  @override
  State<LoginFormDemo> createState() => _LoginFormDemoState();
}

class _LoginFormDemoState extends State<LoginFormDemo> {
  late final FiftyFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FiftyFormController(
      initialValues: {
        'email': '',
        'password': '',
      },
      validators: {
        'email': [
          const Required(message: 'Email is required'),
          const Email(message: 'Enter a valid email'),
        ],
        'password': [
          const Required(message: 'Password is required'),
          const MinLength(6, message: 'Password must be at least 6 characters'),
        ],
      },
      onValidationChanged: (isValid) {
        debugPrint('Form is ${isValid ? 'valid' : 'invalid'}');
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    await _controller.submit((values) async {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful: ${values['email']}'),
          backgroundColor: FiftyColors.igrisGreen,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN FORM'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(FiftySpacing.xl),
        child: FiftyForm(
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const SizedBox(height: FiftySpacing.xxxl),
              Text(
                'ESTABLISH UPLINK',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: FiftyColors.terminalWhite,
                      fontFamily: FiftyTypography.fontFamilyHeadline,
                      letterSpacing: 2,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FiftySpacing.sm),
              Text(
                'Enter your credentials to continue',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: FiftyColors.hyperChrome,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FiftySpacing.xxxl),

              // Email field
              FiftyTextFormField(
                name: 'email',
                controller: _controller,
                label: 'EMAIL',
                hint: 'agent@fifty.ai',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                prefix: const Icon(Icons.email_outlined, size: 20),
              ),
              const SizedBox(height: FiftySpacing.lg),

              // Password field
              FiftyTextFormField(
                name: 'password',
                controller: _controller,
                label: 'PASSWORD',
                hint: 'Enter password',
                obscureText: true,
                textInputAction: TextInputAction.done,
                prefix: const Icon(Icons.lock_outlined, size: 20),
                onSubmitted: (_) => _handleSubmit(),
              ),
              const SizedBox(height: FiftySpacing.xxxl),

              // Submit button
              FiftySubmitButton(
                controller: _controller,
                label: 'ESTABLISH UPLINK',
                loadingText: 'CONNECTING',
                onPressed: _handleSubmit,
                expanded: true,
                isGlitch: true,
              ),
              const SizedBox(height: FiftySpacing.lg),

              // Form status indicator
              ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  return _StatusIndicator(
                    isDirty: _controller.isDirty,
                    isValid: _controller.isValid,
                    status: _controller.status,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final bool isDirty;
  final bool isValid;
  final FormStatus status;

  const _StatusIndicator({
    required this.isDirty,
    required this.isValid,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
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
            'FORM STATUS',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelSmall,
              fontWeight: FiftyTypography.bold,
              letterSpacing: FiftyTypography.letterSpacingLabel,
              color: FiftyColors.hyperChrome,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
          Row(
            children: [
              _StatusChip(
                label: 'DIRTY',
                isActive: isDirty,
              ),
              const SizedBox(width: FiftySpacing.sm),
              _StatusChip(
                label: 'VALID',
                isActive: isValid,
                activeColor: FiftyColors.igrisGreen,
              ),
              const SizedBox(width: FiftySpacing.sm),
              _StatusChip(
                label: status.name.toUpperCase(),
                isActive: status == FormStatus.submitting,
                activeColor: FiftyColors.crimsonPulse,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;

  const _StatusChip({
    required this.label,
    required this.isActive,
    this.activeColor = FiftyColors.terminalWhite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.sm,
        vertical: FiftySpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isActive ? activeColor.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: FiftyRadii.smRadius,
        border: Border.all(
          color: isActive ? activeColor : FiftyColors.border,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontSize: 10,
          fontWeight: FiftyTypography.medium,
          color: isActive ? activeColor : FiftyColors.hyperChrome,
        ),
      ),
    );
  }
}
