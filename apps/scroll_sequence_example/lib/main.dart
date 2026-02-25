/// Scroll Sequence Example - Entry Point
///
/// Showcase app demonstrating the fifty_scroll_sequence package
/// with basic, pinned, and multi-sequence demos.
library;

import 'package:flutter/material.dart';

import 'app/app.dart';

/// Main entry point for the Scroll Sequence Example application.
///
/// Initializes Flutter bindings and runs the root app widget.
/// No DI or storage needed -- this is a lightweight package demo.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ScrollSequenceExampleApp());
}
