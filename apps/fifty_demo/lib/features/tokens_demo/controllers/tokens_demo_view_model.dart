/// Tokens Demo ViewModel
///
/// Business logic for the tokens demo feature.
/// Tracks which palette is currently active.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:get/get.dart';

/// ViewModel for the tokens demo feature.
///
/// Tracks the current palette name and provides state
/// for display on the demo page.
class TokensDemoViewModel extends GetxController {
  /// Whether the Baltic Blue palette is currently active.
  bool _isBalticBlue = false;

  /// Gets whether Baltic Blue palette is active.
  bool get isBalticBlue => _isBalticBlue;

  /// Gets the display name of the current palette.
  String get paletteName => _isBalticBlue ? 'Baltic Blue' : 'FDL v2';

  @override
  void onInit() {
    super.onInit();
    // Sync state with actual token configuration
    _isBalticBlue = FiftyTokens.isConfigured;
  }

  /// Sets the palette state and notifies listeners.
  void setBalticBlue({required bool active}) {
    _isBalticBlue = active;
    update();
  }
}
