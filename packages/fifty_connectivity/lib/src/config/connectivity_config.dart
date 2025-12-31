import 'package:flutter/widgets.dart';

/// Configuration for fifty_connectivity package.
///
/// Provides centralized configuration for all connectivity-related labels,
/// navigation, and splash screen settings. All values can be customized
/// before use (e.g., for localization or theming).
///
/// **Usage:**
/// ```dart
/// // Configure labels (for localization)
/// ConnectivityConfig.labelSignalLost = 'SIGNAL_LOST'.tr;
/// ConnectivityConfig.labelTryAgain = 'TRY_AGAIN'.tr;
///
/// // Configure navigation
/// ConnectivityConfig.navigateOff = (route) async {
///   Get.offAllNamed(route);
/// };
///
/// // Configure splash screen
/// ConnectivityConfig.logoBuilder = (context) => SvgPicture.asset('assets/logo.svg');
/// ConnectivityConfig.defaultNextRoute = '/home';
/// ```
class ConnectivityConfig {
  ConnectivityConfig._();

  // ────────────────────────────────────────────────────────────────────────────
  // Labels (can be localized by setting before use)
  // ────────────────────────────────────────────────────────────────────────────

  /// Label for signal lost status (used in overlays and cards).
  static String labelSignalLost = 'SIGNAL LOST';

  /// Label for establishing uplink status.
  static String labelEstablishingUplink = 'ESTABLISHING UPLINK';

  /// Label for reconnecting status.
  static String labelReconnecting = 'RECONNECTING';

  /// Label for retry connection button.
  static String labelRetryConnection = 'RETRY CONNECTION';

  /// Label for try again button.
  static String labelTryAgain = 'TRY AGAIN';

  /// Label prefix for offline duration display.
  static String labelOfflineFor = 'Offline for:';

  /// Label for attempting to restore uplink message.
  static String labelAttemptingRestore = 'Attempting to restore uplink...';

  /// Label for connection lost subtitle.
  static String labelConnectionLost = 'Connection to server lost';

  /// Semantics label for no internet accessibility.
  static String labelNoInternetSemantics = 'No internet connection';

  /// Label for uplink active status.
  static String labelUplinkActive = 'UPLINK ACTIVE';

  // ────────────────────────────────────────────────────────────────────────────
  // Navigation callback (null = no auto-navigation)
  // ────────────────────────────────────────────────────────────────────────────

  /// Callback for navigation. Set this to integrate with your app's navigation.
  ///
  /// If null, navigation will be skipped (caller handles navigation).
  ///
  /// **Example:**
  /// ```dart
  /// ConnectivityConfig.navigateOff = (route) async {
  ///   Get.offAllNamed(route);
  /// };
  /// ```
  static Future<void> Function(String route)? navigateOff;

  // ────────────────────────────────────────────────────────────────────────────
  // Splash screen config
  // ────────────────────────────────────────────────────────────────────────────

  /// Builder function for the logo widget in splash screen.
  ///
  /// If null, a default placeholder will be used.
  ///
  /// **Example:**
  /// ```dart
  /// ConnectivityConfig.logoBuilder = (context) => SvgPicture.asset(
  ///   'assets/logo.svg',
  ///   height: MediaQuery.of(context).size.height / 3,
  /// );
  /// ```
  static Widget Function(BuildContext context)? logoBuilder;

  /// Default route to navigate to after splash initialization.
  static String defaultNextRoute = '/auth';

  /// Delay in seconds before navigating from splash screen.
  static int splashDelaySeconds = 1;

  // ────────────────────────────────────────────────────────────────────────────
  // Reset
  // ────────────────────────────────────────────────────────────────────────────

  /// Reset all configuration to defaults (useful for testing).
  static void reset() {
    labelSignalLost = 'SIGNAL LOST';
    labelEstablishingUplink = 'ESTABLISHING UPLINK';
    labelReconnecting = 'RECONNECTING';
    labelRetryConnection = 'RETRY CONNECTION';
    labelTryAgain = 'TRY AGAIN';
    labelOfflineFor = 'Offline for:';
    labelAttemptingRestore = 'Attempting to restore uplink...';
    labelConnectionLost = 'Connection to server lost';
    labelNoInternetSemantics = 'No internet connection';
    labelUplinkActive = 'UPLINK ACTIVE';
    navigateOff = null;
    logoBuilder = null;
    defaultNextRoute = '/auth';
    splashDelaySeconds = 1;
  }
}
