import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';

/// Wraps a widget with the necessary theme providers for testing.
Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    theme: FiftyTheme.dark(),
    home: Scaffold(
      body: Center(child: child),
    ),
  );
}

/// Wraps a widget with theme and scaffold for snackbar testing.
Widget wrapWithScaffold(Widget child) {
  return MaterialApp(
    theme: FiftyTheme.dark(),
    home: Scaffold(
      body: Builder(
        builder: (context) => Center(child: child),
      ),
    ),
  );
}
