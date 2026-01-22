import 'package:flutter/widgets.dart';

import '../core/form_controller.dart';

/// Inherited widget providing form controller to descendants.
///
/// Use [FiftyFormScope.of] to access the controller from child widgets.
///
/// **Example:**
/// ```dart
/// final controller = FiftyFormScope.of(context);
/// if (controller != null) {
///   controller.setValue('email', value);
/// }
/// ```
class FiftyFormScope extends InheritedWidget {
  /// The form controller provided to descendants.
  final FiftyFormController controller;

  /// Creates a form scope with the given controller.
  const FiftyFormScope({
    super.key,
    required this.controller,
    required super.child,
  });

  /// Gets the [FiftyFormController] from the nearest ancestor [FiftyFormScope].
  ///
  /// Returns null if no [FiftyFormScope] is found.
  static FiftyFormController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FiftyFormScope>()
        ?.controller;
  }

  /// Gets the [FiftyFormController] from the nearest ancestor [FiftyFormScope].
  ///
  /// Throws if no [FiftyFormScope] is found.
  static FiftyFormController require(BuildContext context) {
    final controller = of(context);
    assert(controller != null, 'No FiftyFormScope found in context');
    return controller!;
  }

  @override
  bool updateShouldNotify(FiftyFormScope oldWidget) {
    return controller != oldWidget.controller;
  }
}

/// Form container widget that provides controller to children.
///
/// Wraps child widgets with a [FiftyFormScope] so that form field widgets
/// can access the controller via [FiftyFormScope.of].
///
/// **Example:**
/// ```dart
/// FiftyForm(
///   controller: _formController,
///   child: Column(
///     children: [
///       FiftyTextFormField(name: 'email'),
///       FiftyTextFormField(name: 'password', obscureText: true),
///       FiftySubmitButton(
///         onPressed: () => _formController.submit(_handleSubmit),
///         child: Text('SUBMIT'),
///       ),
///     ],
///   ),
/// )
/// ```
class FiftyForm extends StatelessWidget {
  /// The form controller managing form state.
  final FiftyFormController controller;

  /// The form content.
  final Widget child;

  /// Optional padding around the form content.
  final EdgeInsets? padding;

  /// Creates a form container with the given controller.
  const FiftyForm({
    super.key,
    required this.controller,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = FiftyFormScope(
      controller: controller,
      child: child,
    );

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return content;
  }
}
