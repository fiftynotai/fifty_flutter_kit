/// Packages Page
///
/// Hub page for accessing all Fifty ecosystem package demos.
/// Organizes packages by category for easy navigation.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
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
                _buildStatusSummary(viewModel),
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

  Widget _buildStatusSummary(PackagesViewModel viewModel) {
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: FiftyColors.hunterGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: FiftySpacing.sm),
          Text(
            '${viewModel.availableCount}/${viewModel.totalCount} DEMOS AVAILABLE',
            style: const TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.cream,
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
        SectionHeader(
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
                    ? FiftyColors.burgundy.withValues(alpha: 0.2)
                    : FiftyColors.slateGrey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(FiftyRadii.sm),
              ),
              child: Icon(
                package.icon,
                color: package.isAvailable
                    ? FiftyColors.burgundy
                    : FiftyColors.slateGrey,
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
                    style: const TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      fontWeight: FontWeight.w600,
                      color: FiftyColors.cream,
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.xs),
                  Text(
                    package.description,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: FiftyColors.cream.withValues(alpha: 0.7),
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
                  color: FiftyColors.slateGrey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(FiftyRadii.sm),
                ),
                child: const Text(
                  'SOON',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: 10,
                    color: FiftyColors.cream,
                  ),
                ),
              )
            else
              const Icon(
                Icons.chevron_right,
                color: FiftyColors.cream,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
