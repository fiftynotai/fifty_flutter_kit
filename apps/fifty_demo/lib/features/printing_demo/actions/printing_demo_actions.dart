/// Printing Demo Actions
///
/// Handles user interactions for the printing demo feature.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/printing_demo_view_model.dart';

/// Actions for the printing demo feature.
///
/// Provides printer discovery and print actions.
class PrintingDemoActions {
  /// Creates printing demo actions with required dependencies.
  PrintingDemoActions(this._viewModel, this._presenter);

  final PrintingDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static PrintingDemoActions get instance => Get.find<PrintingDemoActions>();

  // ---------------------------------------------------------------------------
  // Discovery Actions
  // ---------------------------------------------------------------------------

  /// Called when discover printers button is tapped.
  Future<void> onDiscoverTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      await _viewModel.discoverPrinters();
    });
  }

  /// Called when a printer is selected.
  void onPrinterSelected(MockPrinterDevice? printer) {
    _viewModel.selectPrinter(printer);
  }

  // ---------------------------------------------------------------------------
  // Print Actions
  // ---------------------------------------------------------------------------

  /// Called when print button is tapped.
  Future<void> onPrintTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      final result = await _viewModel.printTicket();

      if (result.success) {
        _presenter.showSuccessSnackBar(
          context,
          'Print Sent',
          result.message,
        );
      } else {
        _presenter.showErrorSnackBar(
          context,
          'Print Failed',
          result.message,
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Goes back to previous screen.
  void onBackTapped() {
    _presenter.back();
  }
}
