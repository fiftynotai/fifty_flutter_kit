import 'package:cached_network_image/cached_network_image.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// **MarsPhotoCard**
///
/// A card for displaying Mars rover photos from NASA API.
///
/// **Features**:
/// - Full image display with CachedNetworkImage
/// - Camera name badge overlay
/// - Earth date display
/// - Rover name indicator
///
/// **Usage**:
/// ```dart
/// MarsPhotoCard(
///   imageUrl: 'https://mars.nasa.gov/...',
///   cameraName: 'NAVCAM',
///   cameraFullName: 'Navigation Camera',
///   earthDate: DateTime(2025, 1, 10),
///   roverName: 'Perseverance',
///   onTap: () => showFullScreen(),
/// )
/// ```
class MarsPhotoCard extends StatelessWidget {
  /// URL of the Mars photo.
  final String imageUrl;

  /// Short camera name (e.g., "NAVCAM", "FHAZ").
  final String cameraName;

  /// Full camera name for tooltip/accessibility.
  final String cameraFullName;

  /// The Earth date when the photo was taken.
  final DateTime earthDate;

  /// Name of the rover (e.g., "Curiosity", "Perseverance").
  final String roverName;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  const MarsPhotoCard({
    super.key,
    required this.imageUrl,
    required this.cameraName,
    required this.cameraFullName,
    required this.earthDate,
    required this.roverName,
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
          // Image with camera badge overlay
          Stack(
            children: [
              // Mars photo
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
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

              // Camera name badge
              Positioned(
                top: FiftySpacing.sm,
                left: FiftySpacing.sm,
                child: Tooltip(
                  message: cameraFullName,
                  child: FiftyBadge(
                    label: cameraName,
                    variant: FiftyBadgeVariant.primary,
                  ),
                ),
              ),
            ],
          ),

          // Photo metadata
          Padding(
            padding: const EdgeInsets.all(FiftySpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rover name
                Row(
                  children: [
                    Icon(
                      Icons.smart_toy_outlined,
                      size: 14,
                      color: FiftyColors.crimsonPulse,
                    ),
                    const SizedBox(width: FiftySpacing.xs),
                    Text(
                      roverName.toUpperCase(),
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamilyMono,
                        fontSize: FiftyTypography.mono,
                        fontWeight: FiftyTypography.medium,
                        color: FiftyColors.terminalWhite,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                // Earth date
                Row(
                  children: [
                    Icon(
                      Icons.public_outlined,
                      size: 14,
                      color: FiftyColors.hyperChrome,
                    ),
                    const SizedBox(width: FiftySpacing.xs),
                    Text(
                      _formatDate(earthDate),
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamilyMono,
                        fontSize: FiftyTypography.mono,
                        fontWeight: FiftyTypography.regular,
                        color: FiftyColors.hyperChrome,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Formats date as "YYYY-MM-DD".
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
