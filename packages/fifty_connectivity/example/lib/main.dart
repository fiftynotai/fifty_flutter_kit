import 'package:fifty_connectivity/fifty_connectivity.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/handler_demo_screen.dart';
import 'screens/home_screen.dart';
import 'screens/overlay_demo_screen.dart';
import 'screens/splash_demo_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectionBindings().dependencies();
  runApp(const ConnectivityExampleApp());
}

/// Root widget for the Fifty Connectivity example app.
class ConnectivityExampleApp extends StatefulWidget {
  /// Creates the connectivity example app.
  const ConnectivityExampleApp({super.key});

  @override
  State<ConnectivityExampleApp> createState() =>
      _ConnectivityExampleAppState();
}

class _ConnectivityExampleAppState extends State<ConnectivityExampleApp> {
  bool _isBalticBlue = false;

  void _togglePreset() {
    setState(() {
      _isBalticBlue = !_isBalticBlue;
      if (_isBalticBlue) {
        FiftyTokens.load(FiftyPreset.balticBlue);
      } else {
        FiftyTokens.load(FiftyPreset.fdlV2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fifty Connectivity Example',
      debugShowCheckedModeBanner: false,
      darkTheme: FiftyTheme.dark(),
      themeMode: ThemeMode.dark,
      builder: (context, child) => ConnectionOverlay(child: child!),
      home: MainNavigationScreen(
        isBalticBlue: _isBalticBlue,
        onTogglePreset: _togglePreset,
      ),
    );
  }
}

/// Main navigation screen with bottom navigation bar.
class MainNavigationScreen extends StatefulWidget {
  /// Creates the main navigation screen.
  const MainNavigationScreen({
    super.key,
    required this.isBalticBlue,
    required this.onTogglePreset,
  });

  final bool isBalticBlue;
  final VoidCallback onTogglePreset;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HandlerDemoScreen(),
    OverlayDemoScreen(),
    SplashDemoScreen(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Status',
    ),
    NavigationDestination(
      icon: Icon(Icons.swap_vert_outlined),
      selectedIcon: Icon(Icons.swap_vert),
      label: 'Handler',
    ),
    NavigationDestination(
      icon: Icon(Icons.layers_outlined),
      selectedIcon: Icon(Icons.layers),
      label: 'Overlay',
    ),
    NavigationDestination(
      icon: Icon(Icons.rocket_launch_outlined),
      selectedIcon: Icon(Icons.rocket_launch),
      label: 'Splash',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onTogglePreset,
        icon: Icon(widget.isBalticBlue ? Icons.restore : Icons.palette),
        label: Text(widget.isBalticBlue ? 'RESET FDL v2' : 'BALTIC BLUE'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: _destinations,
      ),
    );
  }
}
