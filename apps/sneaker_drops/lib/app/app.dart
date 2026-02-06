import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/routes/route_manager.dart';
import '../core/theme/sneaker_theme.dart';

/// **SneakerDropsApp**
///
/// Root application widget for the sneaker marketplace.
/// Uses GetMaterialApp for routing and state management.
class SneakerDropsApp extends StatelessWidget {
  const SneakerDropsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sneaker Drops',
      debugShowCheckedModeBanner: false,
      theme: SneakerTheme.dark,
      initialRoute: RouteManager.initialRoute,
      getPages: RouteManager.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
