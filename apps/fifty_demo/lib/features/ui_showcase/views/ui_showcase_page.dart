/// UI Showcase Page
///
/// Demonstrates all fifty_ui components with FDL styling.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../controllers/ui_showcase_view_model.dart';
import 'widgets/buttons_section.dart';
import 'widgets/display_section.dart';
import 'widgets/feedback_section.dart';
import 'widgets/inputs_section.dart';

/// UI showcase page widget.
///
/// Shows all FDL components organized by category.
class UiShowcasePage extends GetView<UiShowcaseViewModel> {
  const UiShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UiShowcaseViewModel>(
      builder: (viewModel) {
        return DemoScaffold(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Navigation
                const SectionHeader(
                  title: 'Component Library',
                  subtitle: 'Fifty Design Language',
                ),
                _SectionNav(
                  sections: UiShowcaseViewModel.sections,
                  activeSection: viewModel.activeSection,
                  onSectionSelected: viewModel.setActiveSection,
                ),
                const SizedBox(height: FiftySpacing.xl),

                // Active Section Content
                _buildSectionContent(viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionContent(UiShowcaseViewModel viewModel) {
    switch (viewModel.activeSection) {
      case 'buttons':
        return ButtonsSection(viewModel: viewModel);
      case 'inputs':
        return InputsSection(viewModel: viewModel);
      case 'display':
        return DisplaySection(viewModel: viewModel);
      case 'feedback':
        return FeedbackSection(viewModel: viewModel);
      default:
        return const SizedBox.shrink();
    }
  }
}

class _SectionNav extends StatelessWidget {
  const _SectionNav({
    required this.sections,
    required this.activeSection,
    required this.onSectionSelected,
  });

  final List<SectionInfo> sections;
  final String activeSection;
  final void Function(String) onSectionSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: FiftySpacing.sm,
      runSpacing: FiftySpacing.sm,
      children: sections.map((section) {
        final isActive = section.id == activeSection;
        return GestureDetector(
          onTap: () => onSectionSelected(section.id),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FiftySpacing.md,
              vertical: FiftySpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? FiftyColors.crimsonPulse.withValues(alpha: 0.2)
                  : Colors.transparent,
              borderRadius: FiftyRadii.standardRadius,
              border: Border.all(
                color: isActive
                    ? FiftyColors.crimsonPulse
                    : FiftyColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  IconData(section.icon, fontFamily: 'MaterialIcons'),
                  size: 16,
                  color: isActive
                      ? FiftyColors.crimsonPulse
                      : FiftyColors.hyperChrome,
                ),
                const SizedBox(width: FiftySpacing.xs),
                Text(
                  section.label,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamilyMono,
                    fontSize: FiftyTypography.mono,
                    color: isActive
                        ? FiftyColors.crimsonPulse
                        : FiftyColors.hyperChrome,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
