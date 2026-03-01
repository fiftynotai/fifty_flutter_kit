/// Achievement Page
///
/// Full-screen achievement list accessible from the main menu.
/// Uses [AchievementList] from the fifty_achievement_engine package.
library;

import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../achievement_view_model.dart';

/// Displays all achievements with progress and unlock state.
class AchievementPage extends StatelessWidget {
  const AchievementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<AchievementViewModel>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: FiftySpacing.lg,
                vertical: FiftySpacing.md,
              ),
              child: Row(
                children: [
                  FiftyButton(
                    label: 'BACK',
                    variant: FiftyButtonVariant.ghost,
                    size: FiftyButtonSize.small,
                    onPressed: () => Get.back<void>(),
                  ),
                  const Spacer(),
                  Text(
                    'ACHIEVEMENTS',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.displayMedium,
                      fontWeight: FiftyTypography.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: FiftyTypography.letterSpacingDisplay,
                    ),
                  ),
                  const Spacer(),
                  // Points display
                  GetBuilder<AchievementViewModel>(
                    builder: (_) => Text(
                      '${vm.engine.earnedPoints}/${vm.engine.totalPoints} pts',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodyMedium,
                        fontWeight: FiftyTypography.semiBold,
                        color: FiftyColors.slateGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: FiftyColors.slateGrey, height: 1),
            // Achievement list
            Expanded(
              child: GetBuilder<AchievementViewModel>(
                builder: (_) => AchievementList<void>(
                  controller: vm.engine,
                  filter: AchievementFilter.all,
                  showProgress: true,
                  padding: EdgeInsets.all(FiftySpacing.lg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
