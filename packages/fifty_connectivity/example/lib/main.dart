import 'package:fifty_connectivity/fifty_connectivity.dart';
import 'package:fifty_theme/fifty_theme.dart';
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
class ConnectivityExampleApp extends StatelessWidget {
  /// Creates the connectivity example app.
  const ConnectivityExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fifty Connectivity Example',
      debugShowCheckedModeBanner: false,
      darkTheme: FiftyTheme.dark(),
      themeMode: ThemeMode.dark,
      builder: (context, child) => ConnectionOverlay(child: child!),
      home: const MainNavigationScreen(),
    );
  }
}

/// Main navigation screen with bottom navigation bar.
class MainNavigationScreen extends StatefulWidget {
  /// Creates the main navigation screen.
  const MainNavigationScreen({super.key});

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
