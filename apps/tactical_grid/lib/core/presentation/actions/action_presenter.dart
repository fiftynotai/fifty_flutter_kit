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
  /// Handle an async action with loading overlay and error handling.
  Future<void> actionHandler(
    BuildContext context,
    AsyncCallback action, {
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
  }) async {
    try {
      if (context.mounted) {
        context.loaderOverlay.show();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ActionPresenter] Failed to show loader overlay: $e');
      }
    }
    try {
      await action();
      if (onSuccess != null) onSuccess();
    } on AppException catch (e, stackTrace) {
      _handleException(context, e, stackTrace, e.prefix, e.message);
      if (onFailure != null) onFailure();
    } catch (e, stackTrace) {
      _handleException(context, e, stackTrace, tkError, tkSomethingWentWrongMsg);
      if (onFailure != null) onFailure();
    } finally {
      try {
        if (context.mounted) {
          context.loaderOverlay.hide();
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[ActionPresenter] Failed to hide loader overlay: $e');
        }
      }
    }
  }

  /// Handle an async action without loading overlay.
  Future<void> actionHandlerWithoutLoading(
    AsyncCallback action, {
    BuildContext? context,
    VoidCallback? onSuccess,
    VoidCallback? onFailure,
  }) async {
    try {
      await action();
      if (onSuccess != null) onSuccess();
    } on AppException catch (e, stackTrace) {
      _handleException(context, e, stackTrace, e.prefix, e.message);
      if (onFailure != null) onFailure();
    } catch (e, stackTrace) {
      _handleException(context, e, stackTrace, tkError, tkSomethingWentWrongMsg);
      if (onFailure != null) onFailure();
    }
  }

  void _handleException(
    BuildContext? context,
    dynamic e,
    StackTrace stackTrace,
    String title,
    String message,
  ) {
    if (kDebugMode) {
      debugPrint('[ActionPresenter] Exception: $e');
      debugPrint('[ActionPresenter] StackTrace: $stackTrace');
      log(e.toString());
    }
    if (context != null && context.mounted) {
      showErrorSnackBar(context, title, message);
    }
  }

  /// Show an error snackbar.
  void showErrorSnackBar(BuildContext context, String title, String message) {
    FiftySnackbar.show(
      context,
      message: message,
      variant: FiftySnackbarVariant.error,
    );
  }

  /// Show a success snackbar.
  void showSuccessSnackBar(BuildContext context, String title, String message) {
    FiftySnackbar.show(
      context,
      message: message,
      variant: FiftySnackbarVariant.success,
    );
  }

  /// Show a confirmation dialog.
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

  /// Navigate back.
  void back() {
    Get.back<void>();
  }
}
