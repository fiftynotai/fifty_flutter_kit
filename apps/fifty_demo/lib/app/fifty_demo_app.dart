/// Fifty Demo App Shell
///
/// Provides the main scaffold with GetX and bottom navigation.
/// Uses FDL v2 colors and bottom navigation pattern.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../core/bindings/initial_bindings.dart';
import '../features/achievement_demo/achievement_demo_bindings.dart';
import '../features/dialogue_demo/dialogue_demo_bindings.dart';
import '../features/forms_demo/forms_demo_bindings.dart';
import '../features/home/home_bindings.dart';
import '../features/home/views/home_page.dart';
import '../features/map_demo/map_demo_bindings.dart';
import '../features/packages/packages_bindings.dart';
import '../features/packages/views/packages_page.dart';
import '../features/printing_demo/printing_demo_bindings.dart';
import '../features/settings/settings_bindings.dart';
import '../features/settings/views/settings_page.dart';
import '../features/skill_tree_demo/skill_tree_demo_bindings.dart';
import '../features/ui_showcase/ui_showcase_bindings.dart';
import '../features/ui_showcase/views/ui_showcase_page.dart';

/// Main app shell with bottom navigation.
///
/// Provides a tabbed interface for the four main sections:
/// Home, Packages, UI Kit, and Settings.
///
/// Uses FDL v2 colors (darkBurgundy, burgundy, cream, etc.).
class FiftyDemoApp extends StatelessWidget {
  /// Creates the main demo app widget.
  const FiftyDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fifty Demo',
      theme: FiftyTheme.dark(),
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      home: GlobalLoaderOverlay(
        overlayColor: FiftyColors.darkBurgundy.withAlpha(200),
        overlayWidgetBuilder: (_) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(FiftyColors.burgundy),
          ),
        ),
        child: const _DemoShell(),
      ),
    );
  }
}

/// Demo shell widget that contains the bottom navigation.
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

  /// Navigation items for the bottom navigation bar.
  static const _navItems = [
    FiftyNavItem(label: 'HOME', icon: Icons.home_outlined),
    FiftyNavItem(label: 'PACKAGES', icon: Icons.inventory_2_outlined),
    FiftyNavItem(label: 'UI KIT', icon: Icons.widgets_outlined),
    FiftyNavItem(label: 'SETTINGS', icon: Icons.settings_outlined),
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
    PackagesBindings().dependencies();
    UiShowcaseBindings().dependencies();
    SettingsBindings().dependencies();

    // Initialize legacy demo bindings (accessible from Packages hub)
    MapDemoBindings().dependencies();
    DialogueDemoBindings().dependencies();

    // Initialize new demo bindings
    PrintingDemoBindings().dependencies();
    SkillTreeDemoBindings().dependencies();
    AchievementDemoBindings().dependencies();
    FormsDemoBindings().dependencies();

    setState(() {
      _bindingsInitialized = true;
    });
  }

  Widget _buildDot(bool active) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active
            ? FiftyColors.cream
            : FiftyColors.cream.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FiftyColors.darkBurgundy,
      body: SafeArea(
        bottom: false, // Let bottom nav handle safe area
        child: Column(
          children: [
            // Hero header card with FDL v2 colors
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.lg,
                vertical: FiftySpacing.lg,
              ),
              child: FiftyCard(
                padding: EdgeInsets.zero,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        FiftyColors.burgundy,
                        FiftyColors.darkBurgundy,
                      ],
                    ),
                    borderRadius: FiftyRadii.lgRadius,
                  ),
                  child: Stack(
                    children: [
                      // Badge
                      Positioned(
                        top: FiftySpacing.md,
                        left: FiftySpacing.md,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: FiftySpacing.sm,
                            vertical: FiftySpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: FiftyColors.powderBlush.withValues(alpha: 0.2),
                            borderRadius: FiftyRadii.smRadius,
                            border: Border.all(
                              color:
                                  FiftyColors.powderBlush.withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Text(
                            'FLUTTER KIT',
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.labelSmall,
                              fontWeight: FontWeight.bold,
                              color: FiftyColors.cream,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                      // Title and subtitle
                      const Positioned(
                        bottom: FiftySpacing.lg,
                        left: FiftySpacing.md,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fifty Demo',
                              style: TextStyle(
                                fontFamily: FiftyTypography.fontFamily,
                                fontSize: FiftyTypography.displayMedium,
                                fontWeight: FontWeight.bold,
                                color: FiftyColors.cream,
                              ),
                            ),
                            SizedBox(height: FiftySpacing.xs),
                            Text(
                              'Design System v2.0',
                              style: TextStyle(
                                fontFamily: FiftyTypography.fontFamily,
                                fontSize: FiftyTypography.bodyMedium,
                                color: FiftyColors.cream,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Dot indicators (decorative)
                      Positioned(
                        bottom: FiftySpacing.md,
                        right: FiftySpacing.md,
                        child: Row(
                          children: [
                            _buildDot(true),
                            const SizedBox(width: FiftySpacing.xs),
                            _buildDot(false),
                            const SizedBox(width: FiftySpacing.xs),
                            _buildDot(false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Content area
            Expanded(
              child: _bindingsInitialized
                  ? IndexedStack(
                      index: _selectedIndex,
                      children: const [
                        HomePage(),
                        PackagesPage(),
                        UiShowcasePage(),
                        SettingsPage(),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FiftyColors.burgundy,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      // Bottom navigation bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: FiftyColors.surfaceDark,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FiftySpacing.md,
              vertical: FiftySpacing.sm,
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
        ),
      ),
    );
  }
}
