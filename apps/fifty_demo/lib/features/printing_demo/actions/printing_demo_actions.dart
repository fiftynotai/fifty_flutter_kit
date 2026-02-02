/// Printing Demo Actions
///
/// Handles user interactions for the printing demo feature.
/// Uses real fifty_printing_engine for Bluetooth printer operations.
library;

import 'package:fifty_printing_engine/fifty_printing_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/printing_demo_view_model.dart';

/// Actions for the printing demo feature.
///
/// Provides real Bluetooth printer discovery, registration, and print actions.
class PrintingDemoActions {
  /// Creates printing demo actions with required dependencies.
  PrintingDemoActions(this._viewModel, this._presenter);

  final PrintingDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static PrintingDemoActions get instance => Get.find<PrintingDemoActions>();

  // ---------------------------------------------------------------------------
  // Permissions Actions
  // ---------------------------------------------------------------------------

  /// Called when open settings button is tapped.
  Future<void> onOpenSettingsTapped(BuildContext context) async {
    await _viewModel.openSettings();
  }

  // ---------------------------------------------------------------------------
  // Discovery Actions
  // ---------------------------------------------------------------------------

  /// Called when discover printers button is tapped.
  Future<void> onDiscoverTapped(BuildContext context) async {
    // Don't use actionHandler to avoid loader overlay during discovery
    await _viewModel.discoverPrinters();
  }

  /// Called when a discovered printer is tapped (to register it).
  void onDiscoveredPrinterTapped(BuildContext context, DiscoveredPrinter discovered) {
    _viewModel.registerPrinter(discovered);
    _presenter.showSuccessSnackBar(
      context,
      'Printer Added',
      '${discovered.name} has been registered',
    );
  }

  /// Called when a registered printer is tapped (to select it).
  void onRegisteredPrinterTapped(BuildContext context, PrinterDevice printer) {
    _viewModel.selectPrinter(printer.id);
  }

  // ---------------------------------------------------------------------------
  // Connection Actions
  // ---------------------------------------------------------------------------

  /// Called when connect button is tapped.
  Future<void> onConnectTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      final success = await _viewModel.connectPrinter();

      if (success) {
        _presenter.showSuccessSnackBar(
          context,
          'Connected',
          'Printer connected successfully',
        );
      } else {
        _presenter.showErrorSnackBar(
          context,
          'Connection Failed',
          _viewModel.errorMessage ?? 'Could not connect to printer',
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Print Actions
  // ---------------------------------------------------------------------------

  /// Called when print button is tapped.
  Future<void> onPrintTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      final result = await _viewModel.printTicket();

      if (result != null && result.isSuccess) {
        _presenter.showSuccessSnackBar(
          context,
          'Print Sent',
          'Ticket sent to ${_viewModel.selectedPrinter?.name}',
        );
      } else if (result != null) {
        _presenter.showErrorSnackBar(
          context,
          'Print Failed',
          _viewModel.errorMessage ?? 'Could not print ticket',
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
