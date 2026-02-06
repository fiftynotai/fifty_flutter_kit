import 'package:get/get.dart';

/// **InitialBindings**
///
/// Registers global dependencies at app startup.
/// Module-specific bindings are registered via route bindings.
class InitialBindings extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      // Global services will be registered here
      // Module-specific dependencies use route-level bindings
    ];
  }
}
