import 'package:flutter/material.dart';

/// Fifty.dev border radius tokens - shape system.
///
/// Simplified to two primary radii per FDL specification:
/// - Standard (12px) - Default for all elements
/// - Smooth (24px) - Softer, more rounded elements
class FiftyRadii {
  FiftyRadii._();

  // ============================================================================
  // RADIUS VALUES (from FDL Brand Sheet)
  // ============================================================================

  /// Standard radius (12px) - Default for all elements.
  ///
  /// Use for:
  /// - Cards and containers
  /// - Buttons and inputs
  /// - Panels and modals
  ///
  /// The default choice for most UI elements.
  static const double standard = 12;

  /// Smooth radius (24px) - Softer elements.
  ///
  /// Use for:
  /// - Hero cards
  /// - Feature panels
  /// - Elements requiring softer appearance
  static const double smooth = 24;

  /// Full radius (999px) - Pills and circles.
  ///
  /// Use for:
  /// - Pill buttons
  /// - Circular avatars
  /// - Badges
  static const double full = 999;

  // ============================================================================
  // BORDERRADIUS OBJECTS (Convenience)
  // ============================================================================

  /// BorderRadius for standard radius (12px).
  static final BorderRadius standardRadius = BorderRadius.circular(standard);

  /// BorderRadius for smooth radius (24px).
  static final BorderRadius smoothRadius = BorderRadius.circular(smooth);

  /// BorderRadius for full radius (999px).
  static final BorderRadius fullRadius = BorderRadius.circular(full);
}
