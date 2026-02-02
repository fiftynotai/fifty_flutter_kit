/// Skill Tree Demo Page
///
/// Demonstrates skill tree visualization and skill unlocking.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../actions/skill_tree_demo_actions.dart';
import '../controllers/skill_tree_demo_view_model.dart';

/// Skill tree demo page widget.
///
/// Shows skill tree with branch selection and skill unlocking.
class SkillTreeDemoPage extends GetView<SkillTreeDemoViewModel> {
  /// Creates a skill tree demo page.
  const SkillTreeDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SkillTreeDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<SkillTreeDemoActions>();

        return DemoScaffold(
          title: 'Skill Tree',
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  _buildStatsRow(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),

                  // Branch Tabs
                  const FiftySectionHeader(
                    title: 'Skill Branches',
                    subtitle: 'Select a branch to view skills',
                  ),
                  _buildBranchTabs(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),

                  // Skill Tree View
                  FiftySectionHeader(
                    title: viewModel.selectedBranch.label,
                    subtitle:
                        '${viewModel.currentBranchSkills.where((s) => s.isUnlocked).length}/${viewModel.currentBranchSkills.length} unlocked',
                  ),
                  _buildSkillTree(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),

                  // Selected Skill Details
                  if (viewModel.selectedSkill != null) ...[
                    const FiftySectionHeader(
                      title: 'Skill Details',
                      subtitle: 'Selected skill information',
                    ),
                    _buildSkillDetails(context, viewModel, actions),
                  ],
                ],
              ),
            ),
          );
        },
      );
  }

  Widget _buildStatsRow(
    BuildContext context,
    SkillTreeDemoViewModel viewModel,
    SkillTreeDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Row(
        children: [
          // Skill Points
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SKILL POINTS',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: FiftySpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: FiftySpacing.xs),
                    Text(
                      '${viewModel.skillPoints}',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.titleLarge,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Unlocked Count
          Expanded(
            child: Builder(
              builder: (context) {
                final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
                final successColor = fiftyTheme?.success ?? colorScheme.tertiary;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SKILLS UNLOCKED',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: FiftySpacing.xs),
                    Text(
                      '${viewModel.unlockedCount}/${viewModel.totalSkills}',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.titleLarge,
                        fontWeight: FontWeight.bold,
                        color: successColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Add Points Button (demo)
          FiftyButton(
            label: '+5 PTS',
            variant: FiftyButtonVariant.secondary,
            onPressed: () => actions.onAddPointsTapped(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchTabs(
    BuildContext context,
    SkillTreeDemoViewModel viewModel,
    SkillTreeDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: SkillBranch.values.map((branch) {
        final isSelected = viewModel.selectedBranch == branch;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: FiftySpacing.xs),
            child: GestureDetector(
              onTap: () => actions.onBranchSelected(branch),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: FiftySpacing.sm,
                  horizontal: FiftySpacing.md,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: FiftyRadii.mdRadius,
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      branch.icon,
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface.withValues(alpha: 0.7),
                      size: 24,
                    ),
                    const SizedBox(height: FiftySpacing.xs),
                    Text(
                      branch.label.toUpperCase(),
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkillTree(
    BuildContext context,
    SkillTreeDemoViewModel viewModel,
    SkillTreeDemoActions actions,
  ) {
    final skills = viewModel.currentBranchSkills;
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: [
          // Skill nodes in tree layout
          ...skills.asMap().entries.map((entry) {
            final index = entry.key;
            final skill = entry.value;
            final isSelected = viewModel.selectedSkill?.id == skill.id;
            final skillColor = viewModel.getSkillColor(skill, colorScheme, fiftyTheme);

            // Calculate indent based on parent count
            final indent = skill.parentIds.isEmpty ? 0 : skill.parentIds.length;

            return Column(
              children: [
                // Connection line
                if (index > 0)
                  Padding(
                    padding: EdgeInsets.only(left: (indent * 20.0) + 28),
                    child: Container(
                      width: 2,
                      height: 20,
                      color: skill.isUnlocked
                          ? successColor
                          : colorScheme.outline,
                    ),
                  ),

                // Skill node
                Padding(
                  padding: EdgeInsets.only(left: indent * 20.0),
                  child: GestureDetector(
                    onTap: () => actions.onSkillTapped(skill),
                    child: Container(
                      padding: const EdgeInsets.all(FiftySpacing.md),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? skillColor.withValues(alpha: 0.3)
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: FiftyRadii.mdRadius,
                        border: Border.all(
                          color: isSelected
                              ? skillColor
                              : colorScheme.outline,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Skill icon
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: skillColor.withValues(alpha: 0.2),
                              borderRadius:
                                  FiftyRadii.smRadius,
                            ),
                            child: Icon(
                              skill.icon,
                              color: skillColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: FiftySpacing.md),

                          // Skill info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  skill.name.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: FiftyTypography.fontFamily,
                                    fontSize: FiftyTypography.bodyMedium,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: FiftySpacing.xs),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: FiftySpacing.sm,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: skillColor.withValues(alpha: 0.2),
                                        borderRadius:
                                            FiftyRadii.smRadius,
                                      ),
                                      child: Text(
                                        viewModel.getSkillStatus(skill),
                                        style: TextStyle(
                                          fontFamily: FiftyTypography.fontFamily,
                                          fontSize: 10,
                                          color: skillColor,
                                        ),
                                      ),
                                    ),
                                    if (!skill.isUnlocked) ...[
                                      const SizedBox(width: FiftySpacing.sm),
                                      Icon(
                                        Icons.star,
                                        size: 12,
                                        color: colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${skill.cost}',
                                        style: TextStyle(
                                          fontFamily: FiftyTypography.fontFamily,
                                          fontSize: FiftyTypography.bodySmall,
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Selection indicator
                          if (isSelected)
                            Icon(
                              Icons.chevron_right,
                              color: colorScheme.onSurface,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSkillDetails(
    BuildContext context,
    SkillTreeDemoViewModel viewModel,
    SkillTreeDemoActions actions,
  ) {
    final skill = viewModel.selectedSkill!;
    final canUnlock = viewModel.canUnlockSkill(skill);
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final skillColor = viewModel.getSkillColor(skill, colorScheme, fiftyTheme);

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: skillColor.withValues(alpha: 0.2),
                  borderRadius: FiftyRadii.mdRadius,
                ),
                child: Icon(
                  skill.icon,
                  color: skillColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: FiftySpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skill.name.toUpperCase(),
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyLarge,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      viewModel.getSkillStatus(skill),
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: skillColor,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: colorScheme.onSurface),
                onPressed: actions.onClearSelection,
              ),
            ],
          ),

          const SizedBox(height: FiftySpacing.md),

          // Description
          Text(
            skill.description,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyMedium,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),

          const SizedBox(height: FiftySpacing.md),

          // Cost info (burgundy used as primary accent here)
          if (!skill.isUnlocked) ...[
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: colorScheme.primary,
                  size: 16,
                ),
                const SizedBox(width: FiftySpacing.xs),
                Text(
                  'Cost: ${skill.cost} points',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: FiftySpacing.md),
                if (!canUnlock && viewModel.skillPoints < skill.cost)
                  Text(
                    '(Need ${skill.cost - viewModel.skillPoints} more)',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: colorScheme.primary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: FiftySpacing.md),
          ],

          // Unlock button
          if (!skill.isUnlocked)
            SizedBox(
              width: double.infinity,
              child: FiftyButton(
                label: canUnlock ? 'UNLOCK SKILL' : 'REQUIREMENTS NOT MET',
                variant: FiftyButtonVariant.primary,
                onPressed:
                    canUnlock ? () => actions.onUnlockSkillTapped(context, skill) : null,
              ),
            ),
        ],
      ),
    );
  }
}
