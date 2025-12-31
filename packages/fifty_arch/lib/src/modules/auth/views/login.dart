import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/utils/form_validators.dart';
import '/src/modules/auth/auth.dart';

/// **LoginPage**
///
/// FDL-styled login form with Orbital Command "ESTABLISH UPLINK" theme.
/// Kinetic Brutalism aesthetic with space-themed terminology.
///
/// **FDL Aesthetic:**
/// - Void Black background (#050505)
/// - FiftyCard with gunmetal background and border
/// - Monument Extended for headlines, JetBrains Mono for body
/// - Crimson Pulse primary action button
/// - Terminal-style text fields
///
/// **Features:**
/// - Form validation at view level
/// - Business flow delegated to AuthActions/AuthViewModel
/// - Responsive design
///
/// **Side Effects:**
/// - On submit, saves form fields into [AuthViewModel] and triggers the action
///   handler which shows a loader overlay and error feedback
///
/// // ----------------------------------------------------
class LoginPage extends GetWidget<AuthViewModel> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordVisible = false.obs;

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: FiftySpacing.lg,
            vertical: FiftySpacing.xxl,
          ),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.08),

              // Operator Access title
              Text(
                'OPERATOR ACCESS',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyHeadline,
                  fontSize: FiftyTypography.display,
                  fontWeight: FiftyTypography.ultrabold,
                  color: colorScheme.onSurface,
                  letterSpacing: 4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: FiftySpacing.sm),

              // Establish Uplink subtitle
              Text(
                'ESTABLISH UPLINK',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: FiftyTypography.body,
                  fontWeight: FiftyTypography.regular,
                  color: FiftyColors.crimsonPulse,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: FiftySpacing.xxxl),

              // Login form wrapped in FiftyCard
              FiftyCard(
                padding: const EdgeInsets.all(FiftySpacing.xxl),
                scanlineOnHover: false,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Username field
                      _buildFdlFormField(
                        context,
                        controller: _usernameController,
                        label: 'OPERATOR ID',
                        hint: 'Enter operator ID',
                        validator: FormValidators.username,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: FiftySpacing.lg),

                      // Password field with visibility toggle
                      Obx(() => _buildFdlFormField(
                            context,
                            controller: _passwordController,
                            label: 'ACCESS CODE',
                            hint: 'Enter access code',
                            validator: FormValidators.password,
                            textInputAction: TextInputAction.done,
                            obscureText: !_passwordVisible.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: FiftyColors.hyperChrome,
                                size: 20,
                              ),
                              onPressed: () =>
                                  _passwordVisible.value = !_passwordVisible.value,
                            ),
                          )),

                      const SizedBox(height: FiftySpacing.xxl),

                      // Login button
                      FiftyButton(
                        label: 'ESTABLISH UPLINK',
                        onPressed: () => _login(context),
                        variant: FiftyButtonVariant.primary,
                        size: FiftyButtonSize.large,
                        expanded: true,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: FiftySpacing.xxl),

              // Request Access link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'NO CREDENTIALS? ',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.body,
                      fontWeight: FiftyTypography.regular,
                      color: FiftyColors.hyperChrome,
                    ),
                  ),
                  GestureDetector(
                    onTap: AuthActions.instance.toRegisterPage,
                    child: Text(
                      'REQUEST ACCESS',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamilyMono,
                        fontSize: FiftyTypography.body,
                        fontWeight: FiftyTypography.medium,
                        color: FiftyColors.crimsonPulse,
                        decoration: TextDecoration.underline,
                        decorationColor: FiftyColors.crimsonPulse,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: FiftySpacing.huge),

              // System status indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: FiftyColors.igrisGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  Text(
                    'SYSTEM ONLINE',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.mono,
                      fontWeight: FiftyTypography.regular,
                      color: FiftyColors.igrisGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a FDL-styled form field with validation support.
  Widget _buildFdlFormField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required FormFieldValidator<String>? validator,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamilyMono,
            fontSize: FiftyTypography.mono,
            fontWeight: FiftyTypography.medium,
            color: FiftyColors.hyperChrome,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: FiftySpacing.sm),
        // Form field
        TextFormField(
          controller: controller,
          validator: validator,
          textInputAction: textInputAction,
          obscureText: obscureText,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamilyMono,
            fontSize: FiftyTypography.body,
            fontWeight: FiftyTypography.regular,
            color: colorScheme.onSurface,
          ),
          cursorColor: colorScheme.primary,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.body,
              fontWeight: FiftyTypography.regular,
              color: FiftyColors.hyperChrome,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: FiftySpacing.lg,
              vertical: FiftySpacing.md,
            ),
            border: OutlineInputBorder(
              borderRadius: FiftyRadii.standardRadius,
              borderSide: const BorderSide(
                color: FiftyColors.border,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: FiftyRadii.standardRadius,
              borderSide: const BorderSide(
                color: FiftyColors.border,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: FiftyRadii.standardRadius,
              borderSide: const BorderSide(
                color: FiftyColors.crimsonPulse,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: FiftyRadii.standardRadius,
              borderSide: const BorderSide(
                color: FiftyColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: FiftyRadii.standardRadius,
              borderSide: const BorderSide(
                color: FiftyColors.error,
                width: 2,
              ),
            ),
            errorStyle: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.mono,
              color: FiftyColors.error,
            ),
          ),
        ),
      ],
    );
  }

  /// **_login**
  ///
  /// Validates and saves the form, then triggers [AuthActions.signIn].
  ///
  /// **Parameters**
  /// - `context`: Build context used by the action presenter for overlay/snackbar.
  ///
  /// **Side Effects**
  /// - Updates [AuthViewModel.username] and [AuthViewModel.password] via controllers.
  /// - Triggers the global loader overlay and error handling via [AuthActions].
  ///
  /// // ----------------------------------------------------
  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      controller.username = _usernameController.text;
      controller.password = _passwordController.text;
      AuthActions.instance.signIn(context);
    }
  }
}
