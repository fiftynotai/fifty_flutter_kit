import 'package:flutter/material.dart';

/// Fifty.dev typography tokens - the voice of the brand.
///
/// Binary type system: Hype (Monument Extended) vs Logic (JetBrains Mono).
/// All headlines use ALL CAPS convention.
class FiftyTypography {
  FiftyTypography._();

  // ============================================================================
  // FONT FAMILIES (from FDL Brand Sheet)
  // ============================================================================

  /// Monument Extended - Headlines and display text.
  ///
  /// Use for:
  /// - Hero headlines (ALL CAPS)
  /// - Section headers (ALL CAPS)
  /// - Display text requiring impact
  ///
  /// Weights: Ultrabold (800) for headlines, Regular (400) for sub-heads.
  static const String fontFamilyHeadline = 'Monument Extended';

  /// JetBrains Mono - Body, code, and UI elements.
  ///
  /// Use for:
  /// - Body copy (Sentence case)
  /// - Code blocks and terminal output
  /// - UI elements (Uppercase/Code style)
  ///
  /// The unified monospace font for logic and readability.
  static const String fontFamilyMono = 'JetBrains Mono';

  // ============================================================================
  // FONT WEIGHTS
  // ============================================================================

  /// Regular (400) - Sub-heads and body text.
  static const FontWeight regular = FontWeight.w400;

  /// Medium (500) - UI elements and emphasis.
  static const FontWeight medium = FontWeight.w500;

  /// Ultrabold (800) - Headlines.
  ///
  /// The weight for maximum impact on display text.
  static const FontWeight ultrabold = FontWeight.w800;

  // ============================================================================
  // TYPE SCALE (from FDL Brand Sheet)
  // ============================================================================

  /// Hero (64px) - The largest display text.
  ///
  /// Use for:
  /// - Landing page heroes
  /// - Major announcements
  /// - Maximum visual impact
  ///
  /// Font: Monument Extended Ultrabold, ALL CAPS, -2% tracking.
  static const double hero = 64;

  /// Display (48px) - Major headlines.
  ///
  /// Use for:
  /// - Page titles
  /// - Section intros
  /// - Prominent headers
  ///
  /// Font: Monument Extended Ultrabold, ALL CAPS, -2% tracking.
  static const double display = 48;

  /// Section (32px) - Section headers.
  ///
  /// Use for:
  /// - Section headings
  /// - Card titles
  /// - Panel headers
  ///
  /// Font: Monument Extended Regular, ALL CAPS.
  static const double section = 32;

  /// Body (16px) - Standard body text.
  ///
  /// Use for:
  /// - Paragraphs
  /// - Descriptions
  /// - Standard content
  ///
  /// Font: JetBrains Mono Regular, Sentence case, 1.5 line height.
  static const double body = 16;

  /// Mono (12px) - Terminal and code output.
  ///
  /// Use for:
  /// - Code snippets
  /// - Terminal output
  /// - Metadata and timestamps
  ///
  /// Font: JetBrains Mono Regular, 0.7 opacity for subtle text.
  static const double mono = 12;

  // ============================================================================
  // LETTER SPACING (from FDL Brand Sheet)
  // ============================================================================

  /// Tight (-2%) - Headlines.
  ///
  /// Negative tracking for dense, impactful headlines.
  /// Apply to hero, display, and section sizes.
  static const double tight = -0.02;

  /// Standard (0%) - Body text.
  ///
  /// No additional tracking for body text.
  static const double standard = 0;

  // ============================================================================
  // LINE HEIGHTS
  // ============================================================================

  /// Display line height (1.1) - Tight for impact.
  static const double displayLineHeight = 1.1;

  /// Heading line height (1.2) - Slightly tight.
  static const double headingLineHeight = 1.2;

  /// Body line height (1.5) - Comfortable reading.
  static const double bodyLineHeight = 1.5;

  /// Code line height (1.6) - Monospace spacing.
  static const double codeLineHeight = 1.6;
}
