import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

/// Web implementation of FiftyWorldEngine
class FiftyWorldEngineWeb {
  /// Registers the web plugin
  static void registerWith(Registrar registrar) {
    // No special web initialization needed for this Flame-based plugin
  }

  /// Returns platform version
  Future<String?> getPlatformVersion() async {
    return web.window.navigator.userAgent;
  }
}
