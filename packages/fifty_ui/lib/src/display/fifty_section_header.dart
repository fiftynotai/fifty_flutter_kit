import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Size variants for the section header.
enum FiftySectionHeaderSize {
  /// Small size (body text).
  small,

  /// Medium size (bodyLarge text).
  medium,

  /// Large size (title text).
  large,
}

/// **FiftySectionHeader**
///
/// A styled section header widget for organizing content into logical
/// sections with consistent visual hierarchy.
///
/// Features:
/// - Three size variants (small, medium, large)
/// - Optional subtitle for additional context
/// - Optional leading/trailing widgets
/// - Optional divider line
/// - Optional accent dot
/// - Tap handler support
/// - Theme-aware colors via [ColorScheme]
///
/// **Why**
/// - Provides consistent section demarcation across the ecosystem
/// - Supports flexible layouts with leading/trailing content
/// - Follows FDL design patterns
///
/// **Example Usage**
/// ```dart
/// // Basic usage
/// FiftySectionHeader(
///   title: 'Settings',
/// )
///
/// // With subtitle
/// FiftySectionHeader(
///   title: 'Audio Controls',
///   subtitle: 'Configure audio playback settings',
/// )
///
/// // With trailing widget
/// FiftySectionHeader(
///   title: 'Recent Items',
///   trailing: TextButton(
///     onPressed: () {},
///     child: Text('See All'),
///   ),
/// )
///
/// // Large size without divider
/// FiftySectionHeader(
///   title: 'Dashboard',
///   size: FiftySectionHeaderSize.large,
///   showDivider: false,
/// )
///
/// // With leading icon
/// FiftySectionHeader(
///   title: 'Notifications',
///   leading: Icon(Icons.notifications),
///   showDot: false,
/// )
///
/// // Tappable header
/// FiftySectionHeader(
///   title: 'Expandable Section',
///   onTap: () => toggleSection(),
///   trailing: Icon(Icons.expand_more),
/// )
/// ```
class FiftySectionHeader extends StatelessWidget {
  /// Creates a Fifty-styled section header.
  const FiftySectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
    this.leading,
    this.showDivider = true,
    this.showDot = true,
    this.size = FiftySectionHeaderSize.medium,
    this.onTap,
  });

  /// The section title.
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  /// Optional trailing widget (e.g., action button, icon).
  final Widget? trailing;

  /// Optional leading widget (e.g., icon).
  ///
  /// When provided and [showDot] is true, the dot is hidden
  /// in favor of the leading widget.
  final Widget? leading;

  /// Whether to show a divider line below the header.
  final bool showDivider;

  /// Whether to show the accent dot before the title.
  ///
  /// Automatically hidden when [leading] is provided.
  final bool showDot;

  /// The size variant of the header.
  final FiftySectionHeaderSize size;

  /// Called when the header is tapped.
  final VoidCallback? onTap;

  /// Returns the appropriate font size based on [size].
  double get _fontSize {
    switch (size) {
      case FiftySectionHeaderSize.small:
        return FiftyTypography.bodyMedium;
      case FiftySectionHeaderSize.medium:
        return FiftyTypography.bodyLarge;
      case FiftySectionHeaderSize.large:
        return FiftyTypography.titleLarge;
    }
  }

  /// Returns the appropriate dot size based on [size].
  double get _dotSize {
    switch (size) {
      case FiftySectionHeaderSize.small:
        return 6;
      case FiftySectionHeaderSize.medium:
        return 8;
      case FiftySectionHeaderSize.large:
        return 10;
    }
  }

  /// Returns the appropriate letter spacing based on [size].
  double get _letterSpacing {
    switch (size) {
      case FiftySectionHeaderSize.small:
        return 1.5;
      case FiftySectionHeaderSize.medium:
        return 2;
      case FiftySectionHeaderSize.large:
        return 2.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final showAccentDot = showDot && leading == null;

    final Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (leading != null) ...[
                        leading!,
                        SizedBox(width: FiftySpacing.sm),
                      ] else if (showAccentDot) ...[
                        Container(
                          width: _dotSize,
                          height: _dotSize,
                          margin: EdgeInsets.only(right: FiftySpacing.sm),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                      Flexible(
                        child: Text(
                          title.toUpperCase(),
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: _fontSize,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                            letterSpacing: _letterSpacing,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: FiftySpacing.xs),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        if (showDivider) ...[
          SizedBox(height: FiftySpacing.sm),
          Container(
            height: 1,
            color: colorScheme.outline,
          ),
        ],
        SizedBox(height: FiftySpacing.md),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
