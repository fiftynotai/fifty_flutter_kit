import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'fifty_map_engine_platform_interface.dart';

/// An implementation of [FiftyMapEnginePlatform] that uses method channels.
class MethodChannelFiftyMapEngine extends FiftyMapEnginePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('fifty_map_engine');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
