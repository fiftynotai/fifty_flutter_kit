import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fifty_world_engine_method_channel.dart';

/// The interface that implementations of fifty_world_engine must implement.
abstract class FiftyWorldEnginePlatform extends PlatformInterface {
  /// Constructs a FiftyWorldEnginePlatform.
  FiftyWorldEnginePlatform() : super(token: _token);

  static final Object _token = Object();

  static FiftyWorldEnginePlatform _instance = MethodChannelFiftyWorldEngine();

  /// The default instance of [FiftyWorldEnginePlatform] to use.
  static FiftyWorldEnginePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FiftyWorldEnginePlatform].
  static set instance(FiftyWorldEnginePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the platform version
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
