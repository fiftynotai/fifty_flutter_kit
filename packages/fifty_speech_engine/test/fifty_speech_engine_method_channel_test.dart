import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_speech_engine/fifty_speech_engine_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFiftySpeechEngine platform = MethodChannelFiftySpeechEngine();
  const MethodChannel channel = MethodChannel('fifty_speech_engine');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
