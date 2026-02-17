/// Menu Page
///
/// Main menu screen for Tactical Grid with title, navigation buttons,
/// and version info. Uses FDL tokens throughout for consistent theming.
library;

import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../core/routes/route_manager.dart';
import '../battle/models/game_state.dart';

/// Main menu screen with game title and navigation buttons.
///
/// Layout:
/// - Game title ("TACTICAL" / "GRID") in display text
/// - Subtitle "A FIFTY SHOWCASE"
/// - PLAY button (primary, navigates to battle)
/// - SETTINGS button (outline, navigates to settings)
/// - Version label at the bottom
class MenuPage extends StatefulWidget {
  /// Creates the main menu page.
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  /// Menu BGM asset path.
  static const String _menuBgmPath = 'audio/bgm/menu_theme.mp3';

  @override
  void initState() {
    super.initState();
    _playMenuBgm();
  }

  @override
  void dispose() {
    _stopMenuBgm();
    super.dispose();
  }

  /// Starts menu background music at a comfortable volume.
  ///
  /// Uses [FiftyAudioEngine] directly instead of [BattleAudioCoordinator]
  /// since the battle bindings may not be registered on the menu screen.
  Future<void> _playMenuBgm() async {
    try {
      final engine = FiftyAudioEngine.instance;
      await engine.bgm.setVolume(0.3);
      await engine.bgm.loadDefaultPlaylist([_menuBgmPath]);
      await engine.bgm.resumeDefaultPlaylist();
    } catch (_) {
      // Silently ignore audio failures on menu.
    }
  }

  /// Stops menu BGM when navigating away.
  void _stopMenuBgm() {
    try {
      FiftyAudioEngine.instance.bgm.stop();
    } catch (_) {
      // Silently ignore.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FiftyColors.darkBurgundy,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FiftySpacing.xxl,
            vertical: FiftySpacing.lg,
          ),
          child: Column(
            children: [
              const Spacer(flex: 3),
              // Title block
              const _TitleSection(),
              const Spacer(flex: 2),
              // Navigation buttons
              const _NavigationSection(),
              const Spacer(flex: 2),
              // Version label
              const _VersionLabel(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Title section with "TACTICAL GRID" and subtitle.
class _TitleSection extends StatelessWidget {
  const _TitleSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'TACTICAL',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.displayLarge,
            fontWeight: FiftyTypography.extraBold,
            color: FiftyColors.cream,
            letterSpacing: FiftyTypography.letterSpacingDisplay,
            height: FiftyTypography.lineHeightDisplay,
          ),
        ),
        Text(
          'GRID',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.displayLarge,
            fontWeight: FiftyTypography.extraBold,
            color: FiftyColors.cream,
            letterSpacing: FiftyTypography.letterSpacingDisplay,
            height: FiftyTypography.lineHeightDisplay,
          ),
        ),
        const SizedBox(height: FiftySpacing.md),
        Text(
          'A FIFTY SHOWCASE',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodyMedium,
            fontWeight: FiftyTypography.regular,
            color: FiftyColors.slateGrey,
            letterSpacing: FiftyTypography.letterSpacingLabelMedium,
          ),
        ),
      ],
    );
  }
}

/// Navigation section with PLAY and SETTINGS buttons.
class _NavigationSection extends StatelessWidget {
  const _NavigationSection();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FiftyButton(
            label: 'PLAY',
            variant: FiftyButtonVariant.primary,
            size: FiftyButtonSize.large,
            expanded: true,
            onPressed: () => _showGameModeSheet(context),
          ),
          const SizedBox(height: FiftySpacing.lg),
          FiftyButton(
            label: 'ACHIEVEMENTS',
            variant: FiftyButtonVariant.outline,
            size: FiftyButtonSize.medium,
            expanded: true,
            onPressed: () => RouteManager.toAchievements(),
          ),
          const SizedBox(height: FiftySpacing.lg),
          FiftyButton(
            label: 'SETTINGS',
            variant: FiftyButtonVariant.outline,
            size: FiftyButtonSize.medium,
            expanded: true,
            onPressed: () => RouteManager.toSettings(),
          ),
        ],
      ),
    );
  }

  /// Shows the game mode selection bottom sheet.
  void _showGameModeSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _GameModeSheet(),
    );
  }
}

/// Bottom sheet for selecting game mode and AI difficulty.
///
/// Displays two options: LOCAL 1v1 and VS AI. When VS AI is selected,
/// reveals three difficulty buttons (EASY, MEDIUM, HARD).
class _GameModeSheet extends StatefulWidget {
  const _GameModeSheet();

  @override
  State<_GameModeSheet> createState() => _GameModeSheetState();
}

class _GameModeSheetState extends State<_GameModeSheet> {
  /// Whether the AI difficulty options are visible.
  bool _showDifficulty = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.xxl,
        vertical: FiftySpacing.xl,
      ),
      decoration: BoxDecoration(
        color: FiftyColors.darkBurgundy,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(FiftySpacing.lg),
        ),
        border: Border(
          top: BorderSide(
            color: FiftyColors.burgundy.withAlpha(80),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'SELECT GAME MODE',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.titleLarge,
                fontWeight: FiftyTypography.bold,
                color: FiftyColors.cream,
                letterSpacing: FiftyTypography.letterSpacingLabel,
              ),
            ),

            const SizedBox(height: FiftySpacing.xl),

            // LOCAL 1v1 button
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: FiftyButton(
                label: 'LOCAL 1v1',
                variant: FiftyButtonVariant.outline,
                size: FiftyButtonSize.large,
                expanded: true,
                onPressed: () {
                  Navigator.pop(context);
                  RouteManager.toBattle(
                    gameMode: GameMode.localMultiplayer,
                  );
                },
              ),
            ),

            const SizedBox(height: FiftySpacing.md),

            // VS AI button
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: FiftyButton(
                label: 'VS AI',
                variant: _showDifficulty
                    ? FiftyButtonVariant.primary
                    : FiftyButtonVariant.outline,
                size: FiftyButtonSize.large,
                expanded: true,
                onPressed: () {
                  setState(() {
                    _showDifficulty = !_showDifficulty;
                  });
                },
              ),
            ),

            // AI difficulty options (shown after VS AI is tapped)
            if (_showDifficulty) ...[
              const SizedBox(height: FiftySpacing.lg),

              // Divider label
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: FiftyColors.slateGrey.withAlpha(80),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FiftySpacing.md,
                    ),
                    child: Text(
                      'AI DIFFICULTY',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.labelSmall,
                        fontWeight: FiftyTypography.medium,
                        color: FiftyColors.slateGrey,
                        letterSpacing: FiftyTypography.letterSpacingLabel,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: FiftyColors.slateGrey.withAlpha(80),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: FiftySpacing.md),

              // Difficulty buttons row
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Row(
                  children: [
                    Expanded(
                      child: FiftyButton(
                        label: 'EASY',
                        variant: FiftyButtonVariant.ghost,
                        size: FiftyButtonSize.small,
                        onPressed: () => _startAIGame(AIDifficulty.easy),
                      ),
                    ),
                    const SizedBox(width: FiftySpacing.sm),
                    Expanded(
                      child: FiftyButton(
                        label: 'MEDIUM',
                        variant: FiftyButtonVariant.ghost,
                        size: FiftyButtonSize.small,
                        onPressed: () => _startAIGame(AIDifficulty.medium),
                      ),
                    ),
                    const SizedBox(width: FiftySpacing.sm),
                    Expanded(
                      child: FiftyButton(
                        label: 'HARD',
                        variant: FiftyButtonVariant.ghost,
                        size: FiftyButtonSize.small,
                        onPressed: () => _startAIGame(AIDifficulty.hard),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: FiftySpacing.md),
          ],
        ),
      ),
    );
  }

  /// Starts a VS AI game with the chosen [difficulty].
  void _startAIGame(AIDifficulty difficulty) {
    Navigator.pop(context);
    RouteManager.toBattle(
      gameMode: GameMode.vsAI,
      aiDifficulty: difficulty,
    );
  }
}

/// Version label displayed at the bottom of the menu.
class _VersionLabel extends StatelessWidget {
  const _VersionLabel();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'v1.0.0',
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontSize: FiftyTypography.bodySmall,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.slateGrey,
          letterSpacing: FiftyTypography.letterSpacingBodySmall,
        ),
      ),
    );
  }
}
