import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fifty_world_engine_platform_interface.dart';

/// An implementation of [FiftyWorldEnginePlatform] that uses method channels.
class MethodChannelFiftyWorldEngine extends FiftyWorldEnginePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fifty_world_engine');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
