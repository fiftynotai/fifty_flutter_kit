#include "include/fifty_audio_engine/fifty_audio_engine_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "fifty_audio_engine_plugin.h"

void FiftyAudioEnginePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  fifty_audio_engine::FiftyAudioEnginePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
