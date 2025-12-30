/// Fifty Map Engine Example App
///
/// Demonstrates the fifty_map_engine package with Fifty Design Language styling.
/// Features interactive map rendering, entity manipulation, and camera controls.
library;

import 'package:fifty_map_engine/fifty_map_engine.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/map_demo_app.dart';
import 'core/di/service_locator.dart';

/// Main entry point for the example app.
///
/// Initializes Flutter bindings, forces landscape orientation,
/// registers assets, sets up DI, and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force landscape orientation for board-game-like experience
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Register all map assets before running the app
  FiftyAssetLoader.registerAssets([
    'rooms/small_room.png',
    'rooms/medium_room.png',
    'rooms/large_room.jpg',
    'rooms/corridor_room.jpg',
    'rooms/stairs.png',
    'rooms/purple_room.png',
    'furniture/door.png',
    'furniture/locked_door.png',
    'furniture/rock_door.png',
    'furniture/box.png',
    'furniture/locker.png',
    'furniture/table.png',
    'furniture/token.png',
    'furniture/skull.png',
    'furniture/square.png',
    'monsters/m-1.png',
    'monsters/m-2.png',
    'monsters/m-3.png',
    'monsters/m-4.png',
    'events/basic.png',
    'events/npc.png',
    'events/master_of_shadow.png',
  ]);

  // Set up dependency injection
  await setupServiceLocator();

  runApp(const MapEngineExampleApp());
}

/// Root widget for the Map Engine example app.
///
/// Applies FDL dark theme and routes to the main demo page.
class MapEngineExampleApp extends StatelessWidget {
  const MapEngineExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifty Map Engine',
      theme: FiftyTheme.dark(),
      debugShowCheckedModeBanner: false,
      home: const MapDemoApp(),
    );
  }
}
