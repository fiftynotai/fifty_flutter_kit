import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

/// An animated popup notification for achievement unlocks.
///
/// Consumes FDL tokens directly for consistent styling.
///
/// This widget wraps its content in a [Material] widget with
/// [MaterialType.transparency] to ensure proper text rendering when
/// displayed via Flutter's [Overlay]. Without a [Material] ancestor,
/// [Text] widgets display with yellow underlines in debug mode.
///
/// **Usage with Overlay:**
///
/// When showing this popup via [Overlay.of(context)?.insert()], the popup
/// handles the Material requirement internally - no additional wrapper needed.
///
/// **Example:**
/// ```dart
/// // Show popup when achievement unlocks
/// controller.onUnlock = (achievement) {
///   final overlay = Overlay.of(context);
///   late OverlayEntry entry;
///   entry = OverlayEntry(
///     builder: (context) => AchievementPopup(
///       achievement: achievement,
///       onDismiss: () => entry.remove(),
///     ),
///   );
///   overlay.insert(entry);
/// };
/// ```
class AchievementPopup<T> extends StatefulWidget {
  /// Creates an achievement popup.
  const AchievementPopup({
    super.key,
    required this.achievement,
    this.onDismiss,
    this.onTap,
    this.duration = const Duration(seconds: 4),
    this.backgroundColor,
    this.showAnimation = true,
  });

  /// The unlocked achievement to display.
  final Achievement<T> achievement;

  /// Callback when the popup is dismissed.
  final VoidCallback? onDismiss;

  /// Callback when the popup is tapped.
  final VoidCallback? onTap;

  /// How long the popup should be visible.
  final Duration duration;

  /// Background color override.
  final Color? backgroundColor;

  /// Whether to show entrance/exit animations.
  final bool showAnimation;

  @override
  State<AchievementPopup<T>> createState() => _AchievementPopupState<T>();
}

class _AchievementPopupState<T> extends State<AchievementPopup<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: FiftyMotion.compiling,
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: -100, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    if (widget.showAnimation) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }

    // Auto-dismiss after duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (widget.showAnimation) {
      await _controller.reverse();
    }
    widget.onDismiss?.call();
  }

  Color get _rarityColor {
    switch (widget.achievement.rarity) {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              ),
            );
          },
          child: Material(
            type: MaterialType.transparency,
            child: GestureDetector(
              onTap: widget.onTap ?? _dismiss,
              child: Container(
              margin: const EdgeInsets.all(FiftySpacing.md),
              padding: const EdgeInsets.all(FiftySpacing.md),
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? FiftyColors.surfaceDark,
                borderRadius: FiftyRadii.lgRadius,
                border: Border.all(color: _rarityColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: _rarityColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIcon(),
                  const SizedBox(width: FiftySpacing.md),
                  Flexible(child: _buildContent()),
                ],
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _rarityColor,
              _rarityColor.withValues(alpha: 0.7),
            ],
          ),
          borderRadius: FiftyRadii.mdRadius,
          boxShadow: [
            BoxShadow(
              color: _rarityColor.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          widget.achievement.icon ?? Icons.emoji_events,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'ACHIEVEMENT UNLOCKED',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.labelMedium,
            fontWeight: FiftyTypography.bold,
            letterSpacing: FiftyTypography.letterSpacingLabelMedium,
            color: _rarityColor,
          ),
        ),
        const SizedBox(height: FiftySpacing.xs),
        Text(
          widget.achievement.name,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.titleMedium,
            fontWeight: FiftyTypography.bold,
            color: FiftyColors.cream,
          ),
        ),
        if (widget.achievement.description != null) ...[
          const SizedBox(height: FiftySpacing.xs / 2),
          Text(
            widget.achievement.description!,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.cream.withValues(alpha: 0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: FiftySpacing.sm),
        Row(
          children: [
            _buildRarityBadge(),
            const SizedBox(width: FiftySpacing.sm),
            Text(
              '+${widget.achievement.points} pts',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelLarge,
                fontWeight: FiftyTypography.bold,
                color: FiftyColors.cream,
              ),
            ),
          ],
        ),
      ],
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
        border: Border.all(color: _rarityColor),
      ),
      child: Text(
        widget.achievement.rarity.displayName.toUpperCase(),
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
