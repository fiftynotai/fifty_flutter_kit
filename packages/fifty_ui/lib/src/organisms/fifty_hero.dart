import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../utils/glitch_effect.dart';

/// Hero text size variants.
enum FiftyHeroSize {
  /// Display size (64px) - Maximum impact.
  display,

  /// H1 size (48px) - Major headlines.
  h1,

  /// H2 size (32px) - Section headers.
  h2,
}

/// Dramatic headline text with Manrope font.
///
/// Implements the FDL v2 "Monument Headers" specification:
/// - Text: ALL CAPS
/// - Font: Manrope (primary font family)
/// - Sizes: display (64px), h1 (48px), h2 (32px)
/// - Optional glitch effect on mount
/// - Optional gradient fill
///
/// Example:
/// ```dart
/// FiftyHero(
///   text: 'Welcome to Fifty',
///   size: FiftyHeroSize.display,
///   glitchOnMount: true,
///   gradient: LinearGradient(
///     colors: [FiftyColors.burgundy, FiftyColors.cream],
///   ),
/// )
/// ```
class FiftyHero extends StatelessWidget {
  /// Creates a hero text widget.
  const FiftyHero({
    super.key,
    required this.text,
    this.size = FiftyHeroSize.display,
    this.glitchOnMount = false,
    this.gradient,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow = TextOverflow.visible,
  });

  /// The headline text to display.
  ///
  /// Will be rendered in ALL CAPS per FDL specification.
  final String text;

  /// The size of the hero text.
  final FiftyHeroSize size;

  /// Whether to trigger a glitch effect when the widget mounts.
  final bool glitchOnMount;

  /// Optional gradient to apply to the text.
  ///
  /// If null, uses [FiftyColors.cream].
  final Gradient? gradient;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// Maximum number of lines for the text.
  final int? maxLines;

  /// How visual overflow should be handled.
  final TextOverflow overflow;

  double get _fontSize {
    switch (size) {
      case FiftyHeroSize.display:
        return FiftyTypography.displayLarge; // 32px (hero)
      case FiftyHeroSize.h1:
        return FiftyTypography.displayMedium; // 24px
      case FiftyHeroSize.h2:
        return FiftyTypography.titleLarge; // 20px
    }
  }

  FontWeight get _fontWeight {
    switch (size) {
      case FiftyHeroSize.display:
      case FiftyHeroSize.h1:
        return FiftyTypography.extraBold;
      case FiftyHeroSize.h2:
        return FiftyTypography.regular;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = _buildText(context);

    if (glitchOnMount) {
      return GlitchEffect(
        triggerOnMount: true,
        intensity: 0.8,
        offset: 4.0,
        child: textWidget,
      );
    }

    return textWidget;
  }

  Widget _buildText(BuildContext context) {
    final style = TextStyle(
      fontFamily: FiftyTypography.fontFamily,
      fontSize: _fontSize,
      fontWeight: _fontWeight,
      color: FiftyColors.cream,
      letterSpacing: FiftyTypography.letterSpacingDisplay,
      height: FiftyTypography.lineHeightDisplay,
    );

    final textContent = Text(
      text.toUpperCase(),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );

    if (gradient != null) {
      return ShaderMask(
        shaderCallback: (bounds) => gradient!.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        blendMode: BlendMode.srcIn,
        child: textContent,
      );
    }

    return textContent;
  }
}

/// A hero section with title and optional subtitle.
///
/// Convenience widget combining [FiftyHero] with an optional subtitle
/// and consistent spacing.
///
/// Example:
/// ```dart
/// FiftyHeroSection(
///   title: 'The Future of AI',
///   subtitle: 'Powered by Fifty.ai',
///   glitchOnMount: true,
/// )
/// ```
class FiftyHeroSection extends StatelessWidget {
  /// Creates a hero section.
  const FiftyHeroSection({
    super.key,
    required this.title,
    this.subtitle,
    this.titleSize = FiftyHeroSize.display,
    this.glitchOnMount = false,
    this.titleGradient,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = FiftySpacing.lg,
  });

  /// The main headline text.
  final String title;

  /// Optional subtitle text below the title.
  final String? subtitle;

  /// The size of the title.
  final FiftyHeroSize titleSize;

  /// Whether to trigger a glitch effect on the title.
  final bool glitchOnMount;

  /// Optional gradient for the title.
  final Gradient? titleGradient;

  /// Cross-axis alignment for the section.
  final CrossAxisAlignment crossAxisAlignment;

  /// Spacing between title and subtitle.
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        FiftyHero(
          text: title,
          size: titleSize,
          glitchOnMount: glitchOnMount,
          gradient: titleGradient,
          textAlign: _textAlignFromCrossAxis(),
        ),
        if (subtitle != null) ...[
          SizedBox(height: spacing),
          Text(
            subtitle!,
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyLarge,
              fontWeight: FiftyTypography.regular,
              color: FiftyColors.slateGrey,
              height: FiftyTypography.lineHeightBody,
            ),
            textAlign: _textAlignFromCrossAxis(),
          ),
        ],
      ],
    );
  }

  TextAlign _textAlignFromCrossAxis() {
    switch (crossAxisAlignment) {
      case CrossAxisAlignment.start:
        return TextAlign.left;
      case CrossAxisAlignment.end:
        return TextAlign.right;
      case CrossAxisAlignment.center:
      case CrossAxisAlignment.stretch:
      case CrossAxisAlignment.baseline:
        return TextAlign.center;
    }
  }
}
