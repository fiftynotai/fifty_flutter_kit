/// Buttons Section Widget
///
/// Showcases FiftyButton variants and sizes.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/section_label.dart';
import '../../controllers/ui_showcase_view_model.dart';

/// Buttons section widget.
///
/// Displays all button variants and sizes.
class ButtonsSection extends StatelessWidget {
  const ButtonsSection({
    required this.viewModel,
    super.key,
  });

  final UiShowcaseViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary Buttons
        const SectionLabel(label: 'PRIMARY BUTTONS'),
        const SizedBox(height: FiftySpacing.md),
        Wrap(
          spacing: FiftySpacing.md,
          runSpacing: FiftySpacing.md,
          children: [
            FiftyButton(
              label: 'LARGE',
              onPressed: () {},
              variant: FiftyButtonVariant.primary,
              size: FiftyButtonSize.large,
            ),
            FiftyButton(
              label: 'MEDIUM',
              onPressed: () {},
              variant: FiftyButtonVariant.primary,
              size: FiftyButtonSize.medium,
            ),
            FiftyButton(
              label: 'SMALL',
              onPressed: () {},
              variant: FiftyButtonVariant.primary,
              size: FiftyButtonSize.small,
            ),
          ],
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Secondary Buttons
        const SectionLabel(label: 'SECONDARY BUTTONS'),
        const SizedBox(height: FiftySpacing.md),
        Wrap(
          spacing: FiftySpacing.md,
          runSpacing: FiftySpacing.md,
          children: [
            FiftyButton(
              label: 'LARGE',
              onPressed: () {},
              variant: FiftyButtonVariant.secondary,
              size: FiftyButtonSize.large,
            ),
            FiftyButton(
              label: 'MEDIUM',
              onPressed: () {},
              variant: FiftyButtonVariant.secondary,
              size: FiftyButtonSize.medium,
            ),
            FiftyButton(
              label: 'SMALL',
              onPressed: () {},
              variant: FiftyButtonVariant.secondary,
              size: FiftyButtonSize.small,
            ),
          ],
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Outline Buttons
        const SectionLabel(label: 'OUTLINE BUTTONS'),
        const SizedBox(height: FiftySpacing.md),
        Wrap(
          spacing: FiftySpacing.md,
          runSpacing: FiftySpacing.md,
          children: [
            FiftyButton(
              label: 'LARGE',
              onPressed: () {},
              variant: FiftyButtonVariant.outline,
              size: FiftyButtonSize.large,
            ),
            FiftyButton(
              label: 'MEDIUM',
              onPressed: () {},
              variant: FiftyButtonVariant.outline,
              size: FiftyButtonSize.medium,
            ),
            FiftyButton(
              label: 'SMALL',
              onPressed: () {},
              variant: FiftyButtonVariant.outline,
              size: FiftyButtonSize.small,
            ),
          ],
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Ghost Buttons
        const SectionLabel(label: 'GHOST BUTTONS'),
        const SizedBox(height: FiftySpacing.md),
        Wrap(
          spacing: FiftySpacing.md,
          runSpacing: FiftySpacing.md,
          children: [
            FiftyButton(
              label: 'GHOST',
              onPressed: () {},
              variant: FiftyButtonVariant.ghost,
              size: FiftyButtonSize.medium,
            ),
            FiftyButton(
              label: 'WITH ICON',
              onPressed: () {},
              variant: FiftyButtonVariant.ghost,
              size: FiftyButtonSize.medium,
              icon: Icons.add,
            ),
          ],
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Trailing Icon Examples
        const SectionLabel(label: 'TRAILING ICON'),
        const SizedBox(height: FiftySpacing.md),
        Wrap(
          spacing: FiftySpacing.md,
          runSpacing: FiftySpacing.md,
          children: [
            FiftyButton(
              label: 'GET STARTED',
              onPressed: () {},
              variant: FiftyButtonVariant.primary,
              size: FiftyButtonSize.large,
              trailingIcon: Icons.arrow_forward,
            ),
            FiftyButton(
              label: 'DOWNLOAD',
              onPressed: () {},
              variant: FiftyButtonVariant.secondary,
              size: FiftyButtonSize.medium,
              icon: Icons.download,
            ),
            FiftyButton(
              label: 'LEARN MORE',
              onPressed: () {},
              variant: FiftyButtonVariant.outline,
              size: FiftyButtonSize.medium,
              trailingIcon: Icons.arrow_forward,
            ),
          ],
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Disabled State
        const SectionLabel(label: 'DISABLED STATE'),
        const SizedBox(height: FiftySpacing.md),
        const Wrap(
          spacing: FiftySpacing.md,
          runSpacing: FiftySpacing.md,
          children: [
            FiftyButton(
              label: 'DISABLED',
              onPressed: null,
              variant: FiftyButtonVariant.primary,
              size: FiftyButtonSize.medium,
            ),
            FiftyButton(
              label: 'DISABLED',
              onPressed: null,
              variant: FiftyButtonVariant.secondary,
              size: FiftyButtonSize.medium,
            ),
            FiftyButton(
              label: 'DISABLED',
              onPressed: null,
              variant: FiftyButtonVariant.outline,
              size: FiftyButtonSize.medium,
            ),
          ],
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Expanded Button
        const SectionLabel(label: 'EXPANDED BUTTON'),
        const SizedBox(height: FiftySpacing.md),
        FiftyButton(
          label: 'FULL WIDTH BUTTON',
          onPressed: () {},
          variant: FiftyButtonVariant.primary,
          size: FiftyButtonSize.large,
          expanded: true,
        ),
      ],
    );
  }
}

