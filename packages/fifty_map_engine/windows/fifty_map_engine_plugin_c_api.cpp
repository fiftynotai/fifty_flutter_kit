#include "include/fifty_map_engine/fifty_map_engine_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "fifty_map_engine_plugin.h"

void FiftyMapEnginePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  fifty_map_engine::FiftyMapEnginePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
