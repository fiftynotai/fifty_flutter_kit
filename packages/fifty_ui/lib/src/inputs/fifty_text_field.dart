import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A text field with FDL styling and crimson focus glow.
///
/// Features:
/// - Crimson border and glow on focus (2px + box shadow)
/// - Gunmetal background
/// - JetBrains Mono typography
/// - Error state styling
/// - Optional prefix/suffix icons
///
/// Example:
/// ```dart
/// FiftyTextField(
///   controller: _emailController,
///   label: 'Email',
///   hint: 'Enter your email',
///   prefix: Icon(Icons.email),
/// )
/// ```
class FiftyTextField extends StatefulWidget {
  /// Creates a Fifty-styled text field.
  const FiftyTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
  });

  /// Controller for the text field.
  final TextEditingController? controller;

  /// Label text displayed above the field.
  final String? label;

  /// Hint text displayed when the field is empty.
  final String? hint;

  /// Error text displayed below the field.
  ///
  /// When not null, the field shows error styling.
  final String? errorText;

  /// Widget displayed before the input (e.g., an icon).
  final Widget? prefix;

  /// Widget displayed after the input (e.g., a button).
  final Widget? suffix;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// Maximum number of lines.
  ///
  /// Set to null for unlimited lines.
  final int? maxLines;

  /// Minimum number of lines.
  final int? minLines;

  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when the user submits.
  final ValueChanged<String>? onSubmitted;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether to autofocus on mount.
  final bool autofocus;

  /// The type of keyboard to show.
  final TextInputType? keyboardType;

  /// The action button on the keyboard.
  final TextInputAction? textInputAction;

  /// Focus node for the field.
  final FocusNode? focusNode;

  @override
  State<FiftyTextField> createState() => _FiftyTextFieldState();
}

class _FiftyTextFieldState extends State<FiftyTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  bool get _hasError => widget.errorText != null;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_handleFocusChange);
    }
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!.toUpperCase(),
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.mono,
              fontWeight: FiftyTypography.medium,
              color: _hasError
                  ? colorScheme.error
                  : (_isFocused ? colorScheme.primary : FiftyColors.hyperChrome),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: FiftySpacing.sm),
        ],
        AnimatedContainer(
          duration: fifty.fast,
          curve: fifty.standardCurve,
          decoration: BoxDecoration(
            borderRadius: FiftyRadii.standardRadius,
            boxShadow: _isFocused && !_hasError ? fifty.focusGlow : null,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.body,
              fontWeight: FiftyTypography.regular,
              color: widget.enabled
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            cursorColor: colorScheme.primary,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.body,
                fontWeight: FiftyTypography.regular,
                color: FiftyColors.hyperChrome,
              ),
              prefixIcon: widget.prefix,
              prefixIconColor: _isFocused
                  ? colorScheme.primary
                  : FiftyColors.hyperChrome,
              suffixIcon: widget.suffix,
              suffixIconColor: FiftyColors.hyperChrome,
              filled: true,
              fillColor: FiftyColors.gunmetal,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.lg,
                vertical: FiftySpacing.md,
              ),
              border: OutlineInputBorder(
                borderRadius: FiftyRadii.standardRadius,
                borderSide: const BorderSide(color: FiftyColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: FiftyRadii.standardRadius,
                borderSide: const BorderSide(color: FiftyColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: FiftyRadii.standardRadius,
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: FiftyRadii.standardRadius,
                borderSide: BorderSide(color: colorScheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: FiftyRadii.standardRadius,
                borderSide: BorderSide(
                  color: colorScheme.error,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: FiftyRadii.standardRadius,
                borderSide: BorderSide(
                  color: FiftyColors.border.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ),
        if (_hasError) ...[
          const SizedBox(height: FiftySpacing.xs),
          Text(
            widget.errorText!,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamilyMono,
              fontSize: FiftyTypography.mono,
              fontWeight: FiftyTypography.regular,
              color: colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}
