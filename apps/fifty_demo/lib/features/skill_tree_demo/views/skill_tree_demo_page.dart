/// Skill Tree Demo Page
///
/// Demonstrates skill tree visualization and skill unlocking.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
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
        return Scaffold(
          backgroundColor: FiftyColors.darkBurgundy,
          appBar: AppBar(
            backgroundColor: FiftyColors.surfaceDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: FiftyColors.cream),
              onPressed: actions.onBackTapped,
            ),
            title: const Text(
              'SKILL TREE',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyLarge,
                fontWeight: FontWeight.bold,
                color: FiftyColors.cream,
                letterSpacing: 2,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: FiftyColors.cream),
                onPressed: () => actions.onResetTapped(context),
                tooltip: 'Reset Skills',
              ),
            ],
          ),
          body: DemoScaffold(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  _buildStatsRow(context, viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),

                  // Branch Tabs
                  const SectionHeader(
                    title: 'Skill Branches',
                    subtitle: 'Select a branch to view skills',
                  ),
                  _buildBranchTabs(viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),

                  // Skill Tree View
                  SectionHeader(
                    title: viewModel.selectedBranch.label,
                    subtitle:
                        '${viewModel.currentBranchSkills.where((s) => s.isUnlocked).length}/${viewModel.currentBranchSkills.length} unlocked',
                  ),
                  _buildSkillTree(viewModel, actions),
                  const SizedBox(height: FiftySpacing.xl),

                  // Selected Skill Details
                  if (viewModel.selectedSkill != null) ...[
                    const SectionHeader(
                      title: 'Skill Details',
                      subtitle: 'Selected skill information',
                    ),
                    _buildSkillDetails(context, viewModel, actions),
                  ],
                ],
              ),
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
                    color: FiftyColors.cream.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: FiftySpacing.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: FiftyColors.burgundy,
                      size: 24,
                    ),
                    const SizedBox(width: FiftySpacing.xs),
                    Text(
                      '${viewModel.skillPoints}',
                      style: const TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.titleLarge,
                        fontWeight: FontWeight.bold,
                        color: FiftyColors.cream,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Unlocked Count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SKILLS UNLOCKED',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: FiftyColors.cream.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: FiftySpacing.xs),
                Text(
                  '${viewModel.unlockedCount}/${viewModel.totalSkills}',
                  style: const TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.titleLarge,
                    fontWeight: FontWeight.bold,
                    color: FiftyColors.hunterGreen,
                  ),
                ),
              ],
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
    SkillTreeDemoViewModel viewModel,
    SkillTreeDemoActions actions,
  ) {
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
                      ? FiftyColors.burgundy
                      : FiftyColors.surfaceDark,
                  borderRadius: BorderRadius.circular(FiftyRadii.md),
                  border: Border.all(
                    color: isSelected
                        ? FiftyColors.burgundy
                        : FiftyColors.borderDark,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      branch.icon,
                      color: isSelected
                          ? FiftyColors.cream
                          : FiftyColors.cream.withValues(alpha: 0.7),
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
                            ? FiftyColors.cream
                            : FiftyColors.cream.withValues(alpha: 0.7),
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
    SkillTreeDemoViewModel viewModel,
    SkillTreeDemoActions actions,
  ) {
    final skills = viewModel.currentBranchSkills;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: [
          // Skill nodes in tree layout
          ...skills.asMap().entries.map((entry) {
            final index = entry.key;
            final skill = entry.value;
            final isSelected = viewModel.selectedSkill?.id == skill.id;

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
                          ? FiftyColors.hunterGreen
                          : FiftyColors.borderDark,
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
                            ? viewModel.getSkillColor(skill).withValues(alpha: 0.3)
                            : FiftyColors.surfaceDark,
                        borderRadius: BorderRadius.circular(FiftyRadii.md),
                        border: Border.all(
                          color: isSelected
                              ? viewModel.getSkillColor(skill)
                              : FiftyColors.borderDark,
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
                              color: viewModel
                                  .getSkillColor(skill)
                                  .withValues(alpha: 0.2),
                              borderRadius:
                                  BorderRadius.circular(FiftyRadii.sm),
                            ),
                            child: Icon(
                              skill.icon,
                              color: viewModel.getSkillColor(skill),
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
                                  style: const TextStyle(
                                    fontFamily: FiftyTypography.fontFamily,
                                    fontSize: FiftyTypography.bodyMedium,
                                    fontWeight: FontWeight.bold,
                                    color: FiftyColors.cream,
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
                                        color: viewModel
                                            .getSkillColor(skill)
                                            .withValues(alpha: 0.2),
                                        borderRadius:
                                            BorderRadius.circular(FiftyRadii.sm),
                                      ),
                                      child: Text(
                                        viewModel.getSkillStatus(skill),
                                        style: TextStyle(
                                          fontFamily: FiftyTypography.fontFamily,
                                          fontSize: 10,
                                          color: viewModel.getSkillColor(skill),
                                        ),
                                      ),
                                    ),
                                    if (!skill.isUnlocked) ...[
                                      const SizedBox(width: FiftySpacing.sm),
                                      Icon(
                                        Icons.star,
                                        size: 12,
                                        color: FiftyColors.cream
                                            .withValues(alpha: 0.7),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${skill.cost}',
                                        style: TextStyle(
                                          fontFamily: FiftyTypography.fontFamily,
                                          fontSize: FiftyTypography.bodySmall,
                                          color: FiftyColors.cream
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
                            const Icon(
                              Icons.chevron_right,
                              color: FiftyColors.cream,
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
                  color: viewModel.getSkillColor(skill).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(FiftyRadii.md),
                ),
                child: Icon(
                  skill.icon,
                  color: viewModel.getSkillColor(skill),
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
                      style: const TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyLarge,
                        fontWeight: FontWeight.bold,
                        color: FiftyColors.cream,
                      ),
                    ),
                    Text(
                      viewModel.getSkillStatus(skill),
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: viewModel.getSkillColor(skill),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: FiftyColors.cream),
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
              color: FiftyColors.cream.withValues(alpha: 0.8),
            ),
          ),

          const SizedBox(height: FiftySpacing.md),

          // Cost info
          if (!skill.isUnlocked) ...[
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: FiftyColors.burgundy,
                  size: 16,
                ),
                const SizedBox(width: FiftySpacing.xs),
                Text(
                  'Cost: ${skill.cost} points',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: FiftyColors.cream.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: FiftySpacing.md),
                if (!canUnlock && viewModel.skillPoints < skill.cost)
                  Text(
                    '(Need ${skill.cost - viewModel.skillPoints} more)',
                    style: const TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: FiftyColors.burgundy,
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
