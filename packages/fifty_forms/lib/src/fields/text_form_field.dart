import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../core/form_controller.dart';
import '../validators/validator.dart';
import 'form_field_base.dart';

/// A text input field integrated with [FiftyFormController].
///
/// Wraps [FiftyTextField] and provides automatic:
/// - Field registration with the form controller
/// - Value synchronization
/// - Error display from validation
/// - Touch tracking on blur
///
/// **Example:**
/// ```dart
/// FiftyTextFormField(
///   name: 'email',
///   controller: formController,
///   validators: [Required(), Email()],
///   label: 'Email',
///   hint: 'Enter your email',
///   keyboardType: TextInputType.emailAddress,
/// )
/// ```
///
/// **Example with password:**
/// ```dart
/// FiftyTextFormField(
///   name: 'password',
///   controller: formController,
///   validators: [Required(), MinLength(8)],
///   label: 'Password',
///   obscureText: true,
/// )
/// ```
class FiftyTextFormField extends StatefulWidget {
  /// Creates a form-integrated text field.
  const FiftyTextFormField({
    super.key,
    required this.name,
    required this.controller,
    this.validators,
    this.textController,
    this.label,
    this.hint,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
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
    this.onSubmitted,
    this.initialValue,
  });

  /// Unique field name for form registration.
  final String name;

  /// The form controller to register with.
  final FiftyFormController controller;

  /// Validators for this field.
  final List<Validator<dynamic>>? validators;

  /// Optional text editing controller for direct text access.
  final TextEditingController? textController;

  /// Label text displayed above the field.
  final String? label;

  /// Hint text displayed when the field is empty.
  final String? hint;

  /// Widget displayed before the input (e.g., an icon).
  final Widget? prefix;

  /// Widget displayed after the input (e.g., a button).
  final Widget? suffix;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// Maximum number of lines.
  final int? maxLines;

  /// Minimum number of lines.
  final int? minLines;

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
  final bool terminalStyle;

  /// The border style of the text field.
  final FiftyBorderStyle borderStyle;

  /// The prefix style for the text field.
  final FiftyPrefixStyle? prefixStyle;

  /// Custom prefix string when [prefixStyle] is [FiftyPrefixStyle.custom].
  final String? customPrefix;

  /// The cursor style for the text field.
  final FiftyCursorStyle cursorStyle;

  /// Callback when the user submits.
  final ValueChanged<String>? onSubmitted;

  /// Initial value for the field.
  final String? initialValue;

  @override
  State<FiftyTextFormField> createState() => _FiftyTextFormFieldState();
}

class _FiftyTextFormFieldState extends State<FiftyTextFormField>
    with FormFieldMixin<FiftyTextFormField> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  bool _didInitialize = false;

  @override
  FiftyFormController? get controller => widget.controller;

  @override
  String get fieldName => widget.name;

  @override
  List<Validator<dynamic>>? get validators => widget.validators;

  @override
  dynamic get initialValue => widget.initialValue ?? '';

  @override
  void initState() {
    super.initState();
    _textController = widget.textController ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);

    // Set initial value from controller if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncValueFromController();
      _didInitialize = true;
    });
  }

  @override
  void didUpdateWidget(FiftyTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_didInitialize) {
      _syncValueFromController();
    }
  }

  void _syncValueFromController() {
    final value = controller?.getValue<String>(fieldName);
    if (value != null && value != _textController.text) {
      _textController.text = value;
    }
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      onFieldBlur();
    }
  }

  void _handleChanged(String value) {
    onFieldChanged(value);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.textController == null) {
      _textController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final errorText = shouldShowError ? fieldError : null;

        return FiftyTextField(
          controller: _textController,
          focusNode: _focusNode,
          label: widget.label,
          hint: widget.hint,
          errorText: errorText,
          prefix: widget.prefix,
          suffix: widget.suffix,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          terminalStyle: widget.terminalStyle,
          borderStyle: widget.borderStyle,
          prefixStyle: widget.prefixStyle,
          customPrefix: widget.customPrefix,
          cursorStyle: widget.cursorStyle,
          onChanged: _handleChanged,
          onSubmitted: widget.onSubmitted,
        );
      },
    );
  }
}
