import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fifty_audio_engine_platform_interface.dart';

/// An implementation of [FiftyAudioEnginePlatform] that uses method channels.
class MethodChannelFiftyAudioEngine extends FiftyAudioEnginePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fifty_audio_engine');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
