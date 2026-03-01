/// Fifty Demo App Shell
///
/// Provides the main scaffold with GetX and bottom navigation.
/// Uses theme-aware colors from ColorScheme for light/dark mode support.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../core/bindings/initial_bindings.dart';
import '../features/achievement_demo/achievement_demo_bindings.dart';
import '../features/audio_demo/audio_demo_bindings.dart';
import '../features/cache_demo/cache_demo_bindings.dart';
import '../features/forms_demo/forms_demo_bindings.dart';
import '../features/home/home_bindings.dart';
import '../features/home/views/home_page.dart';
import '../features/map_demo/map_demo_bindings.dart';
import '../features/narrative_demo/narrative_demo_bindings.dart';
import '../features/packages/packages_bindings.dart';
import '../features/packages/views/packages_page.dart';
import '../features/printing_demo/printing_demo_bindings.dart';
import '../features/settings/settings_bindings.dart';
import '../features/settings/views/settings_page.dart';
import '../features/skill_tree_demo/skill_tree_demo_bindings.dart';
import '../features/socket_demo/socket_demo_bindings.dart';
import '../features/speech_demo/speech_demo_bindings.dart';
import '../features/ui_showcase/ui_showcase_bindings.dart';
import '../features/ui_showcase/views/ui_showcase_page.dart';
import '../features/utils_demo/utils_demo_bindings.dart';

/// Main app shell with bottom navigation.
///
/// Provides a tabbed interface for the four main sections:
/// Home, Packages, UI Kit, and Settings.
///
/// Uses theme-aware colors via [ColorScheme] for light/dark mode support.
class FiftyDemoApp extends StatelessWidget {
  /// Creates the main demo app widget.
  const FiftyDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fifty Demo',
      theme: FiftyTheme.light(),
      darkTheme: FiftyTheme.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      builder: (context, child) {
        final colorScheme = Theme.of(context).colorScheme;
        return GlobalLoaderOverlay(
          overlayColor: colorScheme.surface.withAlpha(200),
          overlayWidgetBuilder: (_) => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const _DemoShell(),
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

  /// Height for the hero card in the header.
  static const double _heroCardHeight = 140;

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

    // Initialize engine demo bindings (accessible from Packages hub)
    MapDemoBindings().dependencies();
    AudioDemoBindings().dependencies();
    SpeechDemoBindings().dependencies();
    NarrativeDemoBindings().dependencies();

    // Initialize new demo bindings
    PrintingDemoBindings().dependencies();
    SkillTreeDemoBindings().dependencies();
    AchievementDemoBindings().dependencies();
    FormsDemoBindings().dependencies();
    CacheDemoBindings().dependencies();
    UtilsDemoBindings().dependencies();
    SocketDemoBindings().dependencies();

    setState(() {
      _bindingsInitialized = true;
    });
  }

  Widget _buildDot(bool active, ColorScheme colorScheme, {bool onPrimary = false}) {
    final baseColor = onPrimary ? colorScheme.onPrimary : colorScheme.onSurface;
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? baseColor : baseColor.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Main content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Hero header card - only shown on Home tab
                // Note: Hero uses fixed brand colors (burgundy gradient) intentionally
                if (_selectedIndex == 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FiftySpacing.lg,
                      vertical: FiftySpacing.lg,
                    ),
                    child: FiftyCard(
                      padding: EdgeInsets.zero,
                      hasTexture: true,
                      child: Container(
                        height: _DemoShellState._heroCardHeight,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colorScheme.primary,
                              colorScheme.primary, // Both use primary for gradient
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
                                  color:
                                      colorScheme.onPrimary.withValues(alpha: 0.2),
                                  borderRadius: FiftyRadii.smRadius,
                                  border: Border.all(
                                    color:
                                        colorScheme.onPrimary.withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Text(
                                  'FLUTTER KIT',
                              style: TextStyle(
                                fontFamily: FiftyTypography.fontFamily,
                                fontSize: FiftyTypography.labelSmall,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimary,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        // Title and subtitle
                        Positioned(
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
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                              SizedBox(height: FiftySpacing.xs),
                              Text(
                                'Design System v2.0',
                                style: TextStyle(
                                  fontFamily: FiftyTypography.fontFamily,
                                  fontSize: FiftyTypography.bodyMedium,
                                  color: colorScheme.onPrimary,
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
                              _buildDot(true, colorScheme, onPrimary: true),
                              SizedBox(width: FiftySpacing.xs),
                              _buildDot(false, colorScheme, onPrimary: true),
                              SizedBox(width: FiftySpacing.xs),
                              _buildDot(false, colorScheme, onPrimary: true),
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
                      children: [
                        HomePage(
                          onTabChange: (index) {
                            setState(() => _selectedIndex = index);
                          },
                        ),
                        const PackagesPage(),
                        const UiShowcasePage(),
                        const SettingsPage(),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      ),
                    ),
            ),
              ],
            ),
          ),
          // Floating bottom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
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
        ],
      ),
    );
  }
}
