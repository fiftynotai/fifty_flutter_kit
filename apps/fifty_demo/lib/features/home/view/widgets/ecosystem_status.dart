/// Ecosystem Status Widget
///
/// Displays a grid of package status cards.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../viewmodel/home_viewmodel.dart';

/// Ecosystem status display widget.
///
/// Shows a grid of all Fifty packages with their status.
class EcosystemStatus extends StatelessWidget {
  const EcosystemStatus({
    required this.packages,
    super.key,
  });

  /// List of packages to display.
  final List<PackageStatus> packages;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: FiftySpacing.md,
      runSpacing: FiftySpacing.md,
      children: packages.map((pkg) => _PackageCard(package: pkg)).toList(),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({required this.package});

  final PackageStatus package;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: FiftyCard(
        padding: const EdgeInsets.all(FiftySpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status dot and version
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: package.isReady
                        ? FiftyColors.igrisGreen
                        : FiftyColors.warning,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  package.version,
                  style: const TextStyle(
                    fontFamily: FiftyTypography.fontFamilyMono,
                    fontSize: 10,
                    color: FiftyColors.hyperChrome,
                  ),
                ),
              ],
            ),
            const SizedBox(height: FiftySpacing.sm),
            // Package name
            Text(
              package.name,
              style: const TextStyle(
                fontFamily: FiftyTypography.fontFamilyMono,
                fontSize: FiftyTypography.mono,
                fontWeight: FontWeight.bold,
                color: FiftyColors.terminalWhite,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (package.description != null) ...[
              const SizedBox(height: FiftySpacing.xs),
              Text(
                package.description!,
                style: const TextStyle(
                  fontFamily: FiftyTypography.fontFamilyMono,
                  fontSize: 9,
                  color: FiftyColors.hyperChrome,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
