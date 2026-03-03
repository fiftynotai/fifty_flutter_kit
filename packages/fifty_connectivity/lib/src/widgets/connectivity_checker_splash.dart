import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/connectivity_config.dart';
import '../actions/connection_actions.dart';
import '../controllers/connection_view_model.dart';
import 'connection_handler.dart';

/// States exposed to splash content builders.
///
/// Simplifies the 5-value [ConnectivityType] into 3 consumer-facing states
/// suitable for splash screen UIs.
enum SplashConnectivityState {
  /// Connectivity check is in progress.
  checking,

  /// Device is connected to the internet.
  connected,

  /// Connectivity check failed (disconnected or no internet).
  failed,
}

/// Builder for custom splash screen content based on connectivity state.
///
/// - [context]: The build context.
/// - [state]: The current connectivity check state.
/// - [retryAction]: Callback to retry the connectivity check.
///
/// When provided to [ConnectivityCheckerSplash.contentBuilder], replaces
/// the default splash content while preserving the [Scaffold] wrapper
/// and connectivity check pipeline.
///
/// **Note:** When [ConnectivityCheckerSplash.contentBuilder] is provided,
/// [ConnectivityCheckerSplash.logoBuilder] is ignored since the builder
/// controls all inner content.
typedef SplashContentBuilder = Widget Function(
  BuildContext context,
  SplashConnectivityState state,
  VoidCallback retryAction,
);

/// **ConnectivityCheckerSplash**
///
/// Splash screen that waits for connectivity initialization before navigating
/// to the next route. Useful when the app experience should begin only when
/// basic network availability is confirmed.
///
/// ## Parameters
/// - [nextRouteName]: Route to navigate to after initialization (defaults to [ConnectivityConfig.defaultNextRoute]).
/// - [delayInSeconds]: Optional delay before navigating (defaults to [ConnectivityConfig.splashDelaySeconds]).
/// - [logoBuilder]: Optional custom logo widget builder. Falls back to [ConnectivityConfig.logoBuilder] or a default placeholder.
/// - [contentBuilder]: Optional builder that replaces the default splash content with custom UI per [SplashConnectivityState].
///   When provided, [logoBuilder] is ignored since the builder controls all inner content.
///
/// ## Usage
/// ```dart
/// // Basic usage with defaults
/// const ConnectivityCheckerSplash()
///
/// // Custom route and delay
/// const ConnectivityCheckerSplash(
///   nextRouteName: '/home',
///   delayInSeconds: 2,
/// )
///
/// // Custom logo
/// ConnectivityCheckerSplash(
///   logoBuilder: (context) => SvgPicture.asset('assets/logo.svg'),
/// )
///
/// // Custom content builder
/// ConnectivityCheckerSplash(
///   contentBuilder: (context, state, retry) {
///     switch (state) {
///       case SplashConnectivityState.checking:
///         return const CircularProgressIndicator();
///       case SplashConnectivityState.connected:
///         return const Icon(Icons.check_circle);
///       case SplashConnectivityState.failed:
///         return ElevatedButton(onPressed: retry, child: const Text('Retry'));
///     }
///   },
/// )
/// ```
///
/// ## Configuration
/// Set global defaults via [ConnectivityConfig]:
/// ```dart
/// ConnectivityConfig.logoBuilder = (context) => Image.asset('assets/logo.png');
/// ConnectivityConfig.defaultNextRoute = '/home';
/// ConnectivityConfig.splashDelaySeconds = 2;
/// ```
///
/// ## Notes
/// - Delegates connectivity checks and navigation timing to [ConnectionActions].
/// - Requires [ConnectivityConfig.navigateOff] to be set for navigation to work.
class ConnectivityCheckerSplash extends StatefulWidget {
  /// Route to navigate to after initialization.
  /// Defaults to [ConnectivityConfig.defaultNextRoute].
  final String? nextRouteName;

  /// Delay in seconds before navigating.
  /// Defaults to [ConnectivityConfig.splashDelaySeconds].
  final int? delayInSeconds;

  /// Custom logo widget builder.
  /// Falls back to [ConnectivityConfig.logoBuilder] or a default placeholder.
  ///
  /// Ignored when [contentBuilder] is provided.
  final Widget Function(BuildContext context)? logoBuilder;

  /// Optional builder that replaces the default splash content with custom UI.
  ///
  /// When provided, the builder receives the current [SplashConnectivityState]
  /// and a retry callback, and controls all inner content. The [Scaffold] and
  /// [Center] wrapper remain widget-owned.
  ///
  /// When null, the default [ConnectionHandler]-based content is used.
  final SplashContentBuilder? contentBuilder;

  /// Constructor for the [ConnectivityCheckerSplash] widget.
  const ConnectivityCheckerSplash({
    super.key,
    this.nextRouteName,
    this.delayInSeconds,
    this.logoBuilder,
    this.contentBuilder,
  });

  @override
  State<ConnectivityCheckerSplash> createState() =>
      _ConnectivityCheckerSplashState();
}

class _ConnectivityCheckerSplashState extends State<ConnectivityCheckerSplash> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    // Builder path: consumer replaces inner content
    if (widget.contentBuilder != null) {
      return Scaffold(
        body: Center(
          child: Obx(() {
            final state = _mapToSplashState(
              Get.find<ConnectionViewModel>().connectionType.value,
            );
            return widget.contentBuilder!(context, state, _init);
          }),
        ),
      );
    }

    // Default path (existing behavior unchanged)
    return Scaffold(
      body: Center(
        child: ConnectionHandler(
          tryAgainAction: _init,
          connectedWidget: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildLogo(context),
          ),
        ),
      ),
    );
  }

  /// Maps infrastructure-level [ConnectivityType] to the simplified
  /// consumer-facing [SplashConnectivityState].
  SplashConnectivityState _mapToSplashState(ConnectivityType type) {
    switch (type) {
      case ConnectivityType.connecting:
        return SplashConnectivityState.checking;
      case ConnectivityType.wifi:
      case ConnectivityType.mobileData:
        return SplashConnectivityState.connected;
      case ConnectivityType.disconnected:
      case ConnectivityType.noInternet:
        return SplashConnectivityState.failed;
    }
  }

  /// Builds the logo widget using the priority:
  /// 1. Widget's [logoBuilder] parameter
  /// 2. [ConnectivityConfig.logoBuilder]
  /// 3. Default placeholder
  Widget _buildLogo(BuildContext context) {
    // Priority 1: Widget's logoBuilder
    if (widget.logoBuilder != null) {
      return widget.logoBuilder!(context);
    }

    // Priority 2: Config's logoBuilder
    if (ConnectivityConfig.logoBuilder != null) {
      return ConnectivityConfig.logoBuilder!(context);
    }

    // Priority 3: Default placeholder
    return _buildDefaultPlaceholder(context);
  }

  /// Builds a default placeholder logo when no custom logo is configured.
  Widget _buildDefaultPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.of(context).size.height / 3,
      height: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          Icons.wifi,
          size: 64,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  void _init() {
    final route = widget.nextRouteName ?? ConnectivityConfig.defaultNextRoute;
    final delay = widget.delayInSeconds ?? ConnectivityConfig.splashDelaySeconds;
    ConnectionActions.instance.initSplash(route, delay);
  }
}
