import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fifty_speech_engine_method_channel.dart';

/// The interface that implementations of fifty_speech_engine must implement.
///
/// Platform implementations should extend this class rather than implement it
/// as `FiftySpeechEnginePlatform` does not consider newly added methods to be
/// breaking changes. Extending this class (using `extends`) ensures that the
/// subclass will get the default implementation, while platform implementations
/// that `implements` this interface will be broken by newly added methods.
abstract class FiftySpeechEnginePlatform extends PlatformInterface {
  /// Constructs a FiftySpeechEnginePlatform.
  FiftySpeechEnginePlatform() : super(token: _token);

  static final Object _token = Object();

  static FiftySpeechEnginePlatform _instance = MethodChannelFiftySpeechEngine();

  /// The default instance of [FiftySpeechEnginePlatform] to use.
  ///
  /// Defaults to [MethodChannelFiftySpeechEngine].
  static FiftySpeechEnginePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FiftySpeechEnginePlatform] when
  /// they register themselves.
  static set instance(FiftySpeechEnginePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the platform version string.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
