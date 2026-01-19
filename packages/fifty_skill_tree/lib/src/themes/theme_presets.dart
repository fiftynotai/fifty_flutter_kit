import 'package:flutter/painting.dart';

import 'skill_tree_theme.dart';

/// Extension on [SkillTreeTheme] providing preset theme factories.
///
/// These presets provide ready-to-use themes for common game styles.
///
/// **Example:**
/// ```dart
/// // Fantasy RPG style
/// final theme = SkillTreeTheme.rpg();
///
/// // Sci-fi tech style
/// final theme = SkillTreeTheme.scifi();
///
/// // Minimalist style
/// final theme = SkillTreeTheme.minimal();
/// ```
extension SkillTreeThemePresets on SkillTreeTheme {
  /// Creates a fantasy RPG themed skill tree.
  ///
  /// Features gold and purple accents reminiscent of classic fantasy games.
  /// Suitable for medieval, fantasy, or dungeon crawler games.
  static SkillTreeTheme rpg() {
    return const SkillTreeTheme(
      // Node colors by state - fantasy gold/purple palette
      lockedNodeColor: Color(0xFF1A1A2E),
      lockedNodeBorderColor: Color(0xFF4A4A5E),
      availableNodeColor: Color(0xFF2A1A4A),
      availableNodeBorderColor: Color(0xFF9B59B6),
      unlockedNodeColor: Color(0xFF2A3A1A),
      unlockedNodeBorderColor: Color(0xFF8B7355),
      maxedNodeColor: Color(0xFF3D2A1A),
      maxedNodeBorderColor: Color(0xFFFFD700),
      // Node colors by type
      passiveColor: Color(0xFF8B7355),
      activeColor: Color(0xFF9B59B6),
      ultimateColor: Color(0xFFE74C3C),
      keystoneColor: Color(0xFFFFD700),
      // Connection colors
      connectionLockedColor: Color(0xFF4A4A5E),
      connectionUnlockedColor: Color(0xFF8B7355),
      connectionHighlightColor: Color(0xFFFFD700),
      // Sizes
      nodeRadius: 28.0,
      nodeBorderWidth: 3.0,
      connectionWidth: 2.5,
      // Text styles
      nodeNameStyle: TextStyle(
        color: Color(0xFFF5E6D3),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      nodeLevelStyle: TextStyle(
        color: Color(0xFFF5E6D3),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      nodeCostStyle: TextStyle(
        color: Color(0xFFFFD700),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      tooltipTitleStyle: TextStyle(
        color: Color(0xFFFFD700),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      tooltipDescriptionStyle: TextStyle(
        color: Color(0xFFC9B896),
        fontSize: 12,
      ),
      // Tooltip
      tooltipBackground: Color(0xF01A1A2E),
      tooltipBorder: Color(0xFF8B7355),
    );
  }

  /// Creates a sci-fi tech themed skill tree.
  ///
  /// Features cyan and blue accents for a futuristic technology feel.
  /// Suitable for sci-fi, cyberpunk, or space games.
  static SkillTreeTheme scifi() {
    return const SkillTreeTheme(
      // Node colors by state - tech cyan/blue palette
      lockedNodeColor: Color(0xFF0D1B2A),
      lockedNodeBorderColor: Color(0xFF1B3A4B),
      availableNodeColor: Color(0xFF0A2F4A),
      availableNodeBorderColor: Color(0xFF00BCD4),
      unlockedNodeColor: Color(0xFF0A3A2A),
      unlockedNodeBorderColor: Color(0xFF00E676),
      maxedNodeColor: Color(0xFF1A2A3A),
      maxedNodeBorderColor: Color(0xFF00FFFF),
      // Node colors by type
      passiveColor: Color(0xFF607D8B),
      activeColor: Color(0xFF00BCD4),
      ultimateColor: Color(0xFFE040FB),
      keystoneColor: Color(0xFF00FFFF),
      // Connection colors
      connectionLockedColor: Color(0xFF1B3A4B),
      connectionUnlockedColor: Color(0xFF00BCD4),
      connectionHighlightColor: Color(0xFF00FFFF),
      // Sizes
      nodeRadius: 28.0,
      nodeBorderWidth: 2.0,
      connectionWidth: 2.0,
      // Text styles
      nodeNameStyle: TextStyle(
        color: Color(0xFFE0F7FA),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      nodeLevelStyle: TextStyle(
        color: Color(0xFFE0F7FA),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      nodeCostStyle: TextStyle(
        color: Color(0xFF00FFFF),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      tooltipTitleStyle: TextStyle(
        color: Color(0xFF00FFFF),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      tooltipDescriptionStyle: TextStyle(
        color: Color(0xFF80DEEA),
        fontSize: 12,
      ),
      // Tooltip
      tooltipBackground: Color(0xF00D1B2A),
      tooltipBorder: Color(0xFF00BCD4),
    );
  }

  /// Creates a minimal monochrome themed skill tree.
  ///
  /// Features clean lines and subtle colors for a modern, minimal look.
  /// Suitable for casual games, productivity apps, or clean UI designs.
  static SkillTreeTheme minimal() {
    return const SkillTreeTheme(
      // Node colors by state - monochrome with subtle accents
      lockedNodeColor: Color(0xFFF5F5F5),
      lockedNodeBorderColor: Color(0xFFE0E0E0),
      availableNodeColor: Color(0xFFFFFFFF),
      availableNodeBorderColor: Color(0xFF757575),
      unlockedNodeColor: Color(0xFFFFFFFF),
      unlockedNodeBorderColor: Color(0xFF424242),
      maxedNodeColor: Color(0xFFFAFAFA),
      maxedNodeBorderColor: Color(0xFF212121),
      // Node colors by type
      passiveColor: Color(0xFF9E9E9E),
      activeColor: Color(0xFF616161),
      ultimateColor: Color(0xFF424242),
      keystoneColor: Color(0xFF212121),
      // Connection colors
      connectionLockedColor: Color(0xFFE0E0E0),
      connectionUnlockedColor: Color(0xFF757575),
      connectionHighlightColor: Color(0xFF424242),
      // Sizes - thinner lines for minimal look
      nodeRadius: 24.0,
      nodeBorderWidth: 1.5,
      connectionWidth: 1.0,
      // Text styles
      nodeNameStyle: TextStyle(
        color: Color(0xFF212121),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      nodeLevelStyle: TextStyle(
        color: Color(0xFF424242),
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
      nodeCostStyle: TextStyle(
        color: Color(0xFF757575),
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
      tooltipTitleStyle: TextStyle(
        color: Color(0xFF212121),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      tooltipDescriptionStyle: TextStyle(
        color: Color(0xFF616161),
        fontSize: 12,
      ),
      // Tooltip
      tooltipBackground: Color(0xFFFAFAFA),
      tooltipBorder: Color(0xFFE0E0E0),
    );
  }

  /// Creates a nature/organic themed skill tree.
  ///
  /// Features greens and earth tones for natural, organic feel.
  /// Suitable for farming, nature, or survival games.
  static SkillTreeTheme nature() {
    return const SkillTreeTheme(
      // Node colors by state - earth tones
      lockedNodeColor: Color(0xFF2D2A24),
      lockedNodeBorderColor: Color(0xFF5D5A54),
      availableNodeColor: Color(0xFF2A3D2A),
      availableNodeBorderColor: Color(0xFF66BB6A),
      unlockedNodeColor: Color(0xFF3D5A3D),
      unlockedNodeBorderColor: Color(0xFF81C784),
      maxedNodeColor: Color(0xFF4A5D3A),
      maxedNodeBorderColor: Color(0xFFA5D6A7),
      // Node colors by type
      passiveColor: Color(0xFF8D6E63),
      activeColor: Color(0xFF66BB6A),
      ultimateColor: Color(0xFFFFB74D),
      keystoneColor: Color(0xFFA5D6A7),
      // Connection colors
      connectionLockedColor: Color(0xFF5D5A54),
      connectionUnlockedColor: Color(0xFF81C784),
      connectionHighlightColor: Color(0xFFA5D6A7),
      // Sizes
      nodeRadius: 28.0,
      nodeBorderWidth: 2.0,
      connectionWidth: 2.0,
      // Text styles
      nodeNameStyle: TextStyle(
        color: Color(0xFFE8F5E9),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      nodeLevelStyle: TextStyle(
        color: Color(0xFFC8E6C9),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      nodeCostStyle: TextStyle(
        color: Color(0xFFFFB74D),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
      tooltipTitleStyle: TextStyle(
        color: Color(0xFFA5D6A7),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      tooltipDescriptionStyle: TextStyle(
        color: Color(0xFFC8E6C9),
        fontSize: 12,
      ),
      // Tooltip
      tooltipBackground: Color(0xF02D2A24),
      tooltipBorder: Color(0xFF66BB6A),
    );
  }
}
