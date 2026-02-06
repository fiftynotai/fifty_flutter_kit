import 'package:get/get.dart';

import 'controllers/cart_view_model.dart';
import 'data/services/sneaker_service.dart';

/// **SneakerMarketplaceBindings**
///
/// DI registration for sneaker marketplace feature.
/// Registers services, view models, and actions.
class SneakerMarketplaceBindings extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      // Services
      Bind.lazyPut<SneakerService>(() => SneakerService()),

      // ViewModels
      Bind.lazyPut<CartViewModel>(() => CartViewModel(), fenix: true),
    ];
  }

  /// Cleanup method for state reset.
  static void destroy() {
    // Clean up dependencies in reverse order
    if (Get.isRegistered<CartViewModel>()) {
      Get.delete<CartViewModel>();
    }
    if (Get.isRegistered<SneakerService>()) {
      Get.delete<SneakerService>();
    }
  }
}
