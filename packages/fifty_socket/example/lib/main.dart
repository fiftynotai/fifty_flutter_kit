import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/socket_controller.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(SocketController());
  runApp(const FiftySocketExampleApp());
}

/// Root widget for the Fifty Socket example app.
class FiftySocketExampleApp extends StatelessWidget {
  /// Creates the socket example app.
  const FiftySocketExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fifty Socket Example',
      debugShowCheckedModeBanner: false,
      darkTheme: FiftyTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
