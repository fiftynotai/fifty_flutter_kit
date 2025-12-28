import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fifty_speech_engine_platform_interface.dart';

/// An implementation of [FiftySpeechEnginePlatform] that uses method channels.
class MethodChannelFiftySpeechEngine extends FiftySpeechEnginePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fifty_speech_engine');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
