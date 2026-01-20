import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../features/bgm/bgm_view.dart';
import '../features/global/global_view.dart';
import '../features/sfx/sfx_view.dart';
import '../features/voice/voice_view.dart';

/// Main app shell with FiftyNavBar navigation.
///
/// Provides a tabbed interface for the four audio features:
/// BGM, SFX, Voice, and Global controls.
class ExampleLauncher extends StatefulWidget {
  const ExampleLauncher({super.key});

  @override
  State<ExampleLauncher> createState() => _ExampleLauncherState();
}

class _ExampleLauncherState extends State<ExampleLauncher> {
  int _selectedIndex = 0;

  static const _navItems = [
    FiftyNavItem(label: 'BGM', icon: Icons.music_note),
    FiftyNavItem(label: 'SFX', icon: Icons.speaker),
    FiftyNavItem(label: 'Voice', icon: Icons.record_voice_over),
    FiftyNavItem(label: 'Global', icon: Icons.settings),
  ];

  static const _titles = [
    'BGM Player',
    'SFX Player',
    'Voice Player',
    'Global Controls',
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
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: Column(
        children: [
          // Navigation bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FiftySpacing.lg,
              vertical: FiftySpacing.md,
            ),
            child: FiftyNavBar(
              items: _navItems,
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              style: FiftyNavBarStyle.pill,
            ),
          ),
          // Content
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _views,
            ),
          ),
        ],
      ),
    );
  }
}
