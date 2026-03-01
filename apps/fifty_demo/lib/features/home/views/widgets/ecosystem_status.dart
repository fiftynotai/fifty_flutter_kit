/// Ecosystem Status Widget
///
/// Displays a categorized grid of package status cards.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../controllers/home_view_model.dart';

/// Ecosystem status display widget.
///
/// Shows a categorized grid of all Fifty packages with their status.
class EcosystemStatus extends StatelessWidget {
  const EcosystemStatus({
    required this.packages,
    super.key,
  });

  /// List of packages to display.
  final List<PackageStatus> packages;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Group packages by category
    final groupedPackages = <PackageCategory, List<PackageStatus>>{};
    for (final pkg in packages) {
      groupedPackages.putIfAbsent(pkg.category, () => []).add(pkg);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: PackageCategory.values.map((category) {
        final categoryPackages = groupedPackages[category] ?? [];
        if (categoryPackages.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.only(bottom: FiftySpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category header
              Padding(
                padding: EdgeInsets.only(bottom: FiftySpacing.sm),
                child: Text(
                  category.label.toUpperCase(),
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              // Package grid
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate columns based on available width
                  const cardMinWidth = 140.0;
                  spacing = FiftySpacing.sm;
                  final columns =
                      ((constraints.maxWidth + spacing) / (cardMinWidth + spacing))
                          .floor()
                          .clamp(2, 4);

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: categoryPackages.length,
                    itemBuilder: (context, index) {
                      return _PackageCard(package: categoryPackages[index]);
                    },
                  );
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});

  final PackageStatus package;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;
    final warningColor = fiftyTheme?.warning ?? colorScheme.error;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status dot and version row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: package.isReady ? successColor : warningColor,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                package.version,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.labelSmall,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: FiftySpacing.xs),
          // Package name
          Text(
            package.name,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (package.description != null) ...[
            const SizedBox(height: 2),
            Expanded(
              child: Text(
                package.description!,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.labelSmall,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
