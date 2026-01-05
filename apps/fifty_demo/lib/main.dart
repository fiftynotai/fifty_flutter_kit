/// Fifty Demo App - Entry Point
///
/// Composite demo app showcasing all Fifty ecosystem packages working together.
/// Demonstrates audio, speech, sentences, and map engines with FDL styling.
library;

import 'package:flutter/material.dart';

import 'app/fifty_demo_app.dart';
import 'core/di/service_locator.dart';

/// Main entry point for the Fifty Demo application.
///
/// Initializes Flutter bindings, sets up dependency injection,
/// and runs the root app widget.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up dependency injection
  await setupServiceLocator();

  runApp(const FiftyDemoApp());
}
