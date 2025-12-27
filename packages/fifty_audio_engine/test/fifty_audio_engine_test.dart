import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_audio_engine/fifty_audio_engine_platform_interface.dart';
import 'package:fifty_audio_engine/fifty_audio_engine_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFiftyAudioEnginePlatform
    with MockPlatformInterfaceMixin
    implements FiftyAudioEnginePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FiftyAudioEnginePlatform initialPlatform = FiftyAudioEnginePlatform.instance;

  test('$MethodChannelFiftyAudioEngine is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFiftyAudioEngine>());
  });

}
