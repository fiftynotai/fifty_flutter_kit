import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/connectivity_config.dart';
import '../controllers/connection_view_model.dart';

/// **ConnectionHandler**
///
/// Simple switcher that observes connection state via [ConnectionViewModel]
/// and renders one of three states:
/// - [connectedWidget] when connected,
/// - [onConnectingWidget] while probing reachability,
/// - a retry UI when offline.
///
/// Styled with FDL (Fifty Design Language) v2 aesthetic
/// using the Orbital Command space theme.
///
/// ## Why
/// - Centralize connection gating around a section of the UI.
/// - Provide a consistent retry affordance when offline.
/// - Avoid showing connected content while the app is still checking connectivity.
///
/// ## Parameters
/// - [connectedWidget]: Rendered when [isConnected()] is true.
/// - [onConnectingWidget]: Optional widget while [ConnectivityType.connecting]; defaults to FDL loading indicator.
/// - [notConnectedWidget]: Optional custom offline UI; defaults to FDL styled prompt with retry.
/// - [tryAgainAction]: Callback invoked when user taps to retry (offline states only).
///
/// ## Usage
/// ```dart
/// ConnectionHandler(
///   connectedWidget: YourMainContent(),
///   tryAgainAction: () => ConnectionActions.instance.checkConnectivity(),
/// )
/// ```
class ConnectionHandler extends GetWidget<ConnectionViewModel> {
  /// The widget to display when the device is connected to the internet.
  final Widget connectedWidget;

  /// The widget to display while the app is probing connectivity.
  final Widget? onConnectingWidget;

  /// The widget to display when the device is not connected.
  /// Defaults to a column with an icon and "try again" text.
  final Widget? notConnectedWidget;

  /// The action to perform when the user taps the retry button.
  final VoidCallback tryAgainAction;

  /// Constructor to create an instance of [ConnectionHandler].
  const ConnectionHandler({
    super.key,
    required this.connectedWidget,
    required this.tryAgainAction,
    this.onConnectingWidget,
    this.notConnectedWidget,
  });

  /// Builds the UI based on the current connection state using an [Obx] widget.
  ///
  /// When connected, shows [connectedWidget]. While probing, shows [onConnectingWidget]
  /// (or a default FDL loading indicator). When offline, shows [notConnectedWidget] or a default
  /// FDL styled UI with a retry tap handler. The retry action is only triggered by user input
  /// to avoid repeated calls on rebuilds.
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final state = controller.connectionType.value;
        if (controller.isConnected()) {
          return connectedWidget;
        }
        if (state == ConnectivityType.connecting) {
          return onConnectingWidget ?? _buildConnectingWidget(context);
        }
        // Offline (disconnected or noInternet): show retry UI
        return notConnectedWidget ?? _buildOfflineWidget(context);
      },
    );
  }

  /// Builds the default FDL-styled connecting widget.
  Widget _buildConnectingWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FiftyLoadingIndicator(
              text: ConnectivityConfig.labelEstablishingUplink,
              style: FiftyLoadingStyle.dots,
              size: FiftyLoadingSize.large,
              color: FiftyColors.slateGrey,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the default FDL-styled offline widget.
  Widget _buildOfflineWidget(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(FiftySpacing.xxl),
          child: FiftyCard(
            onTap: tryAgainAction,
            padding: const EdgeInsets.all(FiftySpacing.xxxl),
            backgroundColor: colorScheme.surfaceContainerHighest,
            scanlineOnHover: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Signal lost icon
                Icon(
                  Icons.cloud_off,
                  size: MediaQuery.of(context).size.height / 6,
                  color: FiftyColors.burgundy,
                ),
                const SizedBox(height: FiftySpacing.xl),

                // Title
                Text(
                  ConnectivityConfig.labelSignalLost,
                  style: const TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.titleLarge,
                    fontWeight: FiftyTypography.extraBold,
                    color: FiftyColors.burgundy,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: FiftySpacing.lg),

                // Subtitle
                Text(
                  ConnectivityConfig.labelConnectionLost,
                  style: const TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyLarge,
                    fontWeight: FiftyTypography.regular,
                    color: FiftyColors.slateGrey,
                  ),
                ),
                const SizedBox(height: FiftySpacing.xxl),

                // Retry button
                FiftyButton(
                  label: ConnectivityConfig.labelTryAgain,
                  onPressed: tryAgainAction,
                  variant: FiftyButtonVariant.secondary,
                  icon: Icons.refresh,
                  size: FiftyButtonSize.large,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
