/// Tactical Grid App Shell
///
/// Provides the main scaffold with GetX, routing, and FiftyTheme.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../core/bindings/initial_bindings.dart';
import '../core/routes/route_manager.dart';

/// Main app widget with GetX routing and FiftyTheme.
///
/// Provides:
/// - Dark mode by default (tactical game aesthetic)
/// - Global loader overlay for async actions
/// - Centralized routing via [RouteManager]
class TacticalGridApp extends StatelessWidget {
  const TacticalGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tactical Grid',
      theme: FiftyTheme.light(),
      darkTheme: FiftyTheme.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      initialRoute: RouteManager.menuRoute,
      getPages: RouteManager.pages,
      builder: (context, child) {
        final colorScheme = Theme.of(context).colorScheme;
        return GlobalLoaderOverlay(
          overlayColor: colorScheme.surface.withAlpha(200),
          overlayWidgetBuilder: (_) => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
