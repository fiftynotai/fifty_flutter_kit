import 'package:flutter/material.dart';

import 'sneaker_colors.dart';
import 'sneaker_typography.dart';

/// **SneakerTheme**
///
/// FDL-compliant theme data for the sneaker marketplace.
/// Uses "Sophisticated Warm" palette with Manrope typography.
abstract class SneakerTheme {
  SneakerTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: SneakerColors.darkBurgundy,
        colorScheme: const ColorScheme.dark(
          primary: SneakerColors.burgundy,
          onPrimary: SneakerColors.cream,
          secondary: SneakerColors.slateGrey,
          onSecondary: SneakerColors.cream,
          surface: SneakerColors.surfaceDark,
          onSurface: SneakerColors.cream,
          error: SneakerColors.burgundy,
          onError: SneakerColors.cream,
        ),
        textTheme: SneakerTypography.textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: SneakerColors.cream,
          ),
          iconTheme: IconThemeData(color: SneakerColors.cream),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: SneakerColors.burgundy,
            foregroundColor: SneakerColors.cream,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: SneakerColors.cream,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            side: const BorderSide(color: SneakerColors.slateGrey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: SneakerColors.surfaceDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: SneakerColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: SneakerColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: SneakerColors.powderBlush),
          ),
          labelStyle: const TextStyle(color: SneakerColors.slateGrey),
          hintStyle: TextStyle(color: SneakerColors.slateGrey.withValues(alpha: 0.7)),
        ),
        cardTheme: CardThemeData(
          color: SneakerColors.surfaceDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: SneakerColors.border),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: SneakerColors.border,
          thickness: 1,
        ),
        iconTheme: const IconThemeData(
          color: SneakerColors.cream,
          size: 24,
        ),
      );
}
