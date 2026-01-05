/// Buttons Section Widget
///
/// Showcases FiftyButton variants and sizes.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../viewmodel/ui_showcase_viewmodel.dart';

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
        const _SectionLabel(label: 'PRIMARY BUTTONS'),
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
        const _SectionLabel(label: 'SECONDARY BUTTONS'),
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

        // Ghost Buttons
        const _SectionLabel(label: 'GHOST BUTTONS'),
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

        // Disabled State
        const _SectionLabel(label: 'DISABLED STATE'),
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
          ],
        ),
        const SizedBox(height: FiftySpacing.xl),

        // Expanded Button
        const _SectionLabel(label: 'EXPANDED BUTTON'),
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: FiftyTypography.mono,
        color: FiftyColors.hyperChrome,
        letterSpacing: 1,
      ),
    );
  }
}
