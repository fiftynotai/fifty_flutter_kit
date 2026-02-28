import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/connectivity_config.dart';
import '../controllers/connection_view_model.dart';
import '../actions/connection_actions.dart';

/// **ConnectionOverlay**
///
/// Widget that overlays its [child] with a small status surface when the
/// device is attempting to reconnect or has no internet connectivity.
///
/// Styled with FDL (Fifty Design Language) v2 aesthetic
/// using the Orbital Command space theme.
///
/// ## Why
/// - Provide ambient feedback without blocking the entire screen.
/// - Keep feature UIs responsive while connection issues resolve.
///
/// ## Usage
/// ```dart
/// ConnectionOverlay(child: YourPage())
/// ```
class ConnectionOverlay extends GetWidget<ConnectionViewModel> {
  /// The child widget to overlay with the connection status.
  final Widget child;

  /// The alignment of the overlay.
  final Alignment? alignment;

  /// Constructor for the [ConnectionOverlay] widget.
  const ConnectionOverlay({
    super.key,
    required this.child,
    this.alignment = Alignment.bottomCenter,
  });

  /// Builds the overlay with the appropriate connection status widget.
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Obx(() {
          switch (controller.connectionType.value) {
            case ConnectivityType.connecting:
              return const UplinkStatusBar(status: UplinkStatus.connecting);
            case ConnectivityType.disconnected:
            case ConnectivityType.noInternet:
              return const OfflineStatusCard();
            default:
              return const SizedBox.shrink();
          }
        }),
      ],
    );
  }
}

/// Uplink status states for the connection overlay.
enum UplinkStatus {
  /// Currently online and connected.
  online,

  /// Currently offline/disconnected.
  offline,

  /// Attempting to establish connection.
  connecting,
}

/// **UplinkStatusBar**
///
/// A compact status bar shown when the connection status changes.
/// Follows FDL v2 aesthetic with Orbital Command theme.
class UplinkStatusBar extends StatelessWidget {
  /// The current uplink status.
  final UplinkStatus status;

  /// Constructor for the [UplinkStatusBar] widget.
  const UplinkStatusBar({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: FiftySpacing.md),
          child: _buildStatusBadge(context),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    switch (status) {
      case UplinkStatus.online:
        return FiftyBadge.status(ConnectivityConfig.labelUplinkActive);
      case UplinkStatus.offline:
        return FiftyBadge(
          label: ConnectivityConfig.labelSignalLost,
          variant: FiftyBadgeVariant.error,
          showGlow: true,
        );
      case UplinkStatus.connecting:
        return FiftyBadge(
          label: ConnectivityConfig.labelEstablishingUplink,
          variant: FiftyBadgeVariant.neutral,
          showGlow: true,
          customColor: Theme.of(context).colorScheme.onSurfaceVariant,
        );
    }
  }
}

/// **OfflineStatusCard**
///
/// Full-screen modal card shown when the app determines there is no internet
/// connectivity. Styled with FDL v2 aesthetic.
///
/// ## Why
/// - Provide clear, blocking feedback when connectivity is lost.
/// - Show user how long they've been offline with a live timer.
///
/// ## Key Features
/// - Full-screen overlay with voidBlack background (85% opacity).
/// - Central FiftyCard with gunmetal background.
/// - Pulsing WiFi-off icon in crimsonPulse.
/// - Title in Monument Extended style, uppercase.
/// - Live offline duration timer via ConnectionViewModel.
/// - Retry button with FDL styling.
/// - Auto-dismisses when connectivity is restored.
class OfflineStatusCard extends StatefulWidget {
  /// Constructor for the [OfflineStatusCard] widget.
  const OfflineStatusCard({super.key});

  @override
  State<OfflineStatusCard> createState() => _OfflineStatusCardState();
}

class _OfflineStatusCardState extends State<OfflineStatusCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  /// Initializes the connection lost handler and pulse animation.
  @override
  void initState() {
    super.initState();
    ConnectionActions.instance.onConnectionLost();

    // Initialize pulse animation for the icon
    _pulseController = AnimationController(
      vsync: this,
      duration: FiftyMotion.systemLoad, // 800ms
    );

    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Check for reduced motion preference after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reduceMotion =
          MediaQuery.maybeDisableAnimationsOf(context) ?? false;
      if (!reduceMotion) {
        _pulseController.repeat(reverse: true);
      }
    });
  }

  /// Builds the UI for the no-internet widget.
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.scrim,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(FiftySpacing.xxl),
            child: FiftyCard(
              padding: const EdgeInsets.all(FiftySpacing.xxxl),
              backgroundColor: colorScheme.surfaceContainerHighest,
              scanlineOnHover: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pulsing WiFi-off icon
                  Semantics(
                    label: ConnectivityConfig.labelNoInternetSemantics,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Icon(
                            Icons.wifi_off,
                            color: colorScheme.error,
                            size: 64,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.xl),

                  // Title: SIGNAL LOST
                  Text(
                    ConnectivityConfig.labelSignalLost,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.titleLarge,
                      fontWeight: FiftyTypography.extraBold,
                      color: colorScheme.error,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.md),

                  // Subtitle: Attempting to restore uplink...
                  Text(
                    ConnectivityConfig.labelAttemptingRestore,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodyLarge,
                      fontWeight: FiftyTypography.regular,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: FiftySpacing.lg),

                  // Offline duration timer
                  Obx(() => Text(
                        '${ConnectivityConfig.labelOfflineFor} ${Get.find<ConnectionViewModel>().dialogTimer.value}',
                        style: TextStyle(
                          fontFamily: FiftyTypography.fontFamily,
                          fontSize: FiftyTypography.bodySmall,
                          fontWeight: FiftyTypography.regular,
                          color:
                              colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      )),
                  const SizedBox(height: FiftySpacing.xl),

                  // Loading indicator
                  FiftyLoadingIndicator(
                    text: ConnectivityConfig.labelReconnecting,
                    style: FiftyLoadingStyle.dots,
                    size: FiftyLoadingSize.medium,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: FiftySpacing.xxl),

                  // Retry button
                  FiftyButton(
                    label: ConnectivityConfig.labelRetryConnection,
                    onPressed: _refresh,
                    variant: FiftyButtonVariant.secondary,
                    icon: Icons.refresh,
                    size: FiftyButtonSize.large,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Refreshes the connectivity state when the widget is disposed.
  @override
  void dispose() {
    _pulseController.dispose();
    ConnectionActions.instance.refreshData();
    super.dispose();
  }

  /// Refreshes the connection status and data.
  void _refresh() {
    ConnectionActions.instance.checkConnectivity();
    ConnectionActions.instance.refreshData();
  }
}
