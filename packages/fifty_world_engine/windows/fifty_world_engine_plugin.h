#ifndef FLUTTER_PLUGIN_FIFTY_WORLD_ENGINE_PLUGIN_H_
#define FLUTTER_PLUGIN_FIFTY_WORLD_ENGINE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace fifty_world_engine {

class FiftyWorldEnginePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FiftyWorldEnginePlugin();

  virtual ~FiftyWorldEnginePlugin();

  // Disallow copy and assign.
  FiftyWorldEnginePlugin(const FiftyWorldEnginePlugin&) = delete;
  FiftyWorldEnginePlugin& operator=(const FiftyWorldEnginePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace fifty_world_engine

#endif  // FLUTTER_PLUGIN_FIFTY_WORLD_ENGINE_PLUGIN_H_
