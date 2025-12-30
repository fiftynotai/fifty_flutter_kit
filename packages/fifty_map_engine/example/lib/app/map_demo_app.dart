/// Map Demo App Shell
///
/// Provides the main scaffold and provider setup for the map demo feature.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/di/service_locator.dart';
import '../features/map_demo/viewmodel/map_viewmodel.dart';
import '../features/map_demo/view/map_demo_page.dart';

/// Main app shell that sets up providers for the map demo.
///
/// Uses ChangeNotifierProvider to provide [MapViewModel] to the widget tree.
class MapDemoApp extends StatelessWidget {
  const MapDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapViewModel>(
      create: (_) => serviceLocator<MapViewModel>(),
      child: const MapDemoPage(),
    );
  }
}
