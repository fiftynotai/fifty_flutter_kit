import 'package:flutter/material.dart';

/// Immutable theme configuration for skill tree appearance.
///
/// Contains all visual properties including node colors by state,
/// node colors by type, connection colors, sizes, and text styles.
///
/// **Example:**
/// ```dart
/// // Use default dark theme
/// final theme = SkillTreeTheme.dark();
///
/// // Customize specific colors
/// final customTheme = theme.copyWith(
///   availableNodeColor: Color(0xFF2196F3),
///   unlockedNodeColor: Color(0xFF4CAF50),
/// );
/// ```
@immutable
class SkillTreeTheme {
  /// Creates a skill tree theme with all properties.
  ///
  /// For convenience, use [SkillTreeTheme.dark] or [SkillTreeTheme.light]
  /// factory constructors which provide sensible defaults.
  const SkillTreeTheme({
    // Node colors by state
    required this.lockedNodeColor,
    required this.lockedNodeBorderColor,
    required this.availableNodeColor,
    required this.availableNodeBorderColor,
    required this.unlockedNodeColor,
    required this.unlockedNodeBorderColor,
    required this.maxedNodeColor,
    required this.maxedNodeBorderColor,
    // Node colors by type
    required this.passiveColor,
    required this.activeColor,
    required this.ultimateColor,
    required this.keystoneColor,
    // Connection colors
    required this.connectionLockedColor,
    required this.connectionUnlockedColor,
    this.connectionHighlightColor,
    // Sizes
    required this.nodeRadius,
    required this.nodeBorderWidth,
    required this.connectionWidth,
    // Text styles
    this.nodeNameStyle,
    this.nodeLevelStyle,
    this.nodeCostStyle,
    this.tooltipTitleStyle,
    this.tooltipDescriptionStyle,
    // Tooltip
    this.tooltipBackground,
    this.tooltipBorder,
  });

  // ---- Node colors by state ----

  /// Background color for locked nodes.
  final Color lockedNodeColor;

  /// Border color for locked nodes.
  final Color lockedNodeBorderColor;

  /// Background color for available (can unlock) nodes.
  final Color availableNodeColor;

  /// Border color for available nodes.
  final Color availableNodeBorderColor;

  /// Background color for unlocked (in progress) nodes.
  final Color unlockedNodeColor;

  /// Border color for unlocked nodes.
  final Color unlockedNodeBorderColor;

  /// Background color for maxed out nodes.
  final Color maxedNodeColor;

  /// Border color for maxed out nodes.
  final Color maxedNodeBorderColor;

  // ---- Node colors by type ----

  /// Accent color for passive skill nodes.
  final Color passiveColor;

  /// Accent color for active skill nodes.
  final Color activeColor;

  /// Accent color for ultimate skill nodes.
  final Color ultimateColor;

  /// Accent color for keystone skill nodes.
  final Color keystoneColor;

  // ---- Connection colors ----

  /// Color for connections between locked nodes.
  final Color connectionLockedColor;

  /// Color for connections between unlocked nodes.
  final Color connectionUnlockedColor;

  /// Optional highlight color for selected/hovered connections.
  final Color? connectionHighlightColor;

  // ---- Sizes ----

  /// Radius of skill nodes.
  final double nodeRadius;

  /// Width of node borders.
  final double nodeBorderWidth;

  /// Width of connection lines.
  final double connectionWidth;

  // ---- Text styles ----

  /// Text style for node names (used in tooltips).
  final TextStyle? nodeNameStyle;

  /// Text style for node level display (e.g., "3/5").
  final TextStyle? nodeLevelStyle;

  /// Text style for node cost display.
  final TextStyle? nodeCostStyle;

  /// Text style for tooltip titles.
  final TextStyle? tooltipTitleStyle;

  /// Text style for tooltip descriptions.
  final TextStyle? tooltipDescriptionStyle;

  // ---- Tooltip ----

  /// Background color for tooltips.
  final Color? tooltipBackground;

  /// Border color for tooltips.
  final Color? tooltipBorder;

  /// Creates a dark theme suitable for most games.
  ///
  /// Features deep backgrounds with bright accents for visibility.
  factory SkillTreeTheme.dark() {
    return const SkillTreeTheme(
      // Node colors by state
      lockedNodeColor: Color(0xFF2A2A2A),
      lockedNodeBorderColor: Color(0xFF444444),
      availableNodeColor: Color(0xFF1A3A5C),
      availableNodeBorderColor: Color(0xFF3A7CA5),
      unlockedNodeColor: Color(0xFF1A4D1A),
      unlockedNodeBorderColor: Color(0xFF4CAF50),
      maxedNodeColor: Color(0xFF4A3A1A),
      maxedNodeBorderColor: Color(0xFFFFD700),
      // Node colors by type
      passiveColor: Color(0xFF607D8B),
      activeColor: Color(0xFF2196F3),
      ultimateColor: Color(0xFF9C27B0),
      keystoneColor: Color(0xFFFF9800),
      // Connection colors
      connectionLockedColor: Color(0xFF444444),
      connectionUnlockedColor: Color(0xFF4CAF50),
      connectionHighlightColor: Color(0xFF64B5F6),
      // Sizes
      nodeRadius: 28.0,
      nodeBorderWidth: 2.0,
      connectionWidth: 2.0,
      // Text styles
      nodeNameStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      nodeLevelStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      nodeCostStyle: TextStyle(
        color: Color(0xFFFFD700),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      tooltipTitleStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      tooltipDescriptionStyle: TextStyle(
        color: Color(0xFFBDBDBD),
        fontSize: 12,
      ),
      // Tooltip
      tooltipBackground: Color(0xF0212121),
      tooltipBorder: Color(0xFF616161),
    );
  }

  /// Creates a light theme suitable for casual/mobile games.
  ///
  /// Features light backgrounds with subtle colors.
  factory SkillTreeTheme.light() {
    return const SkillTreeTheme(
      // Node colors by state
      lockedNodeColor: Color(0xFFE0E0E0),
      lockedNodeBorderColor: Color(0xFFBDBDBD),
      availableNodeColor: Color(0xFFBBDEFB),
      availableNodeBorderColor: Color(0xFF2196F3),
      unlockedNodeColor: Color(0xFFC8E6C9),
      unlockedNodeBorderColor: Color(0xFF4CAF50),
      maxedNodeColor: Color(0xFFFFF8E1),
      maxedNodeBorderColor: Color(0xFFFFB300),
      // Node colors by type
      passiveColor: Color(0xFF78909C),
      activeColor: Color(0xFF42A5F5),
      ultimateColor: Color(0xFFAB47BC),
      keystoneColor: Color(0xFFFFB74D),
      // Connection colors
      connectionLockedColor: Color(0xFFBDBDBD),
      connectionUnlockedColor: Color(0xFF4CAF50),
      connectionHighlightColor: Color(0xFF2196F3),
      // Sizes
      nodeRadius: 28.0,
      nodeBorderWidth: 2.0,
      connectionWidth: 2.0,
      // Text styles
      nodeNameStyle: TextStyle(
        color: Color(0xFF212121),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      nodeLevelStyle: TextStyle(
        color: Color(0xFF212121),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      nodeCostStyle: TextStyle(
        color: Color(0xFFFF9800),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      tooltipTitleStyle: TextStyle(
        color: Color(0xFF212121),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      tooltipDescriptionStyle: TextStyle(
        color: Color(0xFF757575),
        fontSize: 12,
      ),
      // Tooltip
      tooltipBackground: Color(0xFFFAFAFA),
      tooltipBorder: Color(0xFFE0E0E0),
    );
  }

  /// Creates a theme derived from the app's [ColorScheme] via [Theme.of].
  ///
  /// Maps ColorScheme roles to skill tree properties so that the tree
  /// follows the consumer's active theme automatically.
  ///
  /// For colors that have no direct ColorScheme equivalent (warning, accent),
  /// optional parameters are provided with reasonable fallbacks:
  /// - [warningColor] defaults to `colorScheme.error`
  /// - [accentColor] defaults to `colorScheme.secondary`
  ///
  /// **Example:**
  /// ```dart
  /// final theme = SkillTreeTheme.fromContext(context);
  /// ```
  factory SkillTreeTheme.fromContext(
    BuildContext context, {
    Color? warningColor,
    Color? accentColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final warning = warningColor ?? colorScheme.error;
    final accent = accentColor ?? colorScheme.secondary;

    return SkillTreeTheme(
      // Node colors by state
      lockedNodeColor: colorScheme.surfaceContainerHighest,
      lockedNodeBorderColor: colorScheme.outline,
      availableNodeColor: colorScheme.primaryContainer,
      availableNodeBorderColor: colorScheme.primary,
      unlockedNodeColor: colorScheme.tertiaryContainer,
      unlockedNodeBorderColor: colorScheme.tertiary,
      maxedNodeColor: colorScheme.primary.withValues(alpha: 0.2),
      maxedNodeBorderColor: colorScheme.primary,
      // Node colors by type
      passiveColor: colorScheme.onSurfaceVariant,
      activeColor: colorScheme.primary,
      ultimateColor: accent,
      keystoneColor: warning,
      // Connection colors
      connectionLockedColor: colorScheme.outline,
      connectionUnlockedColor: colorScheme.tertiary,
      connectionHighlightColor: colorScheme.primary,
      // Sizes
      nodeRadius: 28.0,
      nodeBorderWidth: 2.0,
      connectionWidth: 2.0,
      // Text styles
      nodeNameStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      nodeLevelStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      nodeCostStyle: TextStyle(
        color: warning,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      tooltipTitleStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      tooltipDescriptionStyle: TextStyle(
        color: colorScheme.onSurface.withValues(alpha: 0.7),
        fontSize: 12,
      ),
      // Tooltip
      tooltipBackground: colorScheme.surfaceContainerHighest,
      tooltipBorder: colorScheme.outline,
    );
  }

  /// Creates a copy of this theme with the given fields replaced.
  SkillTreeTheme copyWith({
    // Node colors by state
    Color? lockedNodeColor,
    Color? lockedNodeBorderColor,
    Color? availableNodeColor,
    Color? availableNodeBorderColor,
    Color? unlockedNodeColor,
    Color? unlockedNodeBorderColor,
    Color? maxedNodeColor,
    Color? maxedNodeBorderColor,
    // Node colors by type
    Color? passiveColor,
    Color? activeColor,
    Color? ultimateColor,
    Color? keystoneColor,
    // Connection colors
    Color? connectionLockedColor,
    Color? connectionUnlockedColor,
    Color? connectionHighlightColor,
    // Sizes
    double? nodeRadius,
    double? nodeBorderWidth,
    double? connectionWidth,
    // Text styles
    TextStyle? nodeNameStyle,
    TextStyle? nodeLevelStyle,
    TextStyle? nodeCostStyle,
    TextStyle? tooltipTitleStyle,
    TextStyle? tooltipDescriptionStyle,
    // Tooltip
    Color? tooltipBackground,
    Color? tooltipBorder,
  }) {
    return SkillTreeTheme(
      // Node colors by state
      lockedNodeColor: lockedNodeColor ?? this.lockedNodeColor,
      lockedNodeBorderColor:
          lockedNodeBorderColor ?? this.lockedNodeBorderColor,
      availableNodeColor: availableNodeColor ?? this.availableNodeColor,
      availableNodeBorderColor:
          availableNodeBorderColor ?? this.availableNodeBorderColor,
      unlockedNodeColor: unlockedNodeColor ?? this.unlockedNodeColor,
      unlockedNodeBorderColor:
          unlockedNodeBorderColor ?? this.unlockedNodeBorderColor,
      maxedNodeColor: maxedNodeColor ?? this.maxedNodeColor,
      maxedNodeBorderColor: maxedNodeBorderColor ?? this.maxedNodeBorderColor,
      // Node colors by type
      passiveColor: passiveColor ?? this.passiveColor,
      activeColor: activeColor ?? this.activeColor,
      ultimateColor: ultimateColor ?? this.ultimateColor,
      keystoneColor: keystoneColor ?? this.keystoneColor,
      // Connection colors
      connectionLockedColor:
          connectionLockedColor ?? this.connectionLockedColor,
      connectionUnlockedColor:
          connectionUnlockedColor ?? this.connectionUnlockedColor,
      connectionHighlightColor:
          connectionHighlightColor ?? this.connectionHighlightColor,
      // Sizes
      nodeRadius: nodeRadius ?? this.nodeRadius,
      nodeBorderWidth: nodeBorderWidth ?? this.nodeBorderWidth,
      connectionWidth: connectionWidth ?? this.connectionWidth,
      // Text styles
      nodeNameStyle: nodeNameStyle ?? this.nodeNameStyle,
      nodeLevelStyle: nodeLevelStyle ?? this.nodeLevelStyle,
      nodeCostStyle: nodeCostStyle ?? this.nodeCostStyle,
      tooltipTitleStyle: tooltipTitleStyle ?? this.tooltipTitleStyle,
      tooltipDescriptionStyle:
          tooltipDescriptionStyle ?? this.tooltipDescriptionStyle,
      // Tooltip
      tooltipBackground: tooltipBackground ?? this.tooltipBackground,
      tooltipBorder: tooltipBorder ?? this.tooltipBorder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SkillTreeTheme) return false;
    return lockedNodeColor == other.lockedNodeColor &&
        lockedNodeBorderColor == other.lockedNodeBorderColor &&
        availableNodeColor == other.availableNodeColor &&
        availableNodeBorderColor == other.availableNodeBorderColor &&
        unlockedNodeColor == other.unlockedNodeColor &&
        unlockedNodeBorderColor == other.unlockedNodeBorderColor &&
        maxedNodeColor == other.maxedNodeColor &&
        maxedNodeBorderColor == other.maxedNodeBorderColor &&
        passiveColor == other.passiveColor &&
        activeColor == other.activeColor &&
        ultimateColor == other.ultimateColor &&
        keystoneColor == other.keystoneColor &&
        connectionLockedColor == other.connectionLockedColor &&
        connectionUnlockedColor == other.connectionUnlockedColor &&
        connectionHighlightColor == other.connectionHighlightColor &&
        nodeRadius == other.nodeRadius &&
        nodeBorderWidth == other.nodeBorderWidth &&
        connectionWidth == other.connectionWidth &&
        tooltipBackground == other.tooltipBackground &&
        tooltipBorder == other.tooltipBorder;
  }

  @override
  int get hashCode {
    return Object.hash(
      lockedNodeColor,
      lockedNodeBorderColor,
      availableNodeColor,
      availableNodeBorderColor,
      unlockedNodeColor,
      unlockedNodeBorderColor,
      maxedNodeColor,
      maxedNodeBorderColor,
      passiveColor,
      activeColor,
      ultimateColor,
      keystoneColor,
      connectionLockedColor,
      connectionUnlockedColor,
      connectionHighlightColor,
      nodeRadius,
      nodeBorderWidth,
      connectionWidth,
      tooltipBackground,
      tooltipBorder,
    );
  }
}
