import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/utils/form_validators.dart';
import '/src/core/routing/route_manager.dart';
import '/src/modules/auth/auth.dart';

/// **RegisterPage**
///
/// FDL-styled registration form with Orbital Command "REQUEST ACCESS" theme.
/// FDL v2 aesthetic with space-themed terminology.
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
/// - Responsive design with scroll support
///
/// **Side Effects:**
/// - Fields save into [AuthViewModel.newUser] via controllers
/// - On submit, triggers [AuthActions.signUp] which shows loader and error handling
///
/// // ----------------------------------------------------
class RegisterPage extends GetWidget<AuthViewModel> {
  const RegisterPage({super.key});

  static final _formKey = GlobalKey<FormState>();
  static final _usernameController = TextEditingController();
  static final _phoneController = TextEditingController();
  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();
  static final _passwordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: FiftySpacing.lg,
            vertical: FiftySpacing.lg,
          ),
          child: Column(
            children: [
              // Back button row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => RouteManager.back(),
                    child: Container(
                      padding: EdgeInsets.all(FiftySpacing.sm),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: FiftyColors.border,
                          width: 1,
                        ),
                        borderRadius: FiftyRadii.standardRadius,
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: colorScheme.onSurface,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: FiftySpacing.xxl),

              // Request Access title
              Text(
                'REQUEST ACCESS',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyHeadline,
                  fontSize: FiftyTypography.display,
                  fontWeight: FiftyTypography.ultrabold,
                  color: colorScheme.onSurface,
                  letterSpacing: 4,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: FiftySpacing.sm),

              // Subtitle
              Text(
                'NEW OPERATOR REGISTRATION',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: FiftyTypography.body,
                  fontWeight: FiftyTypography.regular,
                  color: FiftyColors.hyperChrome,
                  letterSpacing: 2,
                ),
              ),

              SizedBox(height: FiftySpacing.xxl),

              // Registration form wrapped in FiftyCard
              FiftyCard(
                padding: EdgeInsets.all(FiftySpacing.xxl),
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
                        hint: 'Choose operator ID',
                        validator: FormValidators.username,
                        textInputAction: TextInputAction.next,
                      ),

                      SizedBox(height: FiftySpacing.lg),

                      // Phone field
                      _buildFdlFormField(
                        context,
                        controller: _phoneController,
                        label: 'COMM CHANNEL',
                        hint: 'Enter comm channel (phone)',
                        validator: FormValidators.phone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),

                      SizedBox(height: FiftySpacing.lg),

                      // Email field
                      _buildFdlFormField(
                        context,
                        controller: _emailController,
                        label: 'DATA UPLINK',
                        hint: 'Enter data uplink (email)',
                        validator: FormValidators.email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),

                      SizedBox(height: FiftySpacing.lg),

                      // Password field with visibility toggle
                      Obx(() => _buildFdlFormField(
                            context,
                            controller: _passwordController,
                            label: 'ACCESS CODE',
                            hint: 'Create access code',
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

                      SizedBox(height: FiftySpacing.xxl),

                      // Register button
                      FiftyButton(
                        label: 'SUBMIT REQUEST',
                        onPressed: () => _register(context),
                        variant: FiftyButtonVariant.primary,
                        size: FiftyButtonSize.large,
                        expanded: true,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: FiftySpacing.xxl),

              // Back to login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ALREADY REGISTERED? ',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamilyMono,
                      fontSize: FiftyTypography.body,
                      fontWeight: FiftyTypography.regular,
                      color: FiftyColors.hyperChrome,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => RouteManager.back(),
                    child: Text(
                      'ESTABLISH UPLINK',
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

              SizedBox(height: FiftySpacing.lg),

              // Security notice
              Container(
                padding: EdgeInsets.all(FiftySpacing.md),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: FiftyColors.hyperChrome.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  borderRadius: FiftyRadii.standardRadius,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.security,
                      color: FiftyColors.igrisGreen,
                      size: 16,
                    ),
                    SizedBox(width: FiftySpacing.sm),
                    Expanded(
                      child: Text(
                        'ALL DATA TRANSMISSIONS ARE ENCRYPTED',
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamilyMono,
                          fontSize: FiftyTypography.mono,
                          fontWeight: FiftyTypography.regular,
                          color: FiftyColors.hyperChrome,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: FiftySpacing.lg),
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
    TextInputType? keyboardType,
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
        SizedBox(height: FiftySpacing.sm),
        // Form field
        TextFormField(
          controller: controller,
          validator: validator,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
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
            contentPadding: EdgeInsets.symmetric(
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
              borderSide: BorderSide(
                color: FiftyColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: FiftyRadii.standardRadius,
              borderSide: BorderSide(
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

  /// **_register**
  ///
  /// Validates and saves the form, then triggers [AuthActions.signUp].
  ///
  /// **Parameters**
  /// - `context`: Build context used by the action presenter for overlay/snackbar.
  ///
  /// **Side Effects**
  /// - Updates [AuthViewModel.newUser] fields via controllers.
  /// - Triggers the global loader overlay and error handling via [AuthActions].
  ///
  /// // ----------------------------------------------------
  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      controller.newUser.username = _usernameController.text;
      controller.newUser.phone = _phoneController.text;
      controller.newUser.email = _emailController.text;
      controller.newUser.password = _passwordController.text;
      AuthActions.instance.signUp(context);
    }
  }
}
