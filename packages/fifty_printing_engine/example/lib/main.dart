import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/printer_management_screen.dart';
import 'screens/test_print_screen.dart';
import 'screens/ticket_builder_screen.dart';

void main() {
  runApp(const PrintingEngineExampleApp());
}

class PrintingEngineExampleApp extends StatelessWidget {
  const PrintingEngineExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printing Engine Example',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    PrinterManagementScreen(),
    TestPrintScreen(),
    TicketBuilderScreen(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.print_outlined),
      selectedIcon: Icon(Icons.print),
      label: 'Printers',
    ),
    NavigationDestination(
      icon: Icon(Icons.science_outlined),
      selectedIcon: Icon(Icons.science),
      label: 'Test Print',
    ),
    NavigationDestination(
      icon: Icon(Icons.edit_outlined),
      selectedIcon: Icon(Icons.edit),
      label: 'Builder',
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
