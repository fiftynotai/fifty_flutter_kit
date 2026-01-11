/// Fifty Demo App Shell
///
/// Provides the main scaffold with GetX and tabbed navigation.
/// Uses tabbed navigation to switch between demo features.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../core/bindings/initial_bindings.dart';
import '../features/dialogue_demo/dialogue_demo_bindings.dart';
import '../features/dialogue_demo/views/dialogue_demo_page.dart';
import '../features/home/home_bindings.dart';
import '../features/home/views/home_page.dart';
import '../features/map_demo/map_demo_bindings.dart';
import '../features/map_demo/views/map_demo_page.dart';
import '../features/ui_showcase/ui_showcase_bindings.dart';
import '../features/ui_showcase/views/ui_showcase_page.dart';

/// Main app shell with navigation.
///
/// Provides a tabbed interface for the four demo features:
/// Home, Map Demo, Dialogue Demo, and UI Showcase.
class FiftyDemoApp extends StatelessWidget {
  const FiftyDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fifty Demo',
      theme: FiftyTheme.dark(),
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      home: GlobalLoaderOverlay(
        overlayColor: FiftyColors.voidBlack.withAlpha(200),
        overlayWidgetBuilder: (_) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(FiftyColors.crimsonPulse),
          ),
        ),
        child: const _DemoShell(),
      ),
    );
  }
}

/// Demo shell widget that contains the tab navigation.
///
/// Handles feature bindings initialization and tab switching.
class _DemoShell extends StatefulWidget {
  const _DemoShell();

  @override
  State<_DemoShell> createState() => _DemoShellState();
}

class _DemoShellState extends State<_DemoShell> {
  int _selectedIndex = 0;
  bool _bindingsInitialized = false;

  static const _navItems = [
    FiftyNavItem(label: 'HOME', icon: Icons.home),
    FiftyNavItem(label: 'MAP', icon: Icons.map),
    FiftyNavItem(label: 'DIALOGUE', icon: Icons.chat),
    FiftyNavItem(label: 'UI', icon: Icons.widgets),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize feature bindings after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeBindings();
    });
  }

  void _initializeBindings() {
    if (_bindingsInitialized) return;

    // Initialize all feature bindings
    HomeBindings().dependencies();
    MapDemoBindings().dependencies();
    DialogueDemoBindings().dependencies();
    UiShowcaseBindings().dependencies();

    setState(() {
      _bindingsInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: _bindingsInitialized
                  ? IndexedStack(
                      index: _selectedIndex,
                      children: const [
                        HomePage(),
                        MapDemoPage(),
                        DialogueDemoPage(),
                        UiShowcasePage(),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FiftyColors.crimsonPulse,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
