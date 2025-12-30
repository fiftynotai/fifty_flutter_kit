#include "include/fifty_sentences_engine/fifty_sentences_engine_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "fifty_sentences_engine_plugin.h"

void FiftySentencesEnginePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  fifty_sentences_engine::FiftySentencesEnginePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
