/// Utils Demo Page
///
/// Demonstrates DateTime extensions, Color utilities, responsive breakpoints,
/// and ApiResponse state machine from fifty_utils.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:fifty_utils/fifty_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../actions/utils_demo_actions.dart';
import '../controllers/utils_demo_view_model.dart';

/// Utils demo page widget.
///
/// Shows DateTime extensions, Color utilities, responsive info, and API state.
class UtilsDemoPage extends GetView<UtilsDemoViewModel> {
  /// Creates a utils demo page.
  const UtilsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UtilsDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<UtilsDemoActions>();

        return DemoScaffold(
          title: 'Fifty Utils',
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DateTime Extensions
                const FiftySectionHeader(
                  title: 'DateTime Extensions',
                  subtitle: 'timeAgo(), format(), isToday, and more',
                ),
                _buildDateTimeSection(context, viewModel),
                const SizedBox(height: FiftySpacing.xl),

                // Color Extensions
                const FiftySectionHeader(
                  title: 'Color Extensions',
                  subtitle: 'HexColor parsing and conversion',
                ),
                _buildColorSection(context, viewModel),
                const SizedBox(height: FiftySpacing.xl),

                // Responsive Utilities
                const FiftySectionHeader(
                  title: 'Responsive Utilities',
                  subtitle: 'Device type detection and breakpoints',
                ),
                _buildResponsiveSection(context),
                const SizedBox(height: FiftySpacing.xl),

                // ApiResponse State Machine
                const FiftySectionHeader(
                  title: 'ApiResponse State Machine',
                  subtitle: 'idle -> loading -> success -> error cycle',
                ),
                _buildApiStateSection(context, viewModel, actions),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // DateTime Section
  // ---------------------------------------------------------------------------

  Widget _buildDateTimeSection(
    BuildContext context,
    UtilsDemoViewModel viewModel,
  ) {
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: List.generate(viewModel.sampleDates.length, (index) {
          final date = viewModel.sampleDates[index];
          return _buildDateRow(
            context,
            viewModel.labelForDate(index),
            date,
          );
        }),
      ),
    );
  }

  Widget _buildDateRow(BuildContext context, String label, DateTime date) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FiftySpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelSmall,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: FiftySpacing.xs),
          Row(
            children: [
              Expanded(
                child: _buildDateChip(
                  context,
                  'timeAgo()',
                  date.timeAgo(),
                ),
              ),
              const SizedBox(width: FiftySpacing.sm),
              Expanded(
                child: _buildDateChip(
                  context,
                  'format()',
                  date.format(),
                ),
              ),
              const SizedBox(width: FiftySpacing.sm),
              Expanded(
                child: _buildDateChip(
                  context,
                  'isToday',
                  date.isToday ? 'true' : 'false',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateChip(BuildContext context, String method, String result) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(FiftySpacing.sm),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: FiftyRadii.smRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            method,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelSmall,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            result,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Color Section
  // ---------------------------------------------------------------------------

  Widget _buildColorSection(
    BuildContext context,
    UtilsDemoViewModel viewModel,
  ) {
    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: [
          for (final hex in UtilsDemoViewModel.sampleHexColors)
            _buildColorRow(context, viewModel, hex),
        ],
      ),
    );
  }

  Widget _buildColorRow(
    BuildContext context,
    UtilsDemoViewModel viewModel,
    String hex,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = viewModel.parseHexColor(hex);
    final roundTrip = viewModel.colorToHex(color);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FiftySpacing.xs),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: FiftyRadii.smRadius,
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(width: FiftySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HexColor.fromHex("$hex")',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '.toHex() = $roundTrip',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.labelSmall,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Responsive Section
  // ---------------------------------------------------------------------------

  Widget _buildResponsiveSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deviceType = ResponsiveUtils.deviceType(context);
    final screenWidth = ResponsiveUtils.screenWidth(context);
    final screenHeight = ResponsiveUtils.screenHeight(context);
    final isPortrait = ResponsiveUtils.isPortrait(context);
    final responsivePadding = ResponsiveUtils.padding(context);
    final gridCols = ResponsiveUtils.gridColumns(context);

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: [
          // Device type badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.lg,
                vertical: FiftySpacing.sm,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: FiftyRadii.smRadius,
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                deviceType.name.toUpperCase(),
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.titleMedium,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: FiftySpacing.md),
          _buildResponsiveRow(context, 'Screen Width', '${screenWidth.toStringAsFixed(0)}px'),
          _buildResponsiveRow(context, 'Screen Height', '${screenHeight.toStringAsFixed(0)}px'),
          _buildResponsiveRow(context, 'Orientation', isPortrait ? 'Portrait' : 'Landscape'),
          _buildResponsiveRow(context, 'Responsive Padding', '${responsivePadding.toStringAsFixed(0)}px'),
          _buildResponsiveRow(context, 'Grid Columns', '$gridCols'),
          const SizedBox(height: FiftySpacing.sm),
          // Breakpoint thresholds
          Text(
            'BREAKPOINTS',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelSmall,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: FiftySpacing.xs),
          _buildBreakpointRow(context, 'Mobile', '< 600px', ResponsiveUtils.isMobile(context)),
          _buildBreakpointRow(context, 'Tablet', '600 - 1024px', ResponsiveUtils.isTablet(context)),
          _buildBreakpointRow(context, 'Desktop', '1024 - 1440px', ResponsiveUtils.isDesktop(context)),
          _buildBreakpointRow(context, 'Wide', '>= 1440px', ResponsiveUtils.isWideDesktop(context)),
        ],
      ),
    );
  }

  Widget _buildResponsiveRow(BuildContext context, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FiftySpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakpointRow(
    BuildContext context,
    String label,
    String range,
    bool isActive,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          Text(
            range,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.labelSmall,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ApiResponse Section
  // ---------------------------------------------------------------------------

  Widget _buildApiStateSection(
    BuildContext context,
    UtilsDemoViewModel viewModel,
    UtilsDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Current state display
        Obx(() {
          final statusColor = viewModel.apiStatusColor(colorScheme);
          final state = viewModel.apiState.value;

          return FiftyCard(
            padding: const EdgeInsets.all(FiftySpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: FiftySpacing.sm),
                    Text(
                      viewModel.apiStatusLabel,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.titleMedium,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: FiftySpacing.sm),
                // State properties
                _buildApiProperty(context, 'isLoading', '${state.isLoading}'),
                _buildApiProperty(context, 'hasData', '${state.hasData}'),
                _buildApiProperty(context, 'hasError', '${state.hasError}'),
                _buildApiProperty(context, 'isIdle', '${state.isIdle}'),
                _buildApiProperty(context, 'isSuccess', '${state.isSuccess}'),
                if (state.hasData) ...[
                  const SizedBox(height: FiftySpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(FiftySpacing.sm),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: FiftyRadii.smRadius,
                    ),
                    child: Text(
                      'data: ${state.data}',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
                if (state.hasError) ...[
                  const SizedBox(height: FiftySpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(FiftySpacing.sm),
                    decoration: BoxDecoration(
                      color: colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: FiftyRadii.smRadius,
                    ),
                    child: Text(
                      'error: ${state.error}',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
        const SizedBox(height: FiftySpacing.md),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: FiftyButton(
                label: 'CYCLE STATES',
                variant: FiftyButtonVariant.primary,
                onPressed: () => actions.onCycleApiStatesTapped(context),
              ),
            ),
            const SizedBox(width: FiftySpacing.md),
            Expanded(
              child: FiftyButton(
                label: 'RESET',
                variant: FiftyButtonVariant.secondary,
                onPressed: actions.onResetApiStateTapped,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildApiProperty(BuildContext context, String name, String value) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FontWeight.bold,
              color: value == 'true'
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
