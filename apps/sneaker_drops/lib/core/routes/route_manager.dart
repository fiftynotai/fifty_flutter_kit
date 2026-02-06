import 'package:get/get.dart';

import '../../features/sneaker_marketplace/sneaker_marketplace_bindings.dart';
import '../../features/sneaker_marketplace/views/landing_page.dart';
import '../../features/sneaker_marketplace/views/catalog_page.dart';
import '../../features/sneaker_marketplace/views/product_detail_page.dart';
import '../../features/sneaker_marketplace/views/cart_page.dart';
import '../../features/sneaker_marketplace/views/checkout_page.dart';

/// **RouteManager**
///
/// Centralized routing configuration for the sneaker marketplace.
/// All navigation goes through this manager.
class RouteManager {
  RouteManager._();

  // Route constants
  static const String initialRoute = landing;
  static const String landing = '/';
  static const String catalog = '/catalog';
  static const String productDetail = '/product/:id';
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  // Route pages
  static List<GetPage> get pages => [
        GetPage(
          name: landing,
          page: () => const LandingPage(),
          binding: SneakerMarketplaceBindings(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: catalog,
          page: () => const CatalogPage(),
          binding: SneakerMarketplaceBindings(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: productDetail,
          page: () => const ProductDetailPage(),
          binding: SneakerMarketplaceBindings(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: cart,
          page: () => const CartPage(),
          binding: SneakerMarketplaceBindings(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: checkout,
          page: () => const CheckoutPage(),
          binding: SneakerMarketplaceBindings(),
          transition: Transition.rightToLeft,
        ),
      ];

  // Navigation helpers
  static Future<T?>? to<T>(String route, {dynamic arguments}) =>
      Get.toNamed<T>(route, arguments: arguments);

  static Future<T?>? off<T>(String route, {dynamic arguments}) =>
      Get.offNamed<T>(route, arguments: arguments);

  static Future<T?>? offAll<T>(String route, {dynamic arguments}) =>
      Get.offAllNamed<T>(route, arguments: arguments);

  static void back<T>({T? result}) => Get.back<T>(result: result);

  // Specific navigation helpers
  static Future<dynamic>? toLanding() => to(landing);
  static Future<dynamic>? toCatalog() => to(catalog);
  static Future<dynamic>? toProduct(String id) =>
      to(productDetail.replaceAll(':id', id));
  static Future<dynamic>? toCart() => to(cart);
  static Future<dynamic>? toCheckout() => to(checkout);
}
