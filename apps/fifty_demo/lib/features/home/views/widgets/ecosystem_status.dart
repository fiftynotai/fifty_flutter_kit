/// Ecosystem Status Widget
///
/// Displays a categorized grid of package status cards.
library;

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
          padding: const EdgeInsets.only(bottom: FiftySpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category header
              Padding(
                padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
                child: Text(
                  category.label.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    fontWeight: FontWeight.w600,
                    color: FiftyColors.slateGrey,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              // Package grid
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate columns based on available width
                  const cardMinWidth = 140.0;
                  const spacing = FiftySpacing.sm;
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
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.sm),
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
                  color: package.isReady
                      ? FiftyColors.hunterGreen
                      : FiftyColors.warning,
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                package.version,
                style: const TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: 10,
                  color: FiftyColors.slateGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: FiftySpacing.xs),
          // Package name
          Text(
            package.name,
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: FiftyColors.cream,
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
                  fontSize: 9,
                  color: FiftyColors.cream.withValues(alpha: 0.6),
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
