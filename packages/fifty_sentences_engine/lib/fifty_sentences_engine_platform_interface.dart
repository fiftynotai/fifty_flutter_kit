import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'fifty_sentences_engine_method_channel.dart';

/// Platform interface for FiftySentencesEngine.
///
/// Platform-specific implementations should extend this class and implement
/// the required methods. The default implementation uses method channels.
abstract class FiftySentencesEnginePlatform extends PlatformInterface {
  /// Constructs a FiftySentencesEnginePlatform.
  FiftySentencesEnginePlatform() : super(token: _token);

  static final Object _token = Object();

  static FiftySentencesEnginePlatform _instance =
      MethodChannelFiftySentencesEngine();

  /// The default instance of [FiftySentencesEnginePlatform] to use.
  ///
  /// Defaults to [MethodChannelFiftySentencesEngine].
  static FiftySentencesEnginePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FiftySentencesEnginePlatform] when
  /// they register themselves.
  static set instance(FiftySentencesEnginePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the platform version string.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
