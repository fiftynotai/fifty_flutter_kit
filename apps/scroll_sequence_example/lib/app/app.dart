/// Scroll Sequence Example - App Shell
///
/// GetMaterialApp with FDL dark theme and route configuration.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/routes/route_manager.dart';

/// Root application widget for the scroll sequence demo.
///
/// Uses [GetMaterialApp] for routing (ecosystem convention) and
/// [FiftyTheme.dark] as the primary theme.
class ScrollSequenceExampleApp extends StatelessWidget {
  /// Creates the scroll sequence example app.
  const ScrollSequenceExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Scroll Sequence',
      theme: FiftyTheme.dark(),
      darkTheme: FiftyTheme.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: RouteManager.menuRoute,
      getPages: RouteManager.pages,
    );
  }
}
