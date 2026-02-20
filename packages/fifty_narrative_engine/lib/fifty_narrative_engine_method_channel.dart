import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fifty_narrative_engine_platform_interface.dart';

/// An implementation of [FiftyNarrativeEnginePlatform] that uses method channels.
class MethodChannelFiftyNarrativeEngine extends FiftyNarrativeEnginePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fifty_narrative_engine');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
