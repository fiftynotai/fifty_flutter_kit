import 'package:flutter/material.dart';
import '../config/connectivity_config.dart';
import '../actions/connection_actions.dart';
import 'connection_handler.dart';

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
  final Widget Function(BuildContext context)? logoBuilder;

  /// Constructor for the [ConnectivityCheckerSplash] widget.
  const ConnectivityCheckerSplash({
    super.key,
    this.nextRouteName,
    this.delayInSeconds,
    this.logoBuilder,
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
