import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fifty_map_engine_method_channel.dart';

/// The interface that implementations of fifty_map_engine must implement.
abstract class FiftyMapEnginePlatform extends PlatformInterface {
  /// Constructs a FiftyMapEnginePlatform.
  FiftyMapEnginePlatform() : super(token: _token);

  static final Object _token = Object();

  static FiftyMapEnginePlatform _instance = MethodChannelFiftyMapEngine();

  /// The default instance of [FiftyMapEnginePlatform] to use.
  static FiftyMapEnginePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FiftyMapEnginePlatform].
  static set instance(FiftyMapEnginePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the platform version
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
