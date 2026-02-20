#ifndef FLUTTER_PLUGIN_FIFTY_SENTENCES_ENGINE_PLUGIN_H_
#define FLUTTER_PLUGIN_FIFTY_SENTENCES_ENGINE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace fifty_narrative_engine {

class FiftyNarrativeEnginePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FiftyNarrativeEnginePlugin();

  virtual ~FiftyNarrativeEnginePlugin();

  // Disallow copy and assign.
  FiftyNarrativeEnginePlugin(const FiftyNarrativeEnginePlugin&) = delete;
  FiftyNarrativeEnginePlugin& operator=(const FiftyNarrativeEnginePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace fifty_narrative_engine

#endif  // FLUTTER_PLUGIN_FIFTY_SENTENCES_ENGINE_PLUGIN_H_
