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

  /// Gets the rarity color based on achievement rarity.
  Color get _rarityColor {
    switch (achievement.rarity) {
      case AchievementRarity.common:
        return FiftyColors.slateGrey;
      case AchievementRarity.uncommon:
        return FiftyColors.hunterGreen;
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
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedOpacity(
        duration: FiftyMotion.fast,
        opacity: _opacity,
        child: Container(
          padding: EdgeInsets.all(compact ? FiftySpacing.sm : FiftySpacing.md),
          decoration: BoxDecoration(
            color: backgroundColor ?? FiftyColors.surfaceDark,
            borderRadius: FiftyRadii.lgRadius,
            border: Border.all(
              color: borderColor ??
                  (state.isComplete
                      ? _rarityColor
                      : _rarityColor.withValues(alpha: 0.3)),
              width: state.isComplete ? 2 : 1,
            ),
          ),
          child: _isHiddenAndLocked ? _buildHiddenContent() : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildHiddenContent() {
    return Row(
      children: [
        _buildIcon(Icons.help_outline),
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
                  color: FiftyColors.cream.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: FiftySpacing.xs),
              Text(
                'Keep playing to discover this achievement',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  color: FiftyColors.cream.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Row(
      children: [
        _buildIcon(achievement.icon ?? Icons.emoji_events),
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
                        color: FiftyColors.cream,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: FiftySpacing.sm),
                  _buildRarityBadge(),
                ],
              ),
              if (achievement.description != null && !compact) ...[
                const SizedBox(height: FiftySpacing.xs),
                Text(
                  achievement.description!,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: FiftyColors.cream.withValues(alpha: 0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (showProgress && state == AchievementState.available) ...[
                const SizedBox(height: FiftySpacing.sm),
                AchievementProgressBar(
                  progress: progress,
                  foregroundColor: _rarityColor,
                ),
              ],
              if (state.isComplete) ...[
                const SizedBox(height: FiftySpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: FiftyColors.hunterGreen,
                    ),
                    const SizedBox(width: FiftySpacing.xs),
                    Text(
                      'Unlocked',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.labelSmall,
                        fontWeight: FiftyTypography.semiBold,
                        color: FiftyColors.hunterGreen,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '+${achievement.points} pts',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.labelSmall,
                        fontWeight: FiftyTypography.bold,
                        color: _rarityColor,
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

  Widget _buildIcon(IconData iconData) {
    final size = compact ? 40.0 : 48.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: state.isComplete
            ? _rarityColor.withValues(alpha: 0.2)
            : FiftyColors.darkBurgundy,
        borderRadius: FiftyRadii.mdRadius,
        border: Border.all(
          color: state.isComplete
              ? _rarityColor
              : _rarityColor.withValues(alpha: 0.3),
        ),
      ),
      child: Icon(
        iconData,
        size: compact ? 20 : 24,
        color: state.isComplete
            ? _rarityColor
            : FiftyColors.cream.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildRarityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.sm,
        vertical: FiftySpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: _rarityColor.withValues(alpha: 0.2),
        borderRadius: FiftyRadii.smRadius,
        border: Border.all(color: _rarityColor.withValues(alpha: 0.5)),
      ),
      child: Text(
        achievement.rarity.displayName.toUpperCase(),
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontSize: FiftyTypography.labelSmall,
          fontWeight: FiftyTypography.bold,
          letterSpacing: FiftyTypography.letterSpacingLabelMedium,
          color: _rarityColor,
        ),
      ),
    );
  }
}
