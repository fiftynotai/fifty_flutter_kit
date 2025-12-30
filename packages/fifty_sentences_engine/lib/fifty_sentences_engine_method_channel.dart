import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fifty_sentences_engine_platform_interface.dart';

/// An implementation of [FiftySentencesEnginePlatform] that uses method channels.
class MethodChannelFiftySentencesEngine extends FiftySentencesEnginePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fifty_sentences_engine');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
