/// Action Presenter
///
/// Handles actions with error handling, loading indicators, and UI feedback.
library;

import 'dart:developer';

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../errors/app_exception.dart';

/// Handles actions with error handling, loading indicators, and UI feedback.
class ActionPresenter {
  /// Method to handle an asynchronous action with error handling and loading indicator.
  ///
  /// `action`: The async function to be executed.
  /// `onSuccess`: Optional callback to be executed on successful completion of the action.
  /// `onFailure`: Optional callback to be executed on failure.
  Future<void> actionHandler(
    BuildContext context,
    AsyncCallback action, {
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
  }) async {
    // Show the loading overlay during the action execution (guarded).
    try {
      if (context.mounted) {
        context.loaderOverlay.show();
      }
    } catch (_) {
      /* no overlay present; ignore */
    }
    try {
      // Execute the provided action.
      await action();

      // Call the onSuccess callback if provided.
      if (onSuccess != null) {
        onSuccess();
      }
    } on AppException catch (e, stackTrace) {
      // Handle specific AppException with custom prefix and message.
      _handleException(context, e, stackTrace, e.prefix, e.message);
      if (onFailure != null) onFailure(); // Call onFailure if provided.
    } catch (e, stackTrace) {
      // Handle generic exceptions with a more specific message for auth errors.
      final isAuth =
          e is AuthException || e.toString().toLowerCase().contains('unauthorized');
      const title = tkError;
      final message = isAuth ? 'Invalid email or password' : tkSomethingWentWrongMsg;
      _handleException(context, e, stackTrace, title, message);
      if (onFailure != null) onFailure(); // Call onFailure if provided.
    } finally {
      // Hide the loading overlay after the action completes (guarded).
      try {
        if (context.mounted) {
          context.loaderOverlay.hide();
        }
      } catch (_) {
        /* no overlay present; ignore */
      }
    }
  }

  /// Method to handle an asynchronous action without loading indicator.
  ///
  /// `action`: The async function to be executed.
  /// `context`: Optional BuildContext for displaying error snackbars.
  /// `onSuccess`: Optional callback to be executed on successful completion of the action.
  /// `onFailure`: Optional callback to be executed on failure.
  Future<void> actionHandlerWithoutLoading(
    AsyncCallback action, {
    BuildContext? context,
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
  }) async {
    try {
      // Execute the provided action.
      await action();

      // Call the onSuccess callback if provided.
      if (onSuccess != null) {
        onSuccess();
      }
    } on AppException catch (e, stackTrace) {
      // Handle specific AppException with custom prefix and message.
      _handleException(context, e, stackTrace, e.prefix, e.message);
      if (onFailure != null) onFailure(); // Call onFailure if provided.
    } catch (e, stackTrace) {
      // Handle generic exceptions with a default error message.
      _handleException(context, e, stackTrace, tkError, tkSomethingWentWrongMsg);
      if (onFailure != null) onFailure(); // Call onFailure if provided.
    }
  }

  /// Handles exceptions by logging and showing a snackbar.
  ///
  /// `context`: Optional BuildContext for displaying snackbars.
  /// `e`: The exception to handle.
  /// `stackTrace`: The associated stack trace.
  /// `title`: The title of the error.
  /// `message`: The message to display to the user.
  void _handleException(
    BuildContext? context,
    dynamic e,
    StackTrace stackTrace,
    String title,
    String message,
  ) async {
    if (kDebugMode) {
      print(stackTrace); // Print stack trace in debug mode.
      log(e.toString()); // Log the error message.
    }

    // Display an error snackbar if context is available.
    if (context != null && context.mounted) {
      showErrorSnackBar(context, title, message);
    }
  }

  /// Displays an error snackbar using FiftySnackbar.
  ///
  /// `context`: The BuildContext for displaying the snackbar.
  /// `title`: The title of the error message (unused, kept for API compatibility).
  /// `message`: The message to display to the user.
  void showErrorSnackBar(BuildContext context, String title, String message) {
    FiftySnackbar.show(
      context,
      message: message,
      variant: FiftySnackbarVariant.error,
    );
  }

  /// Displays a success snackbar using FiftySnackbar.
  ///
  /// `context`: The BuildContext for displaying the snackbar.
  /// `title`: The title of the success message (unused, kept for API compatibility).
  /// `message`: The message to display to the user.
  void showSuccessSnackBar(BuildContext context, String title, String message) {
    FiftySnackbar.show(
      context,
      message: message,
      variant: FiftySnackbarVariant.success,
    );
  }

  /// Displays a confirmation dialog using FiftyDialog.
  ///
  /// `context`: The BuildContext for displaying the dialog.
  /// `message`: The confirmation message to display.
  Future<bool> showConfirmationDialog(
    BuildContext context, [
    String message = 'Are you sure',
  ]) async {
    final result = await showFiftyDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;
        return FiftyDialog(
          title: 'Confirm',
          content: Text(
            message,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyMedium,
              color: colorScheme.onSurface,
            ),
          ),
          showCloseButton: false,
          actions: [
            FiftyButton(
              label: 'NO',
              variant: FiftyButtonVariant.ghost,
              onPressed: () => Navigator.pop(dialogContext, false),
            ),
            FiftyButton(
              label: 'YES',
              variant: FiftyButtonVariant.primary,
              onPressed: () => Navigator.pop(dialogContext, true),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  void back() {
    Get.back<void>();
  }
}
