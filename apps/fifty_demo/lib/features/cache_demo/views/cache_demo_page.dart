/// Cache Demo Page
///
/// Demonstrates TTL-based caching with hit/miss indicators.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../actions/cache_demo_actions.dart';
import '../controllers/cache_demo_view_model.dart';

/// Cache demo page widget.
///
/// Shows cache hit/miss indicators, TTL countdown, and cache stats.
class CacheDemoPage extends GetView<CacheDemoViewModel> {
  /// Creates a cache demo page.
  const CacheDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CacheDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<CacheDemoActions>();

        return DemoScaffold(
          title: 'Fifty Cache',
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const FiftySectionHeader(
                  title: 'TTL Cache Demo',
                  subtitle: 'Simulated API calls with in-memory caching',
                ),

                // Endpoint Selection
                _buildEndpointSelector(context, viewModel, actions),
                SizedBox(height: FiftySpacing.lg),

                // TTL Countdown
                _buildTtlCountdown(context, viewModel),
                SizedBox(height: FiftySpacing.lg),

                // Action Buttons
                _buildActionButtons(context, viewModel, actions),
                SizedBox(height: FiftySpacing.lg),

                // Last Result
                if (viewModel.lastResult.isNotEmpty)
                  _buildLastResult(context, viewModel),
                if (viewModel.lastResult.isNotEmpty)
                  SizedBox(height: FiftySpacing.lg),

                // Cache Stats
                _buildCacheStats(context, viewModel),
                SizedBox(height: FiftySpacing.lg),

                // Info Card
                _buildInfoCard(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEndpointSelector(
    BuildContext context,
    CacheDemoViewModel viewModel,
    CacheDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ENDPOINT',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: FiftySpacing.sm),
        Wrap(
          spacing: FiftySpacing.sm,
          runSpacing: FiftySpacing.sm,
          children: List.generate(CacheDemoViewModel.endpoints.length, (index) {
            final isSelected = viewModel.selectedEndpoint == index;
            final label = Uri.parse(CacheDemoViewModel.endpoints[index]).pathSegments.last;

            return GestureDetector(
              onTap: () => actions.onEndpointSelected(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FiftySpacing.md,
                  vertical: FiftySpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: FiftyRadii.smRadius,
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '/$label',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTtlCountdown(
    BuildContext context,
    CacheDemoViewModel viewModel,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = viewModel.hasActiveEntry
        ? viewModel.ttlRemaining / CacheDemoViewModel.cacheTtl.inSeconds
        : 0.0;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TTL COUNTDOWN',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FiftySpacing.sm,
                  vertical: FiftySpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: viewModel.hasActiveEntry
                      ? colorScheme.primary.withValues(alpha: 0.15)
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: FiftyRadii.smRadius,
                ),
                child: Text(
                  viewModel.hasActiveEntry
                      ? '${viewModel.ttlRemaining}s remaining'
                      : 'No active entry',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    fontWeight: FontWeight.bold,
                    color: viewModel.hasActiveEntry
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: FiftySpacing.sm),
          ClipRRect(
            borderRadius: FiftyRadii.smRadius,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    CacheDemoViewModel viewModel,
    CacheDemoActions actions,
  ) {
    return Row(
      children: [
        Expanded(
          child: FiftyButton(
            label: viewModel.isLoading ? 'FETCHING...' : 'FETCH DATA',
            variant: FiftyButtonVariant.primary,
            loading: viewModel.isLoading,
            onPressed: viewModel.isLoading
                ? null
                : () => actions.onFetchTapped(context),
          ),
        ),
        SizedBox(width: FiftySpacing.md),
        Expanded(
          child: FiftyButton(
            label: 'CLEAR CACHE',
            variant: FiftyButtonVariant.secondary,
            onPressed: () => actions.onClearCacheTapped(context),
          ),
        ),
      ],
    );
  }

  Widget _buildLastResult(
    BuildContext context,
    CacheDemoViewModel viewModel,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                viewModel.wasCacheHit
                    ? Icons.flash_on
                    : Icons.cloud_download_outlined,
                color: viewModel.wasCacheHit
                    ? colorScheme.primary
                    : colorScheme.tertiary,
                size: 20,
              ),
              SizedBox(width: FiftySpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FiftySpacing.sm,
                  vertical: FiftySpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: viewModel.wasCacheHit
                      ? colorScheme.primary.withValues(alpha: 0.15)
                      : colorScheme.tertiary.withValues(alpha: 0.15),
                  borderRadius: FiftyRadii.smRadius,
                ),
                child: Text(
                  viewModel.wasCacheHit ? 'CACHE HIT' : 'CACHE MISS',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.labelSmall,
                    fontWeight: FontWeight.bold,
                    color: viewModel.wasCacheHit
                        ? colorScheme.primary
                        : colorScheme.tertiary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: FiftySpacing.sm),
          Text(
            'RESPONSE',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: FiftySpacing.xs),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(FiftySpacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: FiftyRadii.smRadius,
            ),
            child: Text(
              viewModel.lastResult,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCacheStats(
    BuildContext context,
    CacheDemoViewModel viewModel,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CACHE STATISTICS',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: FiftySpacing.md),
          Row(
            children: [
              _buildStatItem(
                context,
                'HITS',
                '${viewModel.hitCount}',
                Icons.flash_on,
                colorScheme.primary,
              ),
              _buildStatItem(
                context,
                'MISSES',
                '${viewModel.missCount}',
                Icons.cloud_download_outlined,
                colorScheme.tertiary,
              ),
              _buildStatItem(
                context,
                'ENTRIES',
                '${viewModel.entryCount}',
                Icons.storage_outlined,
                colorScheme.secondary,
              ),
              _buildStatItem(
                context,
                'HIT RATE',
                viewModel.hitRateDisplay,
                Icons.speed_outlined,
                colorScheme.onSurface,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: FiftySpacing.xs),
          Text(
            value,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.titleMedium,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelSmall,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                size: 16,
              ),
              SizedBox(width: FiftySpacing.sm),
              Text(
                'HOW IT WORKS',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: FiftySpacing.sm),
          _buildInfoItem(context, 'Uses MemoryCacheStore for in-memory caching'),
          _buildInfoItem(context, 'TTL is set to 15 seconds per entry'),
          _buildInfoItem(context, 'First fetch: cache miss (simulates 800ms network delay)'),
          _buildInfoItem(context, 'Subsequent fetches within TTL: instant cache hit'),
          _buildInfoItem(context, 'Each endpoint has its own cache entry'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: FiftySpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u2022',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
