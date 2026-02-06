import 'package:flutter/material.dart';

/// **SneakerRadii**
///
/// FDL v2 border radius scale for sneaker marketplace.
/// Use these constants for all border radius values.
abstract class SneakerRadii {
  SneakerRadii._();

  // Radius values
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double full = 9999.0;

  // BorderRadius helpers
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius radiusXxxl = BorderRadius.all(Radius.circular(xxxl));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));

  // Semantic radii
  static const BorderRadius badge = radiusSm;
  static const BorderRadius chip = radiusMd;
  static const BorderRadius input = radiusXl;
  static const BorderRadius card = radiusXxl;
  static const BorderRadius heroCard = radiusXxxl;
  static const BorderRadius pill = radiusFull;
}
