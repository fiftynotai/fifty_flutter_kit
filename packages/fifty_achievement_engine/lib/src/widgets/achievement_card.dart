import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import 'achievement_progress_bar.dart';

/// A card widget for displaying a single achievement with progress.
///
/// Consumes FDL tokens directly for consistent styling.
/// Provides optional color overrides for customization.
///
/// **Example:**
/// ```dart
/// AchievementCard(
///   achievement: myAchievement,
///   progress: 0.75,
///   state: AchievementState.available,
///   onTap: () => showDetails(myAchievement),
/// )
/// ```
class AchievementCard<T> extends StatelessWidget {
  /// Creates an achievement card.
  const AchievementCard({
    super.key,
    required this.achievement,
    required this.progress,
    this.state = AchievementState.available,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.borderColor,
    this.showProgress = true,
    this.compact = false,
    this.rarityColors,
  });

  /// The achievement to display.
  final Achievement<T> achievement;

  /// Progress value from 0.0 to 1.0.
  final double progress;

  /// Current state of the achievement.
  final AchievementState state;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Callback when the card is long pressed.
  final VoidCallback? onLongPress;

  /// Background color override.
  final Color? backgroundColor;

  /// Border color override.
  final Color? borderColor;

  /// Whether to show the progress bar.
  final bool showProgress;

  /// Whether to use compact layout.
  final bool compact;

  /// Optional rarity color overrides.
  ///
  /// If a color is provided for a given rarity, it takes precedence
  /// over the default. Defaults use theme-derived colors for common
  /// and uncommon, and hardcoded domain colors for rare/epic/legendary.
  final Map<AchievementRarity, Color>? rarityColors;

  /// Gets the rarity color based on achievement rarity.
  ///
  /// Checks [rarityColors] overrides first, then falls back to
  /// theme-derived defaults for common/uncommon and hardcoded
  /// domain colors for rare/epic/legendary.
  Color _getRarityColor(ColorScheme colorScheme) {
    if (rarityColors != null && rarityColors!.containsKey(achievement.rarity)) {
      return rarityColors![achievement.rarity]!;
    }
    switch (achievement.rarity) {
      case AchievementRarity.common:
        return colorScheme.onSurfaceVariant;
      case AchievementRarity.uncommon:
        return colorScheme.tertiary;
      case AchievementRarity.rare:
        return const Color(0xFF5B8BD4);
      case AchievementRarity.epic:
        return const Color(0xFF9B59B6);
      case AchievementRarity.legendary:
        return const Color(0xFFE67E22);
    }
  }

  /// Gets the state-based opacity.
  double get _opacity {
    switch (state) {
      case AchievementState.locked:
        return 0.5;
      case AchievementState.available:
        return 0.9;
      case AchievementState.unlocked:
      case AchievementState.claimed:
        return 1.0;
    }
  }

  /// Whether to show hidden achievement placeholder.
  bool get _isHiddenAndLocked =>
      achievement.hidden && state == AchievementState.locked;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rarityColor = _getRarityColor(colorScheme);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedOpacity(
        duration: FiftyMotion.fast,
        opacity: _opacity,
        child: Container(
          padding: EdgeInsets.all(compact ? FiftySpacing.sm : FiftySpacing.md),
          decoration: BoxDecoration(
            color: backgroundColor ??
                colorScheme.surfaceContainerHighest,
            borderRadius: FiftyRadii.lgRadius,
            border: Border.all(
              color: borderColor ??
                  (state.isComplete
                      ? rarityColor
                      : rarityColor.withValues(alpha: 0.3)),
              width: state.isComplete ? 2 : 1,
            ),
          ),
          child: _isHiddenAndLocked
              ? _buildHiddenContent(context, rarityColor)
              : _buildContent(context, rarityColor),
        ),
      ),
    );
  }

  Widget _buildHiddenContent(BuildContext context, Color rarityColor) {
    return Row(
      children: [
        _buildIcon(context, Icons.help_outline, rarityColor),
        SizedBox(width: compact ? FiftySpacing.sm : FiftySpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hidden Achievement',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: compact
                      ? FiftyTypography.bodyMedium
                      : FiftyTypography.titleSmall,
                  fontWeight: FiftyTypography.bold,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              SizedBox(height: FiftySpacing.xs),
              Text(
                'Keep playing to discover this achievement',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, Color rarityColor) {
    return Row(
      children: [
        _buildIcon(context, achievement.icon ?? Icons.emoji_events, rarityColor),
        SizedBox(width: compact ? FiftySpacing.sm : FiftySpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      achievement.name,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: compact
                            ? FiftyTypography.bodyMedium
                            : FiftyTypography.titleSmall,
                        fontWeight: FiftyTypography.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: FiftySpacing.sm),
                  _buildRarityBadge(rarityColor),
                ],
              ),
              if (achievement.description != null && !compact) ...[
                SizedBox(height: FiftySpacing.xs),
                Text(
                  achievement.description!,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (showProgress && state == AchievementState.available) ...[
                SizedBox(height: FiftySpacing.sm),
                AchievementProgressBar(
                  progress: progress,
                  foregroundColor: rarityColor,
                ),
              ],
              if (state.isComplete) ...[
                SizedBox(height: FiftySpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: FiftySpacing.xs),
                    Text(
                      'Unlocked',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.labelSmall,
                        fontWeight: FiftyTypography.semiBold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '+${achievement.points} pts',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.labelSmall,
                        fontWeight: FiftyTypography.bold,
                        color: rarityColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIcon(BuildContext context, IconData iconData, Color rarityColor) {
    final size = compact ? 40.0 : 48.0;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: state.isComplete
            ? rarityColor.withValues(alpha: 0.2)
            : colorScheme.surface,
        borderRadius: FiftyRadii.mdRadius,
        border: Border.all(
          color: state.isComplete
              ? rarityColor
              : rarityColor.withValues(alpha: 0.3),
        ),
      ),
      child: Icon(
        iconData,
        size: compact ? 20 : 24,
        color: state.isComplete
            ? rarityColor
            : colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildRarityBadge(Color rarityColor) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: FiftySpacing.sm,
        vertical: FiftySpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: rarityColor.withValues(alpha: 0.2),
        borderRadius: FiftyRadii.smRadius,
        border: Border.all(color: rarityColor.withValues(alpha: 0.5)),
      ),
      child: Text(
        achievement.rarity.displayName.toUpperCase(),
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontSize: FiftyTypography.labelSmall,
          fontWeight: FiftyTypography.bold,
          letterSpacing: FiftyTypography.letterSpacingLabelMedium,
          color: rarityColor,
        ),
      ),
    );
  }
}
