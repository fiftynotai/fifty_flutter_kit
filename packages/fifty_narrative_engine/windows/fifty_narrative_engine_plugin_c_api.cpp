#include "include/fifty_narrative_engine/fifty_narrative_engine_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "fifty_narrative_engine_plugin.h"

void FiftyNarrativeEnginePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  fifty_narrative_engine::FiftyNarrativeEnginePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
