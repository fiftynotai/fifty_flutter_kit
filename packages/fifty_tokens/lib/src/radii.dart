import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'config/radii_config.dart';

/// Fifty.dev border radius tokens v2 - Complete radius scale.
///
/// Expanded scale from none (0) to full (9999px).
///
/// Override defaults via [FiftyTokens.configure()] with a [FiftyRadiiConfig].
class FiftyRadii {
  FiftyRadii._();

  /// Internal config -- set via [FiftyTokens.configure()].
  /// Do not set directly.
  @internal
  static FiftyRadiiConfig? config;

  // ============================================================================
  // RADIUS VALUES (v2)
  // ============================================================================

  static const double _defaultNone = 0;
  static const double _defaultSm = 4;
  static const double _defaultMd = 8;
  static const double _defaultLg = 12;
  static const double _defaultXl = 16;
  static const double _defaultXxl = 24;
  static const double _defaultXxxl = 32;
  static const double _defaultFull = 9999;

  /// None (0) - No radius.
  static double get none => config?.none ?? _defaultNone;

  /// Small (4px) - Subtle rounding.
  ///
  /// Use for: Checkboxes, small badges.
  static double get sm => config?.sm ?? _defaultSm;

  /// Medium (8px) - Default small elements.
  ///
  /// Use for: Chips, tags.
  static double get md => config?.md ?? _defaultMd;

  /// Large (12px) - Standard elements.
  ///
  /// Use for: Standard cards, inputs (legacy).
  static double get lg => config?.lg ?? _defaultLg;

  /// Extra Large (16px) - Buttons and inputs.
  ///
  /// Use for: Buttons, text fields, dropdowns.
  static double get xl => config?.xl ?? _defaultXl;

  /// 2X Large (24px) - Cards.
  ///
  /// Use for: Standard cards, containers.
  static double get xxl => config?.xxl ?? _defaultXxl;

  /// 3X Large (32px) - Hero cards.
  ///
  /// Use for: Hero cards, modals, dialogs.
  static double get xxxl => config?.xxxl ?? _defaultXxxl;

  /// Full (9999px) - Pills and circles.
  ///
  /// Use for: Pill buttons, avatars, badges.
  static double get full => config?.full ?? _defaultFull;

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
