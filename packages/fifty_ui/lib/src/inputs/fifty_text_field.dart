import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Border style options for FiftyTextField.
///
/// - [full]: Full border around the entire field
/// - [bottom]: Only bottom border (underline style)
/// - [none]: No border
enum FiftyBorderStyle {
  /// Full border around the entire field.
  full,

  /// Only bottom border (underline style).
  bottom,

  /// No border.
  none,
}

/// Prefix style options for FiftyTextField.
///
/// - [chevron]: Shows ">" prefix
/// - [comment]: Shows "//" prefix
/// - [none]: No prefix
/// - [custom]: Custom prefix string
enum FiftyPrefixStyle {
  /// Shows ">" prefix for terminal-like appearance.
  chevron,

  /// Shows "//" prefix for comment-like appearance.
  comment,

  /// No prefix.
  none,

  /// Custom prefix string (use customPrefix parameter).
  custom,
}

/// Cursor style options for FiftyTextField.
///
/// - [line]: Standard thin line cursor
/// - [block]: Block cursor (terminal style)
/// - [underscore]: Underscore cursor
enum FiftyCursorStyle {
  /// Standard thin line cursor.
  line,

  /// Block cursor (terminal style).
  block,

  /// Underscore cursor.
  underscore,
}

/// A text field with FDL styling and crimson focus glow.
///
/// Features:
/// - Crimson border and glow on focus (2px + box shadow)
/// - Gunmetal background
/// - JetBrains Mono typography
/// - Error state styling
/// - Optional prefix/suffix icons
/// - Configurable border styles (full, bottom, none)
/// - Configurable prefix styles (chevron, comment, none, custom)
/// - Configurable cursor styles (line, block, underscore)
/// - Terminal mode with "> " prefix (FDL: "Inputs look like terminal command lines")
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
///
/// Terminal mode example:
/// ```dart
/// FiftyTextField(
///   controller: _commandController,
///   terminalStyle: true,
///   hint: 'Enter command',
/// )
/// ```
///
/// Custom styling example:
/// ```dart
/// FiftyTextField(
///   controller: _controller,
///   borderStyle: FiftyBorderStyle.bottom,
///   prefixStyle: FiftyPrefixStyle.comment,
///   cursorStyle: FiftyCursorStyle.block,
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
    this.terminalStyle = false,
    this.borderStyle = FiftyBorderStyle.full,
    this.prefixStyle,
    this.customPrefix,
    this.cursorStyle = FiftyCursorStyle.line,
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

  /// Whether to display in terminal style.
  ///
  /// FDL Rule: "Inputs look like terminal command lines (_blinking cursor)"
  /// When true, shows "> " prefix before input.
  /// Note: This is a legacy parameter. For more control, use [prefixStyle].
  final bool terminalStyle;

  /// The border style of the text field.
  ///
  /// Controls how the border is rendered:
  /// - [FiftyBorderStyle.full]: Full border around the field (default)
  /// - [FiftyBorderStyle.bottom]: Only bottom border (underline)
  /// - [FiftyBorderStyle.none]: No border
  final FiftyBorderStyle borderStyle;

  /// The prefix style for the text field.
  ///
  /// Controls the prefix shown before input:
  /// - [FiftyPrefixStyle.chevron]: Shows ">"
  /// - [FiftyPrefixStyle.comment]: Shows "//"
  /// - [FiftyPrefixStyle.none]: No prefix
  /// - [FiftyPrefixStyle.custom]: Uses [customPrefix] value
  ///
  /// When null, defaults to chevron if [terminalStyle] is true, otherwise none.
  final FiftyPrefixStyle? prefixStyle;

  /// Custom prefix string when [prefixStyle] is [FiftyPrefixStyle.custom].
  final String? customPrefix;

  /// The cursor style for the text field.
  ///
  /// Controls how the cursor is rendered:
  /// - [FiftyCursorStyle.line]: Standard thin line cursor (default)
  /// - [FiftyCursorStyle.block]: Block cursor (terminal style)
  /// - [FiftyCursorStyle.underscore]: Underscore cursor
  final FiftyCursorStyle cursorStyle;

  @override
  State<FiftyTextField> createState() => _FiftyTextFieldState();
}

class _FiftyTextFieldState extends State<FiftyTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  bool _isFocused = false;
  late AnimationController _cursorController;

  bool get _hasError => widget.errorText != null;

  /// Determines the effective prefix style, considering legacy terminalStyle.
  FiftyPrefixStyle get _effectivePrefixStyle {
    if (widget.prefixStyle != null) return widget.prefixStyle!;
    if (widget.terminalStyle) return FiftyPrefixStyle.chevron;
    return FiftyPrefixStyle.none;
  }

  /// Gets the prefix text based on the prefix style.
  String? get _prefixText {
    switch (_effectivePrefixStyle) {
      case FiftyPrefixStyle.chevron:
        return '>';
      case FiftyPrefixStyle.comment:
        return '//';
      case FiftyPrefixStyle.custom:
        return widget.customPrefix;
      case FiftyPrefixStyle.none:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorController.dispose();
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

  /// Builds the border based on [widget.borderStyle].
  InputBorder _buildBorder(Color color, {double width = 1}) {
    switch (widget.borderStyle) {
      case FiftyBorderStyle.full:
        return OutlineInputBorder(
          borderRadius: FiftyRadii.standardRadius,
          borderSide: BorderSide(color: color, width: width),
        );
      case FiftyBorderStyle.bottom:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: width),
        );
      case FiftyBorderStyle.none:
        return InputBorder.none;
    }
  }

  /// Builds the prefix icon widget.
  Widget? _buildPrefixIcon(ColorScheme colorScheme) {
    final prefixText = _prefixText;
    if (prefixText != null) {
      return Padding(
        padding: const EdgeInsets.only(left: FiftySpacing.lg),
        child: Text(
          prefixText,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamilyMono,
            fontSize: FiftyTypography.body,
            fontWeight: FiftyTypography.medium,
            color: _isFocused ? colorScheme.primary : FiftyColors.hyperChrome,
          ),
        ),
      );
    }
    return widget.prefix;
  }

  /// Builds the suffix widget with custom cursor if needed.
  Widget? _buildSuffixIcon(ColorScheme colorScheme) {
    // For block or underscore cursor, we add a custom cursor widget
    if (widget.cursorStyle != FiftyCursorStyle.line && _isFocused) {
      final cursorChar = widget.cursorStyle == FiftyCursorStyle.block
          ? '\u2588' // Full block character
          : '_';
      return Padding(
        padding: const EdgeInsets.only(right: FiftySpacing.sm),
        child: AnimatedBuilder(
          animation: _cursorController,
          builder: (context, child) {
            return Opacity(
              opacity: _cursorController.value,
              child: Text(
                cursorChar,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: FiftyTypography.body,
                  fontWeight: FiftyTypography.medium,
                  color: colorScheme.primary,
                ),
              ),
            );
          },
        ),
      );
    }
    return widget.suffix;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final hasPrefixText = _prefixText != null;

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
            borderRadius: widget.borderStyle == FiftyBorderStyle.full
                ? FiftyRadii.standardRadius
                : null,
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
            cursorColor: widget.cursorStyle == FiftyCursorStyle.line
                ? colorScheme.primary
                : Colors.transparent, // Hide default cursor for custom styles
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.body,
                fontWeight: FiftyTypography.regular,
                color: FiftyColors.hyperChrome,
              ),
              prefixIcon: _buildPrefixIcon(colorScheme),
              prefixIconConstraints: hasPrefixText
                  ? const BoxConstraints(minWidth: 24, minHeight: 0)
                  : null,
              prefixIconColor: _isFocused
                  ? colorScheme.primary
                  : FiftyColors.hyperChrome,
              suffixIcon: _buildSuffixIcon(colorScheme),
              suffixIconColor: FiftyColors.hyperChrome,
              filled: true,
              fillColor: FiftyColors.gunmetal,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.lg,
                vertical: FiftySpacing.md,
              ),
              border: _buildBorder(FiftyColors.border),
              enabledBorder: _buildBorder(FiftyColors.border),
              focusedBorder: _buildBorder(colorScheme.primary, width: 2),
              errorBorder: _buildBorder(colorScheme.error),
              focusedErrorBorder: _buildBorder(colorScheme.error, width: 2),
              disabledBorder: _buildBorder(
                FiftyColors.border.withValues(alpha: 0.5),
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
