import 'package:flutter/material.dart';

/// Fifty.dev color tokens - the visual signature of the brand.
///
/// All colors follow the Fifty Design Language (FDL) specification.
/// Dark mode is the primary environment (OLED-optimized).
///
/// The palette evokes a "Mecha Cockpit" or "Server Room" environment.
class FiftyColors {
  FiftyColors._();

  // ============================================================================
  // CORE PALETTE (from FDL Brand Sheet)
  // ============================================================================

  /// Void Black (#050505) - The infinite canvas.
  ///
  /// Use for:
  /// - Primary backgrounds
  /// - OLED-optimized surfaces
  /// - Deep, immersive environments
  ///
  /// Never pure black - has subtle warmth.
  static const Color voidBlack = Color(0xFF050505);

  /// Crimson Pulse (#960E29) - The heartbeat.
  ///
  /// Use for:
  /// - Primary buttons and CTAs
  /// - Active states and errors
  /// - Brand accents and highlights
  ///
  /// The system's heartbeat - use sparingly for maximum impact.
  static const Color crimsonPulse = Color(0xFF960E29);

  /// Gunmetal (#1A1A1A) - Surfaces.
  ///
  /// Use for:
  /// - Cards and bento containers
  /// - Panels and code blocks
  /// - Elevated surfaces
  static const Color gunmetal = Color(0xFF1A1A1A);

  /// Terminal White (#EAEAEA) - Primary text.
  ///
  /// Use for:
  /// - Headings and titles
  /// - Primary content
  /// - High legibility, reduced eye strain
  ///
  /// Not pure white - softer for extended reading.
  static const Color terminalWhite = Color(0xFFEAEAEA);

  /// Hyper Chrome (#888888) - Hardware/metadata.
  ///
  /// Use for:
  /// - Borders and inactive icons
  /// - Metadata and secondary text
  /// - Subtle separators
  static const Color hyperChrome = Color(0xFF888888);

  /// Igris Green (#00FF41) - AI Agent.
  ///
  /// Use for:
  /// - IGRIS terminal output exclusively
  /// - AI agent indicators
  /// - System status (success variant)
  ///
  /// Reserved for AI/terminal contexts only.
  static const Color igrisGreen = Color(0xFF00FF41);

  // ============================================================================
  // DERIVED COLORS
  // ============================================================================

  /// Border - Hyper Chrome at 10% opacity.
  ///
  /// Per FDL spec: 1px solid HYPER_CHROME @ 10% opacity.
  /// Use for:
  /// - Card outlines
  /// - Input borders
  /// - Subtle separators
  static const Color border = Color(0x1A888888);

  // ============================================================================
  // SEMANTIC COLORS
  // ============================================================================

  /// Success (#00BA33) - Positive actions.
  ///
  /// Use for:
  /// - Success messages
  /// - Confirmation states
  /// - Positive indicators
  static const Color success = Color(0xFF00BA33);

  /// Warning (#F7A100) - Caution states.
  ///
  /// Use for:
  /// - Warning messages
  /// - Pending states
  /// - Important notices
  static const Color warning = Color(0xFFF7A100);

  /// Error - Uses Crimson Pulse.
  ///
  /// Destructive actions carry the brand signature.
  /// Use for:
  /// - Error messages
  /// - Destructive actions
  /// - Validation failures
  static const Color error = Color(0xFF960E29);
}
