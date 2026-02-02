/// Forms Demo Page
///
/// Demonstrates form validation and field management.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../actions/forms_demo_actions.dart';
import '../controllers/forms_demo_view_model.dart';

/// Forms demo page widget.
///
/// Shows registration form with validation.
class FormsDemoPage extends GetView<FormsDemoViewModel> {
  /// Creates a forms demo page.
  const FormsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FormsDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<FormsDemoActions>();

        return DemoScaffold(
          title: 'Fifty Forms',
          child: viewModel.isSubmitted
              ? _buildSuccessView(context, viewModel, actions)
              : _buildFormView(context, viewModel, actions),
        );
      },
    );
  }

  Widget _buildFormView(
    BuildContext context,
    FormsDemoViewModel viewModel,
    FormsDemoActions actions,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const FiftySectionHeader(
            title: 'Registration Form',
            subtitle: 'Demo of fifty_forms validation',
          ),

          // Name Field
          FiftyTextField(
            label: 'FULL NAME *',
            hint: 'Enter your full name',
            controller: viewModel.nameController,
            prefix: const Icon(Icons.person_outline),
            errorText: viewModel.nameError,
            onChanged: (_) => viewModel.update(),
          ),
          const SizedBox(height: FiftySpacing.md),

          // Email Field
          FiftyTextField(
            label: 'EMAIL ADDRESS *',
            hint: 'Enter your email',
            controller: viewModel.emailController,
            prefix: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            errorText: viewModel.emailError,
            onChanged: (_) => viewModel.update(),
          ),
          const SizedBox(height: FiftySpacing.md),

          // Password Field
          Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;
              return FiftyTextField(
                label: 'PASSWORD *',
                hint: 'Enter a strong password',
                controller: viewModel.passwordController,
                prefix: const Icon(Icons.lock_outline),
                suffix: IconButton(
                  icon: Icon(
                    viewModel.passwordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: actions.onTogglePasswordVisibility,
                ),
                obscureText: !viewModel.passwordVisible,
                errorText: viewModel.passwordError,
                onChanged: (_) => viewModel.update(),
              );
            },
          ),

          // Password strength indicator
          if (viewModel.passwordController.text.isNotEmpty) ...[
            const SizedBox(height: FiftySpacing.sm),
            _buildPasswordStrength(context, viewModel),
          ],
          const SizedBox(height: FiftySpacing.md),

          // Confirm Password Field
          Builder(
            builder: (context) {
              final colorScheme = Theme.of(context).colorScheme;
              return FiftyTextField(
                label: 'CONFIRM PASSWORD *',
                hint: 'Re-enter your password',
                controller: viewModel.confirmPasswordController,
                prefix: const Icon(Icons.lock_outline),
                suffix: IconButton(
                  icon: Icon(
                    viewModel.confirmPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onPressed: actions.onToggleConfirmPasswordVisibility,
                ),
                obscureText: !viewModel.confirmPasswordVisible,
                errorText: viewModel.confirmPasswordError,
                onChanged: (_) => viewModel.update(),
              );
            },
          ),
          const SizedBox(height: FiftySpacing.md),

          // Phone Field (Optional)
          FiftyTextField(
            label: 'PHONE NUMBER',
            hint: 'Enter your phone number',
            controller: viewModel.phoneController,
            prefix: const Icon(Icons.phone_outlined),
            keyboardType: TextInputType.phone,
            errorText: viewModel.phoneError,
            onChanged: (_) => viewModel.update(),
          ),
          const SizedBox(height: FiftySpacing.md),

          // Age Field (Optional)
          FiftyTextField(
            label: 'AGE',
            hint: 'Enter your age',
            controller: viewModel.ageController,
            prefix: const Icon(Icons.cake_outlined),
            keyboardType: TextInputType.number,
            errorText: viewModel.ageError,
            onChanged: (_) => viewModel.update(),
          ),
          const SizedBox(height: FiftySpacing.xl),

          // Submit Button
          SizedBox(
            width: double.infinity,
            child: FiftyButton(
              label: viewModel.isSubmitting ? 'SUBMITTING...' : 'REGISTER',
              variant: FiftyButtonVariant.primary,
              loading: viewModel.isSubmitting,
              onPressed: viewModel.isSubmitting
                  ? null
                  : () => actions.onSubmitTapped(context),
            ),
          ),
          const SizedBox(height: FiftySpacing.lg),

          // Form info
          _buildFormInfo(context),
        ],
      ),
    );
  }

  Widget _buildPasswordStrength(BuildContext context, FormsDemoViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final strengthColor = viewModel.getPasswordStrengthColor(
      viewModel.passwordStrength,
      colorScheme,
      fiftyTheme,
    );

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: FiftyRadii.smRadius,
              child: LinearProgressIndicator(
                value: viewModel.passwordStrength,
                backgroundColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
                minHeight: 4,
              ),
            ),
          ),
          const SizedBox(width: FiftySpacing.md),
          Text(
            viewModel.passwordStrengthLabel.toUpperCase(),
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FontWeight.bold,
              color: strengthColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormInfo(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                size: 16,
              ),
              const SizedBox(width: FiftySpacing.sm),
              Text(
                'VALIDATION RULES',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.sm),
          _buildInfoItem(context, 'Name: 2+ characters, letters only'),
          _buildInfoItem(context, 'Email: Valid email format'),
          _buildInfoItem(context, 'Password: 8+ chars, uppercase, lowercase, number'),
          _buildInfoItem(context, 'Phone & Age: Optional fields'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: FiftySpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u2022',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(
    BuildContext context,
    FormsDemoViewModel viewModel,
    FormsDemoActions actions,
  ) {
    final data = viewModel.submittedData ?? {};
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Success Header
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: successColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: successColor,
                    size: 48,
                  ),
                ),
                const SizedBox(height: FiftySpacing.lg),
                Text(
                  'REGISTRATION COMPLETE!',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.titleLarge,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: FiftySpacing.sm),
                Text(
                  'Your form has been submitted successfully.',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyMedium,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: FiftySpacing.xl),

          // Submitted Data
          const FiftySectionHeader(
            title: 'Submitted Data',
            subtitle: 'Form values captured',
          ),
          FiftyCard(
            padding: const EdgeInsets.all(FiftySpacing.md),
            child: Column(
              children: [
                _buildDataRow(context, 'Name', data['name'] ?? '-'),
                _buildDataRow(context, 'Email', data['email'] ?? '-'),
                _buildDataRow(context, 'Phone', data['phone']?.isNotEmpty == true
                    ? data['phone']!
                    : 'Not provided'),
                _buildDataRow(context, 'Age', data['age']?.isNotEmpty == true
                    ? data['age']!
                    : 'Not provided'),
              ],
            ),
          ),
          const SizedBox(height: FiftySpacing.xl),

          // Register Again Button
          SizedBox(
            width: double.infinity,
            child: FiftyButton(
              label: 'REGISTER ANOTHER',
              variant: FiftyButtonVariant.secondary,
              onPressed: () => actions.onResetTapped(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FiftySpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyMedium,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
