/// Settings Bindings
///
/// GetX dependency injection registration for the settings feature.
/// Only registers [SettingsActions] since the [SettingsViewModel] and
/// [SettingsService] are already registered app-wide in [InitialBindings].
///
/// **Usage:**
/// ```dart
/// GetPage(
///   name: '/settings',
///   page: () => const SettingsPage(),
///   binding: SettingsBindings(),
/// );
/// ```
library;

import 'package:get/get.dart';

import 'actions/settings_actions.dart';
import 'controllers/settings_view_model.dart';

/// Registers settings-route-scoped dependencies.
///
/// The [SettingsActions] layer is registered here (lazily, with fenix)
/// because it is only needed when the settings page is active.
/// The [SettingsViewModel] is already permanent and app-wide.
class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsActions>(
      () => SettingsActions(Get.find<SettingsViewModel>()),
      fenix: true,
    );
  }
}
