import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

/// **NeoListTile**
///
/// A list tile for displaying Near Earth Object data from NASA API.
///
/// **Features**:
/// - Object name as title
/// - Diameter, velocity, and miss distance metrics
/// - Hazardous status chip (red for hazardous, green for nominal)
/// - Close approach date display
///
/// **Usage**:
/// ```dart
/// NeoListTile(
///   name: '(2024 AB1)',
///   diameterMin: 50.0,
///   diameterMax: 112.0,
///   velocityKmPerSecond: 15.5,
///   missDistanceKm: 1200000,
///   isHazardous: true,
///   closeApproachDate: DateTime(2025, 1, 20),
///   onTap: () => showDetails(),
/// )
/// ```
class NeoListTile extends StatelessWidget {
  /// The NEO designation/name.
  final String name;

  /// Minimum estimated diameter in meters.
  final double diameterMin;

  /// Maximum estimated diameter in meters.
  final double diameterMax;

  /// Relative velocity in km/s.
  final double velocityKmPerSecond;

  /// Miss distance in kilometers.
  final double missDistanceKm;

  /// Whether this object is classified as potentially hazardous.
  final bool isHazardous;

  /// The close approach date.
  final DateTime closeApproachDate;

  /// Callback when the tile is tapped.
  final VoidCallback? onTap;

  const NeoListTile({
    super.key,
    required this.name,
    required this.diameterMin,
    required this.diameterMax,
    required this.velocityKmPerSecond,
    required this.missDistanceKm,
    required this.isHazardous,
    required this.closeApproachDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name + Hazard Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Object name
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamilyMono,
                    fontSize: FiftyTypography.body,
                    fontWeight: FiftyTypography.medium,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(width: FiftySpacing.md),

              // Hazard status chip
              FiftyChip(
                label: isHazardous ? 'HAZARDOUS' : 'NOMINAL',
                variant: isHazardous
                    ? FiftyChipVariant.error
                    : FiftyChipVariant.success,
                selected: isHazardous,
              ),
            ],
          ),

          const SizedBox(height: FiftySpacing.md),

          // Metrics row
          Row(
            children: [
              // Diameter
              Expanded(
                child: _MetricItem(
                  label: 'DIAMETER',
                  value: '${diameterMin.toStringAsFixed(0)}-${diameterMax.toStringAsFixed(0)}m',
                ),
              ),

              // Velocity
              Expanded(
                child: _MetricItem(
                  label: 'VELOCITY',
                  value: '${velocityKmPerSecond.toStringAsFixed(1)} km/s',
                ),
              ),

              // Miss Distance
              Expanded(
                child: _MetricItem(
                  label: 'MISS DIST',
                  value: _formatDistance(missDistanceKm),
                ),
              ),
            ],
          ),

          const SizedBox(height: FiftySpacing.md),

          // Close approach date
          Row(
            children: [
              Icon(
                Icons.event_outlined,
                size: 14,
                color: FiftyColors.hyperChrome,
              ),
              const SizedBox(width: FiftySpacing.xs),
              Text(
                'Close approach: ${_formatDate(closeApproachDate)}',
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
    );
  }

  /// Formats distance with appropriate units (km or million km).
  String _formatDistance(double km) {
    if (km >= 1000000) {
      return '${(km / 1000000).toStringAsFixed(2)}M km';
    }
    return '${km.toStringAsFixed(0)} km';
  }

  /// Formats date as "YYYY-MM-DD".
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// Internal widget for displaying a metric label and value.
class _MetricItem extends StatelessWidget {
  final String label;
  final String value;

  const _MetricItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamilyMono,
            fontSize: 10,
            fontWeight: FiftyTypography.regular,
            color: FiftyColors.hyperChrome,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamilyMono,
            fontSize: FiftyTypography.mono,
            fontWeight: FiftyTypography.medium,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
