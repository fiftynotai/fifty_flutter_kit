/// Feedback Section Widget
///
/// Showcases FDL feedback components.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

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
        const _SectionLabel(label: 'LOADING INDICATORS'),
        const SizedBox(height: FiftySpacing.md),
        FiftyCard(
          padding: const EdgeInsets.all(FiftySpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Column(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FiftyColors.burgundy,
                      ),
                    ),
                  ),
                  SizedBox(height: FiftySpacing.sm),
                  Text(
                    'SPINNER',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: 10,
                      color: FiftyColors.slateGrey,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: 100,
                    child: LinearProgressIndicator(
                      backgroundColor: FiftyColors.borderDark,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        FiftyColors.burgundy,
                      ),
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.sm),
                  const Text(
                    'PROGRESS',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: 10,
                      color: FiftyColors.slateGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Status Badges
        const _SectionLabel(label: 'STATUS BADGES'),
        const SizedBox(height: FiftySpacing.md),
        const FiftyCard(
          padding: EdgeInsets.all(FiftySpacing.lg),
          child: Wrap(
            spacing: FiftySpacing.md,
            runSpacing: FiftySpacing.md,
            children: [
              _StatusBadge(label: 'ONLINE', color: FiftyColors.hunterGreen),
              _StatusBadge(label: 'PENDING', color: FiftyColors.warning),
              _StatusBadge(label: 'ERROR', color: FiftyColors.error),
              _StatusBadge(label: 'OFFLINE', color: FiftyColors.slateGrey),
            ],
          ),
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Toast/Snackbar
        const _SectionLabel(label: 'TOAST NOTIFICATION'),
        const SizedBox(height: FiftySpacing.md),
        FiftyButton(
          label: 'SHOW TOAST',
          onPressed: viewModel.triggerSnackbar,
          variant: FiftyButtonVariant.secondary,
          size: FiftyButtonSize.medium,
        ),
        if (viewModel.showSnackbar) ...[
          const SizedBox(height: FiftySpacing.md),
          Container(
            padding: const EdgeInsets.all(FiftySpacing.md),
            decoration: BoxDecoration(
              color: FiftyColors.burgundy.withValues(alpha: 0.1),
              borderRadius: FiftyRadii.lgRadius,
              border: Border.all(color: FiftyColors.burgundy),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: FiftyColors.burgundy,
                  size: 20,
                ),
                SizedBox(width: FiftySpacing.sm),
                Expanded(
                  child: Text(
                    'Action completed successfully!',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodyLarge,
                      color: FiftyColors.cream,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: FiftySpacing.xl),

        // Empty State
        const _SectionLabel(label: 'EMPTY STATE'),
        const SizedBox(height: FiftySpacing.md),
        const FiftyCard(
          padding: EdgeInsets.all(FiftySpacing.xxl),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.inbox,
                  size: 48,
                  color: FiftyColors.slateGrey,
                ),
                SizedBox(height: FiftySpacing.md),
                Text(
                  'NO DATA FOUND',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodyLarge,
                    color: FiftyColors.slateGrey,
                  ),
                ),
                SizedBox(height: FiftySpacing.xs),
                Text(
                  'Check back later or try a different filter',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: FiftyColors.slateGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.bodySmall,
        color: FiftyColors.slateGrey,
        letterSpacing: 1,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
  });

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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: FiftySpacing.xs),
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
