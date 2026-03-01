/// Feedback Section Widget
///
/// Showcases FDL feedback components.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/section_label.dart';
import '../../controllers/ui_showcase_view_model.dart';

/// Feedback section widget.
///
/// Shows loading indicators, status badges, and notifications.
class FeedbackSection extends StatelessWidget {
  const FeedbackSection({
    required this.viewModel,
    super.key,
  });

  final UiShowcaseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Loading Indicators
        const SectionLabel(label: 'LOADING INDICATORS'),
        SizedBox(height: FiftySpacing.md),
        const FiftyCard(
          padding: EdgeInsets.all(FiftySpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LoadingIndicatorDemo(
                type: _LoadingType.spinner,
                label: 'SPINNER',
              ),
              _LoadingIndicatorDemo(
                type: _LoadingType.progress,
                label: 'PROGRESS',
              ),
            ],
          ),
        ),
        SizedBox(height: FiftySpacing.xl),

        // Status Badges
        const SectionLabel(label: 'STATUS BADGES'),
        SizedBox(height: FiftySpacing.md),
        Builder(
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
            return FiftyCard(
              padding: EdgeInsets.all(FiftySpacing.lg),
              child: Wrap(
                spacing: FiftySpacing.md,
                runSpacing: FiftySpacing.md,
                children: [
                  _StatusBadge(
                    label: 'ONLINE',
                    color: fiftyTheme?.success ?? colorScheme.tertiary,
                  ),
                  _StatusBadge(
                    label: 'PENDING',
                    color: fiftyTheme?.warning ?? colorScheme.error,
                  ),
                  _StatusBadge(label: 'ERROR', color: colorScheme.error),
                  _StatusBadge(
                    label: 'OFFLINE',
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: FiftySpacing.xl),

        // Toast/Snackbar - Now triggers actual FiftySnackbar
        const SectionLabel(label: 'TOAST NOTIFICATION'),
        SizedBox(height: FiftySpacing.md),
        Wrap(
          spacing: FiftySpacing.sm,
          runSpacing: FiftySpacing.sm,
          children: [
            FiftyButton(
              label: 'INFO',
              onPressed: () => FiftySnackbar.show(
                context,
                message: 'This is an info notification',
                variant: FiftySnackbarVariant.info,
              ),
              variant: FiftyButtonVariant.secondary,
              size: FiftyButtonSize.small,
            ),
            FiftyButton(
              label: 'SUCCESS',
              onPressed: () => FiftySnackbar.show(
                context,
                message: 'Action completed successfully!',
                variant: FiftySnackbarVariant.success,
              ),
              variant: FiftyButtonVariant.secondary,
              size: FiftyButtonSize.small,
            ),
            FiftyButton(
              label: 'WARNING',
              onPressed: () => FiftySnackbar.show(
                context,
                message: 'Please review before proceeding',
                variant: FiftySnackbarVariant.warning,
              ),
              variant: FiftyButtonVariant.secondary,
              size: FiftyButtonSize.small,
            ),
            FiftyButton(
              label: 'ERROR',
              onPressed: () => FiftySnackbar.show(
                context,
                message: 'Something went wrong',
                variant: FiftySnackbarVariant.error,
              ),
              variant: FiftyButtonVariant.secondary,
              size: FiftyButtonSize.small,
            ),
          ],
        ),
        SizedBox(height: FiftySpacing.xl),

        // Empty State
        const SectionLabel(label: 'EMPTY STATE'),
        SizedBox(height: FiftySpacing.md),
        Builder(
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            return FiftyCard(
              padding: EdgeInsets.all(FiftySpacing.xxl),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 48,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(height: FiftySpacing.md),
                    Text(
                      'NO DATA FOUND',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyLarge,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: FiftySpacing.xs),
                    Text(
                      'Check back later or try a different filter',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Loading indicator type for demo.
enum _LoadingType { spinner, progress }

/// Styled loading indicator demo widget.
///
/// Displays loading indicators with consistent FDL styling.
class _LoadingIndicatorDemo extends StatelessWidget {
  const _LoadingIndicatorDemo({
    required this.type,
    required this.label,
  });

  /// Size for spinner indicator.
  static const double _spinnerSize = 24;

  /// Width for progress indicator.
  static const double _progressWidth = 100;

  final _LoadingType type;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        if (type == _LoadingType.spinner)
          SizedBox(
            width: _spinnerSize,
            height: _spinnerSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          )
        else
          SizedBox(
            width: _progressWidth,
            child: LinearProgressIndicator(
              backgroundColor: colorScheme.outline,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
        SizedBox(height: FiftySpacing.sm),
        Text(
          label,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.labelSmall,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Status badge widget with FDL styling.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
  });

  /// Size for status dot indicator.
  static const double _dotSize = 6;

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.md,
        vertical: FiftySpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: FiftyRadii.lgRadius,
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _dotSize,
            height: _dotSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: FiftySpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
