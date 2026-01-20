import 'package:flutter/material.dart';

/// Fifty.dev border radius tokens v2 - Complete radius scale.
///
/// Expanded scale from none (0) to full (9999px).
class FiftyRadii {
  FiftyRadii._();

  // ============================================================================
  // RADIUS VALUES (v2)
  // ============================================================================

  /// None (0) - No radius.
  static const double none = 0;

  /// Small (4px) - Subtle rounding.
  ///
  /// Use for: Checkboxes, small badges.
  static const double sm = 4;

  /// Medium (8px) - Default small elements.
  ///
  /// Use for: Chips, tags.
  static const double md = 8;

  /// Large (12px) - Standard elements.
  ///
  /// Use for: Standard cards, inputs (legacy).
  static const double lg = 12;

  /// Extra Large (16px) - Buttons and inputs.
  ///
  /// Use for: Buttons, text fields, dropdowns.
  static const double xl = 16;

  /// 2X Large (24px) - Cards.
  ///
  /// Use for: Standard cards, containers.
  static const double xxl = 24;

  /// 3X Large (32px) - Hero cards.
  ///
  /// Use for: Hero cards, modals, dialogs.
  static const double xxxl = 32;

  /// Full (9999px) - Pills and circles.
  ///
  /// Use for: Pill buttons, avatars, badges.
  static const double full = 9999;

  // ============================================================================
  // BORDERRADIUS OBJECTS (Convenience)
  // ============================================================================

  /// BorderRadius for none (0).
  static const BorderRadius noneRadius = BorderRadius.zero;

  /// BorderRadius for sm (4px).
  static final BorderRadius smRadius = BorderRadius.circular(sm);

  /// BorderRadius for md (8px).
  static final BorderRadius mdRadius = BorderRadius.circular(md);

  /// BorderRadius for lg (12px).
  static final BorderRadius lgRadius = BorderRadius.circular(lg);

  /// BorderRadius for xl (16px).
  static final BorderRadius xlRadius = BorderRadius.circular(xl);

  /// BorderRadius for xxl (24px).
  static final BorderRadius xxlRadius = BorderRadius.circular(xxl);

  /// BorderRadius for xxxl (32px).
  static final BorderRadius xxxlRadius = BorderRadius.circular(xxxl);

  /// BorderRadius for full (9999px).
  static final BorderRadius fullRadius = BorderRadius.circular(full);

  // ============================================================================
  // DEPRECATED (v1 compatibility)
  // ============================================================================

  /// @deprecated Use [lg] (12) instead.
  @Deprecated('Use lg (12) instead')
  static const double standard = 12;

  /// @deprecated Use [xxl] (24) instead.
  @Deprecated('Use xxl (24) instead')
  static const double smooth = 24;

  /// @deprecated Use [lgRadius] instead.
  @Deprecated('Use lgRadius instead')
  static final BorderRadius standardRadius = BorderRadius.circular(12);

  /// @deprecated Use [xxlRadius] instead.
  @Deprecated('Use xxlRadius instead')
  static final BorderRadius smoothRadius = BorderRadius.circular(24);
}
