/// Packages Page
///
/// Hub page for accessing all Fifty ecosystem package demos.
/// Organizes packages by category for easy navigation.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../actions/packages_actions.dart';
import '../controllers/packages_view_model.dart';

/// Packages hub page widget.
///
/// Displays package demos organized by category with status indicators.
class PackagesPage extends GetView<PackagesViewModel> {
  /// Creates a packages page.
  const PackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackagesViewModel>(
      builder: (viewModel) {
        return DemoScaffold(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status summary
                _buildStatusSummary(context, viewModel),
                const SizedBox(height: FiftySpacing.xl),

                // Package categories
                for (final category in PackageCategory.values) ...[
                  _buildCategorySection(category, viewModel),
                  const SizedBox(height: FiftySpacing.lg),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusSummary(BuildContext context, PackagesViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: fiftyTheme?.success ?? colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: FiftySpacing.sm),
          Text(
            '${viewModel.availableCount}/${viewModel.totalCount} DEMOS AVAILABLE',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    PackageCategory category,
    PackagesViewModel viewModel,
  ) {
    final packages = viewModel.getPackagesByCategory(category);
    if (packages.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FiftySectionHeader(
          title: category.label.toUpperCase(),
          subtitle: '${packages.length} packages',
        ),
        ...packages.map(
          (package) => Padding(
            padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
            child: _PackageDemoCard(package: package),
          ),
        ),
      ],
    );
  }
}

/// Card widget for displaying a package demo entry.
class _PackageDemoCard extends StatelessWidget {
  const _PackageDemoCard({required this.package});

  final PackageDemo package;

  @override
  Widget build(BuildContext context) {
    final actions = Get.find<PackagesActions>();
    final colorScheme = Theme.of(context).colorScheme;

    return Opacity(
      opacity: package.isAvailable ? 1.0 : 0.5,
      child: FiftyCard(
        padding: const EdgeInsets.all(FiftySpacing.md),
        onTap: () => actions.onPackageTapped(context, package.id),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: package.isAvailable
                    ? colorScheme.primary.withValues(alpha: 0.2)
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(FiftyRadii.sm),
              ),
              child: Icon(
                package.icon,
                color: package.isAvailable
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            const SizedBox(width: FiftySpacing.md),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name.toUpperCase(),
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.xs),
                  Text(
                    package.description,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Status indicator
            if (!package.isAvailable)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FiftySpacing.sm,
                  vertical: FiftySpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(FiftyRadii.sm),
                ),
                child: Text(
                  'SOON',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: 10,
                    color: colorScheme.onSurface,
                  ),
                ),
              )
            else
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
