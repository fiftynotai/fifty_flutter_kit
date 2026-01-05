/// Fifty Demo App Shell
///
/// Provides the main scaffold and provider setup for the demo app.
/// Uses tabbed navigation to switch between demo features.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/di/service_locator.dart';
import '../features/dialogue_demo/view/dialogue_demo_page.dart';
import '../features/dialogue_demo/viewmodel/dialogue_demo_viewmodel.dart';
import '../features/home/view/home_page.dart';
import '../features/home/viewmodel/home_viewmodel.dart';
import '../features/map_demo/view/map_demo_page.dart';
import '../features/map_demo/viewmodel/map_demo_viewmodel.dart';
import '../features/ui_showcase/view/ui_showcase_page.dart';
import '../features/ui_showcase/viewmodel/ui_showcase_viewmodel.dart';

/// Main app shell with navigation.
///
/// Provides a tabbed interface for the four demo features:
/// Home, Map Demo, Dialogue Demo, and UI Showcase.
class FiftyDemoApp extends StatefulWidget {
  const FiftyDemoApp({super.key});

  @override
  State<FiftyDemoApp> createState() => _FiftyDemoAppState();
}

class _FiftyDemoAppState extends State<FiftyDemoApp> {
  int _selectedIndex = 0;

  static const _navItems = [
    FiftyNavItem(label: 'HOME', icon: Icons.home),
    FiftyNavItem(label: 'MAP', icon: Icons.map),
    FiftyNavItem(label: 'DIALOGUE', icon: Icons.chat),
    FiftyNavItem(label: 'UI', icon: Icons.widgets),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fifty Demo',
      theme: FiftyTheme.dark(),
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeViewModel>(
            create: (_) => serviceLocator<HomeViewModel>(),
          ),
          ChangeNotifierProvider<MapDemoViewModel>(
            create: (_) => serviceLocator<MapDemoViewModel>(),
          ),
          ChangeNotifierProvider<DialogueDemoViewModel>(
            create: (_) => serviceLocator<DialogueDemoViewModel>(),
          ),
          ChangeNotifierProvider<UiShowcaseViewModel>(
            create: (_) => serviceLocator<UiShowcaseViewModel>(),
          ),
        ],
        child: Scaffold(
          backgroundColor: FiftyColors.voidBlack,
          body: SafeArea(
            child: Column(
              children: [
                // Hero header
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: FiftySpacing.lg,
                    vertical: FiftySpacing.xl,
                  ),
                  child: FiftyHeroSection(
                    title: 'FIFTY DEMO',
                    subtitle: 'Ecosystem Integration Showcase',
                    titleSize: FiftyHeroSize.h2,
                    glitchOnMount: true,
                    titleGradient: LinearGradient(
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
                    children: const [
                      HomePage(),
                      MapDemoPage(),
                      DialogueDemoPage(),
                      UiShowcasePage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
