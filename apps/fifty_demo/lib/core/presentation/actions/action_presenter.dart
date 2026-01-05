/// Action Presenter
///
/// Handles actions with error handling, loading indicators, and UI feedback.
library;

import 'dart:developer';

import 'package:fifty_tokens/fifty_tokens.dart';
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
      _handleException(e, stackTrace, e.prefix, e.message);
      if (onFailure != null) onFailure(); // Call onFailure if provided.
    } catch (e, stackTrace) {
      // Handle generic exceptions with a more specific message for auth errors.
      final isAuth =
          e is AuthException || e.toString().toLowerCase().contains('unauthorized');
      const title = tkError;
      final message = isAuth ? 'Invalid email or password' : tkSomethingWentWrongMsg;
      _handleException(e, stackTrace, title, message);
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
  /// `onSuccess`: Optional callback to be executed on successful completion of the action.
  /// `onFailure`: Optional callback to be executed on failure.
  Future<void> actionHandlerWithoutLoading(
    AsyncCallback action, {
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
      _handleException(e, stackTrace, e.prefix, e.message);
      if (onFailure != null) onFailure(); // Call onFailure if provided.
    } catch (e, stackTrace) {
      // Handle generic exceptions with a default error message.
      _handleException(e, stackTrace, tkError, tkSomethingWentWrongMsg);
      if (onFailure != null) onFailure(); // Call onFailure if provided.
    }
  }

  /// Handles exceptions by logging and showing a snackbar.
  ///
  /// `e`: The exception to handle.
  /// `stackTrace`: The associated stack trace.
  /// `title`: The title of the error.
  /// `message`: The message to display to the user.
  void _handleException(
    dynamic e,
    StackTrace stackTrace,
    String title,
    String message,
  ) async {
    if (kDebugMode) {
      print(stackTrace); // Print stack trace in debug mode.
      log(e.toString()); // Log the error message.
    }

    // Display an error snackbar.
    showErrorSnackBar(title, message);
  }

  /// Displays an error snackbar using GetX.
  ///
  /// `title`: The title of the error message.
  /// `message`: The message to display to the user.
  void showErrorSnackBar(String title, String message) {
    Get.snackbar(
      title.isNotEmpty ? title : 'Error',
      message,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(
        Icons.error_rounded,
        color: FiftyColors.error,
        size: 32.0,
      ),
      margin: const EdgeInsets.all(24.0),
      borderRadius: 24.0,
      shouldIconPulse: true,
      backgroundColor: FiftyColors.voidBlack,
      snackStyle: SnackStyle.FLOATING,
      colorText: FiftyColors.terminalWhite,
    );
  }

  /// Displays a success snackbar using GetX.
  ///
  /// `title`: The title of the success message.
  /// `message`: The message to display to the user.
  void showSuccessSnackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(
        Icons.check,
        color: FiftyColors.igrisGreen,
        size: 32.0,
      ),
      borderRadius: 24.0,
      shouldIconPulse: true,
      backgroundColor: FiftyColors.voidBlack,
      snackStyle: SnackStyle.FLOATING,
      colorText: FiftyColors.terminalWhite,
    );
  }

  /// Displays a confirmation dialog using GetX.
  ///
  /// `message`: The confirmation message to display.
  Future<bool> showConfirmationDialog(
    BuildContext context, [
    String message = 'Are you sure',
  ]) async {
    final result = await Get.dialog<bool>(
      Dialog(
        backgroundColor: FiftyColors.voidBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: 18.0,
                  color: FiftyColors.terminalWhite,
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FiftyColors.igrisGreen,
                      ),
                      child: const Text('Yes'),
                    ),
                  ),
                  const SizedBox(width: 24.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FiftyColors.error,
                      ),
                      child: const Text('No'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    return result ?? false;
  }

  void back() {
    Get.back<void>();
  }
}
