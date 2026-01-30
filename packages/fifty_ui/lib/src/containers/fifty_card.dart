import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../utils/halftone_painter.dart';

/// Card size variants for FiftyCard.
enum FiftyCardSize {
  /// Standard card with xxl radius (24px).
  standard,

  /// Hero card with xxxl radius (32px).
  hero,
}

/// A card container with FDL v2 styling.
///
/// Features:
/// - xxl border radius (24px) for standard, xxxl (32px) for hero cards
/// - Medium shadow by default
/// - Mode-aware border colors
/// - Optional tap interaction with ripple effect
/// - Selected state with primary border and subtle glow
/// - Scanline effect on hover (FDL: "Cards: Hovering triggers a scanline effect")
/// - Optional halftone texture overlay
/// - Configurable hover scale animation
///
/// Example:
/// ```dart
/// FiftyCard(
///   onTap: () => selectItem(),
///   selected: isSelected,
///   scanlineOnHover: true,
///   hasTexture: true,
///   hoverScale: 1.02,
///   child: CardContent(),
/// )
/// ```
class FiftyCard extends StatefulWidget {
  /// Creates a Fifty-styled card.
  const FiftyCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.selected = false,
    this.borderRadius,
    this.backgroundColor,
    this.scanlineOnHover = true,
    this.hasTexture = false,
    this.hoverScale = 1.02,
    this.size = FiftyCardSize.standard,
    this.showShadow = true,
  });

  /// The content of the card.
  final Widget child;

  /// Padding inside the card.
  ///
  /// Defaults to [FiftySpacing.lg] on all sides.
  final EdgeInsetsGeometry? padding;

  /// Margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Callback when the card is tapped.
  ///
  /// If null, the card is not interactive.
  final VoidCallback? onTap;

  /// Whether the card is in a selected state.
  ///
  /// When true, shows primary border and subtle glow.
  final bool selected;

  /// The border radius of the card.
  ///
  /// Defaults to [FiftyRadii.xxlRadius] for standard, [FiftyRadii.xxxlRadius] for hero.
  final BorderRadius? borderRadius;

  /// The background color of the card.
  ///
  /// Defaults to theme's surfaceContainerHighest.
  final Color? backgroundColor;

  /// Whether to show the scanline effect on hover.
  ///
  /// FDL Rule: "Cards: Hovering triggers a scanline effect"
  /// Defaults to true.
  final bool scanlineOnHover;

  /// Whether to show a halftone texture overlay.
  ///
  /// When true, adds a subtle dot pattern texture to the card surface.
  /// Defaults to false.
  final bool hasTexture;

  /// Scale factor when the card is hovered.
  ///
  /// Applied as an AnimatedScale on hover for kinetic feedback.
  /// Set to 1.0 to disable hover scaling.
  /// Defaults to 1.02 (2% larger).
  final double hoverScale;

  /// The size variant of the card.
  ///
  /// Affects border radius:
  /// - [FiftyCardSize.standard]: xxl radius (24px)
  /// - [FiftyCardSize.hero]: xxxl radius (32px)
  final FiftyCardSize size;

  /// Whether to show the medium shadow.
  ///
  /// Defaults to true.
  final bool showShadow;

  @override
  State<FiftyCard> createState() => _FiftyCardState();
}

class _FiftyCardState extends State<FiftyCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isFocused = false;
  late AnimationController _scanlineController;

  bool get _isInteractive => widget.onTap != null;
  bool get _showGlow =>
      widget.selected || ((_isHovered || _isFocused) && _isInteractive);
  bool get _showScanline =>
      widget.scanlineOnHover && _isHovered && !_reduceMotion;
  bool get _reduceMotion =>
      MediaQuery.maybeDisableAnimationsOf(context) ?? false;
  double get _currentScale =>
      _isHovered && _isInteractive && !_reduceMotion ? widget.hoverScale : 1.0;

  BorderRadius get _effectiveRadius {
    if (widget.borderRadius != null) return widget.borderRadius!;
    switch (widget.size) {
      case FiftyCardSize.standard:
        return FiftyRadii.xxlRadius;
      case FiftyCardSize.hero:
        return FiftyRadii.xxxlRadius;
    }
  }

  @override
  void initState() {
    super.initState();
    _scanlineController = AnimationController(
      vsync: this,
      duration: FiftyMotion.compiling, // 300ms
    );
  }

  @override
  void dispose() {
    _scanlineController.dispose();
    super.dispose();
  }

  void _onHoverStart() {
    setState(() => _isHovered = true);
    if (widget.scanlineOnHover && !_reduceMotion) {
      _scanlineController.forward(from: 0);
    }
  }

  void _onHoverEnd() {
    setState(() => _isHovered = false);
    _scanlineController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;

    final effectiveBorderRadius = _effectiveRadius;
    final effectiveBackgroundColor =
        widget.backgroundColor ?? colorScheme.surfaceContainerHighest;
    final effectivePadding = widget.padding ??
        const EdgeInsets.all(FiftySpacing.lg);

    final borderColor = widget.selected || _showGlow
        ? colorScheme.primary
        : colorScheme.outline;
    final borderWidth = widget.selected || _showGlow ? 2.0 : 1.0;

    // Determine shadow - use medium shadow by default
    List<BoxShadow>? effectiveShadow;
    if (_showGlow) {
      effectiveShadow = fifty.shadowGlow;
    } else if (widget.showShadow) {
      effectiveShadow = FiftyShadows.md;
    }

    // Card visual content (padding + child)
    final cardContent = Container(
      padding: effectivePadding,
      child: widget.child,
    );

    // The visual card structure with decoration and overlays
    final Widget cardVisual = AnimatedContainer(
      duration: fifty.fast,
      curve: fifty.standardCurve,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: effectiveShadow,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Stack(
          children: [
            cardContent,
            // FDL Rule: "Cards: Hovering triggers a scanline effect"
            if (widget.scanlineOnHover)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _scanlineController,
                  builder: (context, child) {
                    if (!_showScanline && _scanlineController.value == 0) {
                      return const SizedBox.shrink();
                    }
                    return CustomPaint(
                      painter: _ScanlinePainter(
                        progress: _scanlineController.value,
                        color: colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    );
                  },
                ),
              ),
            // Halftone texture overlay
            if (widget.hasTexture)
              const Positioned.fill(
                child: IgnorePointer(
                  child: HalftoneOverlay(
                    opacity: 0.05,
                    dotRadius: 1.0,
                    spacing: 8.0,
                  ),
                ),
              ),
            // Interactive ripple layer - INSIDE Stack so it draws ON TOP
            if (_isInteractive)
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    borderRadius: effectiveBorderRadius,
                    splashColor: colorScheme.primary.withValues(alpha: 0.2),
                    highlightColor: colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    return Focus(
      onFocusChange: _isInteractive
          ? (focused) => setState(() => _isFocused = focused)
          : null,
      child: MouseRegion(
        onEnter: _isInteractive ? (_) => _onHoverStart() : null,
        onExit: _isInteractive ? (_) => _onHoverEnd() : null,
        child: AnimatedScale(
          scale: _currentScale,
          duration: fifty.fast,
          curve: fifty.standardCurve,
          child: cardVisual,
        ),
      ),
    );
  }
}

/// Paints a horizontal scanline that sweeps from top to bottom.
class _ScanlinePainter extends CustomPainter {
  _ScanlinePainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final y = size.height * progress;

    // Draw the scanline
    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      paint,
    );

    // Draw a subtle glow above the line
    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          color.withValues(alpha: 0.1),
          color.withValues(alpha: 0.2),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, y - 10, size.width, 20));

    canvas.drawRect(
      Rect.fromLTWH(0, y - 10, size.width, 20),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanlinePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
