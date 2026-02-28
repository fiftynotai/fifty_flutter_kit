import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Badge variants for different semantic meanings.
enum FiftyBadgeVariant {
  /// Default badge with primary color.
  primary,

  /// Success badge with green color.
  success,

  /// Warning badge with amber color.
  warning,

  /// Error badge with burgundy color.
  error,

  /// Neutral badge with slateGrey color.
  neutral,
}

/// A small status indicator badge with FDL v2 styling.
///
/// Features:
/// - Five variants matching semantic colors
/// - Optional glow pulse animation
/// - Compact pill shape
/// - Factory constructors for common use cases
/// - Manrope font family
///
/// Example:
/// ```dart
/// FiftyBadge(
///   label: 'LIVE',
///   variant: FiftyBadgeVariant.success,
///   showGlow: true,
/// )
/// ```
///
/// Factory constructor examples:
/// ```dart
/// FiftyBadge.tech('FLUTTER'),  // Gray/slateGrey tech label
/// FiftyBadge.status('ONLINE'), // Green status with glow
/// FiftyBadge.ai('IGRIS'),      // HunterGreen AI indicator
/// ```
class FiftyBadge extends StatefulWidget {
  /// Creates a Fifty-styled badge.
  const FiftyBadge({
    super.key,
    required this.label,
    this.variant = FiftyBadgeVariant.primary,
    this.showGlow = false,
    this.customColor,
  });

  /// Creates a tech-style badge with neutral styling.
  ///
  /// Uses [FiftyBadgeVariant.neutral] which resolves to
  /// `colorScheme.onSurfaceVariant` at build time for proper theme alignment.
  ///
  /// Suitable for technology labels like 'FLUTTER', 'DART', 'REACT'.
  factory FiftyBadge.tech(String label) {
    return FiftyBadge(
      label: label,
      variant: FiftyBadgeVariant.neutral,
    );
  }

  /// Creates a status badge with green border and subtle glow.
  ///
  /// Suitable for status indicators like 'ONLINE', 'ACTIVE', 'CONNECTED'.
  factory FiftyBadge.status(String label) {
    return FiftyBadge(
      label: label,
      variant: FiftyBadgeVariant.success,
      showGlow: true,
    );
  }

  /// Creates an AI indicator badge with success styling and glow.
  ///
  /// Uses [FiftyBadgeVariant.success] which resolves to
  /// `extension.success` or `colorScheme.tertiary` at build time
  /// for proper theme alignment.
  ///
  /// Suitable for AI-related labels like 'IGRIS', 'AI', 'AGENT'.
  factory FiftyBadge.ai(String label) {
    return FiftyBadge(
      label: label,
      variant: FiftyBadgeVariant.success,
      showGlow: true,
    );
  }

  /// The badge label text.
  final String label;

  /// The visual variant of the badge.
  final FiftyBadgeVariant variant;

  /// Whether to show a pulsing glow animation.
  final bool showGlow;

  /// Custom accent color for the badge.
  ///
  /// When set, overrides the variant-based color.
  /// Used by factory constructors for specific styling.
  final Color? customColor;

  @override
  State<FiftyBadge> createState() => _FiftyBadgeState();
}

class _FiftyBadgeState extends State<FiftyBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.showGlow) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(FiftyBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showGlow && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.showGlow && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>();
    final colorScheme = theme.colorScheme;

    final accentColor = _getAccentColor(fifty, colorScheme);

    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: FiftySpacing.sm,
            vertical: FiftySpacing.xs / 2,
          ),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.2),
            borderRadius: FiftyRadii.fullRadius,
            border: Border.all(
              color: accentColor,
              width: 1,
            ),
            boxShadow: widget.showGlow
                ? [
                    BoxShadow(
                      color: accentColor.withValues(
                        alpha: _opacityAnimation.value * 0.4,
                      ),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label.toUpperCase(),
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelSmall,
              fontWeight: FiftyTypography.medium,
              color: accentColor,
              letterSpacing: FiftyTypography.letterSpacingLabel,
            ),
          ),
        );
      },
    );
  }

  Color _getAccentColor(FiftyThemeExtension? fifty, ColorScheme colorScheme) {
    // Custom color takes precedence
    if (widget.customColor != null) {
      return widget.customColor!;
    }

    switch (widget.variant) {
      case FiftyBadgeVariant.primary:
        return colorScheme.primary;
      case FiftyBadgeVariant.success:
        return fifty?.success ?? colorScheme.tertiary;
      case FiftyBadgeVariant.warning:
        return fifty?.warning ?? FiftyColors.warning;
      case FiftyBadgeVariant.error:
        return colorScheme.error;
      case FiftyBadgeVariant.neutral:
        return colorScheme.onSurfaceVariant;
    }
  }
}
