import 'package:flutter/material.dart';

import '../../../../../core/theme/sneaker_colors.dart';
import '../../../../../core/theme/sneaker_radii.dart';
import '../../../../../core/theme/sneaker_typography.dart';
import '../../../data/models/sneaker_model.dart';

/// **RarityBadge**
///
/// Badge indicating sneaker rarity tier with distinct visual treatments.
///
/// **Visual Specs:**
/// - Common: slateGrey border, no glow, "COMMON" text
/// - Rare: powderBlush border, subtle glow, "RARE" text
/// - Grail: gradient border, animated pulse glow, "GRAIL" text
///
/// **Usage:**
/// ```dart
/// RarityBadge(
///   rarity: SneakerRarity.grail,
///   showLabel: true,
/// )
/// ```
class RarityBadge extends StatefulWidget {
  /// The rarity tier to display.
  final SneakerRarity rarity;

  /// Whether to show the rarity label text. Defaults to true.
  final bool showLabel;

  /// Size of the badge. Defaults to medium.
  final RarityBadgeSize size;

  /// Creates a [RarityBadge] with the specified parameters.
  const RarityBadge({
    required this.rarity,
    this.showLabel = true,
    this.size = RarityBadgeSize.medium,
    super.key,
  });

  @override
  State<RarityBadge> createState() => _RarityBadgeState();
}

class _RarityBadgeState extends State<RarityBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Only animate grail rarity
    if (widget.rarity == SneakerRarity.grail) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    if (_reduceMotion) {
      _pulseController.stop();
    } else if (widget.rarity == SneakerRarity.grail &&
        !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(RarityBadge oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.rarity != oldWidget.rarity) {
      if (widget.rarity == SneakerRarity.grail && !_reduceMotion) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.value = 0;
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = _getBadgeConfig();

    if (widget.rarity == SneakerRarity.grail && !_reduceMotion) {
      return AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return _buildBadge(config, glowOpacity: _pulseAnimation.value);
        },
      );
    }

    return _buildBadge(config);
  }

  Widget _buildBadge(_RarityConfig config, {double glowOpacity = 1.0}) {
    final padding = _getPadding();
    final fontSize = _getFontSize();
    final iconSize = _getIconSize();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: SneakerRadii.badge,
        border: config.useGradientBorder
            ? null
            : Border.all(
                color: config.borderColor,
                width: config.borderWidth,
              ),
        gradient: config.useGradientBorder
            ? LinearGradient(
                colors: [
                  config.borderColor,
                  config.borderColor.withValues(alpha: 0.6),
                ],
              )
            : null,
        color: config.useGradientBorder ? null : config.backgroundColor,
        boxShadow: config.hasGlow
            ? [
                BoxShadow(
                  color: config.glowColor.withValues(alpha: 0.3 * glowOpacity),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Rarity icon
          if (config.icon != null)
            Padding(
              padding: EdgeInsets.only(right: widget.showLabel ? 4 : 0),
              child: Icon(
                config.icon,
                size: iconSize,
                color: config.textColor,
              ),
            ),

          // Rarity label
          if (widget.showLabel)
            Text(
              config.label,
              style: TextStyle(
                fontFamily: SneakerTypography.fontFamily,
                fontSize: fontSize,
                fontWeight: SneakerTypography.bold,
                letterSpacing: 1.5,
                color: config.textColor,
              ),
            ),
        ],
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case RarityBadgeSize.small:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case RarityBadgeSize.medium:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case RarityBadgeSize.large:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case RarityBadgeSize.small:
        return 8;
      case RarityBadgeSize.medium:
        return 10;
      case RarityBadgeSize.large:
        return 12;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case RarityBadgeSize.small:
        return 10;
      case RarityBadgeSize.medium:
        return 12;
      case RarityBadgeSize.large:
        return 14;
    }
  }

  _RarityConfig _getBadgeConfig() {
    switch (widget.rarity) {
      case SneakerRarity.common:
        return _RarityConfig(
          label: 'COMMON',
          borderColor: SneakerColors.slateGrey,
          backgroundColor: SneakerColors.surfaceDark,
          textColor: SneakerColors.slateGrey,
          icon: null,
          borderWidth: 1,
          hasGlow: false,
          useGradientBorder: false,
          glowColor: Colors.transparent,
        );
      case SneakerRarity.rare:
        return _RarityConfig(
          label: 'RARE',
          borderColor: SneakerColors.powderBlush,
          backgroundColor: SneakerColors.surfaceDark,
          textColor: SneakerColors.powderBlush,
          icon: Icons.star_outline_rounded,
          borderWidth: 1,
          hasGlow: true,
          useGradientBorder: false,
          glowColor: SneakerColors.powderBlush,
        );
      case SneakerRarity.grail:
        return _RarityConfig(
          label: 'GRAIL',
          borderColor: SneakerColors.burgundy,
          backgroundColor: SneakerColors.darkBurgundy,
          textColor: SneakerColors.cream,
          icon: Icons.auto_awesome_rounded,
          borderWidth: 2,
          hasGlow: true,
          useGradientBorder: true,
          glowColor: SneakerColors.burgundy,
        );
    }
  }
}

/// Size variants for [RarityBadge].
enum RarityBadgeSize {
  /// Small badge (8px font, minimal padding).
  small,

  /// Medium badge (10px font, standard padding).
  medium,

  /// Large badge (12px font, generous padding).
  large,
}

/// Internal configuration for rarity badge styling.
class _RarityConfig {
  final String label;
  final Color borderColor;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double borderWidth;
  final bool hasGlow;
  final bool useGradientBorder;
  final Color glowColor;

  const _RarityConfig({
    required this.label,
    required this.borderColor,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.borderWidth,
    required this.hasGlow,
    required this.useGradientBorder,
    required this.glowColor,
  });
}
