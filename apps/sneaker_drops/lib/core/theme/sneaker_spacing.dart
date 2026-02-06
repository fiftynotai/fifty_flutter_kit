import 'package:flutter/material.dart';

/// **SneakerSpacing**
///
/// FDL 4px grid spacing scale for sneaker marketplace.
/// Use these constants for all padding, margin, and gap values.
abstract class SneakerSpacing {
  SneakerSpacing._();

  // Base unit
  static const double unit = 4.0;

  // Spacing scale
  static const double xs = 4.0; // 1 unit
  static const double sm = 8.0; // 2 units
  static const double md = 12.0; // 3 units
  static const double lg = 16.0; // 4 units
  static const double xl = 20.0; // 5 units
  static const double xxl = 24.0; // 6 units
  static const double xxxl = 32.0; // 8 units
  static const double huge = 40.0; // 10 units
  static const double massive = 48.0; // 12 units

  // EdgeInsets helpers
  static const EdgeInsets allXs = EdgeInsets.all(xs);
  static const EdgeInsets allSm = EdgeInsets.all(sm);
  static const EdgeInsets allMd = EdgeInsets.all(md);
  static const EdgeInsets allLg = EdgeInsets.all(lg);
  static const EdgeInsets allXl = EdgeInsets.all(xl);
  static const EdgeInsets allXxl = EdgeInsets.all(xxl);
  static const EdgeInsets allXxxl = EdgeInsets.all(xxxl);

  // Horizontal padding
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);
  static const EdgeInsets horizontalXxl = EdgeInsets.symmetric(horizontal: xxl);

  // Vertical padding
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);
  static const EdgeInsets verticalXxl = EdgeInsets.symmetric(vertical: xxl);

  // Page padding
  static const EdgeInsets pageMobile = EdgeInsets.all(lg);
  static const EdgeInsets pageTablet = EdgeInsets.all(xxl);
  static const EdgeInsets pageDesktop = EdgeInsets.all(xxxl);

  // Card padding
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(xxl);
}
