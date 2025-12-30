import 'package:cached_network_image/cached_network_image.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// **ApodCard**
///
/// A card displaying the Astronomy Picture of the Day from NASA API.
///
/// **Features**:
/// - Full-width image with CachedNetworkImage
/// - Title in Monument Extended style
/// - Date badge overlay
/// - "VIEW HD" button for high-resolution link
///
/// **Usage**:
/// ```dart
/// ApodCard(
///   title: 'The Horsehead Nebula',
///   imageUrl: 'https://apod.nasa.gov/...',
///   date: DateTime(2025, 1, 15),
///   hdUrl: 'https://apod.nasa.gov/hd/...',
///   onViewHd: () => launchUrl(hdUrl),
/// )
/// ```
class ApodCard extends StatelessWidget {
  /// The APOD title.
  final String title;

  /// URL of the standard resolution image.
  final String imageUrl;

  /// The date of this APOD.
  final DateTime date;

  /// Optional URL for the high-definition image.
  final String? hdUrl;

  /// Callback when "VIEW HD" button is pressed.
  final VoidCallback? onViewHd;

  /// Optional callback when card is tapped.
  final VoidCallback? onTap;

  const ApodCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.date,
    this.hdUrl,
    this.onViewHd,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FiftyCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image with date badge overlay
          Stack(
            children: [
              // Main image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: FiftyColors.gunmetal,
                      child: const Center(
                        child: FiftyLoadingIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: FiftyColors.gunmetal,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: FiftyColors.hyperChrome,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Date badge
              Positioned(
                top: FiftySpacing.md,
                right: FiftySpacing.md,
                child: FiftyBadge(
                  label: _formatDate(date),
                  variant: FiftyBadgeVariant.neutral,
                ),
              ),
            ],
          ),

          // Content section
          Padding(
            padding: const EdgeInsets.all(FiftySpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title in Monument Extended style
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamilyHeadline,
                    fontSize: FiftyTypography.body,
                    fontWeight: FiftyTypography.ultrabold,
                    color: FiftyColors.terminalWhite,
                    letterSpacing: FiftyTypography.tight * FiftyTypography.body,
                    height: FiftyTypography.headingLineHeight,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // VIEW HD button (if HD URL available)
                if (hdUrl != null && hdUrl!.isNotEmpty) ...[
                  const SizedBox(height: FiftySpacing.md),
                  FiftyButton(
                    label: 'VIEW HD',
                    icon: Icons.hd_outlined,
                    variant: FiftyButtonVariant.secondary,
                    size: FiftyButtonSize.small,
                    onPressed: onViewHd,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Formats date as "MMM DD, YYYY"
  String _formatDate(DateTime date) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }
}
