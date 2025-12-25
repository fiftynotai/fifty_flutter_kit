import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A circular avatar with FDL styling.
///
/// Features:
/// - Circular shape with customizable border
/// - Image or fallback initials display
/// - Customizable size and border color
///
/// Example:
/// ```dart
/// FiftyAvatar(
///   imageUrl: 'https://example.com/avatar.jpg',
///   fallbackText: 'JD',
///   size: 48,
/// )
/// ```
class FiftyAvatar extends StatelessWidget {
  /// Creates a Fifty-styled avatar.
  const FiftyAvatar({
    super.key,
    this.imageUrl,
    this.fallbackText,
    this.size = 40,
    this.borderColor,
    this.borderWidth = 2,
    this.backgroundColor,
  });

  /// URL of the avatar image.
  ///
  /// If null or fails to load, [fallbackText] is displayed.
  final String? imageUrl;

  /// Text to display when image is unavailable.
  ///
  /// Typically initials (e.g., "JD" for John Doe).
  final String? fallbackText;

  /// The diameter of the avatar.
  final double size;

  /// The color of the border.
  ///
  /// Defaults to [FiftyColors.border].
  final Color? borderColor;

  /// The width of the border.
  final double borderWidth;

  /// The background color for the fallback state.
  ///
  /// Defaults to [FiftyColors.gunmetal].
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBorderColor = borderColor ?? FiftyColors.border;
    final effectiveBackgroundColor = backgroundColor ?? FiftyColors.gunmetal;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: effectiveBorderColor,
          width: borderWidth,
        ),
      ),
      child: ClipOval(
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                width: size - borderWidth * 2,
                height: size - borderWidth * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildFallback(effectiveBackgroundColor, colorScheme),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildFallback(effectiveBackgroundColor, colorScheme);
                },
              )
            : _buildFallback(effectiveBackgroundColor, colorScheme),
      ),
    );
  }

  Widget _buildFallback(Color backgroundColor, ColorScheme colorScheme) {
    final initials = fallbackText?.toUpperCase() ?? '?';
    final fontSize = size * 0.35;

    return Container(
      width: size - borderWidth * 2,
      height: size - borderWidth * 2,
      color: backgroundColor,
      alignment: Alignment.center,
      child: Text(
        initials.length > 2 ? initials.substring(0, 2) : initials,
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: fontSize,
          fontWeight: FiftyTypography.medium,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
