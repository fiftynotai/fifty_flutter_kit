import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../features/bgm/bgm_view.dart';
import '../features/global/global_view.dart';
import '../features/sfx/sfx_view.dart';
import '../features/voice/voice_view.dart';

/// Main app shell with navigation.
///
/// Provides a tabbed interface for the four audio features:
/// BGM, SFX, Voice, and Global controls.
class AudioDemoApp extends StatefulWidget {
  const AudioDemoApp({super.key});

  @override
  State<AudioDemoApp> createState() => _AudioDemoAppState();
}

class _AudioDemoAppState extends State<AudioDemoApp> {
  int _selectedIndex = 0;

  static const _navItems = [
    FiftyNavItem(label: 'BGM', icon: Icons.music_note),
    FiftyNavItem(label: 'SFX', icon: Icons.speaker),
    FiftyNavItem(label: 'VOICE', icon: Icons.record_voice_over),
    FiftyNavItem(label: 'GLOBAL', icon: Icons.settings),
  ];

  static const _views = [
    BgmView(),
    SfxView(),
    VoiceView(),
    GlobalView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FiftyColors.voidBlack,
      body: SafeArea(
        child: Column(
          children: [
            // Hero header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.lg,
                vertical: FiftySpacing.xl,
              ),
              child: FiftyHeroSection(
                title: 'AUDIO ENGINE',
                subtitle: 'fifty.dev audio system demonstration',
                titleSize: FiftyHeroSize.h2,
                glitchOnMount: true,
                titleGradient: const LinearGradient(
                  colors: [
                    FiftyColors.crimsonPulse,
                    FiftyColors.terminalWhite,
                  ],
                ),
              ),
            ),
            // Navigation bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FiftySpacing.lg),
              child: FiftyNavBar(
                items: _navItems,
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() => _selectedIndex = index);
                },
                style: FiftyNavBarStyle.pill,
              ),
            ),
            const SizedBox(height: FiftySpacing.lg),
            // Content
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _views,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
