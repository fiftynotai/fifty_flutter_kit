#ifndef FLUTTER_PLUGIN_FIFTY_AUDIO_ENGINE_PLUGIN_H_
#define FLUTTER_PLUGIN_FIFTY_AUDIO_ENGINE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace fifty_audio_engine {

class FiftyAudioEnginePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FiftyAudioEnginePlugin();

  virtual ~FiftyAudioEnginePlugin();

  // Disallow copy and assign.
  FiftyAudioEnginePlugin(const FiftyAudioEnginePlugin&) = delete;
  FiftyAudioEnginePlugin& operator=(const FiftyAudioEnginePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace fifty_audio_engine

#endif  // FLUTTER_PLUGIN_FIFTY_AUDIO_ENGINE_PLUGIN_H_
