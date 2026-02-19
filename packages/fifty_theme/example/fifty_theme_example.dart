// ignore_for_file: avoid_print

import 'package:fifty_theme/fifty_theme.dart';

void main() {
  // ===========================================================================
  // FIFTY THEME EXAMPLE
  // Demonstrating the FDL theming layer built on fifty_tokens
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Create ThemeData using FiftyTheme
  // ---------------------------------------------------------------------------

  // Dark theme (primary FDL experience)
  final darkTheme = FiftyTheme.dark();
  print('Dark theme created: ${darkTheme.brightness}');

  // Light theme (equal-quality alternative)
  final lightTheme = FiftyTheme.light();
  print('Light theme created: ${lightTheme.brightness}');

  // ---------------------------------------------------------------------------
  // Use in MaterialApp
  // ---------------------------------------------------------------------------

  // MaterialApp(
  //   theme: FiftyTheme.light(),
  //   darkTheme: FiftyTheme.dark(),
  //   themeMode: ThemeMode.dark,
  // );

  // ---------------------------------------------------------------------------
  // Access color scheme
  // ---------------------------------------------------------------------------

  final colorScheme = darkTheme.colorScheme;
  print('Primary: ${colorScheme.primary}');
  print('Surface: ${colorScheme.surface}');
  print('On Surface: ${colorScheme.onSurface}');

  // ---------------------------------------------------------------------------
  // Access text theme
  // ---------------------------------------------------------------------------

  final textTheme = darkTheme.textTheme;
  print('Display Large: ${textTheme.displayLarge?.fontSize}px');
  print('Body Medium: ${textTheme.bodyMedium?.fontSize}px');
  print('Label Large: ${textTheme.labelLarge?.fontSize}px');

  // ---------------------------------------------------------------------------
  // Access FiftyThemeExtension (in a widget with BuildContext)
  // ---------------------------------------------------------------------------

  // final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;
  // print('Accent: ${fifty.accent}');
  // print('Success: ${fifty.success}');
  // print('Warning: ${fifty.warning}');

  // ---------------------------------------------------------------------------
  // Component themes are pre-configured
  // ---------------------------------------------------------------------------

  print('Card theme elevation: ${darkTheme.cardTheme.elevation}');
  print('AppBar elevation: ${darkTheme.appBarTheme.elevation}');
  print('Material 3: ${darkTheme.useMaterial3}');
}
