/// Socket Demo Actions
///
/// Handles user interactions for the socket demo feature.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/socket_demo_view_model.dart';

/// Actions for the socket demo feature.
///
/// Provides connection, channel, and message actions.
class SocketDemoActions {
  /// Creates socket demo actions with required dependencies.
  SocketDemoActions(this._viewModel, this._presenter);

  final SocketDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static SocketDemoActions get instance => Get.find<SocketDemoActions>();

  // ---------------------------------------------------------------------------
  // Connection Actions
  // ---------------------------------------------------------------------------

  /// Called when connect button is tapped.
  Future<void> onConnectTapped(BuildContext context) async {
    await _viewModel.connect();

    if (!context.mounted) return;

    _presenter.showSuccessSnackBar(
      context,
      'Connected',
      'WebSocket connection established.',
    );
  }

  /// Called when disconnect button is tapped.
  void onDisconnectTapped(BuildContext context) {
    _viewModel.disconnect();

    _presenter.showSuccessSnackBar(
      context,
      'Disconnected',
      'WebSocket connection closed.',
    );
  }

  /// Called when simulate reconnect button is tapped.
  Future<void> onSimulateReconnectTapped(BuildContext context) async {
    await _viewModel.simulateReconnect();

    if (!context.mounted) return;

    _presenter.showSuccessSnackBar(
      context,
      'Reconnected',
      'Reconnection simulation complete.',
    );
  }

  // ---------------------------------------------------------------------------
  // Channel Actions
  // ---------------------------------------------------------------------------

  /// Called when a channel join button is tapped.
  void onJoinChannelTapped(BuildContext context, String topic) {
    _viewModel.joinChannel(topic);
  }

  /// Called when a channel leave button is tapped.
  void onLeaveChannelTapped(BuildContext context, String topic) {
    _viewModel.leaveChannel(topic);
  }

  // ---------------------------------------------------------------------------
  // Message Actions
  // ---------------------------------------------------------------------------

  /// Called when send message button is tapped.
  void onSendMessageTapped(String topic) {
    _viewModel.sendMessage(
      topic,
      'ping',
      '{"message": "Hello from demo!"}',
    );
  }

  /// Called when clear messages button is tapped.
  void onClearMessagesTapped() {
    _viewModel.clearMessages();
  }

  /// Called when reset button is tapped.
  void onResetTapped() {
    _viewModel.resetDemo();
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Goes back to previous screen.
  void onBackTapped() {
    _presenter.back();
  }
}
