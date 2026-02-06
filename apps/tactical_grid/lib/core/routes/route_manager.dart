/// Route Manager
///
/// Centralized routing configuration for Tactical Grid.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/achievements/achievement_bindings.dart';
import '../../features/achievements/views/achievement_page.dart';
import '../../features/battle/battle_bindings.dart';
import '../../features/battle/views/battle_page.dart';
import '../../features/menu/menu_page.dart';

/// Centralized routing for the Tactical Grid app.
///
/// **Routes:**
/// - `/` - Main menu screen
/// - `/battle` - Battle screen (tactical grid gameplay)
/// - `/settings` - Settings screen
class RouteManager {
  /// Main menu route.
  static const String menuRoute = '/';

  /// Battle screen route.
  static const String battleRoute = '/battle';

  /// Settings screen route.
  static const String settingsRoute = '/settings';

  /// Achievement screen route.
  static const String achievementRoute = '/achievements';

  /// All registered pages for GetX navigation.
  static List<GetPage<dynamic>> get pages => [
        GetPage<void>(
          name: menuRoute,
          page: () => const MenuPage(),
        ),
        GetPage<void>(
          name: battleRoute,
          page: () => const BattlePage(),
          binding: BattleBindings(),
        ),
        GetPage<void>(
          name: settingsRoute,
          page: () => const _PlaceholderPage(title: 'SETTINGS'),
        ),
        GetPage<void>(
          name: achievementRoute,
          page: () => const AchievementPage(),
          binding: AchievementBindings(),
        ),
      ];

  /// Navigate to a route.
  static Future<T?>? to<T>(String route, {dynamic arguments}) {
    return Get.toNamed<T>(route, arguments: arguments);
  }

  /// Navigate to a route and remove current from stack.
  static Future<T?>? off<T>(String route, {dynamic arguments}) {
    return Get.offNamed<T>(route, arguments: arguments);
  }

  /// Navigate to a route and clear entire stack.
  static Future<T?>? offAll<T>(String route, {dynamic arguments}) {
    return Get.offAllNamed<T>(route, arguments: arguments);
  }

  /// Go back to previous route.
  static void back<T>({T? result}) {
    Get.back<T>(result: result);
  }

  /// Navigate to battle screen.
  static Future<dynamic>? toBattle() => to(battleRoute);

  /// Navigate to settings.
  static Future<dynamic>? toSettings() => to(settingsRoute);

  /// Navigate to achievements screen.
  static Future<dynamic>? toAchievements() => to(achievementRoute);

  /// Navigate to main menu (clear stack).
  static Future<dynamic>? toMenu() => offAll(menuRoute);
}

/// Placeholder page widget for routes not yet implemented.
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
