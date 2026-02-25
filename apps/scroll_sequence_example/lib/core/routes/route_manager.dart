/// Scroll Sequence Example - Route Manager
///
/// Defines four routes for the demo: menu, basic, pinned, and multi.
library;

import 'package:get/get.dart';

import '../../features/basic/views/basic_page.dart';
import '../../features/menu/views/menu_page.dart';
import '../../features/multi/views/multi_sequence_page.dart';
import '../../features/pinned/views/pinned_page.dart';

/// Centralized route definitions for the scroll sequence demo.
///
/// No bindings are needed since the demos are self-contained
/// StatelessWidget or StatefulWidget pages with no DI.
class RouteManager {
  RouteManager._();

  /// Menu / landing page.
  static const String menuRoute = '/';

  /// Basic (non-pinned) scroll sequence demo.
  static const String basicRoute = '/basic';

  /// Pinned scroll sequence demo with controller.
  static const String pinnedRoute = '/pinned';

  /// Multi-sequence demo with two independent sequences.
  static const String multiRoute = '/multi';

  /// All registered pages for [GetMaterialApp.getPages].
  static final List<GetPage<dynamic>> pages = [
    GetPage<dynamic>(
      name: menuRoute,
      page: () => const MenuPage(),
    ),
    GetPage<dynamic>(
      name: basicRoute,
      page: () => const BasicPage(),
    ),
    GetPage<dynamic>(
      name: pinnedRoute,
      page: () => const PinnedPage(),
    ),
    GetPage<dynamic>(
      name: multiRoute,
      page: () => const MultiSequencePage(),
    ),
  ];
}
