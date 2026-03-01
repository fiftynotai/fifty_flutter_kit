import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// A list tile component for displaying items with icon, title, and trailing content.
///
/// Features:
/// - Leading icon in colored circular background
/// - Title and optional subtitle
/// - Trailing text with optional subtext, or custom widget
/// - Hover state with background change and icon scale
/// - Optional divider
/// - Mode-aware colors
///
/// Example:
/// ```dart
/// FiftyListTile(
///   leadingIcon: Icons.subscriptions,
///   leadingIconColor: Colors.blue,
///   title: 'Subscription',
///   subtitle: 'Adobe Creative Cloud',
///   trailingText: '-\$54.00',
///   trailingSubtext: 'Today',
///   onTap: () => navigateToDetail(),
/// )
/// ```
class FiftyListTile extends StatefulWidget {
  const FiftyListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.leadingIcon,
    this.leadingIconColor,
    this.leadingIconBackgroundColor,
    this.trailing,
    this.trailingText,
    this.trailingSubtext,
    this.trailingTextColor,
    this.onTap,
    this.showDivider = false,
  });

  /// The primary text of the list tile.
  final String title;

  /// Secondary text displayed below the title.
  final String? subtitle;

  /// Custom leading widget. Overrides [leadingIcon] if provided.
  final Widget? leading;

  /// Icon displayed in a circular container on the left.
  final IconData? leadingIcon;

  /// Color of the leading icon.
  final Color? leadingIconColor;

  /// Background color of the icon container.
  final Color? leadingIconBackgroundColor;

  /// Custom trailing widget. Overrides [trailingText] if provided.
  final Widget? trailing;

  /// Primary trailing text (e.g., price, value).
  final String? trailingText;

  /// Secondary trailing text (e.g., date, status).
  final String? trailingSubtext;

  /// Color for the trailing text.
  final Color? trailingTextColor;

  /// Callback when the tile is tapped.
  final VoidCallback? onTap;

  /// Whether to show a divider below the tile.
  final bool showDivider;

  @override
  State<FiftyListTile> createState() => _FiftyListTileState();
}

class _FiftyListTileState extends State<FiftyListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fifty = theme.extension<FiftyThemeExtension>()!;
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Hover background color
    final hoverColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.03);

    // Divider color
    final dividerColor = colorScheme.outline;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: fifty.fast,
              curve: fifty.standardCurve,
              padding: EdgeInsets.all(FiftySpacing.lg),
              decoration: BoxDecoration(
                color: _isHovered ? hoverColor : Colors.transparent,
              ),
              child: Row(
                children: [
                  _buildLeading(colorScheme, fifty),
                  SizedBox(width: FiftySpacing.lg),
                  _buildContent(colorScheme),
                  _buildTrailing(colorScheme),
                ],
              ),
            ),
          ),
        ),
        if (widget.showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor.withValues(alpha: 0.5),
            indent: FiftySpacing.lg + 40 + FiftySpacing.lg, // align with content
          ),
      ],
    );
  }

  Widget _buildLeading(ColorScheme colorScheme, FiftyThemeExtension fifty) {
    if (widget.leading != null) return widget.leading!;
    if (widget.leadingIcon == null) return const SizedBox.shrink();

    final iconColor = widget.leadingIconColor ?? colorScheme.primary;
    final bgColor =
        widget.leadingIconBackgroundColor ?? iconColor.withValues(alpha: 0.15);

    return AnimatedScale(
      scale: _isHovered ? 1.1 : 1.0,
      duration: fifty.fast,
      curve: fifty.standardCurve,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.leadingIcon,
          size: 20,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _buildContent(ColorScheme colorScheme) {
    final subtitleColor = colorScheme.onSurfaceVariant;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FiftyTypography.bold,
              color: colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              widget.subtitle!,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelMedium,
                fontWeight: FiftyTypography.regular,
                color: subtitleColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrailing(ColorScheme colorScheme) {
    if (widget.trailing != null) return widget.trailing!;
    if (widget.trailingText == null) return const SizedBox.shrink();

    final textColor = widget.trailingTextColor ?? colorScheme.onSurface;
    final subtextColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.trailingText!,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            fontWeight: FiftyTypography.bold,
            color: textColor,
          ),
        ),
        if (widget.trailingSubtext != null) ...[
          const SizedBox(height: 2),
          Text(
            widget.trailingSubtext!,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: 10,
              fontWeight: FiftyTypography.regular,
              color: subtextColor,
            ),
          ),
        ],
      ],
    );
  }
}
