/// Achievement Bindings
///
/// GetX dependency injection for the achievements feature route.
library;

import 'package:get/get.dart';

/// Bindings for the achievement screen route.
///
/// The [AchievementViewModel] is registered app-wide in [InitialBindings],
/// so this binding only exists for route-specific dependencies if needed.
class AchievementBindings extends Bindings {
  @override
  void dependencies() {
    // AchievementViewModel is app-wide (registered in InitialBindings).
    // No route-specific dependencies needed for the achievement screen.
  }
}
