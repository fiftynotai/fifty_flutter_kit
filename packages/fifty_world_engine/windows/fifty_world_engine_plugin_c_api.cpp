#include "include/fifty_world_engine/fifty_world_engine_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "fifty_world_engine_plugin.h"

void FiftyWorldEnginePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  fifty_world_engine::FiftyWorldEnginePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
