/// Coffee Showcase - Entry Point
///
/// Single-page Flutter web app demonstrating fifty_scroll_sequence
/// with real video-extracted frames from a coffee product animation.
library;

import 'package:flutter/material.dart';

import 'app/app.dart';

/// Main entry point for the Coffee Showcase application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CoffeeShowcaseApp());
}
