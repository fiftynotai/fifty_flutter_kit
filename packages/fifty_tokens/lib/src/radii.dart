import 'package:flutter/material.dart';

import 'config/fifty_tokens_config.dart';

/// Fifty.dev border radius tokens -- reads from the active [FiftyPreset].
///
/// Expanded scale from none (0) to full (9999px).
class FiftyRadii {
  FiftyRadii._();

  // ============================================================================
  // RADIUS VALUES (v2)
  // ============================================================================

  /// None (0) - No radius.
  static double get none => FiftyTokens.active.radii.none;

  /// Small (4px) - Subtle rounding.
  ///
  /// Use for: Checkboxes, small badges.
  static double get sm => FiftyTokens.active.radii.sm;

  /// Medium (8px) - Default small elements.
  ///
  /// Use for: Chips, tags.
  static double get md => FiftyTokens.active.radii.md;

  /// Large (12px) - Standard elements.
  ///
  /// Use for: Standard cards, inputs (legacy).
  static double get lg => FiftyTokens.active.radii.lg;

  /// Extra Large (16px) - Buttons and inputs.
  ///
  /// Use for: Buttons, text fields, dropdowns.
  static double get xl => FiftyTokens.active.radii.xl;

  /// 2X Large (24px) - Cards.
  ///
  /// Use for: Standard cards, containers.
  static double get xxl => FiftyTokens.active.radii.xxl;

  /// 3X Large (32px) - Hero cards.
  ///
  /// Use for: Hero cards, modals, dialogs.
  static double get xxxl => FiftyTokens.active.radii.xxxl;

  /// Full (9999px) - Pills and circles.
  ///
  /// Use for: Pill buttons, avatars, badges.
  static double get full => FiftyTokens.active.radii.full;

  // ============================================================================
  // BORDERRADIUS OBJECTS (Convenience)
  // ============================================================================

  /// BorderRadius for none (0).
  static BorderRadius get noneRadius => BorderRadius.circular(none);

  /// BorderRadius for sm (4px).
  static BorderRadius get smRadius => BorderRadius.circular(sm);

  /// BorderRadius for md (8px).
  static BorderRadius get mdRadius => BorderRadius.circular(md);

  /// BorderRadius for lg (12px).
  static BorderRadius get lgRadius => BorderRadius.circular(lg);

  /// BorderRadius for xl (16px).
  static BorderRadius get xlRadius => BorderRadius.circular(xl);

  /// BorderRadius for xxl (24px).
  static BorderRadius get xxlRadius => BorderRadius.circular(xxl);

  /// BorderRadius for xxxl (32px).
  static BorderRadius get xxxlRadius => BorderRadius.circular(xxxl);

  /// BorderRadius for full (9999px).
  static BorderRadius get fullRadius => BorderRadius.circular(full);

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
