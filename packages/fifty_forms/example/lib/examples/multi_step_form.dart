import 'package:fifty_forms/fifty_forms.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// Multi-step wizard form demonstrating:
/// - FiftyMultiStepForm
/// - FormStep definitions
/// - Step validation
/// - Progress indicator
class MultiStepFormDemo extends StatefulWidget {
  const MultiStepFormDemo({super.key});

  @override
  State<MultiStepFormDemo> createState() => _MultiStepFormDemoState();
}

class _MultiStepFormDemoState extends State<MultiStepFormDemo> {
  late final FiftyFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FiftyFormController(
      initialValues: {
        // Step 1: Account
        'email': '',
        'password': '',
        // Step 2: Profile
        'displayName': '',
        'bio': '',
        // Step 3: Preferences
        'theme': 'dark',
        'notifications': true,
      },
      validators: {
        'email': [
          const Required(message: 'Email is required'),
          const Email(message: 'Enter a valid email'),
        ],
        'password': [
          const Required(message: 'Password is required'),
          const MinLength(8, message: 'At least 8 characters'),
        ],
        'displayName': [
          const Required(message: 'Display name is required'),
          const MinLength(2, message: 'At least 2 characters'),
          const MaxLength(30, message: 'At most 30 characters'),
        ],
        'bio': [
          const MaxLength(200, message: 'Bio must be under 200 characters'),
        ],
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleComplete(Map<String, dynamic> values) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Setup complete for ${values['displayName']}!'),
        backgroundColor: FiftyColors.hunterGreen,
      ),
    );

    // Return to home
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ACCOUNT SETUP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(FiftySpacing.xl),
        child: FiftyMultiStepForm(
          controller: _controller,
          steps: [
            FormStep(
              title: 'Account',
              description: 'Create your login credentials',
              fields: ['email', 'password'],
            ),
            FormStep(
              title: 'Profile',
              description: 'Tell us about yourself',
              fields: ['displayName', 'bio'],
            ),
            FormStep(
              title: 'Preferences',
              description: 'Customize your experience',
              fields: ['theme', 'notifications'],
              isOptional: true, // Preferences can be skipped
            ),
          ],
          stepBuilder: (context, stepIndex, step) {
            return _buildStepContent(stepIndex, step);
          },
          onComplete: _handleComplete,
          onStepChanged: (step) {
            debugPrint('Now on step ${step + 1}');
          },
          nextLabel: 'CONTINUE',
          previousLabel: 'BACK',
          completeLabel: 'FINISH SETUP',
          expandedButtons: true,
        ),
      ),
    );
  }

  Widget _buildStepContent(int stepIndex, FormStep step) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Step header
        _StepHeader(step: step),
        const SizedBox(height: FiftySpacing.xxxl),

        // Step content based on index
        switch (stepIndex) {
          0 => _AccountStep(controller: _controller),
          1 => _ProfileStep(controller: _controller),
          2 => _PreferencesStep(controller: _controller),
          _ => const SizedBox.shrink(),
        },
      ],
    );
  }
}

class _StepHeader extends StatelessWidget {
  final FormStep step;

  const _StepHeader({required this.step});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          step.title.toUpperCase(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: FiftyColors.cream,
                fontFamily: FiftyTypography.fontFamily,
                letterSpacing: 2,
              ),
          textAlign: TextAlign.center,
        ),
        if (step.description != null) ...[
          const SizedBox(height: FiftySpacing.sm),
          Text(
            step.description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: FiftyColors.slateGrey,
                ),
            textAlign: TextAlign.center,
          ),
        ],
        if (step.isOptional) ...[
          const SizedBox(height: FiftySpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FiftySpacing.md,
              vertical: FiftySpacing.xs,
            ),
            decoration: BoxDecoration(
              color: FiftyColors.slateGrey.withValues(alpha: 0.1),
              borderRadius: FiftyRadii.smRadius,
              border: Border.all(
                color: FiftyColors.slateGrey.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              'OPTIONAL',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelSmall,
                fontWeight: FiftyTypography.medium,
                letterSpacing: FiftyTypography.letterSpacingLabel,
                color: FiftyColors.slateGrey,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AccountStep extends StatelessWidget {
  final FiftyFormController controller;

  const _AccountStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FiftyTextFormField(
          name: 'email',
          controller: controller,
          label: 'EMAIL',
          hint: 'agent@fifty.ai',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          prefix: const Icon(Icons.email_outlined, size: 20),
        ),
        const SizedBox(height: FiftySpacing.lg),
        FiftyTextFormField(
          name: 'password',
          controller: controller,
          label: 'PASSWORD',
          hint: 'Create a password',
          obscureText: true,
          textInputAction: TextInputAction.done,
          prefix: const Icon(Icons.lock_outlined, size: 20),
        ),
        const SizedBox(height: FiftySpacing.lg),
        _InfoCard(
          icon: Icons.security,
          title: 'SECURE CONNECTION',
          message:
              'Your credentials are encrypted and transmitted securely.',
        ),
      ],
    );
  }
}

class _ProfileStep extends StatelessWidget {
  final FiftyFormController controller;

  const _ProfileStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FiftyTextFormField(
          name: 'displayName',
          controller: controller,
          label: 'DISPLAY NAME',
          hint: 'How should we call you?',
          textInputAction: TextInputAction.next,
          prefix: const Icon(Icons.badge_outlined, size: 20),
        ),
        const SizedBox(height: FiftySpacing.lg),
        FiftyTextFormField(
          name: 'bio',
          controller: controller,
          label: 'BIO',
          hint: 'Tell us about yourself (optional)',
          maxLines: 4,
          minLines: 3,
          prefix: const Icon(Icons.description_outlined, size: 20),
        ),
        const SizedBox(height: FiftySpacing.sm),
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final bio = controller.getValue<String>('bio') ?? '';
            final remaining = 200 - bio.length;
            return Text(
              '$remaining characters remaining',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelSmall,
                color: remaining < 20
                    ? FiftyColors.burgundy
                    : FiftyColors.slateGrey,
              ),
              textAlign: TextAlign.right,
            );
          },
        ),
      ],
    );
  }
}

class _PreferencesStep extends StatelessWidget {
  final FiftyFormController controller;

  const _PreferencesStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Theme selection using dropdown
        _SectionTitle(title: 'THEME'),
        const SizedBox(height: FiftySpacing.md),
        FiftyDropdownFormField<String>(
          name: 'theme',
          controller: controller,
          label: 'Select theme',
          items: const [
            FiftyDropdownItem(value: 'dark', label: 'Dark Mode'),
            FiftyDropdownItem(value: 'light', label: 'Light Mode'),
            FiftyDropdownItem(value: 'system', label: 'System Default'),
          ],
          initialValue: 'dark',
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Notifications
        _SectionTitle(title: 'NOTIFICATIONS'),
        const SizedBox(height: FiftySpacing.md),
        FiftySwitchFormField(
          name: 'notifications',
          controller: controller,
          label: 'Enable notifications',
        ),
        const SizedBox(height: FiftySpacing.xs),
        Text(
          'Receive updates and alerts',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            color: FiftyColors.slateGrey,
          ),
        ),
        const SizedBox(height: FiftySpacing.xl),

        _InfoCard(
          icon: Icons.tune,
          title: 'FULLY CUSTOMIZABLE',
          message: 'You can change these settings anytime from your profile.',
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.labelMedium,
        fontWeight: FiftyTypography.bold,
        letterSpacing: FiftyTypography.letterSpacingLabel,
        color: FiftyColors.slateGrey,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FiftySpacing.md),
      decoration: BoxDecoration(
        color: FiftyColors.darkBurgundy,
        borderRadius: FiftyRadii.lgRadius,
        border: Border.all(color: FiftyColors.borderDark),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: FiftyColors.burgundy.withValues(alpha: 0.2),
              borderRadius: FiftyRadii.smRadius,
            ),
            child: Icon(
              icon,
              color: FiftyColors.burgundy,
              size: 20,
            ),
          ),
          const SizedBox(width: FiftySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.labelSmall,
                    fontWeight: FiftyTypography.bold,
                    letterSpacing: FiftyTypography.letterSpacingLabel,
                    color: FiftyColors.cream,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: FiftyColors.slateGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
