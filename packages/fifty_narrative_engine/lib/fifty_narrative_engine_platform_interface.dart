import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fifty_narrative_engine_method_channel.dart';

/// Platform interface for FiftyNarrativeEngine.
///
/// Platform-specific implementations should extend this class and implement
/// the required methods. The default implementation uses method channels.
abstract class FiftyNarrativeEnginePlatform extends PlatformInterface {
  /// Constructs a FiftyNarrativeEnginePlatform.
  FiftyNarrativeEnginePlatform() : super(token: _token);

  static final Object _token = Object();

  static FiftyNarrativeEnginePlatform _instance =
      MethodChannelFiftyNarrativeEngine();

  /// The default instance of [FiftyNarrativeEnginePlatform] to use.
  ///
  /// Defaults to [MethodChannelFiftyNarrativeEngine].
  static FiftyNarrativeEnginePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FiftyNarrativeEnginePlatform] when
  /// they register themselves.
  static set instance(FiftyNarrativeEnginePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the platform version string.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
